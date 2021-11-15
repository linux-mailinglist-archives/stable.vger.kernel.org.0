Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542D9450BD3
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237817AbhKORaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:30:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:53206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237907AbhKOR1W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:27:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 102B963256;
        Mon, 15 Nov 2021 17:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996573;
        bh=ZFd09WJz7JVvVLZbfnvkUfsxEAo7eQt2ciN87SbPpRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rMXp3XCJnW0k0mnhuGIJ/TMtCFhP5nBiV5RGHvP9tgPkNTwrQQR/PdsdQt/yXqGCV
         O9UBZDEBiy6+YyViwdYERc/WdJjK+GQZ/Xa1Cg5pqONTQYtUpW6N6ShW2b7bBmJsxr
         Sa9KMNFz7qXIjUED3Mf4Sor2z7D0byu3sfwFCSRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 189/355] Bluetooth: btmtkuart: fix a memleak in mtk_hci_wmt_sync
Date:   Mon, 15 Nov 2021 18:01:53 +0100
Message-Id: <20211115165319.885214277@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
index 8a81fbca5c9d8..2beb2321825e3 100644
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



