Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA10E4526D3
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245401AbhKPCKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:10:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:45994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239539AbhKOSBM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:01:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A04863341;
        Mon, 15 Nov 2021 17:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997788;
        bh=zlgi4i2C09Cqvl1DXJVyI05x0bKAQExgenOZHrcPfWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SCid2wNIAeKc6OVEME3mnIuxzXG942x2WnmbWx0D0Nrj4X/tLZkZPXb4d1sz9b3cZ
         TtkLmbWZQk/An9HTYOYE1q3Ci7WO1UhHMp6UTl35CKygWbMUnIvcT+04WTsNyHLxUc
         DSkHZjKW3IGp5COgqe/8SCh3x/6e/l32+K7H+fZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 275/575] Bluetooth: btmtkuart: fix a memleak in mtk_hci_wmt_sync
Date:   Mon, 15 Nov 2021 18:00:00 +0100
Message-Id: <20211115165353.288042724@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 3e5f2d90c28f9454e421108554707620bc23269d ]

bdev->evt_skb will get freed in the normal path and one error path
of mtk_hci_wmt_sync, while the other error paths do not free it,
which may cause a memleak. This bug is suggested by a static analysis
tool, please advise.

Fixes: e0b67035a90b ("Bluetooth: mediatek: update the common setup between MT7622 and other devices")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtkuart.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/bluetooth/btmtkuart.c b/drivers/bluetooth/btmtkuart.c
index 6c40bc75fb5b8..719d4685a2ddd 100644
--- a/drivers/bluetooth/btmtkuart.c
+++ b/drivers/bluetooth/btmtkuart.c
@@ -158,8 +158,10 @@ static int mtk_hci_wmt_sync(struct hci_dev *hdev,
 	int err;
 
 	hlen = sizeof(*hdr) + wmt_params->dlen;
-	if (hlen > 255)
-		return -EINVAL;
+	if (hlen > 255) {
+		err = -EINVAL;
+		goto err_free_skb;
+	}
 
 	hdr = (struct mtk_wmt_hdr *)&wc;
 	hdr->dir = 1;
@@ -173,7 +175,7 @@ static int mtk_hci_wmt_sync(struct hci_dev *hdev,
 	err = __hci_cmd_send(hdev, 0xfc6f, hlen, &wc);
 	if (err < 0) {
 		clear_bit(BTMTKUART_TX_WAIT_VND_EVT, &bdev->tx_state);
-		return err;
+		goto err_free_skb;
 	}
 
 	/* The vendor specific WMT commands are all answered by a vendor
@@ -190,13 +192,14 @@ static int mtk_hci_wmt_sync(struct hci_dev *hdev,
 	if (err == -EINTR) {
 		bt_dev_err(hdev, "Execution of wmt command interrupted");
 		clear_bit(BTMTKUART_TX_WAIT_VND_EVT, &bdev->tx_state);
-		return err;
+		goto err_free_skb;
 	}
 
 	if (err) {
 		bt_dev_err(hdev, "Execution of wmt command timed out");
 		clear_bit(BTMTKUART_TX_WAIT_VND_EVT, &bdev->tx_state);
-		return -ETIMEDOUT;
+		err = -ETIMEDOUT;
+		goto err_free_skb;
 	}
 
 	/* Parse and handle the return WMT event */
-- 
2.33.0



