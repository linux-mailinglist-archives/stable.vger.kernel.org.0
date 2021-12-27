Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0C3E47FE66
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237531AbhL0P2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237570AbhL0P2b (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:28:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794B2C06175F;
        Mon, 27 Dec 2021 07:28:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AA76B810AA;
        Mon, 27 Dec 2021 15:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B16C36AE7;
        Mon, 27 Dec 2021 15:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640618909;
        bh=zBVinueb1qPcRhVa/U2awGqXWZcw1+LUqIXqzfJPmko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XwjQ5amzWYKmlf4/LPmy5X1yHDDaB+DUaS1thp3c/G/h2GQvMrwV0UbIVoXHV7B9o
         NP3t9ilcjSMs/3b1rIeXpTkZAwG+YoqY7nHOfjhNSm4SOqUVBEV8LDjZEanjvLS87o
         C4PS0Uru3Mm6HfyjrMIcED0ZX+RbWrBx08UW2/jA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 06/19] bonding: fix ad_actor_system option setting to default
Date:   Mon, 27 Dec 2021 16:27:08 +0100
Message-Id: <20211227151316.760655286@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151316.558965545@linuxfoundation.org>
References: <20211227151316.558965545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

[ Upstream commit 1c15b05baea71a5ff98235783e3e4ad227760876 ]

When 802.3ad bond mode is configured the ad_actor_system option is set to
"00:00:00:00:00:00". But when trying to set the all-zeroes MAC as actors'
system address it was failing with EINVAL.

An all-zeroes ethernet address is valid, only multicast addresses are not
valid values.

Fixes: 171a42c38c6e ("bonding: add netlink support for sys prio, actor sys mac, and port key")
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Link: https://lore.kernel.org/r/20211221111345.2462-1-ffmancera@riseup.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/bonding.txt | 11 ++++++-----
 drivers/net/bonding/bond_options.c   |  2 +-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/bonding.txt b/Documentation/networking/bonding.txt
index 57f52cdce32e4..07b53b2b13df8 100644
--- a/Documentation/networking/bonding.txt
+++ b/Documentation/networking/bonding.txt
@@ -191,11 +191,12 @@ ad_actor_sys_prio
 ad_actor_system
 
 	In an AD system, this specifies the mac-address for the actor in
-	protocol packet exchanges (LACPDUs). The value cannot be NULL or
-	multicast. It is preferred to have the local-admin bit set for this
-	mac but driver does not enforce it. If the value is not given then
-	system defaults to using the masters' mac address as actors' system
-	address.
+	protocol packet exchanges (LACPDUs). The value cannot be a multicast
+	address. If the all-zeroes MAC is specified, bonding will internally
+	use the MAC of the bond itself. It is preferred to have the
+	local-admin bit set for this mac but driver does not enforce it. If
+	the value is not given then system defaults to using the masters'
+	mac address as actors' system address.
 
 	This parameter has effect only in 802.3ad mode and is available through
 	SysFs interface.
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 258cb3999b0e3..5c6a962363096 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -1408,7 +1408,7 @@ static int bond_option_ad_actor_system_set(struct bonding *bond,
 		mac = (u8 *)&newval->value;
 	}
 
-	if (!is_valid_ether_addr(mac))
+	if (is_multicast_ether_addr(mac))
 		goto err;
 
 	netdev_info(bond->dev, "Setting ad_actor_system to %pM\n", mac);
-- 
2.34.1



