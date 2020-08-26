Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552A1252D96
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 14:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729511AbgHZMDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 08:03:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:37810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729499AbgHZMDF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 08:03:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADB8720786;
        Wed, 26 Aug 2020 12:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598443385;
        bh=JwN4pNT2uDpqXGOp0JJjNOfm7Wp47yEF9ZKhPxJRc8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TFEOhBK2mm1e/igynuxvTCqjdpB4O5s9fZwKesI8rc6Vu7TKXuaUUX6xpamaZWSUD
         YGVIrxsGJBF2kwhkSQM8wkl7ERgCoYFIxPF/AmDKxBMg1LQciGY9MWAG5zYMfU7Kl4
         rjZRzlX2l1ZeH+wMHJ/DkcytnVDQN4QztmVGiXGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Alistair Popple <alistair@popple.id.au>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.7 14/15] powerpc/64s: Dont init FSCR_DSCR in __init_FSCR()
Date:   Wed, 26 Aug 2020 14:02:42 +0200
Message-Id: <20200826114849.985021708@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200826114849.295321031@linuxfoundation.org>
References: <20200826114849.295321031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 0828137e8f16721842468e33df0460044a0c588b upstream.

__init_FSCR() was added originally in commit 2468dcf641e4 ("powerpc:
Add support for context switching the TAR register") (Feb 2013), and
only set FSCR_TAR.

At that point FSCR (Facility Status and Control Register) was not
context switched, so the setting was permanent after boot.

Later we added initialisation of FSCR_DSCR to __init_FSCR(), in commit
54c9b2253d34 ("powerpc: Set DSCR bit in FSCR setup") (Mar 2013), again
that was permanent after boot.

Then commit 2517617e0de6 ("powerpc: Fix context switch DSCR on
POWER8") (Aug 2013) added a limited context switch of FSCR, just the
FSCR_DSCR bit was context switched based on thread.dscr_inherit. That
commit said "This clears the H/FSCR DSCR bit initially", but it
didn't, it left the initialisation of FSCR_DSCR in __init_FSCR().
However the initial context switch from init_task to pid 1 would clear
FSCR_DSCR because thread.dscr_inherit was 0.

That commit also introduced the requirement that FSCR_DSCR be clear
for user processes, so that we can take the facility unavailable
interrupt in order to manage dscr_inherit.

Then in commit 152d523e6307 ("powerpc: Create context switch helpers
save_sprs() and restore_sprs()") (Dec 2015) FSCR was added to
thread_struct. However it still wasn't fully context switched, we just
took the existing value and set FSCR_DSCR if the new thread had
dscr_inherit set. FSCR was still initialised at boot to FSCR_DSCR |
FSCR_TAR, but that value was not propagated into the thread_struct, so
the initial context switch set FSCR_DSCR back to 0.

Finally commit b57bd2de8c6c ("powerpc: Improve FSCR init and context
switching") (Jun 2016) added a full context switch of the FSCR, and
added an initialisation of init_task.thread.fscr to FSCR_TAR |
FSCR_EBB, but omitted FSCR_DSCR.

The end result is that swapper runs with FSCR_DSCR set because of the
initialisation in __init_FSCR(), but no other processes do, they use
the value from init_task.thread.fscr.

Having FSCR_DSCR set for swapper allows it to access SPR 3 from
userspace, but swapper never runs userspace, so it has no useful
effect. It's also confusing to have the value initialised in two
places to two different values.

So remove FSCR_DSCR from __init_FSCR(), this at least gets us to the
point where there's a single value of FSCR, even if it's still set in
two places.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Tested-by: Alistair Popple <alistair@popple.id.au>
Link: https://lore.kernel.org/r/20200527145843.2761782-1-mpe@ellerman.id.au
Cc: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/cpu_setup_power.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/cpu_setup_power.S
+++ b/arch/powerpc/kernel/cpu_setup_power.S
@@ -184,7 +184,7 @@ __init_LPCR_ISA300:
 
 __init_FSCR:
 	mfspr	r3,SPRN_FSCR
-	ori	r3,r3,FSCR_TAR|FSCR_DSCR|FSCR_EBB
+	ori	r3,r3,FSCR_TAR|FSCR_EBB
 	mtspr	SPRN_FSCR,r3
 	blr
 


