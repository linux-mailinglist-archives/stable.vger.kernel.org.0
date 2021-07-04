Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5A03BB371
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhGDXSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:18:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234552AbhGDXPO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:15:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD114613D2;
        Sun,  4 Jul 2021 23:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440358;
        bh=goPWnGR9FFZQkpBa1JFvefYOOvvJ/dsmy54RL39bWxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KCY+/zUON/ZiOdo2Q+mpaDPKVKzP0JeEWY1b/7QezAKnCh+woUGUc5C9XnleWs9dY
         8yKBS3d9hRHAg94Q00Bot5Y09NR4M1VmYxtiBItIIc5DHF6AruiJ88yBnz1idf1D2/
         iKKtXV5z+f24t1lHpZTdCu80T+CU9R/2+5VwGPAsEVRFSIcr+qpT0oYbCMvUSD7loE
         qNuWapCmN2axX/g6HVyPKDp0mD4cw5iWzudwiTzQ1AyOYANc8V0MRrok7faE2sCgLY
         dzwflFb4F8B4gxwipCFUAu8qIUf4i/FOvVJk4OrLGvG2s8G7qADnIUFlZ48ZNLDQ4p
         8sDhvsTqE9Xsg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 12/15] media: dvb_net: avoid speculation from net slot
Date:   Sun,  4 Jul 2021 19:12:18 -0400
Message-Id: <20210704231222.1492037-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704231222.1492037-1-sashal@kernel.org>
References: <20210704231222.1492037-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit abc0226df64dc137b48b911c1fe4319aec5891bb ]

The risk of especulation is actually almost-non-existing here,
as there are very few users of TCP/IP using the DVB stack,
as, this is mainly used with DVB-S/S2 cards, and only by people
that receives TCP/IP from satellite connections, which limits
a lot the number of users of such feature(*).

(*) In thesis, DVB-C cards could also benefit from it, but I'm
yet to see a hardware that supports it.

Yet, fixing it is trivial.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-core/dvb_net.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index ce4332e80a91..735baa74043c 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -57,6 +57,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/nospec.h>
 #include <linux/etherdevice.h>
 #include <linux/dvb/net.h>
 #include <linux/uio.h>
@@ -1350,14 +1351,20 @@ static int dvb_net_do_ioctl(struct file *file,
 		struct net_device *netdev;
 		struct dvb_net_priv *priv_data;
 		struct dvb_net_if *dvbnetif = parg;
+		int if_num = dvbnetif->if_num;
 
-		if (dvbnetif->if_num >= DVB_NET_DEVICES_MAX ||
-		    !dvbnet->state[dvbnetif->if_num]) {
+		if (if_num >= DVB_NET_DEVICES_MAX) {
 			ret = -EINVAL;
 			goto ioctl_error;
 		}
+		if_num = array_index_nospec(if_num, DVB_NET_DEVICES_MAX);
 
-		netdev = dvbnet->device[dvbnetif->if_num];
+		if (!dvbnet->state[if_num]) {
+			ret = -EINVAL;
+			goto ioctl_error;
+		}
+
+		netdev = dvbnet->device[if_num];
 
 		priv_data = netdev_priv(netdev);
 		dvbnetif->pid=priv_data->pid;
@@ -1410,14 +1417,20 @@ static int dvb_net_do_ioctl(struct file *file,
 		struct net_device *netdev;
 		struct dvb_net_priv *priv_data;
 		struct __dvb_net_if_old *dvbnetif = parg;
+		int if_num = dvbnetif->if_num;
+
+		if (if_num >= DVB_NET_DEVICES_MAX) {
+			ret = -EINVAL;
+			goto ioctl_error;
+		}
+		if_num = array_index_nospec(if_num, DVB_NET_DEVICES_MAX);
 
-		if (dvbnetif->if_num >= DVB_NET_DEVICES_MAX ||
-		    !dvbnet->state[dvbnetif->if_num]) {
+		if (!dvbnet->state[if_num]) {
 			ret = -EINVAL;
 			goto ioctl_error;
 		}
 
-		netdev = dvbnet->device[dvbnetif->if_num];
+		netdev = dvbnet->device[if_num];
 
 		priv_data = netdev_priv(netdev);
 		dvbnetif->pid=priv_data->pid;
-- 
2.30.2

