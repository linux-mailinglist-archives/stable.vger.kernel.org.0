Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F81E2ABB36
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387607AbgKINZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:25:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:44610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733130AbgKINRZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:17:25 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 329B920731;
        Mon,  9 Nov 2020 13:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927844;
        bh=nTpSDGHgiO6MUNCQKieOmkxc0K5FswgNWb/AlOTnKM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wUUwtdX/otS7ZqVos0L8fazDPOB1SzDlf4R0xjVq/vJVrS1SAtR8f2/FrkY9N9Lum
         nYHVACFlc8QqGlvyN9s46pwx8d5/+G10ljm2POMkG3MviIhBb3CmdB3jv8Mtby6Emx
         PwAuP06FK9oOfoGEbXacycnYloyTd40kj0cKQPaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+9a8f8bfcc56e8578016c@syzkaller.appspotmail.com,
        Eelco Chaudron <echaudro@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 041/133] net: openvswitch: silence suspicious RCU usage warning
Date:   Mon,  9 Nov 2020 13:55:03 +0100
Message-Id: <20201109125032.686759783@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eelco Chaudron <echaudro@redhat.com>

[ Upstream commit fea07a487c6dd422dc8837237c9d2bc7c33119af ]

Silence suspicious RCU usage warning in ovs_flow_tbl_masks_cache_resize()
by replacing rcu_dereference() with rcu_dereference_ovsl().

In addition, when creating a new datapath, make sure it's configured under
the ovs_lock.

Fixes: 9bf24f594c6a ("net: openvswitch: make masks cache size configurable")
Reported-by: syzbot+9a8f8bfcc56e8578016c@syzkaller.appspotmail.com
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
Link: https://lore.kernel.org/r/160439190002.56943.1418882726496275961.stgit@ebuild
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/datapath.c   |   14 +++++++-------
 net/openvswitch/flow_table.c |    2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1699,13 +1699,13 @@ static int ovs_dp_cmd_new(struct sk_buff
 	parms.port_no = OVSP_LOCAL;
 	parms.upcall_portids = a[OVS_DP_ATTR_UPCALL_PID];
 
-	err = ovs_dp_change(dp, a);
-	if (err)
-		goto err_destroy_meters;
-
 	/* So far only local changes have been made, now need the lock. */
 	ovs_lock();
 
+	err = ovs_dp_change(dp, a);
+	if (err)
+		goto err_unlock_and_destroy_meters;
+
 	vport = new_vport(&parms);
 	if (IS_ERR(vport)) {
 		err = PTR_ERR(vport);
@@ -1721,8 +1721,7 @@ static int ovs_dp_cmd_new(struct sk_buff
 				ovs_dp_reset_user_features(skb, info);
 		}
 
-		ovs_unlock();
-		goto err_destroy_meters;
+		goto err_unlock_and_destroy_meters;
 	}
 
 	err = ovs_dp_cmd_fill_info(dp, reply, info->snd_portid,
@@ -1737,7 +1736,8 @@ static int ovs_dp_cmd_new(struct sk_buff
 	ovs_notify(&dp_datapath_genl_family, reply, info);
 	return 0;
 
-err_destroy_meters:
+err_unlock_and_destroy_meters:
+	ovs_unlock();
 	ovs_meters_exit(dp);
 err_destroy_ports:
 	kfree(dp->ports);
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -387,7 +387,7 @@ static struct mask_cache *tbl_mask_cache
 }
 int ovs_flow_tbl_masks_cache_resize(struct flow_table *table, u32 size)
 {
-	struct mask_cache *mc = rcu_dereference(table->mask_cache);
+	struct mask_cache *mc = rcu_dereference_ovsl(table->mask_cache);
 	struct mask_cache *new;
 
 	if (size == mc->cache_size)


