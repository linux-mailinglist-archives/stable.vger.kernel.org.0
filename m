Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB7C3AF089
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhFUQuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:50:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:38074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232536AbhFUQro (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:47:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A780611CE;
        Mon, 21 Jun 2021 16:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293220;
        bh=dqoV1TNWUCbUUOS9goSmit/ypve9i2to0VkDscJk+cY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SbaLhk0I5kiHLF/eAJ4RykyM7aaNvb5/nFPyX3vwtbjC4ZkC7GJHmpJ4R2wyHkAmS
         Bg9d1OZCXcGuaas9MyuVv1ZU27NcXZtkSxiCW5QfWvH9+wHPWyu2ukysZq327Z86NP
         2Fm/HndKj2L5zqNRPhlutg8E6XsT/iBhBDcqBv3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Rik van Riel <riel@surriel.com>,
        Babu Moger <babu.moger@amd.com>
Subject: [PATCH 5.12 143/178] x86/pkru: Write hardware init value to PKRU when xstate is init
Date:   Mon, 21 Jun 2021 18:15:57 +0200
Message-Id: <20210621154927.644071487@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 510b80a6a0f1a0d114c6e33bcea64747d127973c upstream.

When user space brings PKRU into init state, then the kernel handling is
broken:

  T1 user space
     xsave(state)
     state.header.xfeatures &= ~XFEATURE_MASK_PKRU;
     xrstor(state)

  T1 -> kernel
     schedule()
       XSAVE(S) -> T1->xsave.header.xfeatures[PKRU] == 0
       T1->flags |= TIF_NEED_FPU_LOAD;

       wrpkru();

     schedule()
       ...
       pk = get_xsave_addr(&T1->fpu->state.xsave, XFEATURE_PKRU);
       if (pk)
	 wrpkru(pk->pkru);
       else
	 wrpkru(DEFAULT_PKRU);

Because the xfeatures bit is 0 and therefore the value in the xsave
storage is not valid, get_xsave_addr() returns NULL and switch_to()
writes the default PKRU. -> FAIL #1!

So that wrecks any copy_to/from_user() on the way back to user space
which hits memory which is protected by the default PKRU value.

Assumed that this does not fail (pure luck) then T1 goes back to user
space and because TIF_NEED_FPU_LOAD is set it ends up in

  switch_fpu_return()
      __fpregs_load_activate()
        if (!fpregs_state_valid()) {
  	 load_XSTATE_from_task();
        }

But if nothing touched the FPU between T1 scheduling out and back in,
then the fpregs_state is still valid which means switch_fpu_return()
does nothing and just clears TIF_NEED_FPU_LOAD. Back to user space with
DEFAULT_PKRU loaded. -> FAIL #2!

The fix is simple: if get_xsave_addr() returns NULL then set the
PKRU value to 0 instead of the restrictive default PKRU value in
init_pkru_value.

 [ bp: Massage in minor nitpicks from folks. ]

Fixes: 0cecca9d03c9 ("x86/fpu: Eager switch PKRU state")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Rik van Riel <riel@surriel.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20210608144346.045616965@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/fpu/internal.h |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -579,9 +579,16 @@ static inline void switch_fpu_finish(str
 	 * return to userland e.g. for a copy_to_user() operation.
 	 */
 	if (!(current->flags & PF_KTHREAD)) {
+		/*
+		 * If the PKRU bit in xsave.header.xfeatures is not set,
+		 * then the PKRU component was in init state, which means
+		 * XRSTOR will set PKRU to 0. If the bit is not set then
+		 * get_xsave_addr() will return NULL because the PKRU value
+		 * in memory is not valid. This means pkru_val has to be
+		 * set to 0 and not to init_pkru_value.
+		 */
 		pk = get_xsave_addr(&new_fpu->state.xsave, XFEATURE_PKRU);
-		if (pk)
-			pkru_val = pk->pkru;
+		pkru_val = pk ? pk->pkru : 0;
 	}
 	__write_pkru(pkru_val);
 }


