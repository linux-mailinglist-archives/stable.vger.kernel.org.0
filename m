Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBCB429B37A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751837AbgJ0Ow0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:52:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1768387AbgJ0Otm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:49:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22F39206E5;
        Tue, 27 Oct 2020 14:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810181;
        bh=hMMjolOHhezTfEboHVT4V0QWkMrOOg2PC5xiFDOy9FI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fLLoORzFXFRnMKxd9VQoYN6lFTW3eMqfmDU4h8db/WmdSDjSYsGXJqoz0wr7UIhPK
         HMZuUsore8VlDzeBTLVl4IhH1CD9YBo9+aZEMECbDj0Ha8h/ra9ZxU3eFnlM86uPkx
         +2KCCr17gMLRzoOYTHiUJyRp75gPKOQCLwDiu9Ss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>,
        Xie He <xie.he.0141@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 042/633] net: hdlc: In hdlc_rcv, check to make sure dev is an HDLC device
Date:   Tue, 27 Oct 2020 14:46:25 +0100
Message-Id: <20201027135524.677380618@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit 01c4ceae0a38a0bdbfea6896f41efcd985a9c064 ]

The hdlc_rcv function is used as hdlc_packet_type.func to process any
skb received in the kernel with skb->protocol == htons(ETH_P_HDLC).
The purpose of this function is to provide second-stage processing for
skbs not assigned a "real" L3 skb->protocol value in the first stage.

This function assumes the device from which the skb is received is an
HDLC device (a device created by this module). It assumes that
netdev_priv(dev) returns a pointer to "struct hdlc_device".

However, it is possible that some driver in the kernel (not necessarily
in our control) submits a received skb with skb->protocol ==
htons(ETH_P_HDLC), from a non-HDLC device. In this case, the skb would
still be received by hdlc_rcv. This will cause problems.

hdlc_rcv should be able to recognize and drop invalid skbs. It should
first make sure "dev" is actually an HDLC device, before starting its
processing. This patch adds this check to hdlc_rcv.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Link: https://lore.kernel.org/r/20201020013152.89259-1-xie.he.0141@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wan/hdlc.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/net/wan/hdlc.c
+++ b/drivers/net/wan/hdlc.c
@@ -46,7 +46,15 @@ static struct hdlc_proto *first_proto;
 static int hdlc_rcv(struct sk_buff *skb, struct net_device *dev,
 		    struct packet_type *p, struct net_device *orig_dev)
 {
-	struct hdlc_device *hdlc = dev_to_hdlc(dev);
+	struct hdlc_device *hdlc;
+
+	/* First make sure "dev" is an HDLC device */
+	if (!(dev->priv_flags & IFF_WAN_HDLC)) {
+		kfree_skb(skb);
+		return NET_RX_SUCCESS;
+	}
+
+	hdlc = dev_to_hdlc(dev);
 
 	if (!net_eq(dev_net(dev), &init_net)) {
 		kfree_skb(skb);


