Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C36768625
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 11:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbfGOJTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 05:19:24 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38707 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729451AbfGOJTY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jul 2019 05:19:24 -0400
Received: by mail-pl1-f194.google.com with SMTP id az7so7982878plb.5
        for <stable@vger.kernel.org>; Mon, 15 Jul 2019 02:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=TrEXUU61RpZVZkUvqS8Bi7os+pnmnhbBq4bW/URe3Ik=;
        b=H9tsSOoV0IJ3B7/3mbdWkPosrSIEJljA0s+qIGlLKjZLaV++WBygrmEbGPD+GBUVbM
         JxmCUcitjuWJJPZPHYxHvJt3Qhdz1sFPVRAV3ZMeejQYBRD+i8eoY5ryDS2tlkpPAeOq
         rRxa0t0S3K8qI88CZiH/ytC9NQnPRitDR5CFs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TrEXUU61RpZVZkUvqS8Bi7os+pnmnhbBq4bW/URe3Ik=;
        b=jvsE3wBWo1Jk8Ax1/PDfoBhs5sZNDFjM1Mkd+ungL2ne0mFuKAu+ifFPydwf35X/fR
         b2zssLHy7Jz3S2YPYv6uFj9VhDPtf0aNGEFE1Qa0voqi13qepvaxIF9RnZL1JMkuPuIA
         Vb7v2/9TkQUQYD/4Z1NFROcu0yeD+Ypa5FdgFKwUDIkliNhAoALcV5e01L9492UrZf00
         R5uzSKki360VXNKaml2TIIzHnk2BQmgnEmkhnsCIr5+BqM2omz2eBlEcXSbEGVarwfFM
         We3qt27WkaUVi0BhXqGBkFmBwMIsDUKVmgVar2VVCk3duJkRYtyF8GBFWSu0KA6npvUQ
         xRgA==
X-Gm-Message-State: APjAAAX5qqKnAYUG95iJCY8hJ3WBJ2lpH/gJkEfGBpMSGT0Z0+59Sbeu
        SWkpU55o12vMKUxsI8OjX1pmsg==
X-Google-Smtp-Source: APXvYqzKiEWAmmw3qEMdru564l6cHmeKw4UryFWk9aENVnA3eCGAP0ieE4vCFSlDERSw5J+vi+gjdA==
X-Received: by 2002:a17:902:2be8:: with SMTP id l95mr24519765plb.231.1563182363163;
        Mon, 15 Jul 2019 02:19:23 -0700 (PDT)
Received: from dhcp-10-123-153-34.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 185sm16026344pga.68.2019.07.15.02.19.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 02:19:22 -0700 (PDT)
From:   Selvin Xavier <selvin.xavier@broadcom.com>
To:     linux-rdma@vger.kernel.org, dledford@redhat.com, jgg@ziepe.ca
Cc:     linux-nvme@lists.infradead.org,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        stable@vger.kernel.org, Parav Pandit <parav@mellanox.com>
Subject: [PATCH for-rc] RDMA/bnxt_re: Honor vlan_id in GID entry comparison
Date:   Mon, 15 Jul 2019 05:19:13 -0400
Message-Id: <20190715091913.15726-1-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.18.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

GID entry consist of GID, vlan, netdev and smac.
Extend GID duplicate check companions to consider vlan_id as well
to support IPv6 VLAN based link local addresses. Introduce
a new structure (bnxt_qplib_gid_info) to hold gid and vlan_id information.

The issue is discussed in the following thread
https://www.spinics.net/lists/linux-rdma/msg81594.html

Fixes: 823b23da7113 ("IB/core: Allow vlan link local address based RoCE GIDs")
Cc: <stable@vger.kernel.org> # v5.2+
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Co-developed-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c  |  7 +++++--
 drivers/infiniband/hw/bnxt_re/qplib_res.c | 13 +++++++++----
 drivers/infiniband/hw/bnxt_re/qplib_res.h |  2 +-
 drivers/infiniband/hw/bnxt_re/qplib_sp.c  | 14 +++++++++-----
 drivers/infiniband/hw/bnxt_re/qplib_sp.h  |  7 ++++++-
 5 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 2c3685faa57a..a4a9f90f2482 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -308,6 +308,7 @@ int bnxt_re_del_gid(const struct ib_gid_attr *attr, void **context)
 	struct bnxt_re_dev *rdev = to_bnxt_re_dev(attr->device, ibdev);
 	struct bnxt_qplib_sgid_tbl *sgid_tbl = &rdev->qplib_res.sgid_tbl;
 	struct bnxt_qplib_gid *gid_to_del;
+	u16 vlan_id = 0xFFFF;
 
 	/* Delete the entry from the hardware */
 	ctx = *context;
