Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFFC2657D59
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233968AbiL1Pmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:42:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233978AbiL1PmO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:42:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6F7164BD
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:42:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 636986155C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:42:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B5BC433D2;
        Wed, 28 Dec 2022 15:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242132;
        bh=ynljBhnagH1I3/GRymd1aeUWiZjRaX18DM7bNApUU0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=asQjAeYWwgwT5AHU7WDsW7EWcmta15c+/5s4gSZuwRZQkKHKoBEE3E4+R0XRQ2PL2
         WdEYkFHu3RMJYRTENG5oEQpN0WUw+d204UyP6bX5z2W3wpxOmKljFB3H02LVahUyL/
         nFlad9DE465sHG4fhorD84nZMcUVFcBltWtjvKk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jonathan Toppins <jtoppins@redhat.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0371/1073] bonding: fix link recovery in mode 2 when updelay is nonzero
Date:   Wed, 28 Dec 2022 15:32:39 +0100
Message-Id: <20221228144338.080585875@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Toppins <jtoppins@redhat.com>

[ Upstream commit f8a65ab2f3ff7410921ebbf0dc55453102c33c56 ]

Before this change when a bond in mode 2 lost link, all of its slaves
lost link, the bonding device would never recover even after the
expiration of updelay. This change removes the updelay when the bond
currently has no usable links. Conforming to bonding.txt section 13.1
paragraph 4.

Fixes: 41f891004063 ("bonding: ignore updelay param when there is no active slave")
Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index c2939621b683..2ad17c840a2a 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2536,7 +2536,16 @@ static int bond_miimon_inspect(struct bonding *bond)
 	struct slave *slave;
 	bool ignore_updelay;
 
-	ignore_updelay = !rcu_dereference(bond->curr_active_slave);
+	if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP) {
+		ignore_updelay = !rcu_dereference(bond->curr_active_slave);
+	} else {
+		struct bond_up_slave *usable_slaves;
+
+		usable_slaves = rcu_dereference(bond->usable_slaves);
+
+		if (usable_slaves && usable_slaves->count == 0)
+			ignore_updelay = true;
+	}
 
 	bond_for_each_slave_rcu(bond, slave, iter) {
 		bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
-- 
2.35.1



