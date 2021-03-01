Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B79328F3B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242033AbhCATsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:48:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:50730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236214AbhCATgF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:36:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 099BB65161;
        Mon,  1 Mar 2021 17:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618400;
        bh=sCzjkdrr6Y45yA0JMQmtMSyd+YvWcVn5SQKCQctTfxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EW5K/xRDypQ0xYRvNaLp4Fg0YhdwD4RDYGPkeavdIldtrth9u+EjJsaPin+b2zP+o
         Gj7cBTjM3HAx/P9imL98NG4grFfeTlg0gnx13yxU8t2m/7bEoU1ohRvlDDVat80fE9
         0Bv2bJut3o/K4Py5BVUBDQ+/gCLnG/pdSJKMOBBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jupeng Zhong <zhongjupeng@yulong.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/663] Bluetooth: btusb: Fix memory leak in btusb_mtk_wmt_recv
Date:   Mon,  1 Mar 2021 17:05:22 +0100
Message-Id: <20210301161145.395535693@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jupeng Zhong <zhongjupeng@yulong.com>

[ Upstream commit de71a6cb4bf24d8993b9ca90d1ddb131b60251a1 ]

In btusb_mtk_wmt_recv if skb_clone fails, the alocated skb should be
released.

Omit the labels “err_out” and “err_free_skb” in this function
implementation so that the desired exception handling code
would be directly specified in the affected if branches.

Fixes: a1c49c434e15 ("btusb: Add protocol support for MediaTek MT7668U USB devices")
Signed-off-by: Jupeng Zhong <zhongjupeng@yulong.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 1c942869baacc..2953b96b3ceda 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2827,7 +2827,7 @@ static void btusb_mtk_wmt_recv(struct urb *urb)
 		skb = bt_skb_alloc(HCI_WMT_MAX_EVENT_SIZE, GFP_ATOMIC);
 		if (!skb) {
 			hdev->stat.err_rx++;
-			goto err_out;
+			return;
 		}
 
 		hci_skb_pkt_type(skb) = HCI_EVENT_PKT;
@@ -2845,13 +2845,18 @@ static void btusb_mtk_wmt_recv(struct urb *urb)
 		 */
 		if (test_bit(BTUSB_TX_WAIT_VND_EVT, &data->flags)) {
 			data->evt_skb = skb_clone(skb, GFP_ATOMIC);
-			if (!data->evt_skb)
-				goto err_out;
+			if (!data->evt_skb) {
+				kfree_skb(skb);
+				return;
+			}
 		}
 
 		err = hci_recv_frame(hdev, skb);
-		if (err < 0)
-			goto err_free_skb;
+		if (err < 0) {
+			kfree_skb(data->evt_skb);
+			data->evt_skb = NULL;
+			return;
+		}
 
 		if (test_and_clear_bit(BTUSB_TX_WAIT_VND_EVT,
 				       &data->flags)) {
@@ -2860,11 +2865,6 @@ static void btusb_mtk_wmt_recv(struct urb *urb)
 			wake_up_bit(&data->flags,
 				    BTUSB_TX_WAIT_VND_EVT);
 		}
-err_out:
-		return;
-err_free_skb:
-		kfree_skb(data->evt_skb);
-		data->evt_skb = NULL;
 		return;
 	} else if (urb->status == -ENOENT) {
 		/* Avoid suspend failed when usb_kill_urb */
-- 
2.27.0