@@ -317,7 +318,8 @@ int bnxt_re_del_gid(const struct ib_gid_attr *attr, void **context)
 	if (sgid_tbl && sgid_tbl->active) {
 		if (ctx->idx >= sgid_tbl->max)
 			return -EINVAL;
-		gid_to_del = &sgid_tbl->tbl[ctx->idx];
+		gid_to_del = &sgid_tbl->tbl[ctx->idx].gid;
+		vlan_id = sgid_tbl->tbl[ctx->idx].vlan_id;
 		/* DEL_GID is called in WQ context(netdevice_event_work_handler)
 		 * or via the ib_unregister_device path. In the former case QP1
 		 * may not be destroyed yet, in which case just return as FW
@@ -335,7 +337,8 @@ int bnxt_re_del_gid(const struct ib_gid_attr *attr, void **context)
 		}
 		ctx->refcnt--;
 		if (!ctx->refcnt) {
-			rc = bnxt_qplib_del_sgid(sgid_tbl, gid_to_del, true);
+			rc = bnxt_qplib_del_sgid(sgid_tbl, gid_to_del,
+						 vlan_id,  true);
 			if (rc) {
 				dev_err(rdev_to_dev(rdev),
 					"Failed to remove GID: %#x", rc);
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.c b/drivers/infiniband/hw/bnxt_re/qplib_res.c
index 37928b1111df..bdbde8e22420 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -488,7 +488,7 @@ static int bnxt_qplib_alloc_sgid_tbl(struct bnxt_qplib_res *res,
 				     struct bnxt_qplib_sgid_tbl *sgid_tbl,
 				     u16 max)
 {
-	sgid_tbl->tbl = kcalloc(max, sizeof(struct bnxt_qplib_gid), GFP_KERNEL);
+	sgid_tbl->tbl = kcalloc(max, sizeof(*sgid_tbl->tbl), GFP_KERNEL);
 	if (!sgid_tbl->tbl)
 		return -ENOMEM;
 
@@ -526,9 +526,10 @@ static void bnxt_qplib_cleanup_sgid_tbl(struct bnxt_qplib_res *res,
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
@@ -537,7 +538,11 @@ static void bnxt_qplib_cleanup_sgid_tbl(struct bnxt_qplib_res *res,
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
 
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.h b/drivers/infiniband/hw/bnxt_re/qplib_res.h
index 30c42c92fac7..fbda11a7ab1a 100644
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
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index 48793d3512ac..40296b97d21e 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -213,12 +213,12 @@ int bnxt_qplib_get_sgid(struct bnxt_qplib_res *res,
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
@@ -236,7 +236,8 @@ int bnxt_qplib_del_sgid(struct bnxt_qplib_sgid_tbl *sgid_tbl,
 		return -ENOMEM;
 	}
 	for (index = 0; index < sgid_tbl->max; index++) {
-		if (!memcmp(&sgid_tbl->tbl[index], gid, sizeof(*gid)))
+		if (!memcmp(&sgid_tbl->tbl[index].gid, gid, sizeof(*gid)) &&
+		    vlan_id == sgid_tbl->tbl[index].vlan_id)
 			break;
 	}
 	if (index == sgid_tbl->max) {
@@ -262,8 +263,9 @@ int bnxt_qplib_del_sgid(struct bnxt_qplib_sgid_tbl *sgid_tbl,
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
@@ -296,7 +298,8 @@ int bnxt_qplib_add_sgid(struct bnxt_qplib_sgid_tbl *sgid_tbl,
 	}
 	free_idx = sgid_tbl->max;
 	for (i = 0; i < sgid_tbl->max; i++) {
-		if (!memcmp(&sgid_tbl->tbl[i], gid, sizeof(*gid))) {
+		if (!memcmp(&sgid_tbl->tbl[i], gid, sizeof(*gid)) &&
+		    sgid_tbl->tbl[i].vlan_id == vlan_id) {
 			dev_dbg(&res->pdev->dev,
 				"SGID entry already exist in entry %d!\n", i);
 			*index = i;
@@ -351,6 +354,7 @@ int bnxt_qplib_add_sgid(struct bnxt_qplib_sgid_tbl *sgid_tbl,
 	}
 	/* Add GID to the sgid_tbl */
 	memcpy(&sgid_tbl->tbl[free_idx], gid, sizeof(*gid));
+	sgid_tbl->tbl[free_idx].vlan_id = vlan_id;
 	sgid_tbl->active++;
 	if (vlan_id != 0xFFFF)
 		sgid_tbl->vlan[free_idx] = 1;
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.h b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
index 0ec3b12b0bcd..13d9432d5ce2 100644
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
@@ -221,7 +226,7 @@ int bnxt_qplib_get_sgid(struct bnxt_qplib_res *res,
 			struct bnxt_qplib_sgid_tbl *sgid_tbl, int index,
 			struct bnxt_qplib_gid *gid);
 int bnxt_qplib_del_sgid(struct bnxt_qplib_sgid_tbl *sgid_tbl,
-			struct bnxt_qplib_gid *gid, bool update);
+			struct bnxt_qplib_gid *gid, u16 vlan_id, bool update);
 int bnxt_qplib_add_sgid(struct bnxt_qplib_sgid_tbl *sgid_tbl,
 			struct bnxt_qplib_gid *gid, u8 *mac, u16 vlan_id,
 			bool update, u32 *index);
-- 
2.18.1

