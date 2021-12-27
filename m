Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC9C47FE53
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237385AbhL0P2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:28:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33448 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237409AbhL0P2A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:28:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24EA9B810C6;
        Mon, 27 Dec 2021 15:27:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2E8C36AEA;
        Mon, 27 Dec 2021 15:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640618878;
        bh=8UMRyUA6ttWAqpCUWPPK75Wdkxi/bJHKjseXvGNSKH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PtQ5/OzIC7cnz0CQ4r60umTeF2LjZVVivEq2JWjhHWZZcW4uzDKHvI4xlBn+XTWmH
         bbNtH0dR3MiI6ZHvXofscgNomfDAGfFFzew5boJtX8rM/yvQAxv1UdJ/fYujRPaKN2
         gyilINYNniIx/sn8B7e5ixao1HxJhv4ybcPh1z6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 06/17] bonding: fix ad_actor_system option setting to default
Date:   Mon, 27 Dec 2021 16:27:01 +0100
Message-Id: <20211227151316.166037116@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151315.962187770@linuxfoundation.org>
References: <20211227151315.962187770@linuxfoundation.org>
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
index 334b49ef02d13..5a6e70483cedf 100644
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
index 1022e80aaf974..1d95a83d2baeb 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -1407,7 +1407,7 @@ static int bond_option_ad_actor_system_set(struct bonding *bond,
 		mac = (u8 *)&newval->value;
 	}
 
-	if (!is_valid_ether_addr(mac))
+	if (is_multicast_ether_addr(mac))
 		goto err;
 
 	netdev_info(bond->dev, "Setting ad_actor_system to %pM\n", mac);
-- 
2.34.1



