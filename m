Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F94FA732A
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 21:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfICTHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 15:07:09 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:43041 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725883AbfICTHI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 15:07:08 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E3641222F1;
        Tue,  3 Sep 2019 15:07:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 03 Sep 2019 15:07:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=IoxPSC
        tb2CR9yjaVZ7fa3Geyd8zhg7a01rzp5VLAzmc=; b=lORMqfD4Pvi9ne0yiaxz+7
        rrofkLMr9SWQG8OHrqSQhKSbOOsPHBHnbCSNRvRcW1i1UhMsfB5GE1qHIFNbQQTG
        9y9VfKoYXwNa6m+QCSISoY0WpuL3SCwvExjlK8Y7AQqP66vEvHXdw/THKLxgC0Nf
        KMfWOJoGU5UbPo3tpGzm5UkWorvJZZshtaWVrPGn3qcxSTdkusspLzEsUq+0Lg9u
        RQyyepcR6tJuAdYZZKau9oVuWb2T2GlGAU0YyXAgrFMlK29rHCqWZLzCW9XmjwE8
        rdHpvv4iMegU91LqyXiZzh0cuE3bWHc9pEQlBYL3G87qIc11h+cUAK+uJVV6/b4g
        ==
X-ME-Sender: <xms:27luXVfsUqi404axTX0WAxUFSm4CEGFM_RjC033-4sSupLZ3M6FzkQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejfedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:27luXXdn00t_w7T3DQUAe6z7cI9GNKlFivb8ktlMgzKH1r1A7MkFmA>
    <xmx:27luXSHr_M1s2zhAtGWagxMLTOUfMfMYJ8JNHsPS83g8mvS_rDcpzA>
    <xmx:27luXeHTh6jR1MjXT82Z78bryPJvgQba9XQqdwGY7tSTHswckTZsfw>
    <xmx:27luXclNF7Ps2y4jxI-H0ib5yETyjG0aHg6InM7A7FKbh-MyiCwdaQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 55D25D60062;
        Tue,  3 Sep 2019 15:07:07 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mt76: mt76x0u: do not reset radio on resume" failed to apply to 4.19-stable tree
To:     sgruszka@redhat.com, kvalo@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Sep 2019 21:07:05 +0200
Message-ID: <156753762597218@kroah.com>
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

From 8f2d163cb26da87e7d8e1677368b8ba1ba4d30b3 Mon Sep 17 00:00:00 2001
From: Stanislaw Gruszka <sgruszka@redhat.com>
Date: Thu, 18 Jul 2019 12:38:10 +0200
Subject: [PATCH] mt76: mt76x0u: do not reset radio on resume

On some machines mt76x0u firmware can hung during resume,
what result on messages like below:

[  475.480062] mt76x0 1-8:1.0: Error: MCU response pre-completed!
[  475.990066] mt76x0 1-8:1.0: Error: send MCU cmd failed:-110
[  475.990075] mt76x0 1-8:1.0: Error: MCU response pre-completed!
[  476.500003] mt76x0 1-8:1.0: Error: send MCU cmd failed:-110
[  476.500012] mt76x0 1-8:1.0: Error: MCU response pre-completed!
[  477.010046] mt76x0 1-8:1.0: Error: send MCU cmd failed:-110
[  477.010055] mt76x0 1-8:1.0: Error: MCU response pre-completed!
[  477.529997] mt76x0 1-8:1.0: Error: send MCU cmd failed:-110
[  477.530006] mt76x0 1-8:1.0: Error: MCU response pre-completed!
[  477.824907] mt76x0 1-8:1.0: Error: send MCU cmd failed:-71
[  477.824916] mt76x0 1-8:1.0: Error: MCU response pre-completed!
[  477.825029] usb 1-8: USB disconnect, device number 6

and possible whole system freeze.

This can be avoided, if we do not perform mt76x0_chip_onoff() reset.

Cc: stable@vger.kernel.org
Fixes: 134b2d0d1fcf ("mt76x0: init files")
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 627ed1fc7b15..645f4d15fb61 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -136,11 +136,11 @@ static const struct ieee80211_ops mt76x0u_ops = {
 	.release_buffered_frames = mt76_release_buffered_frames,
 };
 
-static int mt76x0u_init_hardware(struct mt76x02_dev *dev)
+static int mt76x0u_init_hardware(struct mt76x02_dev *dev, bool reset)
 {
 	int err;
 
-	mt76x0_chip_onoff(dev, true, true);
+	mt76x0_chip_onoff(dev, true, reset);
 
 	if (!mt76x02_wait_for_mac(&dev->mt76))
 		return -ETIMEDOUT;
@@ -173,7 +173,7 @@ static int mt76x0u_register_device(struct mt76x02_dev *dev)
 	if (err < 0)
 		goto out_err;
 
-	err = mt76x0u_init_hardware(dev);
+	err = mt76x0u_init_hardware(dev, true);
 	if (err < 0)
 		goto out_err;
 
@@ -309,7 +309,7 @@ static int __maybe_unused mt76x0_resume(struct usb_interface *usb_intf)
 	if (ret < 0)
 		goto err;
 
-	ret = mt76x0u_init_hardware(dev);
+	ret = mt76x0u_init_hardware(dev, false);
 	if (ret)
 		goto err;
 

