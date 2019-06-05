Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD0135E8A
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 16:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbfFEOBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 10:01:49 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:7336 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727883AbfFEOBt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jun 2019 10:01:49 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5cf7cb4b0000>; Wed, 05 Jun 2019 07:01:47 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 05 Jun 2019 07:01:47 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 05 Jun 2019 07:01:47 -0700
Received: from HQMAIL108.nvidia.com (172.18.146.13) by HQMAIL108.nvidia.com
 (172.18.146.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 5 Jun
 2019 14:01:47 +0000
Received: from hqnvemgw01.nvidia.com (172.20.150.20) by HQMAIL108.nvidia.com
 (172.18.146.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 5 Jun 2019 14:01:47 +0000
Received: from moonraker.nvidia.com (Not Verified[10.21.132.143]) by hqnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5cf7cb490000>; Wed, 05 Jun 2019 07:01:46 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Peter De Schrijver <pdeschrijver@nvidia.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC:     <linux-clk@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sameer Pujar <spujar@nvidia.com>,
        Jon Hunter <jonathanh@nvidia.com>, <stable@vger.kernel.org>
Subject: [PATCH V2] clk: tegra210: Fix default rates for HDA clocks
Date:   Wed, 5 Jun 2019 15:01:39 +0100
Message-ID: <1559743299-11576-1-git-send-email-jonathanh@nvidia.com>
X-Mailer: git-send-email 2.7.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1559743307; bh=hr6Sum0EL3dKCRphnLWbT6XHD6+kpSgVHZM1eLLB26U=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         X-NVConfidentiality:MIME-Version:Content-Type;
        b=Db2YBDdd1BDikzDR26wB9hoAT7eKTtc05yoLCwgKHkj5kLQm/ysprX285tbHhdKuf
         WUnF/NdclaUTKsK71jtx0qhKfMErctkd2P3PN8/i9ElSUnUdg2fLkspTb4iFIirKpW
         v3zW2MMUNpKGHKnDoYCSOZYGSndvONC9cJOm6yHC7akEZwiPP/NId4z9NRIUtcdi2K
         CHnSjRN23U1ugxi7BZewKToBdHvO4IRYbutIoLavFH2ASzrpL+L8ZTfXniAo7/CBbs
         qkQpKCSv9wUVt1bfN/trAP3IZqeJSkhmZPGofrdrpdjZX74SSGaseMpTTHxKVgF86T
         NcZGFYONyao/Q==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently the default clock rates for the HDA and HDA2CODEC_2X clocks
are both 19.2MHz. However, the default rates for these clocks should
actually be 51MHz and 48MHz, respectively. The current clock settings
results in a distorted output during audio playback. Correct the default
clock rates for these clocks by specifying them in the clock init table
for Tegra210.

Cc: stable@vger.kernel.org
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
---
Changes since V1:
- Updated the changelog and cc'ed stable.

Please note that I have not added a fixes tag because this has always
been broken for Tegra210.

 drivers/clk/tegra/clk-tegra210.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/tegra/clk-tegra210.c b/drivers/clk/tegra/clk-tegra210.c
index e1ba62d2b1a0..ac1d27a8c650 100644
--- a/drivers/clk/tegra/clk-tegra210.c
+++ b/drivers/clk/tegra/clk-tegra210.c
@@ -3366,6 +3366,8 @@ static struct tegra_clk_init_table init_table[] __initdata = {
 	{ TEGRA210_CLK_I2S3_SYNC, TEGRA210_CLK_CLK_MAX, 24576000, 0 },
 	{ TEGRA210_CLK_I2S4_SYNC, TEGRA210_CLK_CLK_MAX, 24576000, 0 },
 	{ TEGRA210_CLK_VIMCLK_SYNC, TEGRA210_CLK_CLK_MAX, 24576000, 0 },
+	{ TEGRA210_CLK_HDA, TEGRA210_CLK_PLL_P, 51000000, 0 },
+	{ TEGRA210_CLK_HDA2CODEC_2X, TEGRA210_CLK_PLL_P, 48000000, 0 },
 	/* This MUST be the last entry. */
 	{ TEGRA210_CLK_CLK_MAX, TEGRA210_CLK_CLK_MAX, 0, 0 },
 };
-- 
2.7.4

