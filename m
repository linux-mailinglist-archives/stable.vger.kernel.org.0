Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E57DA3D614D
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbhGZPad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:30:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237447AbhGZP3Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20D8060FF0;
        Mon, 26 Jul 2021 16:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315666;
        bh=10FAHzbUlb7VhMwF8Q9GjWIGQv1nDnLHDv+hy25MlYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c+eFBZTq+HrB0yeo8D417FsXWnUIE3l3B4KleqiYypKlU2rflIEsZQPRDNBbyR1z0
         SN+52t9Oqwctqv5Y0eSvLn4aR+yrGpbl+2VdU2iqDCBCdkwe9PfGVRhMXrcG0Ejotf
         TdMGBcwEW2GlD1oS7bx8ukjQw4p+KwUhE6KDySWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 019/223] bonding: disallow setting nested bonding + ipsec offload
Date:   Mon, 26 Jul 2021 17:36:51 +0200
Message-Id: <20210726153846.881443890@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit b121693381b112b78c076dea171ee113e237c0e4 ]

bonding interface can be nested and it supports ipsec offload.
So, it allows setting the nested bonding + ipsec scenario.
But code does not support this scenario.
So, it should be disallowed.

interface graph:
bond2
   |
bond1
   |
eth0

The nested bonding + ipsec offload may not a real usecase.
So, disallowing this scenario is fine.

Fixes: 18cb261afd7b ("bonding: support hardware encryption offload to slaves")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index a7b6550063b2..d85a19c06c69 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -419,8 +419,9 @@ static int bond_ipsec_add_sa(struct xfrm_state *xs)
 	xs->xso.real_dev = slave->dev;
 	bond->xs = xs;
 
-	if (!(slave->dev->xfrmdev_ops
-	      && slave->dev->xfrmdev_ops->xdo_dev_state_add)) {
+	if (!slave->dev->xfrmdev_ops ||
+	    !slave->dev->xfrmdev_ops->xdo_dev_state_add ||
+	    netif_is_bond_master(slave->dev)) {
 		slave_warn(bond_dev, slave->dev, "Slave does not support ipsec offload\n");
 		rcu_read_unlock();
 		return -EINVAL;
@@ -453,8 +454,9 @@ static void bond_ipsec_del_sa(struct xfrm_state *xs)
 
 	xs->xso.real_dev = slave->dev;
 
-	if (!(slave->dev->xfrmdev_ops
-	      && slave->dev->xfrmdev_ops->xdo_dev_state_delete)) {
+	if (!slave->dev->xfrmdev_ops ||
+	    !slave->dev->xfrmdev_ops->xdo_dev_state_delete ||
+	    netif_is_bond_master(slave->dev)) {
 		slave_warn(bond_dev, slave->dev, "%s: no slave xdo_dev_state_delete\n", __func__);
 		goto out;
 	}
@@ -479,8 +481,9 @@ static bool bond_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *xs)
 	if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP)
 		return true;
 
-	if (!(slave_dev->xfrmdev_ops
-	      && slave_dev->xfrmdev_ops->xdo_dev_offload_ok)) {
+	if (!slave_dev->xfrmdev_ops ||
+	    !slave_dev->xfrmdev_ops->xdo_dev_offload_ok ||
+	    netif_is_bond_master(slave_dev)) {
 		slave_warn(bond_dev, slave_dev, "%s: no slave xdo_dev_offload_ok\n", __func__);
 		return false;
 	}
-- 
2.30.2



