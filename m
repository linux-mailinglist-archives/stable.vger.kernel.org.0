Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0FC283AD8
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbgJEPiA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:38:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:59172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727895AbgJEPb4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:31:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF8892085B;
        Mon,  5 Oct 2020 15:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911915;
        bh=4cOnDL084QNcZBUqFADt3BSsfxvJdhmNTQZseo5pD9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EK6BOt6Rl1Dw2VN/1y+122qXzH4qsxgVu3qSSjF9bZV6dTA1O1tl7K8gvYUEZXoz2
         lYmUznDnwgp9OhZQbTerwOMvLFdbrM18mSCnkra9iErv17ohmoDhTZoMRUg+U6YJeZ
         tPrixP3Ln/tvDxFvG9J9HsT+K46dy04f7mLl3tJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>,
        Martin Schiller <ms@dev.tdt.de>,
        Xie He <xie.he.0141@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 28/85] drivers/net/wan/hdlc_fr: Add needed_headroom for PVC devices
Date:   Mon,  5 Oct 2020 17:26:24 +0200
Message-Id: <20201005142116.088695824@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
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



