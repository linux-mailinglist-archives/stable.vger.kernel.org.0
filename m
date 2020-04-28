Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6DD1BCBC0
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 21:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbgD1S1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:27:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729026AbgD1S1j (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:27:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77596214AF;
        Tue, 28 Apr 2020 18:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098458;
        bh=/7QBwKfyFaGo2/A27oj+RtU0qplo/5qvvtiZVFK3pMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aBxVapo+/6mSwnE9IT+hqAOSf6D/swB/IwgwwqsfCSF9SEpdzlL9kSGIYMGpmcXbk
         JFYB8+Hh/DZuXZjrhMNAw3jGtVcKwY3XAyGuh2BJsxtIuRGHO8h7D4vs1E/LIMnpLJ
         k2tv+caPsF8Fre6+LX29PIPA02Ni5xSbdZbbBOQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 049/167] macsec: avoid to set wrong mtu
Date:   Tue, 28 Apr 2020 20:23:45 +0200
Message-Id: <20200428182231.256018680@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 7f327080364abccf923fa5a5b24e038eb0ba1407 ]

When a macsec interface is created, the mtu is calculated with the lower
interface's mtu value.
If the mtu of lower interface is lower than the length, which is needed
by macsec interface, macsec's mtu value will be overflowed.
So, if the lower interface's mtu is too low, macsec interface's mtu
should be set to 0.

Test commands:
    ip link add dummy0 mtu 10 type dummy
    ip link add macsec0 link dummy0 type macsec
    ip link show macsec0

Before:
    11: macsec0@dummy0: <BROADCAST,MULTICAST,M-DOWN> mtu 4294967274
After:
    11: macsec0@dummy0: <BROADCAST,MULTICAST,M-DOWN> mtu 0

Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macsec.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3658,11 +3658,11 @@ static int macsec_newlink(struct net *ne
 			  struct netlink_ext_ack *extack)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
+	rx_handler_func_t *rx_handler;
+	u8 icv_len = DEFAULT_ICV_LEN;
 	struct net_device *real_dev;
-	int err;
+	int err, mtu;
 	sci_t sci;
-	u8 icv_len = DEFAULT_ICV_LEN;
-	rx_handler_func_t *rx_handler;
 
 	if (!tb[IFLA_LINK])
 		return -EINVAL;
@@ -3681,7 +3681,11 @@ static int macsec_newlink(struct net *ne
 
 	if (data && data[IFLA_MACSEC_ICV_LEN])
 		icv_len = nla_get_u8(data[IFLA_MACSEC_ICV_LEN]);
-	dev->mtu = real_dev->mtu - icv_len - macsec_extra_len(true);
+	mtu = real_dev->mtu - icv_len - macsec_extra_len(true);
+	if (mtu < 0)
+		dev->mtu = 0;
+	else
+		dev->mtu = mtu;
 
 	rx_handler = rtnl_dereference(real_dev->rx_handler);
 	if (rx_handler && rx_handler != macsec_handle_frame)


