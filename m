Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 052E124100D
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbgHJT1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:27:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:40202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729338AbgHJTLe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 15:11:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71C4122B49;
        Mon, 10 Aug 2020 19:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086694;
        bh=K1hirN2sBpFZcADEX5DOg98QwrA5CvrnN4JSkIwDI64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QYlUrOSHgcXUNnqxnXvUtIZq2sT7skX3FJ/1fNxAF/cbkb0TLOuScO4IO7Wh0nT7y
         66t24ABBiMODSpg+YJ71plYe3pX/pZkPYL4ibBw0fbDMLbKiKQ/8q4I3TaHMWXcW5q
         H7fJ5If2Ld2T+11NUWbIPwPK7YGsykI0B3//c+eM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     shirley her <shirley.her@bayhubtech.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 47/60] mmc: sdhci-pci-o2micro: Bug fix for O2 host controller Seabird1
Date:   Mon, 10 Aug 2020 15:10:15 -0400
Message-Id: <20200810191028.3793884-47-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810191028.3793884-1-sashal@kernel.org>
References: <20200810191028.3793884-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: shirley her <shirley.her@bayhubtech.com>

[ Upstream commit cdd2b769789ae1a030e1a26f6c37c5833cabcb34 ]

To fix support for the O2 host controller Seabird1, set the quirk
SDHCI_QUIRK2_PRESET_VALUE_BROKEN and the capability bit MMC_CAP2_NO_SDIO.
Moreover, assign the ->get_cd() callback.

Signed-off-by: Shirley Her <shirley.her@bayhubtech.com>
Link: https://lore.kernel.org/r/20200721011733.8416-1-shirley.her@bayhubtech.com
[Ulf: Updated the commit message]
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-pci-o2micro.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mmc/host/sdhci-pci-o2micro.c b/drivers/mmc/host/sdhci-pci-o2micro.c
index fa8105087d684..41a2394313dd0 100644
--- a/drivers/mmc/host/sdhci-pci-o2micro.c
+++ b/drivers/mmc/host/sdhci-pci-o2micro.c
@@ -561,6 +561,12 @@ int sdhci_pci_o2_probe_slot(struct sdhci_pci_slot *slot)
 			slot->host->mmc_host_ops.get_cd = sdhci_o2_get_cd;
 		}
 
+		if (chip->pdev->device == PCI_DEVICE_ID_O2_SEABIRD1) {
+			slot->host->mmc_host_ops.get_cd = sdhci_o2_get_cd;
+			host->mmc->caps2 |= MMC_CAP2_NO_SDIO;
+			host->quirks2 |= SDHCI_QUIRK2_PRESET_VALUE_BROKEN;
+		}
+
 		host->mmc_host_ops.execute_tuning = sdhci_o2_execute_tuning;
 
 		if (chip->pdev->device != PCI_DEVICE_ID_O2_FUJIN2)
-- 
2.25.1

