Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BADCC259702
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgIAQJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:09:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731418AbgIAPiv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:38:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA44020E65;
        Tue,  1 Sep 2020 15:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974731;
        bh=UIiXDKl+MTlpYV/Z9SFdwrRkfKFxU48g8t3ma74X9As=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kmxvMBgKBsJf0nVw5AGrXotz3l/GOe/dlNc3HLwLVW/x6xHCgmu24cq1aKgrvJygT
         bsSb64CFMesHYuJ3SMnoAmGKBGbxozm/ibOG0zBkvy2au98YvvJYZ/r1f1gz9lfqPH
         yrXjt/yySIXBVc1gXmjlNc+lCdz0M4goTTDziDQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Narani <manish.narani@xilinx.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 072/255] mmc: sdhci-of-arasan: fix timings allocation code
Date:   Tue,  1 Sep 2020 17:08:48 +0200
Message-Id: <20200901151004.181713816@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manish Narani <manish.narani@xilinx.com>

[ Upstream commit 88e1d0b175ec0bfa775c8629eae2a728726e2c6a ]

The initial code that was adding delays was doing a cast over undefined
memory. This meant that the delays would be all gibberish.

This change, allocates all delays on the stack, and assigns them from the
ZynqMP & Versal macros/phase-list. And then finally copies them over the
common iclk_phase & oclk_phase variables.

Signed-off-by: Manish Narani <manish.narani@xilinx.com>
Link: https://lore.kernel.org/r/1594753953-62980-1-git-send-email-manish.narani@xilinx.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-of-arasan.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/mmc/host/sdhci-of-arasan.c b/drivers/mmc/host/sdhci-of-arasan.c
index fb26e743e1fd4..d0a80bfb953b0 100644
--- a/drivers/mmc/host/sdhci-of-arasan.c
+++ b/drivers/mmc/host/sdhci-of-arasan.c
@@ -1025,7 +1025,6 @@ static void arasan_dt_read_clk_phase(struct device *dev,
 static void arasan_dt_parse_clk_phases(struct device *dev,
 				       struct sdhci_arasan_clk_data *clk_data)
 {
-	int *iclk_phase, *oclk_phase;
 	u32 mio_bank = 0;
 	int i;
 
@@ -1037,28 +1036,32 @@ static void arasan_dt_parse_clk_phases(struct device *dev,
 	clk_data->set_clk_delays = sdhci_arasan_set_clk_delays;
 
 	if (of_device_is_compatible(dev->of_node, "xlnx,zynqmp-8.9a")) {
-		iclk_phase = (int [MMC_TIMING_MMC_HS400 + 1]) ZYNQMP_ICLK_PHASE;
-		oclk_phase = (int [MMC_TIMING_MMC_HS400 + 1]) ZYNQMP_OCLK_PHASE;
+		u32 zynqmp_iclk_phase[MMC_TIMING_MMC_HS400 + 1] =
+			ZYNQMP_ICLK_PHASE;
+		u32 zynqmp_oclk_phase[MMC_TIMING_MMC_HS400 + 1] =
+			ZYNQMP_OCLK_PHASE;
 
 		of_property_read_u32(dev->of_node, "xlnx,mio-bank", &mio_bank);
 		if (mio_bank == 2) {
-			oclk_phase[MMC_TIMING_UHS_SDR104] = 90;
-			oclk_phase[MMC_TIMING_MMC_HS200] = 90;
+			zynqmp_oclk_phase[MMC_TIMING_UHS_SDR104] = 90;
+			zynqmp_oclk_phase[MMC_TIMING_MMC_HS200] = 90;
 		}
 
 		for (i = 0; i <= MMC_TIMING_MMC_HS400; i++) {
-			clk_data->clk_phase_in[i] = iclk_phase[i];
-			clk_data->clk_phase_out[i] = oclk_phase[i];
+			clk_data->clk_phase_in[i] = zynqmp_iclk_phase[i];
+			clk_data->clk_phase_out[i] = zynqmp_oclk_phase[i];
 		}
 	}
 
 	if (of_device_is_compatible(dev->of_node, "xlnx,versal-8.9a")) {
-		iclk_phase = (int [MMC_TIMING_MMC_HS400 + 1]) VERSAL_ICLK_PHASE;
-		oclk_phase = (int [MMC_TIMING_MMC_HS400 + 1]) VERSAL_OCLK_PHASE;
+		u32 versal_iclk_phase[MMC_TIMING_MMC_HS400 + 1] =
+			VERSAL_ICLK_PHASE;
+		u32 versal_oclk_phase[MMC_TIMING_MMC_HS400 + 1] =
+			VERSAL_OCLK_PHASE;
 
 		for (i = 0; i <= MMC_TIMING_MMC_HS400; i++) {
-			clk_data->clk_phase_in[i] = iclk_phase[i];
-			clk_data->clk_phase_out[i] = oclk_phase[i];
+			clk_data->clk_phase_in[i] = versal_iclk_phase[i];
+			clk_data->clk_phase_out[i] = versal_oclk_phase[i];
 		}
 	}
 
-- 
2.25.1



