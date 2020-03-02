Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12E6E176401
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 20:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbgCBTdh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 14:33:37 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:53875 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727234AbgCBTdh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Mar 2020 14:33:37 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 34BBA80F;
        Mon,  2 Mar 2020 14:33:36 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 02 Mar 2020 14:33:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=mPdSCK
        i6/8yiuwaQ+s7l6BcAB2GVFrKgtV89J/34pEg=; b=EfIxMKb4RzxoHiu7DUzwSU
        Mq3GqKO2UKb0sMBbc85lrxLyfLkoR/ZfYCnHvS96ioTKmblO7gjP55/nBnDgNnVN
        iYTkwal6BBIG1XKSt9OHvESnUYkLSdEkdwYndEuVhnAtiX1w28CMmDfXLPko+FRn
        iqEYJCDX5/uzRMCKJuoxMCbtgSaQlcvjZ5Nyq0tty1+LDBnaKpvwf3WYX/zeqpdd
        SaLODGg9NitimY8I7nqyb1k/D4nIzJtqXKIySMWhtjijpoZsLv5tycEihN/zJ8qa
        eDSF9uWjQQHef/Wn6UR5T1cm8Zed3167KQb/oVNz+P8pMNK+lhDEy0TQ5gLJObAg
        ==
X-ME-Sender: <xms:j19dXsx07dGfSq9LgzODiz2GiQB54BeInfeEo8HblFriRGqXA1qH2g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddtgedguddvjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:j19dXnhv8w7LabXbBfD0WvRbC-XTFMwYs-waYleQFtODE2JEpw4ZZA>
    <xmx:j19dXt0KzBL-1hyqtvv3FqW-eC8Ffkn3JpUV5Ntp6QGSL6NxCIfr4Q>
    <xmx:j19dXjq2wAj0xEpLurnOf0I1nPXh4ON8Hms2ENpk6YEu5UBKiGNDEw>
    <xmx:j19dXvLFTfZYWKa-hhn4A3REYwOQer_3aY2_iaoxd4Yu7MYzDDRxRg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6187A306130A;
        Mon,  2 Mar 2020 14:33:35 -0500 (EST)
Subject: FAILED: patch "[PATCH] hv_netvsc: Fix unwanted wakeup in netvsc_attach()" failed to apply to 4.14-stable tree
To:     haiyangz@microsoft.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 02 Mar 2020 20:33:33 +0100
Message-ID: <15831776137763@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f6f13c125e05603f68f5bf31f045b95e6d493598 Mon Sep 17 00:00:00 2001
From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Fri, 21 Feb 2020 08:32:18 -0800
Subject: [PATCH] hv_netvsc: Fix unwanted wakeup in netvsc_attach()

When netvsc_attach() is called by operations like changing MTU, etc.,
an extra wakeup may happen while netvsc_attach() calling
rndis_filter_device_add() which sends rndis messages when queue is
stopped in netvsc_detach(). The completion message will wake up queue 0.

We can reproduce the issue by changing MTU etc., then the wake_queue
counter from "ethtool -S" will increase beyond stop_queue counter:
     stop_queue: 0
     wake_queue: 1
The issue causes queue wake up, and counter increment, no other ill
effects in current code. So we didn't see any network problem for now.

To fix this, initialize tx_disable to true, and set it to false when
the NIC is ready to be attached or registered.

Fixes: 7b2ee50c0cd5 ("hv_netvsc: common detach logic")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index ae3f3084c2ed..1b320bcf150a 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -99,7 +99,7 @@ static struct netvsc_device *alloc_net_device(void)
 
 	init_waitqueue_head(&net_device->wait_drain);
 	net_device->destroy = false;
-	net_device->tx_disable = false;
+	net_device->tx_disable = true;
 
 	net_device->max_pkt = RNDIS_MAX_PKT_DEFAULT;
 	net_device->pkt_align = RNDIS_PKT_ALIGN_DEFAULT;
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 65e12cb07f45..2c0a24c606fc 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1068,6 +1068,7 @@ static int netvsc_attach(struct net_device *ndev,
 	}
 
 	/* In any case device is now ready */
+	nvdev->tx_disable = false;
 	netif_device_attach(ndev);
 
 	/* Note: enable and attach happen when sub-channels setup */
@@ -2476,6 +2477,8 @@ static int netvsc_probe(struct hv_device *dev,
 	else
 		net->max_mtu = ETH_DATA_LEN;
 
+	nvdev->tx_disable = false;
+
 	ret = register_netdevice(net);
 	if (ret != 0) {
 		pr_err("Unable to register netdev.\n");

