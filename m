Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A137922F130
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731920AbgG0OaE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:30:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:51570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731931AbgG0OWf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:22:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E3F22075A;
        Mon, 27 Jul 2020 14:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859755;
        bh=XxeXK1ZqMAk6niV3nqN1IkP63mf7KUrh+w6xEhY77Ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G3b1xWsLoZ1yTG3lvet8pZnWhFBsT3MAa32skPviJLaHOyoLX6ArdUXCUsLor27iC
         pt0HQNLGW+HQhAIFG8iOqn84LhVZggxIvTMNOxrS7mYJ+88SZIMd+kEH48m8cdJQ+B
         jVI2j8VcwdCIISIgDPjKv7vnbdCGES/Den06PgQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Beniamino Galvani <bgalvani@redhat.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+bbc3a11c4da63c1b74d6@syzkaller.appspotmail.com
Subject: [PATCH 5.7 093/179] bonding: check return value of register_netdevice() in bond_newlink()
Date:   Mon, 27 Jul 2020 16:04:28 +0200
Message-Id: <20200727134937.197793793@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit c75d1d5248c0c97996051809ad0e9f154ba5d76e ]

Very similar to commit 544f287b8495
("bonding: check error value of register_netdevice() immediately"),
we should immediately check the return value of register_netdevice()
before doing anything else.

Fixes: 005db31d5f5f ("bonding: set carrier off for devices created through netlink")
Reported-and-tested-by: syzbot+bbc3a11c4da63c1b74d6@syzkaller.appspotmail.com
Cc: Beniamino Galvani <bgalvani@redhat.com>
Cc: Taehee Yoo <ap420073@gmail.com>
Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_netlink.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
index b43b51646b11a..f0f9138e967f3 100644
--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -456,11 +456,10 @@ static int bond_newlink(struct net *src_net, struct net_device *bond_dev,
 		return err;
 
 	err = register_netdevice(bond_dev);
-
-	netif_carrier_off(bond_dev);
 	if (!err) {
 		struct bonding *bond = netdev_priv(bond_dev);
 
+		netif_carrier_off(bond_dev);
 		bond_work_init_all(bond);
 	}
 
-- 
2.25.1



