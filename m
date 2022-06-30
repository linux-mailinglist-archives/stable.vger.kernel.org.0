Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4362C561BF8
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 15:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235517AbiF3NvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235635AbiF3Nub (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:50:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371023C710;
        Thu, 30 Jun 2022 06:49:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EB9BB82AEF;
        Thu, 30 Jun 2022 13:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BB4C36AE2;
        Thu, 30 Jun 2022 13:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656596936;
        bh=ObkPRihGr6GwGF8PylNRB0yuQn5FlDhxalTsxytZMbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pbrTFAvMX8Z9R4gOw32nYWeKx0BjUhbRmORge76/6bMYBRIBTrRgmy7J/ypPN+kGi
         CbrGYvvYJU8SQIamHxuL7OyjZq75o+XJSGSgisLvtu5W5dZrMzDeuwflErF1EAw+fz
         TuW0RcEysuOtp1DCd6c7eWjeJfrCsD12CwQuhzXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Toppins <jtoppins@redhat.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 07/29] bonding: ARP monitor spams NETDEV_NOTIFY_PEERS notifiers
Date:   Thu, 30 Jun 2022 15:46:07 +0200
Message-Id: <20220630133231.419368643@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133231.200642128@linuxfoundation.org>
References: <20220630133231.200642128@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jay Vosburgh <jay.vosburgh@canonical.com>

[ Upstream commit 7a9214f3d88cfdb099f3896e102a306b316d8707 ]

The bonding ARP monitor fails to decrement send_peer_notif, the
number of peer notifications (gratuitous ARP or ND) to be sent. This
results in a continuous series of notifications.

Correct this by decrementing the counter for each notification.

Reported-by: Jonathan Toppins <jtoppins@redhat.com>
Signed-off-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Fixes: b0929915e035 ("bonding: Fix RTNL: assertion failed at net/core/rtnetlink.c for ab arp monitor")
Link: https://lore.kernel.org/netdev/b2fd4147-8f50-bebd-963a-1a3e8d1d9715@redhat.com/
Tested-by: Jonathan Toppins <jtoppins@redhat.com>
Reviewed-by: Jonathan Toppins <jtoppins@redhat.com>
Link: https://lore.kernel.org/r/9400.1655407960@famine
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 0d9226bdf661..33843b89ab04 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3014,9 +3014,11 @@ static void bond_activebackup_arp_mon(struct work_struct *work)
 		if (!rtnl_trylock())
 			return;
 
-		if (should_notify_peers)
+		if (should_notify_peers) {
+			bond->send_peer_notif--;
 			call_netdevice_notifiers(NETDEV_NOTIFY_PEERS,
 						 bond->dev);
+		}
 		if (should_notify_rtnl) {
 			bond_slave_state_notify(bond);
 			bond_slave_link_notify(bond);
-- 
2.35.1



