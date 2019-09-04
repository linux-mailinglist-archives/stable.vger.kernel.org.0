Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5601CA8E06
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732715AbfIDRzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:55:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:60784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732749AbfIDRzi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:55:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 068B82339D;
        Wed,  4 Sep 2019 17:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619737;
        bh=JdSjEyUhh5TbeyQIPddKuF11nDjV/fdzbvCoRy3LNR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X52XV70I36HvaUQ/hZlkvlWhsKrcIDMhyTGLHkiPR3SqvDiQ2RHnjqG6bb6xLFu/U
         OkQSweF40LtbCkYRMbWdONXCGLwL1Qbz1Wvz0jC4jviF+GK1ZedKYNL0Uncl6n6Qp0
         UAYK+Zl5q536pdr6LeH86xgONyc3p4AKnsfGGfZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 04/77] bonding: Force slave speed check after link state recovery for 802.3ad
Date:   Wed,  4 Sep 2019 19:52:51 +0200
Message-Id: <20190904175303.815046169@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
References: <20190904175303.317468926@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 12185dfe44360f814ac4ead9d22ad2af7511b2e9 ]

The following scenario was encountered during testing of logical
partition mobility on pseries partitions with bonded ibmvnic
adapters in LACP mode.

1. Driver receives a signal that the device has been
   swapped, and it needs to reset to initialize the new
   device.

2. Driver reports loss of carrier and begins initialization.

3. Bonding driver receives NETDEV_CHANGE notifier and checks
   the slave's current speed and duplex settings. Because these
   are unknown at the time, the bond sets its link state to
   BOND_LINK_FAIL and handles the speed update, clearing
   AD_PORT_LACP_ENABLE.

4. Driver finishes recovery and reports that the carrier is on.

5. Bond receives a new notification and checks the speed again.
   The speeds are valid but miimon has not altered the link
   state yet.  AD_PORT_LACP_ENABLE remains off.

Because the slave's link state is still BOND_LINK_FAIL,
no further port checks are made when it recovers. Though
the slave devices are operational and have valid speed
and duplex settings, the bond will not send LACPDU's. The
simplest fix I can see is to force another speed check
in bond_miimon_commit. This way the bond will update
AD_PORT_LACP_ENABLE if needed when transitioning from
BOND_LINK_FAIL to BOND_LINK_UP.

CC: Jarod Wilson <jarod@redhat.com>
CC: Jay Vosburgh <j.vosburgh@gmail.com>
CC: Veaceslav Falico <vfalico@gmail.com>
CC: Andy Gospodarek <andy@greyhouse.net>
Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 168f2331194ff..fd6aff9f0052e 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2081,6 +2081,15 @@ static void bond_miimon_commit(struct bonding *bond)
 	bond_for_each_slave(bond, slave, iter) {
 		switch (slave->new_link) {
 		case BOND_LINK_NOCHANGE:
+			/* For 802.3ad mode, check current slave speed and
+			 * duplex again in case its port was disabled after
+			 * invalid speed/duplex reporting but recovered before
+			 * link monitoring could make a decision on the actual
+			 * link status
+			 */
+			if (BOND_MODE(bond) == BOND_MODE_8023AD &&
+			    slave->link == BOND_LINK_UP)
+				bond_3ad_adapter_speed_duplex_changed(slave);
 			continue;
 
 		case BOND_LINK_UP:
-- 
2.20.1



