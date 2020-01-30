Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE0614DD4E
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 15:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbgA3OvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 09:51:17 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:41525 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727260AbgA3OvR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 09:51:17 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 84B21313;
        Thu, 30 Jan 2020 09:43:39 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 30 Jan 2020 09:43:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=aIetWP
        zn9nFLRU2hS5thTQuaihFLDyq2IYC+pqN+rkU=; b=JhRsnG+SXA86WF3PDF+0ea
        4L4srEd/Gj9Ysw/TiddJ4gMqzw8pnb2pWeOnBPbK0Z+sVgqCw2AyKDCSQ8pFyfAJ
        7xG8Z3q1/zKPlUTdKaxpwRMEcwQ2VtyHO1eyOXtijkw9MzIeVjzOi18D4BoYecRd
        yI9r9qUsXd3RJ6rreMsJ6EudSi/nPp2IMk3upOJd0MRpqqNJJnZR+M3gbhGE+eMR
        RgUtsdMJUmXPu2CODMIW7Du07FCA++WmAhOA+jboEONpJy838DUSNyA4Ayfh+sXz
        3jY0+KDKvkpF0CQ15AYJbAlzeENt7ma7g/fRfi7ESWZaNLue0aHU68lCu5mcUx4w
        ==
X-ME-Sender: <xms:musyXgYPEp5SFM1VA0jRYZRDV-Htp8ErpgctIU1Yk-nbloNWORQ8fw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrfeekgdeijecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeegrddvgedurdduleekrddukedunecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:musyXmC8SfVZklCcgV860hW-zZ9W-dYzVr9AUz08wxGcpAeASOrThA>
    <xmx:musyXm8Bdn_hi8S1FfRpaFJRfkQR6h65peNzwtG27dNy5U7CzOxT0Q>
    <xmx:musyXq4jl7GcI-gWaURHn8qzf5G34DDyGVo-dlnyze79S9NiUZZL3g>
    <xmx:m-syXjR0bb8Zlw6v6lb8jYaj3wKU440hlMF03ZK15xLw2onTNZ6nNA>
Received: from localhost (unknown [84.241.198.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id 580DA328005D;
        Thu, 30 Jan 2020 09:43:38 -0500 (EST)
Subject: FAILED: patch "[PATCH] rsi: fix use-after-free on failed probe and unbind" failed to apply to 4.19-stable tree
To:     johan@kernel.org, amit.karwar@redpinesignals.com,
        fariyaf@gmail.com, kvalo@codeaurora.org, prameela.j04cs@gmail.com,
        siva.rebbagondla@redpinesignals.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 30 Jan 2020 15:37:32 +0100
Message-ID: <1580395052165153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e93cd35101b61e4c79149be2cfc927c4b28dc60c Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Thu, 28 Nov 2019 18:22:00 +0100
Subject: [PATCH] rsi: fix use-after-free on failed probe and unbind

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

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 53f41fc2cadf..30bed719486e 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -292,6 +292,15 @@ static void rsi_rx_done_handler(struct urb *urb)
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
@@ -823,10 +832,13 @@ static int rsi_probe(struct usb_interface *pfunction,
 	if (adapter->priv->coex_mode > 1) {
 		status = rsi_rx_urb_submit(adapter, BT_EP);
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
@@ -857,6 +869,10 @@ static void rsi_disconnect(struct usb_interface *pfunction)
 		adapter->priv->bt_adapter = NULL;
 	}
 
+	if (adapter->priv->coex_mode > 1)
+		rsi_rx_urb_kill(adapter, BT_EP);
+	rsi_rx_urb_kill(adapter, WLAN_EP);
+
 	rsi_reset_card(adapter);
 	rsi_deinit_usb_interface(adapter);
 	rsi_91x_deinit(adapter);

