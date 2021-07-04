Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D733BB361
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbhGDXR6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:17:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234115AbhGDXOy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94AA5619B3;
        Sun,  4 Jul 2021 23:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440273;
        bh=f2gaVVk3qKCPhfPjawymn2OKft2ynD/p2RJ1eqdB8Jw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mxkE0/0GGMYbdp4gACLIIpDhkFx+WAvk9xh1yrs7LqPjORFBiEQbmLjLmEN5QYEF5
         nGB4StMAPQPrH5YBR0lYwMT8Mm38Rz6o8+OF2BCMWm6cMFfi7p9ZsQ1JqInIlQ3pUj
         kELGZBct7wVZh5Dozs2dssq39Uhj0q4iOZIZ2e9XQ6Gm0ZEHVLRbDhT2439WexrRSG
         T6dvL1Wpi98JYAd5Z+8993qWwIIvxCwe8lvIsWuCvcUo8Y264q49ypwrQGz0VFXLjy
         MPecmNCsit5RAv44F7b/6D/eY7uqJxt/DoruxsDXJic9jqTyRSjLZ94IP17lfcea3+
         V7RWxIWqo/GKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 23/31] media: dvb_net: avoid speculation from net slot
Date:   Sun,  4 Jul 2021 19:10:35 -0400
Message-Id: <20210704231043.1491209-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704231043.1491209-1-sashal@kernel.org>
References: <20210704231043.1491209-1-sashal@kernel.org>
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
index 10f78109bb3f..3f154755bbc6 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -56,6 +56,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/nospec.h>
 #include <linux/etherdevice.h>
 #include <linux/dvb/net.h>
 #include <linux/uio.h>
@@ -1473,14 +1474,20 @@ static int dvb_net_do_ioctl(struct file *file,
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
@@ -1533,14 +1540,20 @@ static int dvb_net_do_ioctl(struct file *file,
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

