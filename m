Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 259CC24F469
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbgHXIgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:36:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728191AbgHXIf5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:35:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D805204FD;
        Mon, 24 Aug 2020 08:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258156;
        bh=EOrNn+I9LL2TuN8tdupUg4Zfr9vHbqKssGESOa5M87o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IPb2SdZf9h191B9Yc94sYrwl4fPHRKezi5A0InKaz/3Nzyb5H+VtdMHxHm0/JnGhx
         pwJ1KBKCFq7k8dbO9xznkoQ0IlwqolyrVPVwx9m7gt2JYxeS1AXKtAIzsrB5Ak5hz+
         8bTZgW2xSfc6bSjcyoM37CaOuyy7iNCblaSaki/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+af23e7f3e0a7e10c8b67@syzkaller.appspotmail.com,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 096/148] bonding: fix a potential double-unregister
Date:   Mon, 24 Aug 2020 10:29:54 +0200
Message-Id: <20200824082418.635907967@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 832707021666411d04795c564a4adea5d6b94f17 ]

When we tear down a network namespace, we unregister all
the netdevices within it. So we may queue a slave device
and a bonding device together in the same unregister queue.

If the only slave device is non-ethernet, it would
automatically unregister the bonding device as well. Thus,
we may end up unregistering the bonding device twice.

Workaround this special case by checking reg_state.

Fixes: 9b5e383c11b0 ("net: Introduce unregister_netdevice_many()")
Reported-by: syzbot+af23e7f3e0a7e10c8b67@syzkaller.appspotmail.com
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index a35a05610a5e3..f438e20fcda1f 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2084,7 +2084,8 @@ static int bond_release_and_destroy(struct net_device *bond_dev,
 	int ret;
 
 	ret = __bond_release_one(bond_dev, slave_dev, false, true);
-	if (ret == 0 && !bond_has_slaves(bond)) {
+	if (ret == 0 && !bond_has_slaves(bond) &&
+	    bond_dev->reg_state != NETREG_UNREGISTERING) {
 		bond_dev->priv_flags |= IFF_DISABLE_NETPOLL;
 		netdev_info(bond_dev, "Destroying bond\n");
 		bond_remove_proc_entry(bond);
-- 
2.25.1



