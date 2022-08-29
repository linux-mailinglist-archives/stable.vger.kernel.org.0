Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECAF05A49C4
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbiH2L37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232512AbiH2L3L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:29:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F8378BEA;
        Mon, 29 Aug 2022 04:17:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6AA7611EC;
        Mon, 29 Aug 2022 11:09:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8617C433C1;
        Mon, 29 Aug 2022 11:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771353;
        bh=GJ8Q2ujZ/fb5V4i0pn6mI3oB5p53qRjHiTACpQSU2p4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EJZ5eUeicej3Wgj9esJsVmOc/K+RvvTLlPy3PT6i6algA+HvmYF8bmfybf31QFUat
         2yFj0o0/7C78qaB3HP8l83tx1YZi/2gIpYm5EcFEbrH9cCleXEg7F6uBB4G+JDIIyo
         PxWUlSw4eyADz+OpTFVCKzpc1jJyVSSKsOvwyj8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Toppins <jtoppins@redhat.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 28/86] bonding: 802.3ad: fix no transmission of LACPDUs
Date:   Mon, 29 Aug 2022 12:58:54 +0200
Message-Id: <20220829105757.689974700@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Toppins <jtoppins@redhat.com>

[ Upstream commit d745b5062ad2b5da90a5e728d7ca884fc07315fd ]

This is caused by the global variable ad_ticks_per_sec being zero as
demonstrated by the reproducer script discussed below. This causes
all timer values in __ad_timer_to_ticks to be zero, resulting
in the periodic timer to never fire.

To reproduce:
Run the script in
`tools/testing/selftests/drivers/net/bonding/bond-break-lacpdu-tx.sh` which
puts bonding into a state where it never transmits LACPDUs.

line 44: ip link add fbond type bond mode 4 miimon 200 \
            xmit_hash_policy 1 ad_actor_sys_prio 65535 lacp_rate fast
setting bond param: ad_actor_sys_prio
given:
    params.ad_actor_system = 0
call stack:
    bond_option_ad_actor_sys_prio()
    -> bond_3ad_update_ad_actor_settings()
       -> set ad.system.sys_priority = bond->params.ad_actor_sys_prio
       -> ad.system.sys_mac_addr = bond->dev->dev_addr; because
            params.ad_actor_system == 0
results:
     ad.system.sys_mac_addr = bond->dev->dev_addr

line 48: ip link set fbond address 52:54:00:3B:7C:A6
setting bond MAC addr
call stack:
    bond->dev->dev_addr = new_mac

line 52: ip link set fbond type bond ad_actor_sys_prio 65535
setting bond param: ad_actor_sys_prio
given:
    params.ad_actor_system = 0
call stack:
    bond_option_ad_actor_sys_prio()
    -> bond_3ad_update_ad_actor_settings()
       -> set ad.system.sys_priority = bond->params.ad_actor_sys_prio
       -> ad.system.sys_mac_addr = bond->dev->dev_addr; because
            params.ad_actor_system == 0
results:
     ad.system.sys_mac_addr = bond->dev->dev_addr

line 60: ip link set veth1-bond down master fbond
given:
    params.ad_actor_system = 0
    params.mode = BOND_MODE_8023AD
    ad.system.sys_mac_addr == bond->dev->dev_addr
call stack:
    bond_enslave
    -> bond_3ad_initialize(); because first slave
       -> if ad.system.sys_mac_addr != bond->dev->dev_addr
          return
results:
     Nothing is run in bond_3ad_initialize() because dev_addr equals
     sys_mac_addr leaving the global ad_ticks_per_sec zero as it is
     never initialized anywhere else.

The if check around the contents of bond_3ad_initialize() is no longer
needed due to commit 5ee14e6d336f ("bonding: 3ad: apply ad_actor settings
changes immediately") which sets ad.system.sys_mac_addr if any one of
the bonding parameters whos set function calls
bond_3ad_update_ad_actor_settings(). This is because if
ad.system.sys_mac_addr is zero it will be set to the current bond mac
address, this causes the if check to never be true.

Fixes: 5ee14e6d336f ("bonding: 3ad: apply ad_actor settings changes immediately")
Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_3ad.c | 38 ++++++++++++++--------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 325b20729d8ba..b0f8d551b61db 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -1988,30 +1988,24 @@ void bond_3ad_initiate_agg_selection(struct bonding *bond, int timeout)
  */
 void bond_3ad_initialize(struct bonding *bond, u16 tick_resolution)
 {
-	/* check that the bond is not initialized yet */
-	if (!MAC_ADDRESS_EQUAL(&(BOND_AD_INFO(bond).system.sys_mac_addr),
-				bond->dev->dev_addr)) {
-
-		BOND_AD_INFO(bond).aggregator_identifier = 0;
-
-		BOND_AD_INFO(bond).system.sys_priority =
-			bond->params.ad_actor_sys_prio;
-		if (is_zero_ether_addr(bond->params.ad_actor_system))
-			BOND_AD_INFO(bond).system.sys_mac_addr =
-			    *((struct mac_addr *)bond->dev->dev_addr);
-		else
-			BOND_AD_INFO(bond).system.sys_mac_addr =
-			    *((struct mac_addr *)bond->params.ad_actor_system);
+	BOND_AD_INFO(bond).aggregator_identifier = 0;
+	BOND_AD_INFO(bond).system.sys_priority =
+		bond->params.ad_actor_sys_prio;
+	if (is_zero_ether_addr(bond->params.ad_actor_system))
+		BOND_AD_INFO(bond).system.sys_mac_addr =
+		    *((struct mac_addr *)bond->dev->dev_addr);
+	else
+		BOND_AD_INFO(bond).system.sys_mac_addr =
+		    *((struct mac_addr *)bond->params.ad_actor_system);
 
-		/* initialize how many times this module is called in one
-		 * second (should be about every 100ms)
-		 */
-		ad_ticks_per_sec = tick_resolution;
+	/* initialize how many times this module is called in one
+	 * second (should be about every 100ms)
+	 */
+	ad_ticks_per_sec = tick_resolution;
 
-		bond_3ad_initiate_agg_selection(bond,
-						AD_AGGREGATOR_SELECTION_TIMER *
-						ad_ticks_per_sec);
-	}
+	bond_3ad_initiate_agg_selection(bond,
+					AD_AGGREGATOR_SELECTION_TIMER *
+					ad_ticks_per_sec);
 }
 
 /**
-- 
2.35.1



