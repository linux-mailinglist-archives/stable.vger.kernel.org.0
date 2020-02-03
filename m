Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B606150D91
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729903AbgBCQb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:31:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:44668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730218AbgBCQb2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:31:28 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DE642051A;
        Mon,  3 Feb 2020 16:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747487;
        bh=/FxeA2SMt1YoBQQdaj+N42iEP6NaXB/5Fr77Nm5QU7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UvC5Uu8qfkt44698U3Er1E2eAGdZonOQzzzhyv9SlsAf2fDaOnLMf54tnUdvD28Wa
         jNST8no22ubRtlxPBt4p4AfjPqW5MPxoqLW0k+Ts2IhsDIgazHk4cUy37u1dErWSbL
         MtJtWAKr8QzgZylVAvoX30iKMt9gmqUL52GkE23w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b563b7f8dbe8223a51e8@syzkaller.appspotmail.com,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Fariya Fatima <fariyaf@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 07/70] rsi: fix use-after-free on failed probe and unbind
Date:   Mon,  3 Feb 2020 16:19:19 +0000
Message-Id: <20200203161913.553800552@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161912.158976871@linuxfoundation.org>
References: <20200203161912.158976871@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit e93cd35101b61e4c79149be2cfc927c4b28dc60c ]

Make sure to stop both URBs before returning after failed probe as well
as on disconnect to avoid use-after-free in the completion handler.

Reported-by: syzbot+b563b7f8dbe8223a51e8@syzkaller.appspotmail.com
Fixes: a4302bff28e2 ("rsi: add bluetooth rx endpoint")
Fixes: dad0d04fa7ba ("rsi: Add RS9113 wireless driver")
Cc: stable <stable@vger.kernel.org>     # 3.15
Cc: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: Amitkumar Karwar <amit.karwar@redpinesignals.com>
Cc: Fariya Fatima <fariyaf@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index c62e7e0f82f32..54106646445a9 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -291,6 +291,15 @@ static void rsi_rx_done_handler(struct urb *urb)
 		dev_kfree_skb(rx_cb->rx_skb);
 }
 
+static void rsi_rx_urb_kill(struct rsi_hw *adapter, u8 ep_num)
+{
+	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
+	struct rx_usb_ctrl_block *rx_cb = &dev->rx_cb[ep_num - 1];
+	struct urb *urb = rx_cb->rx_urb;
+
+	usb_kill_urb(urb);
+}
+
 /**
  * rsi_rx_urb_submit() - This function submits the given URB to the USB stack.
  * @adapter: Pointer to the adapter structure.
@@ -791,10 +800,13 @@ static int rsi_probe(struct usb_interface *pfunction,
 	if (adapter->priv->coex_mode > 1) {
 		status = rsi_rx_urb_submit(adapter, BT_EP, GFP_KERNEL);
 		if (status)
-			goto err1;
+			goto err_kill_wlan_urb;
 	}
 
 	return 0;
+
+err_kill_wlan_urb:
+	rsi_rx_urb_kill(adapter, WLAN_EP);
 err1:
 	rsi_deinit_usb_interface(adapter);
 err:
@@ -825,6 +837,10 @@ static void rsi_disconnect(struct usb_interface *pfunction)
 		adapter->priv->bt_adapter = NULL;
 	}
 
+	if (adapter->priv->coex_mode > 1)
+		rsi_rx_urb_kill(adapter, BT_EP);
+	rsi_rx_urb_kill(adapter, WLAN_EP);
+
 	rsi_reset_card(adapter);
 	rsi_deinit_usb_interface(adapter);
 	rsi_91x_deinit(adapter);
-- 
2.20.1



