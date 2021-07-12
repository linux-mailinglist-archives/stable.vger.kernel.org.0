Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C043C53AC
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348406AbhGLHzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:55:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350611AbhGLHvL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AF726141A;
        Mon, 12 Jul 2021 07:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075997;
        bh=z8sR5TYSANk89jvS8OEPzj3aw9pG3htfJnr50LS1+nU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bI/iklFcnZiQ3haFStOVl8nLuEhUoTFH+Q3s0Mp5BBfSk55sH9cC2sJy7aCKluLKi
         H9g0KjjvAlh1aZxqBYK0TWHdcnL6wQGF5RVedMQd0tmcRVnWdGZzrb9GG3qgbXi2hK
         jn29re6EGCD7CrZZtJxkPCotOJb9AbcbJC6vp2sU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 454/800] ath10k: add missing error return code in ath10k_pci_probe()
Date:   Mon, 12 Jul 2021 08:07:57 +0200
Message-Id: <20210712061015.453057151@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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



