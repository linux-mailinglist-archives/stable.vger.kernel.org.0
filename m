Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26BEB2F11E
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbfE3EKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:10:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730895AbfE3DRC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:17:02 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4951245EB;
        Thu, 30 May 2019 03:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186221;
        bh=mSKlZux6lezkQaiVAF7+TsAapDtrd6W5CepR/4mSkWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yOSPnBHonlfAf0MlKGC+cqdaRmaHTc7MeOQiD4bDcaLOS4tsBw5rGc4qOljmMNBFw
         t7ec6BH22ePlTmY4uxdrq8qpkFeiaQaXHmhov0N+KuVmLhUFi5ZN3ClWh0ZD3jPu+9
         bUM9lkxdXknOgM5fIDXiCjbQOY+i5f/RCYLvXHQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Balakrishna Godavarthi <bgodavar@codeaurora.org>,
        Rocky Liao <rjliao@codeaurora.org>,
        Claire Chang <tientzu@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 114/276] Bluetooth: hci_qca: Give enough time to ROME controller to bootup.
Date:   Wed, 29 May 2019 20:04:32 -0700
Message-Id: <20190530030533.070327189@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7f09d5a6c33be66a5ca19bf9dd1c2d90c5dfcf0d ]

This patch enables enough time to ROME controller to bootup
after we bring the enable pin out of reset.

Fixes: 05ba533c5c11 ("Bluetooth: hci_qca: Add serdev support").
Signed-off-by: Balakrishna Godavarthi <bgodavar@codeaurora.org>
Reviewed-by: Rocky Liao <rjliao@codeaurora.org>
Tested-by: Rocky Liao <rjliao@codeaurora.org>
Tested-by: Claire Chang <tientzu@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index f0d593c3fa728..77004c29da089 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -504,6 +504,8 @@ static int qca_open(struct hci_uart *hu)
 		qcadev = serdev_device_get_drvdata(hu->serdev);
 		if (qcadev->btsoc_type != QCA_WCN3990) {
 			gpiod_set_value_cansleep(qcadev->bt_en, 1);
+			/* Controller needs time to bootup. */
+			msleep(150);
 		} else {
 			hu->init_speed = qcadev->init_speed;
 			hu->oper_speed = qcadev->oper_speed;
-- 
2.20.1



