Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D13AC15C1B3
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387476AbgBMPZh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:25:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:41630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387470AbgBMPZg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:25:36 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BFF820848;
        Thu, 13 Feb 2020 15:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607535;
        bh=AAt1npNBuoF9HEte28mNGNs8qJLbOCp8Vc1bkpK/1Hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=088Rnp5/AYdeFi8LC9tlzl/u7Jjr+cYoZdGPHy8TZ7IuqCkLoNvQbMM3YaIvJwMrZ
         NKyFMrBJAjX9RFi4XgBYkjU08urvrTM4uoTdSAYKloYLyNSQR++U2/HbkGf9JdBNXe
         CZ8DKPJWGYaD8LYprrcImjh2bRSVbOEG2mMk6zns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Hunter <jonathanh@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 4.14 092/173] clk: tegra: Mark fuse clock as critical
Date:   Thu, 13 Feb 2020 07:19:55 -0800
Message-Id: <20200213151956.303629055@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

commit bf83b96f87ae2abb1e535306ea53608e8de5dfbb upstream.

For a little over a year, U-Boot on Tegra124 has configured the flow
controller to perform automatic RAM re-repair on off->on power
transitions of the CPU rail[1]. This is mandatory for correct operation
of Tegra124. However, RAM re-repair relies on certain clocks, which the
kernel must enable and leave running. The fuse clock is one of those
clocks. Mark this clock as critical so that LP1 power mode (system
suspend) operates correctly.

[1] 3cc7942a4ae5 ARM: tegra: implement RAM repair

Reported-by: Jonathan Hunter <jonathanh@nvidia.com>
Cc: stable@vger.kernel.org
Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/tegra/clk-tegra-periph.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/clk/tegra/clk-tegra-periph.c
+++ b/drivers/clk/tegra/clk-tegra-periph.c
@@ -825,7 +825,11 @@ static struct tegra_periph_init_data gat
 	GATE("vcp", "clk_m", 29, 0, tegra_clk_vcp, 0),
 	GATE("apbdma", "clk_m", 34, 0, tegra_clk_apbdma, 0),
 	GATE("kbc", "clk_32k", 36, TEGRA_PERIPH_ON_APB | TEGRA_PERIPH_NO_RESET, tegra_clk_kbc, 0),
-	GATE("fuse", "clk_m", 39, TEGRA_PERIPH_ON_APB, tegra_clk_fuse, 0),
+	/*
+	 * Critical for RAM re-repair operation, which must occur on resume
+	 * from LP1 system suspend and as part of CCPLEX cluster switching.
+	 */
+	GATE("fuse", "clk_m", 39, TEGRA_PERIPH_ON_APB, tegra_clk_fuse, CLK_IS_CRITICAL),
 	GATE("fuse_burn", "clk_m", 39, TEGRA_PERIPH_ON_APB, tegra_clk_fuse_burn, 0),
 	GATE("kfuse", "clk_m", 40, TEGRA_PERIPH_ON_APB, tegra_clk_kfuse, 0),
 	GATE("apbif", "clk_m", 107, TEGRA_PERIPH_ON_APB, tegra_clk_apbif, 0),


