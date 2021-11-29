Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC0B2461E89
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379171AbhK2ShF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:37:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40020 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379092AbhK2SfD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:35:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7B80B815DE;
        Mon, 29 Nov 2021 18:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06940C53FAD;
        Mon, 29 Nov 2021 18:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210703;
        bh=LhxCC2VimnaX4k8GNqn7aRCVMSs2Bpg7mwUGHJ7D0Cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lySMWOIJRWdwEvaRDShIODz+JBsv8zp0lLHm+SdKLkZhoMtZgpotsrUySuiayI1iS
         hXTu7Jvcpj93z2uVdGFyk4+iFQqKo9TzeYG/igMlUTj5rZFNwdnNFX3lRHUP0SrUey
         jD2rU3jLAtUAD5omnomRd8WsPR3uh2D/nmkqNHQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/121] net/smc: Fix NULL pointer dereferencing in smc_vlan_by_tcpsk()
Date:   Mon, 29 Nov 2021 19:18:38 +0100
Message-Id: <20211129181714.594804476@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>

[ Upstream commit 587acad41f1bc48e16f42bb2aca63bf323380be8 ]

Coverity reports a possible NULL dereferencing problem:

in smc_vlan_by_tcpsk():
6. returned_null: netdev_lower_get_next returns NULL (checked 29 out of 30 times).
7. var_assigned: Assigning: ndev = NULL return value from netdev_lower_get_next.
1623                ndev = (struct net_device *)netdev_lower_get_next(ndev, &lower);
CID 1468509 (#1 of 1): Dereference null return value (NULL_RETURNS)
8. dereference: Dereferencing a pointer that might be NULL ndev when calling is_vlan_dev.
1624                if (is_vlan_dev(ndev)) {

Remove the manual implementation and use netdev_walk_all_lower_dev() to
iterate over the lower devices. While on it remove an obsolete function
parameter comment.

Fixes: cb9d43f67754 ("net/smc: determine vlan_id of stacked net_device")
Suggested-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_core.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 109d790eaebe2..cd625b672429f 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1209,14 +1209,26 @@ static void smc_link_down_work(struct work_struct *work)
 	mutex_unlock(&lgr->llc_conf_mutex);
 }
 
-/* Determine vlan of internal TCP socket.
- * @vlan_id: address to store the determined vlan id into
- */
+static int smc_vlan_by_tcpsk_walk(struct net_device *lower_dev,
+				  struct netdev_nested_priv *priv)
+{
+	unsigned short *vlan_id = (unsigned short *)priv->data;
+
+	if (is_vlan_dev(lower_dev)) {
+		*vlan_id = vlan_dev_vlan_id(lower_dev);
+		return 1;
+	}
+
+	return 0;
+}
+
+/* Determine vlan of internal TCP socket. */
 int smc_vlan_by_tcpsk(struct socket *clcsock, struct smc_init_info *ini)
 {
 	struct dst_entry *dst = sk_dst_get(clcsock->sk);
+	struct netdev_nested_priv priv;
 	struct net_device *ndev;
-	int i, nest_lvl, rc = 0;
+	int rc = 0;
 
 	ini->vlan_id = 0;
 	if (!dst) {
@@ -1234,20 +1246,9 @@ int smc_vlan_by_tcpsk(struct socket *clcsock, struct smc_init_info *ini)
 		goto out_rel;
 	}
 
+	priv.data = (void *)&ini->vlan_id;
 	rtnl_lock();
-	nest_lvl = ndev->lower_level;
-	for (i = 0; i < nest_lvl; i++) {
-		struct list_head *lower = &ndev->adj_list.lower;
-
-		if (list_empty(lower))
-			break;
-		lower = lower->next;
-		ndev = (struct net_device *)netdev_lower_get_next(ndev, &lower);
-		if (is_vlan_dev(ndev)) {
-			ini->vlan_id = vlan_dev_vlan_id(ndev);
-			break;
-		}
-	}
+	netdev_walk_all_lower_dev(ndev, smc_vlan_by_tcpsk_walk, &priv);
 	rtnl_unlock();
 
 out_rel:
-- 
2.33.0



