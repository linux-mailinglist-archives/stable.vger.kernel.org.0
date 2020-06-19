Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C7A200FA2
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392642AbgFSPT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:19:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392010AbgFSPTf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:19:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 964C721582;
        Fri, 19 Jun 2020 15:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579974;
        bh=YTANZPruMdfvSrcCUEMGloogkU0s++47yJ9qS7/zSro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xMDv7s4Bsg54NkkWQeDmx8Eoh9Yk76teKiVI/teoJ49+gaGTjl4YNixlGZmRZLMn3
         dz2BHefqRDkvhb4/LbmAM1+atSFiF2htTjbuekB48UFBAwlKVIwYnV8UVNgHTPJKVF
         bXYqX0QcknPa2fxFeDzUrTgSBPNzvibqBKpIU4Bk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zijun Hu <zijuhu@codeaurora.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 074/376] Bluetooth: hci_qca: Fix suspend/resume functionality failure
Date:   Fri, 19 Jun 2020 16:29:52 +0200
Message-Id: <20200619141713.856607857@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zijun Hu <zijuhu@codeaurora.org>

[ Upstream commit feac90d756c03b03b83fabe83571bd88ecc96b78 ]

@dev parameter of qca_suspend()/qca_resume() represents
serdev_device, but it is mistook for hci_dev and causes
succedent unexpected memory access.

Fix by taking @dev as serdev_device.

Fixes: 41d5b25fed0 ("Bluetooth: hci_qca: add PM support")
Signed-off-by: Zijun Hu <zijuhu@codeaurora.org>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 439392b1c043..0b1036e5e963 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1953,8 +1953,9 @@ static void qca_serdev_remove(struct serdev_device *serdev)
 
 static int __maybe_unused qca_suspend(struct device *dev)
 {
-	struct hci_dev *hdev = container_of(dev, struct hci_dev, dev);
-	struct hci_uart *hu = hci_get_drvdata(hdev);
+	struct serdev_device *serdev = to_serdev_device(dev);
+	struct qca_serdev *qcadev = serdev_device_get_drvdata(serdev);
+	struct hci_uart *hu = &qcadev->serdev_hu;
 	struct qca_data *qca = hu->priv;
 	unsigned long flags;
 	int ret = 0;
@@ -2033,8 +2034,9 @@ error:
 
 static int __maybe_unused qca_resume(struct device *dev)
 {
-	struct hci_dev *hdev = container_of(dev, struct hci_dev, dev);
-	struct hci_uart *hu = hci_get_drvdata(hdev);
+	struct serdev_device *serdev = to_serdev_device(dev);
+	struct qca_serdev *qcadev = serdev_device_get_drvdata(serdev);
+	struct hci_uart *hu = &qcadev->serdev_hu;
 	struct qca_data *qca = hu->priv;
 
 	clear_bit(QCA_SUSPENDING, &qca->flags);
-- 
2.25.1



