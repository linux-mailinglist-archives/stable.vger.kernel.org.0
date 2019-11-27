Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0DB910BA6F
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731375AbfK0VDK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:03:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:56262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732006AbfK0VDK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:03:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34E5421569;
        Wed, 27 Nov 2019 21:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888589;
        bh=xy9fV6VRf6ZTjqVGfwmNG4IyHl8ycEZP8gaaGlsnQeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Og3m16eVWE7dRvg7JHDCJdu5FhhqlabChg6XPep8wQQyhVjii7t8Sl/lGUKToI/Su
         mLVIVu2zV2XQr/JpX8Q1hWgLApCqOnw8aKVz6MqeTSP2jJrYm2Z4S7sStfr1a40VT0
         KF+SPoSoWtRgAk+afqCk0Pghg47Dq9kiuyQGodHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Radu Rendec <radu.rendec@gmail.com>,
        Patrick Talbert <ptalbert@redhat.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 151/306] macsec: update operstate when lower device changes
Date:   Wed, 27 Nov 2019 21:30:01 +0100
Message-Id: <20191127203126.714967921@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit e6ac075882b2afcdf2d5ab328ce4ab42a1eb9593 ]

Like all other virtual devices (macvlan, vlan), the operstate of a
macsec device should match the state of its lower device. This is done
by calling netif_stacked_transfer_operstate from its netdevice notifier.

We also need to call netif_stacked_transfer_operstate when a new macsec
device is created, so that its operstate is set properly. This is only
relevant when we try to bring the device up directly when we create it.

Radu Rendec proposed a similar patch, inspired from the 802.1q driver,
that included changing the administrative state of the macsec device,
instead of just the operstate. This version is similar to what the
macvlan driver does, and updates only the operstate.

Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
Reported-by: Radu Rendec <radu.rendec@gmail.com>
Reported-by: Patrick Talbert <ptalbert@redhat.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 05115fb0c97a9..50acd8c9d7f53 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3305,6 +3305,9 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 	if (err < 0)
 		goto del_dev;
 
+	netif_stacked_transfer_operstate(real_dev, dev);
+	linkwatch_fire_event(dev);
+
 	macsec_generation++;
 
 	return 0;
@@ -3489,6 +3492,20 @@ static int macsec_notify(struct notifier_block *this, unsigned long event,
 		return NOTIFY_DONE;
 
 	switch (event) {
+	case NETDEV_DOWN:
+	case NETDEV_UP:
+	case NETDEV_CHANGE: {
+		struct macsec_dev *m, *n;
+		struct macsec_rxh_data *rxd;
+
+		rxd = macsec_data_rtnl(real_dev);
+		list_for_each_entry_safe(m, n, &rxd->secys, secys) {
+			struct net_device *dev = m->secy.netdev;
+
+			netif_stacked_transfer_operstate(real_dev, dev);
+		}
+		break;
+	}
 	case NETDEV_UNREGISTER: {
 		struct macsec_dev *m, *n;
 		struct macsec_rxh_data *rxd;
-- 
2.20.1



