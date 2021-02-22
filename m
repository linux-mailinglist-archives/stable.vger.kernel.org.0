Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9543E321719
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbhBVMmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:42:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:52902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230480AbhBVMl0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:41:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72B8F64F1A;
        Mon, 22 Feb 2021 12:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997536;
        bh=zGNC/Msq2Mct8bA3ldnkJb9Q0GCEogFNKAOBx2PoKgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HYIwuTAeiBSLHAQskcprhbQXUaAkmFQ7ul0OXbNDzCwwBN9WmEk3icstNOX/CibLG
         /7nQwg33p1rtL6QpEsScO14N25jGGKJgX1QzRzW8uI6DXzLOCqO4Xlc25RAvdk1fvh
         6ISyhG/K9jRkd5pEW8m8JubaOk4g6zJHMXa7cpc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Narani <manish.narani@xilinx.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.14 56/57] usb: gadget: u_ether: Fix MTU size mismatch with RX packet size
Date:   Mon, 22 Feb 2021 13:36:22 +0100
Message-Id: <20210222121035.709487049@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121027.174911182@linuxfoundation.org>
References: <20210222121027.174911182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manish Narani <manish.narani@xilinx.com>

commit 0a88fa221ce911c331bf700d2214c5b2f77414d3 upstream

Fix the MTU size issue with RX packet size as the host sends the packet
with extra bytes containing ethernet header. This causes failure when
user sets the MTU size to the maximum i.e. 15412. In this case the
ethernet packet received will be of length 15412 plus the ethernet header
length. This patch fixes the issue where there is a check that RX packet
length must not be more than max packet length.

Fixes: bba787a860fa ("usb: gadget: ether: Allow jumbo frames")
Signed-off-by: Manish Narani <manish.narani@xilinx.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1605597215-122027-1-git-send-email-manish.narani@xilinx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/u_ether.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -49,9 +49,10 @@
 #define UETH__VERSION	"29-May-2008"
 
 /* Experiments show that both Linux and Windows hosts allow up to 16k
- * frame sizes. Set the max size to 15k+52 to prevent allocating 32k
+ * frame sizes. Set the max MTU size to 15k+52 to prevent allocating 32k
  * blocks and still have efficient handling. */
-#define GETHER_MAX_ETH_FRAME_LEN 15412
+#define GETHER_MAX_MTU_SIZE 15412
+#define GETHER_MAX_ETH_FRAME_LEN (GETHER_MAX_MTU_SIZE + ETH_HLEN)
 
 struct eth_dev {
 	/* lock is held while accessing port_usb
@@ -790,7 +791,7 @@ struct eth_dev *gether_setup_name(struct
 
 	/* MTU range: 14 - 15412 */
 	net->min_mtu = ETH_HLEN;
-	net->max_mtu = GETHER_MAX_ETH_FRAME_LEN;
+	net->max_mtu = GETHER_MAX_MTU_SIZE;
 
 	dev->gadget = g;
 	SET_NETDEV_DEV(net, &g->dev);
@@ -852,7 +853,7 @@ struct net_device *gether_setup_name_def
 
 	/* MTU range: 14 - 15412 */
 	net->min_mtu = ETH_HLEN;
-	net->max_mtu = GETHER_MAX_ETH_FRAME_LEN;
+	net->max_mtu = GETHER_MAX_MTU_SIZE;
 
 	return net;
 }


