Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33B640E1DE
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242145AbhIPQcG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:32:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242651AbhIPQ3Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:29:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8866661355;
        Thu, 16 Sep 2021 16:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809111;
        bh=8QkFF/3Y9FGExd+iL28DhiubSmPdF5al9BiXWID5Znk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G93GTPtlNdXqsivRQWKawWLqSmVmQJwnC6enc388RMVsxVqRhvaL0d3WVaeDdnTwF
         vx8ve70CiB1yppl018fwWBNMDWrKZPIoQxg0jAanNJW+lByNt03WnN84FZxa4aPjUJ
         nfFNcgJArE8s9BmguN3t+ibFy7hvjXASdNqpXUdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.13 033/380] arm64: Do not trap PMSNEVFR_EL1
Date:   Thu, 16 Sep 2021 17:56:30 +0200
Message-Id: <20210916155805.088818275@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

commit 50cb99fa89aa2bec2cab2f9917010bbd7769bfa3 upstream.

Commit 31c00d2aeaa2 ("arm64: Disable fine grained traps on boot") zeroed
the fine grained trap registers to prevent unwanted register traps from
occuring. However, for the PMSNEVFR_EL1 register, the corresponding
HDFG{R,W}TR_EL2.nPMSNEVFR_EL1 fields must be 1 to disable trapping. Set
both fields to 1 if FEAT_SPEv1p2 is detected to disable read and write
traps.

Fixes: 31c00d2aeaa2 ("arm64: Disable fine grained traps on boot")
Cc: <stable@vger.kernel.org> # 5.13.x
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210824154523.906270-1-alexandru.elisei@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/el2_setup.h |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -149,8 +149,17 @@
 	ubfx	x1, x1, #ID_AA64MMFR0_FGT_SHIFT, #4
 	cbz	x1, .Lskip_fgt_\@
 
-	msr_s	SYS_HDFGRTR_EL2, xzr
-	msr_s	SYS_HDFGWTR_EL2, xzr
+	mov	x0, xzr
+	mrs	x1, id_aa64dfr0_el1
+	ubfx	x1, x1, #ID_AA64DFR0_PMSVER_SHIFT, #4
+	cmp	x1, #3
+	b.lt	.Lset_fgt_\@
+	/* Disable PMSNEVFR_EL1 read and write traps */
+	orr	x0, x0, #(1 << 62)
+
+.Lset_fgt_\@:
+	msr_s	SYS_HDFGRTR_EL2, x0
+	msr_s	SYS_HDFGWTR_EL2, x0
 	msr_s	SYS_HFGRTR_EL2, xzr
 	msr_s	SYS_HFGWTR_EL2, xzr
 	msr_s	SYS_HFGITR_EL2, xzr


