Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D3743A155
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236321AbhJYTiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:38:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234833AbhJYTff (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:35:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 163F26101C;
        Mon, 25 Oct 2021 19:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190365;
        bh=rJboFWYOlFxCjJ2sD+ydfZ3t2qyUBerEkypslsxgIkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ei8XwRfnvK3Td+MvMjdgYUXLOU75M+lJ/cfMK1wbwJybAkYxAiDV4NXg0xIkM++ds
         8wMdWHSQ6e7UDznfRZnB7lhKKu1/Xx1MFD7CVdsURaIfv6knl8tsCK49DfLxsfMH9n
         EhLeFPdWzXsRF1PDrW0BvZ2E87JtxiEzdusgTWkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 57/95] KVM: PPC: Book3S HV: Make idle_kvm_start_guest() return 0 if it went to guest
Date:   Mon, 25 Oct 2021 21:14:54 +0200
Message-Id: <20211025191005.243158991@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit cdeb5d7d890e14f3b70e8087e745c4a6a7d9f337 upstream.

We call idle_kvm_start_guest() from power7_offline() if the thread has
been requested to enter KVM. We pass it the SRR1 value that was returned
from power7_idle_insn() which tells us what sort of wakeup we're
processing.

Depending on the SRR1 value we pass in, the KVM code might enter the
guest, or it might return to us to do some host action if the wakeup
requires it.

If idle_kvm_start_guest() is able to handle the wakeup, and enter the
guest it is supposed to indicate that by returning a zero SRR1 value to
us.

That was the behaviour prior to commit 10d91611f426 ("powerpc/64s:
Reimplement book3s idle code in C"), however in that commit the
handling of SRR1 was reworked, and the zeroing behaviour was lost.

Returning from idle_kvm_start_guest() without zeroing the SRR1 value can
confuse the host offline code, causing the guest to crash and other
weirdness.

Fixes: 10d91611f426 ("powerpc/64s: Reimplement book3s idle code in C")
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211015133929.832061-2-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -301,6 +301,7 @@ _GLOBAL(idle_kvm_start_guest)
 	stdu	r1, -SWITCH_FRAME_SIZE(r4)
 	// Switch to new frame on emergency stack
 	mr	r1, r4
+	std	r3, 32(r1)	// Save SRR1 wakeup value
 	SAVE_NVGPRS(r1)
 
 	/*
@@ -352,6 +353,10 @@ kvm_unsplit_wakeup:
 
 kvm_secondary_got_guest:
 
+	// About to go to guest, clear saved SRR1
+	li	r0, 0
+	std	r0, 32(r1)
+
 	/* Set HSTATE_DSCR(r13) to something sensible */
 	ld	r6, PACA_DSCR_DEFAULT(r13)
 	std	r6, HSTATE_DSCR(r13)
@@ -443,8 +448,8 @@ kvm_no_guest:
 	mfspr	r4, SPRN_LPCR
 	rlwimi	r4, r3, 0, LPCR_PECE0 | LPCR_PECE1
 	mtspr	SPRN_LPCR, r4
-	/* set up r3 for return */
-	mfspr	r3,SPRN_SRR1
+	// Return SRR1 wakeup value, or 0 if we went into the guest
+	ld	r3, 32(r1)
 	REST_NVGPRS(r1)
 	ld	r1, 0(r1)	// Switch back to caller stack
 	ld	r0, 16(r1)	// Reload LR


