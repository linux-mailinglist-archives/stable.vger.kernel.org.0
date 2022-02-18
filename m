Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF434BBAD2
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 15:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233801AbiBROmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 09:42:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232953AbiBROmS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 09:42:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F8B36334
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 06:42:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 649BCB82653
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 14:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965DCC340E9;
        Fri, 18 Feb 2022 14:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645195319;
        bh=M7sApx+hRT8vaNBL53i0nivUkekUPorsjxkKdM3j7HU=;
        h=Subject:To:Cc:From:Date:From;
        b=DKwYPrRMLY9oTKP00EpC76LyrEd0UKp9llpSZwyQMkLcoxjrEuU0BrDlRAVjADdt1
         mZ+Fs3iyyKLlncY+D3pQJjCbNpiHd/JuAUIp7Kaf5BeQadxAXkG7JMQ1m4wd1TvdoM
         Pxca+u9XwvnPp482/+wMKVkG3oZsI/pJmriLMyd0=
Subject: FAILED: patch "[PATCH] bonding: force carrier update when releasing slave" failed to apply to 4.9-stable tree
To:     zhangchangzhong@huawei.com, jay.vosburgh@canonical.com,
        kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Feb 2022 15:41:56 +0100
Message-ID: <164519531613158@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a6ab75cec1e461f8a35559054c146c21428430b8 Mon Sep 17 00:00:00 2001
From: Zhang Changzhong <zhangchangzhong@huawei.com>
Date: Wed, 16 Feb 2022 22:18:08 +0800
Subject: [PATCH] bonding: force carrier update when releasing slave

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

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 238b56d77c36..aebeb46e6fa6 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2379,10 +2379,9 @@ static int __bond_release_one(struct net_device *bond_dev,
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

