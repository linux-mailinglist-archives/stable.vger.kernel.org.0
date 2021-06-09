Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6155B3A17B7
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 16:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238112AbhFIOso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 10:48:44 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:54970 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238100AbhFIOsn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 10:48:43 -0400
Date:   Wed, 09 Jun 2021 14:46:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1623250007;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0VCGyWAfeJrDIZv4nbwzFIx1nxkq+p7yg81wLtDsQFg=;
        b=EacmVklHdkwKI2qpQjIr6OQZU0cmld0HZTeJIV8tRJBF8Y12o2428XyiOKnbTONc1nBQXa
        YCyea4jUTU5ri9Xa5kaXb+AA7qtaBR5df2ubLtLByj6xE/NyRehe6Ir/kzRs3SiEmxCGD3
        CMQzoSeA/0ki6n09ux03O8MRM8Px3nZApBMi2hdl8lKmgdY5wvZNEuXYcwKAJ70QEhhnjB
        MEbvEXY81UHzLvp4FdAfmP/USJ8ET99+qqKG2Y9JxGXYPpuUHuuyNU7lXS1TjjZLhSpZZe
        uYU6TEzg+8cWPCcENFytBSlGT7ruL8sDEzXG+nK6IiXJyuVgzofCzSK9URpBeA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1623250007;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0VCGyWAfeJrDIZv4nbwzFIx1nxkq+p7yg81wLtDsQFg=;
        b=Hgefg1rNdGIkhKmW22fQRX5Beng/h6GXspKs0C8B3RZMpLGEs9sWEuxEBhsfGNJwPVgPEE
        EeXA5Lmy8se7YdBA==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/pkru: Write hardware init value to PKRU when
 xstate is init
Cc:     Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Rik van Riel <riel@surriel.com>,
        Babu Moger <babu.moger@amd.com>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210608144346.045616965@linutronix.de>
References: <20210608144346.045616965@linutronix.de>
MIME-Version: 1.0
Message-ID: <162325000667.29796.2871509185639909359.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     510b80a6a0f1a0d114c6e33bcea64747d127973c
Gitweb:        https://git.kernel.org/tip/510b80a6a0f1a0d114c6e33bcea64747d127973c
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Tue, 08 Jun 2021 16:36:21 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 09 Jun 2021 12:12:45 +02:00

x86/pkru: Write hardware init value to PKRU when xstate is init

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
---
 arch/x86/include/asm/fpu/internal.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 18382ac..fdee23e 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -579,9 +579,16 @@ static inline void switch_fpu_finish(struct fpu *new_fpu)
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
