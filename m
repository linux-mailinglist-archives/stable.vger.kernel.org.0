Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7A6383768
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343830AbhEQPnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:43:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243423AbhEQPlM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:41:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1711F61D0E;
        Mon, 17 May 2021 14:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262518;
        bh=DRdU950bFxrQzhdl2dct9MiKkUAcUctOWsGQgNIuahM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IWFk8jwkTAGWZV2seK6BePcZPp/Sm0xbGQfvzuxlXggPq59L2P5PwuL6y1K2wp4IS
         R3jZAPbGHm1S8YjEsdmf6k4n5HLDX1yPUWnuwrjuvYK7ILeDb3EZ53Qq7C4vWN9x8W
         RiNQP+ooEhI+psqLnMkFpMUNtmsGqML+I2Nt/O5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Collingbourne <pcc@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.10 205/289] arm64: mte: initialize RGSR_EL1.SEED in __cpu_setup
Date:   Mon, 17 May 2021 16:02:10 +0200
Message-Id: <20210517140312.014073830@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Collingbourne <pcc@google.com>

commit 37a8024d265564eba680575df6421f19db21dfce upstream.

A valid implementation choice for the ChooseRandomNonExcludedTag()
pseudocode function used by IRG is to behave in the same way as with
GCR_EL1.RRND=0. This would mean that RGSR_EL1.SEED is used as an LFSR
which must have a non-zero value in order for IRG to properly produce
pseudorandom numbers. However, RGSR_EL1 is reset to an UNKNOWN value
on soft reset and thus may reset to 0. Therefore we must initialize
RGSR_EL1.SEED to a non-zero value in order to ensure that IRG behaves
as expected.

Signed-off-by: Peter Collingbourne <pcc@google.com>
Fixes: 3b714d24ef17 ("arm64: mte: CPU feature detection and initial sysreg configuration")
Cc: <stable@vger.kernel.org> # 5.10
Link: https://linux-review.googlesource.com/id/I2b089b6c7d6f17ee37e2f0db7df5ad5bcc04526c
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20210507185905.1745402-1-pcc@google.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/proc.S |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -444,6 +444,18 @@ SYM_FUNC_START(__cpu_setup)
 	mov	x10, #(SYS_GCR_EL1_RRND | SYS_GCR_EL1_EXCL_MASK)
 	msr_s	SYS_GCR_EL1, x10
 
+	/*
+	 * If GCR_EL1.RRND=1 is implemented the same way as RRND=0, then
+	 * RGSR_EL1.SEED must be non-zero for IRG to produce
+	 * pseudorandom numbers. As RGSR_EL1 is UNKNOWN out of reset, we
+	 * must initialize it.
+	 */
+	mrs	x10, CNTVCT_EL0
+	ands	x10, x10, #SYS_RGSR_EL1_SEED_MASK
+	csinc	x10, x10, xzr, ne
+	lsl	x10, x10, #SYS_RGSR_EL1_SEED_SHIFT
+	msr_s	SYS_RGSR_EL1, x10
+
 	/* clear any pending tag check faults in TFSR*_EL1 */
 	msr_s	SYS_TFSR_EL1, xzr
 	msr_s	SYS_TFSRE0_EL1, xzr


