Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 657CD3442BC
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhCVMoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:44:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232608AbhCVMmw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:42:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E4E4619A2;
        Mon, 22 Mar 2021 12:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416842;
        bh=0PSbATWdDDaov/Z5J/zXV8SD8WfhRP9ILRONZIESGu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rhmn5jrYcrLeLU41urT38CJiZEI5FhfdJAVkSKSKg/l2D5NF+EWNg0DGlDr4KazlB
         JvVwl6kdKeaa+zE/5d6boNIJwrr1kSe+W5tNMViGLKIfAX300OoRnL/tVeJDoRu9C/
         nWEafdc2WEH73ZMbX+wNgxhaDhjYgwyd8DEln10w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/157] net: bonding: fix error return code of bond_neigh_init()
Date:   Mon, 22 Mar 2021 13:27:45 +0100
Message-Id: <20210322121937.193932219@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 2055a99da8a253a357bdfd359b3338ef3375a26c ]

When slave is NULL or slave_ops->ndo_neigh_setup is NULL, no error
return code of bond_neigh_init() is assigned.
To fix this bug, ret is assigned with -EINVAL in these cases.

Fixes: 9e99bfefdbce ("bonding: fix bond_neigh_init()")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 47afc5938c26..6d5a39af1097 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3918,11 +3918,15 @@ static int bond_neigh_init(struct neighbour *n)
 
 	rcu_read_lock();
 	slave = bond_first_slave_rcu(bond);
-	if (!slave)
+	if (!slave) {
+		ret = -EINVAL;
 		goto out;
+	}
 	slave_ops = slave->dev->netdev_ops;
-	if (!slave_ops->ndo_neigh_setup)
+	if (!slave_ops->ndo_neigh_setup) {
+		ret = -EINVAL;
 		goto out;
+	}
 
 	/* TODO: find another way [1] to implement this.
 	 * Passing a zeroed structure is fragile,
-- 
2.30.1



