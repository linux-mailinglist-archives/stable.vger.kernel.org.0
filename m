Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECC015EB44
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403950AbgBNRTX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:19:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:36658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391619AbgBNQKw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:10:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21A9024695;
        Fri, 14 Feb 2020 16:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696645;
        bh=c5o19+rQFgJknbbwsH/t2vs9Qk0t3EGm16g5n7mQ11A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1HUL+vdA8o3F+CkvKvHwDp6H1JqH2wqF3bhIXhCInCdiz8LliludRQcXWUQxhHSco
         hxySvustunSZYl1VDRMJoZYILCTPRtqk9/0QVeILphPcZYUR1Wu7fpzIausc15obZ6
         0Auo6KhHQ4ghpYUE/rwf3JTldyFEPlvOzkbLUPNM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Manjunath Patil <manjunath.b.patil@oracle.com>,
        Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 421/459] IB/mlx4: Fix leak in id_map_find_del
Date:   Fri, 14 Feb 2020 11:01:11 -0500
Message-Id: <20200214160149.11681-421-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Håkon Bugge <haakon.bugge@oracle.com>

[ Upstream commit ea660ad7c1c476fd6e5e3b17780d47159db71dea ]

Using CX-3 virtual functions, either from a bare-metal machine or
pass-through from a VM, MAD packets are proxied through the PF driver.

Since the VF drivers have separate name spaces for MAD Transaction Ids
(TIDs), the PF driver has to re-map the TIDs and keep the book keeping in
a cache.

Following the RDMA Connection Manager (CM) protocol, it is clear when an
entry has to evicted from the cache. When a DREP is sent from
mlx4_ib_multiplex_cm_handler(), id_map_find_del() is called. Similar when
a REJ is received by the mlx4_ib_demux_cm_handler(), id_map_find_del() is
called.

This function wipes out the TID in use from the IDR or XArray and removes
the id_map_entry from the table.

In short, it does everything except the topping of the cake, which is to
remove the entry from the list and free it. In other words, for the REJ
case enumerated above, one id_map_entry will be leaked.

For the other case above, a DREQ has been received first. The reception of
the DREQ will trigger queuing of a delayed work to delete the
id_map_entry, for the case where the VM doesn't send back a DREP.

In the normal case, the VM _will_ send back a DREP, and id_map_find_del()
will be called.

But this scenario introduces a secondary leak. First, when the DREQ is
received, a delayed work is queued. The VM will then return a DREP, which
will call id_map_find_del(). As stated above, this will free the TID used
from the XArray or IDR. Now, there is window where that particular TID can
be re-allocated, lets say by an outgoing REQ. This TID will later be wiped
out by the delayed work, when the function id_map_ent_timeout() is
called. But the id_map_entry allocated by the outgoing REQ will not be
de-allocated, and we have a leak.

Both leaks are fixed by removing the id_map_find_del() function and only
using schedule_delayed(). Of course, a check in schedule_delayed() to see
if the work already has been queued, has been added.

Another benefit of always using the delayed version for deleting entries,
is that we do get a TimeWait effect; a TID no longer in use, will occupy
the XArray or IDR for CM_CLEANUP_CACHE_TIMEOUT time, without any ability
of being re-used for that time period.

Fixes: 3cf69cc8dbeb ("IB/mlx4: Add CM paravirtualization")
Link: https://lore.kernel.org/r/20200123155521.1212288-1-haakon.bugge@oracle.com
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Manjunath Patil <manjunath.b.patil@oracle.com>
Reviewed-by: Rama Nichanamatlu <rama.nichanamatlu@oracle.com>
Reviewed-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx4/cm.c | 29 +++--------------------------
 1 file changed, 3 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cm.c b/drivers/infiniband/hw/mlx4/cm.c
index ecd6cadd529a5..b591861934b3c 100644
--- a/drivers/infiniband/hw/mlx4/cm.c
+++ b/drivers/infiniband/hw/mlx4/cm.c
@@ -186,23 +186,6 @@ static void id_map_ent_timeout(struct work_struct *work)
 	kfree(ent);
 }
 
-static void id_map_find_del(struct ib_device *ibdev, int pv_cm_id)
-{
-	struct mlx4_ib_sriov *sriov = &to_mdev(ibdev)->sriov;
-	struct rb_root *sl_id_map = &sriov->sl_id_map;
-	struct id_map_entry *ent, *found_ent;
-
-	spin_lock(&sriov->id_map_lock);
-	ent = xa_erase(&sriov->pv_id_table, pv_cm_id);
-	if (!ent)
-		goto out;
-	found_ent = id_map_find_by_sl_id(ibdev, ent->slave_id, ent->sl_cm_id);
-	if (found_ent && found_ent == ent)
-		rb_erase(&found_ent->node, sl_id_map);
-out:
-	spin_unlock(&sriov->id_map_lock);
-}
-
 static void sl_id_map_add(struct ib_device *ibdev, struct id_map_entry *new)
 {
 	struct rb_root *sl_id_map = &to_mdev(ibdev)->sriov.sl_id_map;
@@ -294,7 +277,7 @@ static void schedule_delayed(struct ib_device *ibdev, struct id_map_entry *id)
 	spin_lock(&sriov->id_map_lock);
 	spin_lock_irqsave(&sriov->going_down_lock, flags);
 	/*make sure that there is no schedule inside the scheduled work.*/
-	if (!sriov->is_going_down) {
+	if (!sriov->is_going_down && !id->scheduled_delete) {
 		id->scheduled_delete = 1;
 		schedule_delayed_work(&id->timeout, CM_CLEANUP_CACHE_TIMEOUT);
 	}
@@ -341,9 +324,6 @@ int mlx4_ib_multiplex_cm_handler(struct ib_device *ibdev, int port, int slave_id
 
 	if (mad->mad_hdr.attr_id == CM_DREQ_ATTR_ID)
 		schedule_delayed(ibdev, id);
-	else if (mad->mad_hdr.attr_id == CM_DREP_ATTR_ID)
-		id_map_find_del(ibdev, pv_cm_id);
-
 	return 0;
 }
 
@@ -382,12 +362,9 @@ int mlx4_ib_demux_cm_handler(struct ib_device *ibdev, int port, int *slave,
 		*slave = id->slave_id;
 	set_remote_comm_id(mad, id->sl_cm_id);
 
-	if (mad->mad_hdr.attr_id == CM_DREQ_ATTR_ID)
+	if (mad->mad_hdr.attr_id == CM_DREQ_ATTR_ID ||
+	    mad->mad_hdr.attr_id == CM_REJ_ATTR_ID)
 		schedule_delayed(ibdev, id);
-	else if (mad->mad_hdr.attr_id == CM_REJ_ATTR_ID ||
-			mad->mad_hdr.attr_id == CM_DREP_ATTR_ID) {
-		id_map_find_del(ibdev, (int) pv_cm_id);
-	}
 
 	return 0;
 }
-- 
2.20.1

