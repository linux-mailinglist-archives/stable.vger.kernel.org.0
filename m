Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF67283A01
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbgJEPaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:30:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727159AbgJEPaV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:30:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0220B20B80;
        Mon,  5 Oct 2020 15:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911815;
        bh=4cOnDL084QNcZBUqFADt3BSsfxvJdhmNTQZseo5pD9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vWfCiO6iJepNy8Py5Wv5bBc9ZiEuLBAuVz4WfbNNiA5Knuix+ryW3AxcRoVZvSwqA
         bxJuif8KBi08j+WZyB2DuXroDnebLHjcVo6Ya6EsqwUQKEs7622KnRTC5G+GAZqE6v
         y5dWMdcBytf6QSTjbt5vKqAk6khYgNKHIp67sgds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>,
        Martin Schiller <ms@dev.tdt.de>,
        Xie He <xie.he.0141@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 18/57] drivers/net/wan/hdlc_fr: Add needed_headroom for PVC devices
Date:   Mon,  5 Oct 2020 17:26:30 +0200
Message-Id: <20201005142110.677172239@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142109.796046410@linuxfoundation.org>
References: <20201005142109.796046410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit 44a049c42681de71c783d75cd6e56b4e339488b0 ]

PVC devices are virtual devices in this driver stacked on top of the
actual HDLC device. They are the devices normal users would use.
PVC devices have two types: normal PVC devices and Ethernet-emulating
PVC devices.

When transmitting data with PVC devices, the ndo_start_xmit function
will prepend a header of 4 or 10 bytes. Currently this driver requests
this headroom to be reserved for normal PVC devices by setting their
hard_header_len to 10. However, this does not work when these devices
are used with AF_PACKET/RAW sockets. Also, this driver does not request
this headroom for Ethernet-emulating PVC devices (but deals with this
problem by reallocating the skb when needed, which is not optimal).

This patch replaces hard_header_len with needed_headroom, and set
needed_headroom for Ethernet-emulating PVC devices, too. This makes
the driver to request headroom for all PVC devices in all cases.

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/hdlc_fr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 9acad651ea1f6..12b35404cd8e7 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -1041,7 +1041,7 @@ static void pvc_setup(struct net_device *dev)
 {
 	dev->type = ARPHRD_DLCI;
 	dev->flags = IFF_POINTOPOINT;
-	dev->hard_header_len = 10;
+	dev->hard_header_len = 0;
 	dev->addr_len = 2;
 	netif_keep_dst(dev);
 }
@@ -1093,6 +1093,7 @@ static int fr_add_pvc(struct net_device *frad, unsigned int dlci, int type)
 	dev->mtu = HDLC_MAX_MTU;
 	dev->min_mtu = 68;
 	dev->max_mtu = HDLC_MAX_MTU;
+	dev->needed_headroom = 10;
 	dev->priv_flags |= IFF_NO_QUEUE;
 	dev->ml_priv = pvc;
 
-- 
2.25.1



