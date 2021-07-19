Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6EF3CD908
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242120AbhGSO00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:26:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244193AbhGSOYz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:24:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E418A60FDC;
        Mon, 19 Jul 2021 15:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707134;
        bh=f8njHHel1zt2TRdsVjS12iRp6xCGoCT+iAk6JB6cDoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qp5qpGxLyvZr1urZxC1A757q8XZjmcLyjuU70W5OAo5XGSQZFO0/OpWbuaG54r2/g
         UXcufmAvWEuZOCEWlNqKm/80mSWuMohO6/6sykrhRq+R9/rpBLc6iutlDWbyNrlLMI
         81F8eOjzPhuxrWfLtbKjIFtoNzcas2pNnLSGQk0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 043/245] media: dvb_net: avoid speculation from net slot
Date:   Mon, 19 Jul 2021 16:49:45 +0200
Message-Id: <20210719144941.794763720@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 9914f69a4a02..f133489af9b9 100644
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



