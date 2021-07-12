Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF703C458B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235009AbhGLG0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:26:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234724AbhGLGZH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:25:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75BD561151;
        Mon, 12 Jul 2021 06:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070934;
        bh=sN00r/5IN+63AltIC8b10zsHF2ONyOU0c4Q515h7124=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YRa/7SPhX2wZmQ6oeuOk4/48MPIgQFjaxfNPYfDFSCF9GmdbudMrJAlYPEPVw3VLd
         0or/6NHjtEBE4eCKgBY5KkJkB8kxGdU5LC/HYL4zcS50VeooD7pfvBfOdjQJttHfF4
         JvQqKuKv3sme+MTBS0aYomg8CwRDvB+hrOaEVKH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 201/348] ath10k: add missing error return code in ath10k_pci_probe()
Date:   Mon, 12 Jul 2021 08:09:45 +0200
Message-Id: <20210712060728.131292587@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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
index 53c791cc69a1..0f055e577749 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3647,8 +3647,10 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
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
 
@@ -3659,11 +3661,15 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
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



