Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEE8561DAC
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236138AbiF3ODC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236502AbiF3OCd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:02:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AE368A00;
        Thu, 30 Jun 2022 06:52:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 645F7B82AF5;
        Thu, 30 Jun 2022 13:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40EAC3411E;
        Thu, 30 Jun 2022 13:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597169;
        bh=oyPtyRGppegOs2HUPer1Je0Qz2tbUeLP7TpNwUb2JSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fPK4kYYBsn5stPQ1Cpx8jNVPWpFj/hiFQBjuAnfJhp3R7dTrsKfz4TELJN1hdZrle
         v2YH6Rebz/Q4htsY79yBNABy5B1RO6RIQW56KPUq4SeVyreMJz4tnpd+o8oPnOAY5V
         2iLxLJSUUNf8uTA8jmepfMfWTk5OAMtyIhYFsRhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Toppins <jtoppins@redhat.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 12/49] bonding: ARP monitor spams NETDEV_NOTIFY_PEERS notifiers
Date:   Thu, 30 Jun 2022 15:46:25 +0200
Message-Id: <20220630133234.264577719@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133233.910803744@linuxfoundation.org>
References: <20220630133233.910803744@linuxfoundation.org>
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
index 2d70cdd26f89..cab5c1cc9fe9 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3069,9 +3069,11 @@ static void bond_activebackup_arp_mon(struct bonding *bond)
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



