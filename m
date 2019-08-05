Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB7A81C94
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730741AbfHENZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:25:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729303AbfHENZW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:25:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0CA62067D;
        Mon,  5 Aug 2019 13:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011520;
        bh=9dDrCWgZrg4/MuNSUfC6kDqwGiZ/UAEPGVrGs3N+2EI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=peB5Jue1maxl4qZHwAtkWBz7IKhjEfSqKUJsf9qnf+Yag4s+fkLYi0A++yBla8jKM
         MBVvJYRYX4zFXc4eK6Lj9b8+xfrMmcpz4a7Zi8fIvkf9vKEy8c6JrDK7T4gQf8Bvrd
         a4BV4vAth/5Mr3pq5wF756DM7MnZ2Py9JgnaHJx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Zhang <yi.zhang@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.2 120/131] RDMA/bnxt_re: Honor vlan_id in GID entry comparison
Date:   Mon,  5 Aug 2019 15:03:27 +0200
Message-Id: <20190805124959.995091220@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Selvin Xavier <selvin.xavier@broadcom.com>

commit c56b593d2af4cbd189c6af5fd6790728fade80cc upstream.

A GID entry consists of GID, vlan, netdev and smac.  Extend GID duplicate
check comparisons to consider vlan_id as well to support IPv6 VLAN based
link local addresses. Introduce a new structure (bnxt_qplib_gid_info) to
hold gid and vlan_id information.

The issue is discussed in the following thread
https://lore.kernel.org/r/AM0PR05MB4866CFEDCDF3CDA1D7D18AA5D1F20@AM0PR05MB4866.eurprd05.prod.outlook.com

Fixes: 823b23da7113 ("IB/core: Allow vlan link local address based RoCE GIDs")
Cc: <stable@vger.kernel.org> # v5.2+
Link: https://lore.kernel.org/r/20190715091913.15726-1-selvin.xavier@broadcom.com
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Co-developed-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Tested-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c  |    7 +++++--
 drivers/infiniband/hw/bnxt_re/qplib_res.c |   13 +++++++++----
 drivers/infiniband/hw/bnxt_re/qplib_res.h |    2 +-
 drivers/infiniband/hw/bnxt_re/qplib_sp.c  |   14 +++++++++-----
 drivers/infiniband/hw/bnxt_re/qplib_sp.h  |    7 ++++++-
 5 files changed, 30 insertions(+), 13 deletions(-)

