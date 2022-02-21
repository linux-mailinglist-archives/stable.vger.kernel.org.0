Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C26AC4BE161
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347847AbiBUJOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:14:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349600AbiBUJMh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:12:37 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024D6240B1;
        Mon, 21 Feb 2022 01:05:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 72FE3CE0E93;
        Mon, 21 Feb 2022 09:05:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5637CC340E9;
        Mon, 21 Feb 2022 09:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434334;
        bh=jv+AVOl/lBgMwyLrAswELFvOAFp14rzSsl/8i6LyfMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QvIv2tAmGEPkzy82gmIKnKsYONwzLGPyOHJ13zdZw7jGPPznKdZF2YVxH2Y8IPCHd
         4OXehJzqKzZuJ63SLmWFC63IeNr00ZHXx5JOiHNBP/dTBpk867X/dnTrxQTJnnRhYA
         VpQox7mo9SkSUcs5thzCMaVFN6i8vGvm/vOG8E3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 061/121] bonding: force carrier update when releasing slave
Date:   Mon, 21 Feb 2022 09:49:13 +0100
Message-Id: <20220221084923.279700717@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
References: <20220221084921.147454846@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Zhang Changzhong <zhangchangzhong@huawei.com>

commit a6ab75cec1e461f8a35559054c146c21428430b8 upstream.

In __bond_release_one(), bond_set_carrier() is only called when bond
device has no slave. Therefore, if we remove the up slave from a master
with two slaves and keep the down slave, the master will remain up.

Fix this by moving bond_set_carrier() out of if (!bond_has_slaves(bond))
statement.

Reproducer:
$ insmod bonding.ko mode=0 miimon=100 max_bonds=2
$ ifconfig bond0 up
$ ifenslave bond0 eth0 eth1
$ ifconfig eth0 down
$ ifenslave -d bond0 eth1
$ cat /proc/net/bonding/bond0

Fixes: ff59c4563a8d ("[PATCH] bonding: support carrier state for master")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Link: https://lore.kernel.org/r/1645021088-38370-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2272,10 +2272,9 @@ static int __bond_release_one(struct net
 		bond_select_active_slave(bond);
 	}
 
-	if (!bond_has_slaves(bond)) {
-		bond_set_carrier(bond);
+	bond_set_carrier(bond);
+	if (!bond_has_slaves(bond))
 		eth_hw_addr_random(bond_dev);
-	}
 
 	unblock_netpoll_tx();
 	synchronize_rcu();


