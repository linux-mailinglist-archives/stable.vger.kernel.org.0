Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37EE1157BC6
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbgBJMfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:35:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:53592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728116AbgBJMfs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:48 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3352E214DB;
        Mon, 10 Feb 2020 12:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338148;
        bh=SIsmPf3abXu8RlcQgswvaUTqnh7SxIEE2Cc3DW6G/Lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XVvka3is5EjMfA3XVB5jAwMDjlkU19N+oYZhOURwNhtjd0UbUEtej4ZhI0D7fS2U0
         PU4Nr2VHw5KT9nXdCqWcl5ijr8R5ldGu24yWbrWRhMYJotSmK5R3HRvRYBCljaR1UB
         Um/wIa7/zehty3wjKV5K9vEWoCAfxHzA7Xl6wMRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Hunter <jonathanh@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 4.19 109/195] ARM: tegra: Enable PLLP bypass during Tegra124 LP1
Date:   Mon, 10 Feb 2020 04:32:47 -0800
Message-Id: <20200210122316.106249073@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

commit 1a3388d506bf5b45bb283e6a4c4706cfb4897333 upstream.

For a little over a year, U-Boot has configured the flow controller to
perform automatic RAM re-repair on off->on power transitions of the CPU
rail[1]. This is mandatory for correct operation of Tegra124. However,
RAM re-repair relies on certain clocks, which the kernel must enable and
leave running. PLLP is one of those clocks. This clock is shut down
during LP1 in order to save power. Enable bypass (which I believe routes
osc_div_clk, essentially the crystal clock, to the PLL output) so that
this clock signal toggles even though the PLL is not active. This is
required so that LP1 power mode (system suspend) operates correctly.

The bypass configuration must then be undone when resuming from LP1, so
that all peripheral clocks run at the expected rate. Without this, many
peripherals won't work correctly; for example, the UART baud rate would
be incorrect.

NVIDIA's downstream kernel code only does this if not compiled for
Tegra30, so the added code is made conditional upon the chip ID.
NVIDIA's downstream code makes this change conditional upon the active
CPU cluster. The upstream kernel currently doesn't support cluster
switching, so this patch doesn't test the active CPU cluster ID.

[1] 3cc7942a4ae5 ARM: tegra: implement RAM repair

Reported-by: Jonathan Hunter <jonathanh@nvidia.com>
Cc: stable@vger.kernel.org
Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-tegra/sleep-tegra30.S |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/arm/mach-tegra/sleep-tegra30.S
+++ b/arch/arm/mach-tegra/sleep-tegra30.S
@@ -382,6 +382,14 @@ _pll_m_c_x_done:
 	pll_locked r1, r0, CLK_RESET_PLLC_BASE
 	pll_locked r1, r0, CLK_RESET_PLLX_BASE
 
+	tegra_get_soc_id TEGRA_APB_MISC_BASE, r1
+	cmp	r1, #TEGRA30
+	beq	1f
+	ldr	r1, [r0, #CLK_RESET_PLLP_BASE]
+	bic	r1, r1, #(1<<31)	@ disable PllP bypass
+	str	r1, [r0, #CLK_RESET_PLLP_BASE]
+1:
+
 	mov32	r7, TEGRA_TMRUS_BASE
 	ldr	r1, [r7]
 	add	r1, r1, #LOCK_DELAY
@@ -641,7 +649,10 @@ tegra30_switch_cpu_to_clk32k:
 	str	r0, [r4, #PMC_PLLP_WB0_OVERRIDE]
 
 	/* disable PLLP, PLLA, PLLC and PLLX */
+	tegra_get_soc_id TEGRA_APB_MISC_BASE, r1
+	cmp	r1, #TEGRA30
 	ldr	r0, [r5, #CLK_RESET_PLLP_BASE]
+	orrne	r0, r0, #(1 << 31)	@ enable PllP bypass on fast cluster
 	bic	r0, r0, #(1 << 30)
 	str	r0, [r5, #CLK_RESET_PLLP_BASE]
 	ldr	r0, [r5, #CLK_RESET_PLLA_BASE]