--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -308,6 +308,7 @@ int bnxt_re_del_gid(const struct ib_gid_
 	struct bnxt_re_dev *rdev = to_bnxt_re_dev(attr->device, ibdev);
 	struct bnxt_qplib_sgid_tbl *sgid_tbl = &rdev->qplib_res.sgid_tbl;
 	struct bnxt_qplib_gid *gid_to_del;
+	u16 vlan_id = 0xFFFF;
 
 	/* Delete the entry from the hardware */
 	ctx = *context;
@@ -317,7 +318,8 @@ int bnxt_re_del_gid(const struct ib_gid_
 	if (sgid_tbl && sgid_tbl->active) {
 		if (ctx->idx >= sgid_tbl->max)
 			return -EINVAL;
-		gid_to_del = &sgid_tbl->tbl[ctx->idx];
+		gid_to_del = &sgid_tbl->tbl[ctx->idx].gid;
+		vlan_id = sgid_tbl->tbl[ctx->idx].vlan_id;
 		/* DEL_GID is called in WQ context(netdevice_event_work_handler)
 		 * or via the ib_unregister_device path. In the former case QP1
 		 * may not be destroyed yet, in which case just return as FW
@@ -335,7 +337,8 @@ int bnxt_re_del_gid(const struct ib_gid_
 		}
 		ctx->refcnt--;
 		if (!ctx->refcnt) {
-			rc = bnxt_qplib_del_sgid(sgid_tbl, gid_to_del, true);
+			rc = bnxt_qplib_del_sgid(sgid_tbl, gid_to_del,
+						 vlan_id,  true);
 			if (rc) {
 				dev_err(rdev_to_dev(rdev),
 					"Failed to remove GID: %#x", rc);
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -488,7 +488,7 @@ static int bnxt_qplib_alloc_sgid_tbl(str
 				     struct bnxt_qplib_sgid_tbl *sgid_tbl,
 				     u16 max)
 {
-	sgid_tbl->tbl = kcalloc(max, sizeof(struct bnxt_qplib_gid), GFP_KERNEL);
+	sgid_tbl->tbl = kcalloc(max, sizeof(*sgid_tbl->tbl), GFP_KERNEL);
 	if (!sgid_tbl->tbl)
 		return -ENOMEM;
 
@@ -526,9 +526,10 @@ static void bnxt_qplib_cleanup_sgid_tbl(
 	for (i = 0; i < sgid_tbl->max; i++) {
 		if (memcmp(&sgid_tbl->tbl[i], &bnxt_qplib_gid_zero,
 			   sizeof(bnxt_qplib_gid_zero)))
-			bnxt_qplib_del_sgid(sgid_tbl, &sgid_tbl->tbl[i], true);
+			bnxt_qplib_del_sgid(sgid_tbl, &sgid_tbl->tbl[i].gid,
+					    sgid_tbl->tbl[i].vlan_id, true);
 	}
-	memset(sgid_tbl->tbl, 0, sizeof(struct bnxt_qplib_gid) * sgid_tbl->max);
+	memset(sgid_tbl->tbl, 0, sizeof(*sgid_tbl->tbl) * sgid_tbl->max);
 	memset(sgid_tbl->hw_id, -1, sizeof(u16) * sgid_tbl->max);
 	memset(sgid_tbl->vlan, 0, sizeof(u8) * sgid_tbl->max);
 	sgid_tbl->active = 0;
@@ -537,7 +538,11 @@ static void bnxt_qplib_cleanup_sgid_tbl(
 static void bnxt_qplib_init_sgid_tbl(struct bnxt_qplib_sgid_tbl *sgid_tbl,
 				     struct net_device *netdev)
 {
-	memset(sgid_tbl->tbl, 0, sizeof(struct bnxt_qplib_gid) * sgid_tbl->max);
+	u32 i;
+
+	for (i = 0; i < sgid_tbl->max; i++)
+		sgid_tbl->tbl[i].vlan_id = 0xffff;
+
 	memset(sgid_tbl->hw_id, -1, sizeof(u16) * sgid_tbl->max);
 }
 
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.h
@@ -111,7 +111,7 @@ struct bnxt_qplib_pd_tbl {
 };
 
 struct bnxt_qplib_sgid_tbl {
-	struct bnxt_qplib_gid		*tbl;
+	struct bnxt_qplib_gid_info	*tbl;
 	u16				*hw_id;
 	u16				max;
 	u16				active;
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -213,12 +213,12 @@ int bnxt_qplib_get_sgid(struct bnxt_qpli
 			index, sgid_tbl->max);
 		return -EINVAL;
 	}
-	memcpy(gid, &sgid_tbl->tbl[index], sizeof(*gid));
+	memcpy(gid, &sgid_tbl->tbl[index].gid, sizeof(*gid));
 	return 0;
 }
 
 int bnxt_qplib_del_sgid(struct bnxt_qplib_sgid_tbl *sgid_tbl,
-			struct bnxt_qplib_gid *gid, bool update)
+			struct bnxt_qplib_gid *gid, u16 vlan_id, bool update)
 {
 	struct bnxt_qplib_res *res = to_bnxt_qplib(sgid_tbl,
 						   struct bnxt_qplib_res,
@@ -236,7 +236,8 @@ int bnxt_qplib_del_sgid(struct bnxt_qpli
 		return -ENOMEM;
 	}
 	for (index = 0; index < sgid_tbl->max; index++) {
-		if (!memcmp(&sgid_tbl->tbl[index], gid, sizeof(*gid)))
+		if (!memcmp(&sgid_tbl->tbl[index].gid, gid, sizeof(*gid)) &&
+		    vlan_id == sgid_tbl->tbl[index].vlan_id)
 			break;
 	}
 	if (index == sgid_tbl->max) {
@@ -262,8 +263,9 @@ int bnxt_qplib_del_sgid(struct bnxt_qpli
 		if (rc)
 			return rc;
 	}
-	memcpy(&sgid_tbl->tbl[index], &bnxt_qplib_gid_zero,
+	memcpy(&sgid_tbl->tbl[index].gid, &bnxt_qplib_gid_zero,
 	       sizeof(bnxt_qplib_gid_zero));
+	sgid_tbl->tbl[index].vlan_id = 0xFFFF;
 	sgid_tbl->vlan[index] = 0;
 	sgid_tbl->active--;
 	dev_dbg(&res->pdev->dev,
@@ -296,7 +298,8 @@ int bnxt_qplib_add_sgid(struct bnxt_qpli
 	}
 	free_idx = sgid_tbl->max;
 	for (i = 0; i < sgid_tbl->max; i++) {
-		if (!memcmp(&sgid_tbl->tbl[i], gid, sizeof(*gid))) {
+		if (!memcmp(&sgid_tbl->tbl[i], gid, sizeof(*gid)) &&
+		    sgid_tbl->tbl[i].vlan_id == vlan_id) {
 			dev_dbg(&res->pdev->dev,
 				"SGID entry already exist in entry %d!\n", i);
 			*index = i;
@@ -351,6 +354,7 @@ int bnxt_qplib_add_sgid(struct bnxt_qpli
 	}
 	/* Add GID to the sgid_tbl */
 	memcpy(&sgid_tbl->tbl[free_idx], gid, sizeof(*gid));
+	sgid_tbl->tbl[free_idx].vlan_id = vlan_id;
 	sgid_tbl->active++;
 	if (vlan_id != 0xFFFF)
 		sgid_tbl->vlan[free_idx] = 1;
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
@@ -84,6 +84,11 @@ struct bnxt_qplib_gid {
 	u8				data[16];
 };
 
+struct bnxt_qplib_gid_info {
+	struct bnxt_qplib_gid gid;
+	u16 vlan_id;
+};
+
 struct bnxt_qplib_ah {
 	struct bnxt_qplib_gid		dgid;
 	struct bnxt_qplib_pd		*pd;
@@ -221,7 +226,7 @@ int bnxt_qplib_get_sgid(struct bnxt_qpli
 			struct bnxt_qplib_sgid_tbl *sgid_tbl, int index,
 			struct bnxt_qplib_gid *gid);
 int bnxt_qplib_del_sgid(struct bnxt_qplib_sgid_tbl *sgid_tbl,
-			struct bnxt_qplib_gid *gid, bool update);
+			struct bnxt_qplib_gid *gid, u16 vlan_id, bool update);
 int bnxt_qplib_add_sgid(struct bnxt_qplib_sgid_tbl *sgid_tbl,
 			struct bnxt_qplib_gid *gid, u8 *mac, u16 vlan_id,
 			bool update, u32 *index);


