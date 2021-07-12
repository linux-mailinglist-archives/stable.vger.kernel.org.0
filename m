Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047763C4E48
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237074AbhGLHRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:17:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241689AbhGLHRE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:17:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54C4D61447;
        Mon, 12 Jul 2021 07:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074042;
        bh=z8sR5TYSANk89jvS8OEPzj3aw9pG3htfJnr50LS1+nU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nzc0XOdnf6uIOqVvEMnkvJiScQPcz49NdaLH8kG6tOEWxzkZCB4bqpD9lbktG/5Kr
         GQRWDQxcnw5AzPpkicavU21EAgejS6dnpDR3Mxiv0s2lhhRJiTFkWX9+UbqGyasDbM
         HOLAUm6mlQyhg1d1Cbmkm9EwCeOEVslmtb8zGrW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 402/700] ath10k: add missing error return code in ath10k_pci_probe()
Date:   Mon, 12 Jul 2021 08:08:05 +0200
Message-Id: <20210712061019.135346471@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit e2783e2f39ba99178dedfc1646d5cc0979d1bab3 ]

When chip_id is not supported, the resources will be freed
on path err_unsupported, these resources will also be freed
when calling ath10k_pci_remove(), it will cause double free,
so return -ENODEV when it doesn't support the device with wrong
chip_id.

Fixes: c0c378f9907c ("ath10k: remove target soc ps code")
Fixes: 7505f7c3ec1d ("ath10k: create a chip revision whitelist")
Fixes: f8914a14623a ("ath10k: restore QCA9880-AR1A (v1) detection")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210522105822.1091848-3-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/pci.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 463cf3f8f8a5..71878ab35b93 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3685,8 +3685,10 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 			ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
 		if (bus_params.chip_id != 0xffffffff) {
 			if (!ath10k_pci_chip_is_supported(pdev->device,
-							  bus_params.chip_id))
+							  bus_params.chip_id)) {
+				ret = -ENODEV;
 				goto err_unsupported;
+			}
 		}
 	}
 
@@ -3697,11 +3699,15 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	}
 
 	bus_params.chip_id = ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
-	if (bus_params.chip_id == 0xffffffff)
+	if (bus_params.chip_id == 0xffffffff) {
+		ret = -ENODEV;
 		goto err_unsupported;
+	}
 
-	if (!ath10k_pci_chip_is_supported(pdev->device, bus_params.chip_id))
+	if (!ath10k_pci_chip_is_supported(pdev->device, bus_params.chip_id)) {
+		ret = -ENODEV;
 		goto err_unsupported;
+	}
 
 	ret = ath10k_core_register(ar, &bus_params);
 	if (ret) {
-- 
2.30.2



