Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9B21131F6
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729381AbfLDSEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:04:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:49276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730154AbfLDSEO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:04:14 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A7AF20675;
        Wed,  4 Dec 2019 18:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482653;
        bh=kqpzJnTxRpyBYOpXv54CkIzJJid5vTn2KtSckSJ5ySM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FupoDx1cisAZbV9EoC2phTzbcgYX21xO/PGr+8z51Gvmr0+CwsoK/3veyc0iQIlbc
         HWWOdfPuJNUqoFogMYM7gTgal3ZgNGxgcqKCQydNez5mP2qjb4zuMRz8BmdqUAr3f7
         4/XcDbHpN+fk8aN/OlFjyORbexRYL9JN5oUQ4MbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <petrm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 081/209] vxlan: Fix error path in __vxlan_dev_create()
Date:   Wed,  4 Dec 2019 18:54:53 +0100
Message-Id: <20191204175327.105634330@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

[ Upstream commit 6db9246871394b3a136cd52001a0763676563840 ]

When a failure occurs in rtnl_configure_link(), the current code
calls unregister_netdevice() to roll back the earlier call to
register_netdevice(), and jumps to errout, which calls
vxlan_fdb_destroy().

However unregister_netdevice() calls transitively ndo_uninit, which is
vxlan_uninit(), and that already takes care of deleting the default FDB
entry by calling vxlan_fdb_delete_default(). Since the entry added
earlier in __vxlan_dev_create() is exactly the default entry, the
cleanup code in the errout block always leads to double free and thus a
panic.

Besides, since vxlan_fdb_delete_default() always destroys the FDB entry
with notification enabled, the deletion of the default entry is notified
even before the addition was notified.

Instead, move the unregister_netdevice() call after the manual destroy,
which solves both problems.

Fixes: 0241b836732f ("vxlan: fix default fdb entry netlink notify ordering during netdev create")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 6d26bbd190dd6..153a81ece9fe4 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3217,6 +3217,7 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
 	struct vxlan_net *vn = net_generic(net, vxlan_net_id);
 	struct vxlan_dev *vxlan = netdev_priv(dev);
 	struct vxlan_fdb *f = NULL;
+	bool unregister = false;
 	int err;
 
 	err = vxlan_dev_configure(net, dev, conf, false, extack);
@@ -3242,12 +3243,11 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
 	err = register_netdevice(dev);
 	if (err)
 		goto errout;
+	unregister = true;
 
 	err = rtnl_configure_link(dev, NULL);
-	if (err) {
-		unregister_netdevice(dev);
+	if (err)
 		goto errout;
-	}
 
 	/* notify default fdb entry */
 	if (f)
@@ -3255,9 +3255,16 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
 
 	list_add(&vxlan->next, &vn->vxlan_list);
 	return 0;
+
 errout:
+	/* unregister_netdevice() destroys the default FDB entry with deletion
+	 * notification. But the addition notification was not sent yet, so
+	 * destroy the entry by hand here.
+	 */
 	if (f)
 		vxlan_fdb_destroy(vxlan, f, false);
+	if (unregister)
+		unregister_netdevice(dev);
 	return err;
 }
 
-- 
2.20.1



