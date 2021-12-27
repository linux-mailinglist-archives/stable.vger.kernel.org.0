Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0C248002F
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238964AbhL0Pnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:43:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43110 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238963AbhL0Plg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:41:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06D7EB810A2;
        Mon, 27 Dec 2021 15:41:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486E9C36AE7;
        Mon, 27 Dec 2021 15:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619693;
        bh=wqeH4Tr9e1RNstwYRTFc9BIhN6LpjuF7MvKZz4LDkLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nhJEcpaP8Qpk8Zo1YXTcV3aaYYko+6M2uxwLRruHc8T4KxbajrSYIcAKa+ybZeyh1
         g//6V6QR4MJOWrU86DD6FlgLgHOHCmhnB92jGfONfNcWKxdrZI9UGVSSWP86iWVNHW
         +QO1oCXYvJw1SsYYQPo6rReOCF0N+UT5dl4NvIbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/128] bonding: fix ad_actor_system option setting to default
Date:   Mon, 27 Dec 2021 16:30:11 +0100
Message-Id: <20211227151332.738141698@linuxfoundation.org>
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
 Documentation/networking/bonding.rst | 11 ++++++-----
 drivers/net/bonding/bond_options.c   |  2 +-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
index 31cfd7d674a6c..c0a789b008063 100644
--- a/Documentation/networking/bonding.rst
+++ b/Documentation/networking/bonding.rst
@@ -196,11 +196,12 @@ ad_actor_sys_prio
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
index a8fde3bc458f6..b93337b5a7211 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -1526,7 +1526,7 @@ static int bond_option_ad_actor_system_set(struct bonding *bond,
 		mac = (u8 *)&newval->value;
 	}
 
-	if (!is_valid_ether_addr(mac))
+	if (is_multicast_ether_addr(mac))
 		goto err;
 
 	netdev_dbg(bond->dev, "Setting ad_actor_system to %pM\n", mac);
-- 
2.34.1



