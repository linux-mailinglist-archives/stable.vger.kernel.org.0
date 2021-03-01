Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37330328AD1
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234765AbhCASXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:23:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:39422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239691AbhCASS0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:18:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1809652D3;
        Mon,  1 Mar 2021 17:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620309;
        bh=WZQ8E4iiGne1eG2pllJoNNwnvslluunwrSZPfb+qQ8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zsZP3n8qHtG7DInA8VaWcH8/WYZYiy0Uq03uRUsn2noQdh2n6UyAwKbEoHEdharn+
         /qvnqhPUEPI51km/J1VgSkrWXz3gO6ymPu/mKEsMWCM1qfpqlftSx7+lKeKG/RuxEE
         i7RXhlk4e9a1q2o1iuVcDDtZE8nBEJ2GYj+vb6DE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jupeng Zhong <zhongjupeng@yulong.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 076/775] Bluetooth: btusb: Fix memory leak in btusb_mtk_wmt_recv
Date:   Mon,  1 Mar 2021 17:04:04 +0100
Message-Id: <20210301161205.434062923@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index da57c561642c4..a4f834a50a988 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3195,7 +3195,7 @@ static void btusb_mtk_wmt_recv(struct urb *urb)
 		skb = bt_skb_alloc(HCI_WMT_MAX_EVENT_SIZE, GFP_ATOMIC);
 		if (!skb) {
 			hdev->stat.err_rx++;
-			goto err_out;
+			return;
 		}
 
 		hci_skb_pkt_type(skb) = HCI_EVENT_PKT;
@@ -3213,13 +3213,18 @@ static void btusb_mtk_wmt_recv(struct urb *urb)
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
@@ -3228,11 +3233,6 @@ static void btusb_mtk_wmt_recv(struct urb *urb)
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



