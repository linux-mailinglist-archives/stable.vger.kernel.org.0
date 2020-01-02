Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D45412F055
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbgABWwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:52:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:43682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728655AbgABWWo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:22:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4EB32253D;
        Thu,  2 Jan 2020 22:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003764;
        bh=Al7bzgi2unxPyfP1PZlhJR/3qZPvUNIjLvPGQBoa3nU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Jj5Q4gvVOnRSTlgfYTnUBI9zak0fFca2gg1o/ZwQflAaHENE0ywhK3ptpPghe1Xb
         Z5UmTv6znIEvC8YiSsoivWzV7TwPdhF7rce5i+695QHjnHYqwQvDReVA+QuCRBksLW
         2RI5skx4DudpTtHjVMcfeRBsyBogdp/qWoID1Pcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jay Vosburgh <jay.vosburgh@canonical.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 078/114] bonding: fix active-backup transition after link failure
Date:   Thu,  2 Jan 2020 23:07:30 +0100
Message-Id: <20200102220036.958334339@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220029.183913184@linuxfoundation.org>
References: <20200102220029.183913184@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mahesh Bandewar <maheshb@google.com>

[ Upstream commit 5d485ed88d48f8101a2067348e267c0aaf4ed486 ]

After the recent fix in commit 1899bb325149 ("bonding: fix state
transition issue in link monitoring"), the active-backup mode with
miimon initially come-up fine but after a link-failure, both members
transition into backup state.

Following steps to reproduce the scenario (eth1 and eth2 are the
slaves of the bond):

    ip link set eth1 up
    ip link set eth2 down
    sleep 1
    ip link set eth2 up
    ip link set eth1 down
    cat /sys/class/net/eth1/bonding_slave/state
    cat /sys/class/net/eth2/bonding_slave/state

Fixes: 1899bb325149 ("bonding: fix state transition issue in link monitoring")
CC: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: Mahesh Bandewar <maheshb@google.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 9b8143dca512..f57b86f1373d 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2223,9 +2223,6 @@ static void bond_miimon_commit(struct bonding *bond)
 			} else if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP) {
 				/* make it immediately active */
 				bond_set_active_slave(slave);
-			} else if (slave != primary) {
-				/* prevent it from being the active one */
-				bond_set_backup_slave(slave);
 			}
 
 			netdev_info(bond->dev, "link status definitely up for interface %s, %u Mbps %s duplex\n",
-- 
2.20.1



