Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E9748001E
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236003AbhL0PnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:43:09 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:42594 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239067AbhL0PlF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:41:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EE1D3CE10D1;
        Mon, 27 Dec 2021 15:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D687EC36AE7;
        Mon, 27 Dec 2021 15:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619662;
        bh=hL4Cpgou9wEr9VwmfBQqXqDHHxX5cwgGXwVQWXr8Fj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T3kmtNOzIeA/6Xi7+hNzpGF3PhBbzVNr/ZlbX1xTSNL7Gjem7F9tb5NXy3OfrLW2i
         OGKtcPVAzMBVyUTtgVRSfV8bhRpL0BzaoFoZesbiOhpwVLzE/ES9qcmtWDmnLi1dnO
         mAgL7iDZh1bacdclu5d337dZErWIIBh+Imw050ZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/128] net: marvell: prestera: fix incorrect structure access
Date:   Mon, 27 Dec 2021 16:30:01 +0100
Message-Id: <20211227151332.397132957@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yevhen Orlov <yevhen.orlov@plvision.eu>

[ Upstream commit 2efc2256febf214e7b2bdaa21fe6c3c3146acdcb ]

In line:
	upper = info->upper_dev;
We access upper_dev field, which is related only for particular events
(e.g. event == NETDEV_CHANGEUPPER). So, this line cause invalid memory
access for another events,
when ptr is not netdev_notifier_changeupper_info.

The KASAN logs are as follows:

[   30.123165] BUG: KASAN: stack-out-of-bounds in prestera_netdev_port_event.constprop.0+0x68/0x538 [prestera]
[   30.133336] Read of size 8 at addr ffff80000cf772b0 by task udevd/778
[   30.139866]
[   30.141398] CPU: 0 PID: 778 Comm: udevd Not tainted 5.16.0-rc3 #6
[   30.147588] Hardware name: DNI AmazonGo1 A7040 board (DT)
[   30.153056] Call trace:
[   30.155547]  dump_backtrace+0x0/0x2c0
[   30.159320]  show_stack+0x18/0x30
[   30.162729]  dump_stack_lvl+0x68/0x84
[   30.166491]  print_address_description.constprop.0+0x74/0x2b8
[   30.172346]  kasan_report+0x1e8/0x250
[   30.176102]  __asan_load8+0x98/0xe0
[   30.179682]  prestera_netdev_port_event.constprop.0+0x68/0x538 [prestera]
[   30.186847]  prestera_netdev_event_handler+0x1b4/0x1c0 [prestera]
[   30.193313]  raw_notifier_call_chain+0x74/0xa0
[   30.197860]  call_netdevice_notifiers_info+0x68/0xc0
[   30.202924]  register_netdevice+0x3cc/0x760
[   30.207190]  register_netdev+0x24/0x50
[   30.211015]  prestera_device_register+0x8a0/0xba0 [prestera]

Fixes: 3d5048cc54bd ("net: marvell: prestera: move netdev topology validation to prestera_main")
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Link: https://lore.kernel.org/r/20211216171714.11341-1-yevhen.orlov@plvision.eu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/prestera/prestera_main.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index f6d2f928c5b83..aa543b29799ed 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -707,23 +707,27 @@ static int prestera_netdev_port_event(struct net_device *lower,
 				      struct net_device *dev,
 				      unsigned long event, void *ptr)
 {
-	struct netdev_notifier_changeupper_info *info = ptr;
+	struct netdev_notifier_info *info = ptr;
+	struct netdev_notifier_changeupper_info *cu_info;
 	struct prestera_port *port = netdev_priv(dev);
 	struct netlink_ext_ack *extack;
 	struct net_device *upper;
 
-	extack = netdev_notifier_info_to_extack(&info->info);
-	upper = info->upper_dev;
+	extack = netdev_notifier_info_to_extack(info);
+	cu_info = container_of(info,
+			       struct netdev_notifier_changeupper_info,
+			       info);
 
 	switch (event) {
 	case NETDEV_PRECHANGEUPPER:
+		upper = cu_info->upper_dev;
 		if (!netif_is_bridge_master(upper) &&
 		    !netif_is_lag_master(upper)) {
 			NL_SET_ERR_MSG_MOD(extack, "Unknown upper device type");
 			return -EINVAL;
 		}
 
-		if (!info->linking)
+		if (!cu_info->linking)
 			break;
 
 		if (netdev_has_any_upper_dev(upper)) {
@@ -732,7 +736,7 @@ static int prestera_netdev_port_event(struct net_device *lower,
 		}
 
 		if (netif_is_lag_master(upper) &&
-		    !prestera_lag_master_check(upper, info->upper_info, extack))
+		    !prestera_lag_master_check(upper, cu_info->upper_info, extack))
 			return -EOPNOTSUPP;
 		if (netif_is_lag_master(upper) && vlan_uses_dev(dev)) {
 			NL_SET_ERR_MSG_MOD(extack,
@@ -748,14 +752,15 @@ static int prestera_netdev_port_event(struct net_device *lower,
 		break;
 
 	case NETDEV_CHANGEUPPER:
+		upper = cu_info->upper_dev;
 		if (netif_is_bridge_master(upper)) {
-			if (info->linking)
+			if (cu_info->linking)
 				return prestera_bridge_port_join(upper, port,
 								 extack);
 			else
 				prestera_bridge_port_leave(upper, port);
 		} else if (netif_is_lag_master(upper)) {
-			if (info->linking)
+			if (cu_info->linking)
 				return prestera_lag_port_add(port, upper);
 			else
 				prestera_lag_port_del(port);
-- 
2.34.1



