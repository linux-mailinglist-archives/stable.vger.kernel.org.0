Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4C4614DD4A
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 15:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbgA3OvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 09:51:16 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:42971 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727260AbgA3OvQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 09:51:16 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id AF3BB472;
        Thu, 30 Jan 2020 09:43:46 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 30 Jan 2020 09:43:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=FjgMyv
        AVHFaPPUiwQPJ1TIwdQd234t8eDpU+N/tHjWo=; b=PM8pRsl8yHkCD6rJaXrwJt
        YhUWMw6dm1Fh8h/i+aadF01GfzvLhgguYuZtYtT6vnlp0INMhGhxpv8PWgKcxd5/
        jkBCG98TrZ2Ud4D6YDmcds4qcZIIR1Xs6tN5tF/WoAA61tVROcpODB+QjTVafj3z
        ygeDxYeyso40AT2J7Wo6saEueBT/eeF3jQldaC5HvA/+AKPI026d/ChkTvXzTXdU
        u82/OPQKNsAeEO/u8sRdz4GrcD9K71klWDnvK99nq1mkQQuOKAzZe28xMJ3acMhW
        1PysJzuj3qxa9ojneGnPbbZax0t/ugyIV2wUgRGfYNgj/vR9WaQmUSNEOxeFZEqw
        ==
X-ME-Sender: <xms:ousyXqrlICfe1-7n_k9MQ0x-Emzs9hJyHca7JAV4cvtEYzxy_BxG0Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrfeekgdeijecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeegrddvgedurdduleekrddukedunecuvehluhhsthgvrhfuihiivgepvd
    enucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:ousyXj4qIpR-CfaknfPRL7OggwYlKJWuXfy5rnQrd8JZm2fm8GxgKg>
    <xmx:ousyXvfTBMveEYojHcqeKbNOCz9JvJM_ZotjVIp_Dzavedum2oqKWw>
    <xmx:ousyXnjmoJbQC04gJTpzSF4_KtpSmYRDGAM23Qv2FRLOEcsg9f6UYA>
    <xmx:ousyXuJdZi5AwPRhukufXEQNW1gHA8OntPZjHQg7PpzHrkfvE7umSQ>
Received: from localhost (unknown [84.241.198.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id C79513060B16;
        Thu, 30 Jan 2020 09:43:45 -0500 (EST)
Subject: FAILED: patch "[PATCH] rsi: fix use-after-free on failed probe and unbind" failed to apply to 4.4-stable tree
To:     johan@kernel.org, amit.karwar@redpinesignals.com,
        fariyaf@gmail.com, kvalo@codeaurora.org, prameela.j04cs@gmail.com,
        siva.rebbagondla@redpinesignals.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 30 Jan 2020 15:37:35 +0100
Message-ID: <158039505578131@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

