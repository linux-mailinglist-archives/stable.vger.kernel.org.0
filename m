Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67C99541BD2
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353449AbiFGVyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383219AbiFGVwq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:52:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A11862431A2;
        Tue,  7 Jun 2022 12:10:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2712CB823B1;
        Tue,  7 Jun 2022 19:10:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CF6C385A2;
        Tue,  7 Jun 2022 19:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629041;
        bh=EbUndU5aN6FSHQ/Au1vWjV4N7TDNpgYntN0GGYXZbew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XviRhwEdy0Ut62+yizNm7QJAck2dpDv4TV+1aZMiYJvr5HpEPs+BjeYb9GJ+xEV6s
         s1pDVfxENANqpjmasRw8pSFus4P7iOdl6EAUNMgfCn8rUwaTp+Y9jF2zxkmGTaTCju
         b7OFMXH247njx33DlEHJxowJUjzxMToCaG5q3H8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+92beb3d46aab498710fa@syzkaller.appspotmail.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 507/879] bonding: fix missed rcu protection
Date:   Tue,  7 Jun 2022 19:00:25 +0200
Message-Id: <20220607165017.592202504@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 9b80ccda233fa6c59de411bf889cc4d0e028f2c7 ]

When removing the rcu_read_lock in bond_ethtool_get_ts_info() as
discussed [1], I didn't notice it could be called via setsockopt,
which doesn't hold rcu lock, as syzbot pointed:

  stack backtrace:
  CPU: 0 PID: 3599 Comm: syz-executor317 Not tainted 5.18.0-rc5-syzkaller-01392-g01f4685797a5 #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  Call Trace:
   <TASK>
   __dump_stack lib/dump_stack.c:88 [inline]
   dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
   bond_option_active_slave_get_rcu include/net/bonding.h:353 [inline]
   bond_ethtool_get_ts_info+0x32c/0x3a0 drivers/net/bonding/bond_main.c:5595
   __ethtool_get_ts_info+0x173/0x240 net/ethtool/common.c:554
   ethtool_get_phc_vclocks+0x99/0x110 net/ethtool/common.c:568
   sock_timestamping_bind_phc net/core/sock.c:869 [inline]
   sock_set_timestamping+0x3a3/0x7e0 net/core/sock.c:916
   sock_setsockopt+0x543/0x2ec0 net/core/sock.c:1221
   __sys_setsockopt+0x55e/0x6a0 net/socket.c:2223
   __do_sys_setsockopt net/socket.c:2238 [inline]
   __se_sys_setsockopt net/socket.c:2235 [inline]
   __x64_sys_setsockopt+0xba/0x150 net/socket.c:2235
   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
   entry_SYSCALL_64_after_hwframe+0x44/0xae
  RIP: 0033:0x7f8902c8eb39

Fix it by adding rcu_read_lock and take a ref on the real_dev.
Since dev_hold() and dev_put() can take NULL these days, we can
skip checking if real_dev exist.

[1] https://lore.kernel.org/netdev/27565.1642742439@famine/

Reported-by: syzbot+92beb3d46aab498710fa@syzkaller.appspotmail.com
Fixes: aa6034678e87 ("bonding: use rcu_dereference_rtnl when get bonding active slave")
Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20220519020148.1058344-1-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 38e152548126..b5c5196e03ee 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5591,16 +5591,23 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
 	const struct ethtool_ops *ops;
 	struct net_device *real_dev;
 	struct phy_device *phydev;
+	int ret = 0;
 
+	rcu_read_lock();
 	real_dev = bond_option_active_slave_get_rcu(bond);
+	dev_hold(real_dev);
+	rcu_read_unlock();
+
 	if (real_dev) {
 		ops = real_dev->ethtool_ops;
 		phydev = real_dev->phydev;
 
 		if (phy_has_tsinfo(phydev)) {
-			return phy_ts_info(phydev, info);
+			ret = phy_ts_info(phydev, info);
+			goto out;
 		} else if (ops->get_ts_info) {
-			return ops->get_ts_info(real_dev, info);
+			ret = ops->get_ts_info(real_dev, info);
+			goto out;
 		}
 	}
 
@@ -5608,7 +5615,9 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
 				SOF_TIMESTAMPING_SOFTWARE;
 	info->phc_index = -1;
 
-	return 0;
+out:
+	dev_put(real_dev);
+	return ret;
 }
 
 static const struct ethtool_ops bond_ethtool_ops = {
-- 
2.35.1



