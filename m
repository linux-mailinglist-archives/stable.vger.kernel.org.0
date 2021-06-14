Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F233A6272
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234057AbhFNLAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:00:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234529AbhFNK56 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:57:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01F7A61622;
        Mon, 14 Jun 2021 10:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667299;
        bh=qSRmlgwWY0K2z6udKhRE0dNSDZmP8qs5pPPXI909R3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t1TfqbSnRfRa4Rn1MV813rGFgwsgTk0SfHNb1n2OQ/iUo8ZvwJSejdGx2WLyq8BL2
         3WHrih1rUDzDzEACyxYHYrJNYNc3y8G0MSJMgvQVc3FNgTdXV5OycCqHuRE/Lzh1cr
         7/JxB06aT+oFEC6yElkqXbgdU/gIpEEa+/7Y3XZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+bfda097c12a00c8cae67@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 018/131] bonding: init notify_work earlier to avoid uninitialized use
Date:   Mon, 14 Jun 2021 12:26:19 +0200
Message-Id: <20210614102653.613686097@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 35d96e631860226d5dc4de0fad0a415362ec2457 ]

If bond_kobj_init() or later kzalloc() in bond_alloc_slave() fail,
then we call kobject_put() on the slave->kobj. This in turn calls
the release function slave_kobj_release() which will always try to
cancel_delayed_work_sync(&slave->notify_work), which shouldn't be
done on an uninitialized work struct.

Always initialize the work struct earlier to avoid problems here.

Syzbot bisected this down to a completely pointless commit, some
fault injection may have been at work here that caused the alloc
failure in the first place, which may interact badly with bisect.

Reported-by: syzbot+bfda097c12a00c8cae67@syzkaller.appspotmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 47afc5938c26..345a3f61c723 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1502,6 +1502,7 @@ static struct slave *bond_alloc_slave(struct bonding *bond,
 
 	slave->bond = bond;
 	slave->dev = slave_dev;
+	INIT_DELAYED_WORK(&slave->notify_work, bond_netdev_notify_work);
 
 	if (bond_kobj_init(slave))
 		return NULL;
@@ -1514,7 +1515,6 @@ static struct slave *bond_alloc_slave(struct bonding *bond,
 			return NULL;
 		}
 	}
-	INIT_DELAYED_WORK(&slave->notify_work, bond_netdev_notify_work);
 
 	return slave;
 }
-- 
2.30.2



