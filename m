Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88952473CD
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731753AbgHQTBc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:01:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:59194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730272AbgHQPro (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:47:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEA7E20789;
        Mon, 17 Aug 2020 15:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679263;
        bh=Wxm+dQv1e/7S1fyu4VC3ugX/kDSnqeoQZQzm/VmVwXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MEGWAseOMH0LWg7NJWzmP1RBVWtey5Rcr/taMENO/hCDJfzU6yQmq+3hOPiEsTmeX
         1RSSTU6uvh6n7x0a7rejkSDYCmviBHA3kHhoxuMu5WTtXjWgoSeRJrvLBNNWSa/1UG
         1MjanwfZ9CsA3xBSCqwjA8tFSOFtPo1ejJRvPoFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Chen <Mark-YW.Chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 150/393] Bluetooth: btusb: fix up firmware download sequence
Date:   Mon, 17 Aug 2020 17:13:20 +0200
Message-Id: <20200817143826.890504707@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit f645125711c80f9651e4a57403d799070c6ad13b ]

Data RAM on the device have to be powered on before starting to download
the firmware.

Fixes: a1c49c434e15 ("Bluetooth: btusb: Add protocol support for MediaTek MT7668U USB devices")
Co-developed-by: Mark Chen <Mark-YW.Chen@mediatek.com>
Signed-off-by: Mark Chen <Mark-YW.Chen@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 3d9313c746f39..4085387f13cfb 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2826,7 +2826,7 @@ static int btusb_mtk_setup_firmware(struct hci_dev *hdev, const char *fwname)
 	const u8 *fw_ptr;
 	size_t fw_size;
 	int err, dlen;
-	u8 flag;
+	u8 flag, param;
 
 	err = request_firmware(&fw, fwname, &hdev->dev);
 	if (err < 0) {
@@ -2834,6 +2834,20 @@ static int btusb_mtk_setup_firmware(struct hci_dev *hdev, const char *fwname)
 		return err;
 	}
 
+	/* Power on data RAM the firmware relies on. */
+	param = 1;
+	wmt_params.op = BTMTK_WMT_FUNC_CTRL;
+	wmt_params.flag = 3;
+	wmt_params.dlen = sizeof(param);
+	wmt_params.data = &param;
+	wmt_params.status = NULL;
+
+	err = btusb_mtk_hci_wmt_sync(hdev, &wmt_params);
+	if (err < 0) {
+		bt_dev_err(hdev, "Failed to power on data RAM (%d)", err);
+		return err;
+	}
+
 	fw_ptr = fw->data;
 	fw_size = fw->size;
 
-- 
2.25.1



