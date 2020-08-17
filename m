Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771E4246B0D
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730837AbgHQPsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:48:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730275AbgHQPrr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:47:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C2B220855;
        Mon, 17 Aug 2020 15:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679266;
        bh=Frg6GuRUhsOONlrctqAmXhrzsvKeSDaV/PFRSZRwPkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C1H/444HBBhseVtWZxD/VvjVCJfgqTdT1KNXfaQVXRDMUts8kJv5c/bFDfAkkVCs0
         pJXaoDAuhJrh/1dliht7OHQByBReJWcVMn9T620c3Nvrc4gFlp0MJRS1Jxvg0Lqmdr
         ++mjq5XiAHexHb+HYKIPO3Sn92FlmSmzfMDT7A2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Chen <Mark-YW.Chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 151/393] Bluetooth: btmtksdio: fix up firmware download sequence
Date:   Mon, 17 Aug 2020 17:13:21 +0200
Message-Id: <20200817143826.940490817@linuxfoundation.org>
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

[ Upstream commit 737cd06072a72e8984e41af8e5919338d0c5bf2b ]

Data RAM on the device have to be powered on before starting to download
the firmware.

Fixes: 9aebfd4a2200 ("Bluetooth: mediatek: add support for MediaTek MT7663S and MT7668S SDIO devices")
Co-developed-by: Mark Chen <Mark-YW.Chen@mediatek.com>
Signed-off-by: Mark Chen <Mark-YW.Chen@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtksdio.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btmtksdio.c b/drivers/bluetooth/btmtksdio.c
index 519788c442ca3..11494cd2a9823 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -685,7 +685,7 @@ static int mtk_setup_firmware(struct hci_dev *hdev, const char *fwname)
 	const u8 *fw_ptr;
 	size_t fw_size;
 	int err, dlen;
-	u8 flag;
+	u8 flag, param;
 
 	err = request_firmware(&fw, fwname, &hdev->dev);
 	if (err < 0) {
@@ -693,6 +693,20 @@ static int mtk_setup_firmware(struct hci_dev *hdev, const char *fwname)
 		return err;
 	}
 
+	/* Power on data RAM the firmware relies on. */
+	param = 1;
+	wmt_params.op = MTK_WMT_FUNC_CTRL;
+	wmt_params.flag = 3;
+	wmt_params.dlen = sizeof(param);
+	wmt_params.data = &param;
+	wmt_params.status = NULL;
+
+	err = mtk_hci_wmt_sync(hdev, &wmt_params);
+	if (err < 0) {
+		bt_dev_err(hdev, "Failed to power on data RAM (%d)", err);
+		return err;
+	}
+
 	fw_ptr = fw->data;
 	fw_size = fw->size;
 
-- 
2.25.1



