Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E15015C31A
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729543AbgBMP2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:28:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:53952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728122AbgBMP2B (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:28:01 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8DF324670;
        Thu, 13 Feb 2020 15:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607681;
        bh=Wsgst0ju19D/IyonbwPY+OOZ91mtaatbv2Vwm4gfyG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DFpAQHpCn18UOFM3icqobAhvdetNJtsWbWklo6Swjg4DsWm1RRk0zJkBlIzGszVXi
         1V2ENMfHuC6Hc7jcqA8r0uWJoRmuBhmbjO1xaAWXHirXMx5HLhSocLk28O/iadviVp
         +W26gAK9B1P0BmN8pbdVjQtzvm/ysxuv8U/Lbi3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Danit Goldberg <danitg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.5 003/120] IB/mlx5: Return the administrative GUID if exists
Date:   Thu, 13 Feb 2020 07:19:59 -0800
Message-Id: <20200213151902.446410775@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Danit Goldberg <danitg@mellanox.com>

commit 4bbd4923d1f5627b0c47a9d7dfb5cc91224cfe0c upstream.

A user can change the operational GUID (a.k.a affective GUID) through
link/infiniband. Therefore it is preferred to return the currently set
GUID if it exists instead of the operational.

This way the PF can query which VF GUID will be set in the next bind.  In
order to align with MAC address, zero is returned if administrative GUID
is not set.

For example, before setting administrative GUID:
 $ ip link show
 ib0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 4092 qdisc mq state UP mode DEFAULT group default qlen 256
 link/infiniband 00:00:00:08:fe:80:00:00:00:00:00:00:52:54:00:c0:fe:12:34:55 brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
 vf 0     link/infiniband 00:00:00:08:fe:80:00:00:00:00:00:00:52:54:00:c0:fe:12:34:55 brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff,
 spoof checking off, NODE_GUID 00:00:00:00:00:00:00:00, PORT_GUID 00:00:00:00:00:00:00:00, link-state auto, trust off, query_rss off

Then:

 $ ip link set ib0 vf 0 node_guid 11:00:af:21:cb:05:11:00
 $ ip link set ib0 vf 0 port_guid 22:11:af:21:cb:05:11:00

After setting administrative GUID:
 $ ip link show
 ib0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 4092 qdisc mq state UP mode DEFAULT group default qlen 256
 link/infiniband 00:00:00:08:fe:80:00:00:00:00:00:00:52:54:00:c0:fe:12:34:55 brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
 vf 0     link/infiniband 00:00:00:08:fe:80:00:00:00:00:00:00:52:54:00:c0:fe:12:34:55 brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff,
 spoof checking off, NODE_GUID 11:00:af:21:cb:05:11:00, PORT_GUID 22:11:af:21:cb:05:11:00, link-state auto, trust off, query_rss off

Fixes: 9c0015ef0928 ("IB/mlx5: Implement callbacks for getting VFs GUID attributes")
Link: https://lore.kernel.org/r/20200116120048.12744-1-leon@kernel.org
Signed-off-by: Danit Goldberg <danitg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx5/ib_virt.c |   28 ++++++++++++----------------
 include/linux/mlx5/driver.h          |    5 +++++
 2 files changed, 17 insertions(+), 16 deletions(-)

--- a/drivers/infiniband/hw/mlx5/ib_virt.c
+++ b/drivers/infiniband/hw/mlx5/ib_virt.c
@@ -164,8 +164,10 @@ static int set_vf_node_guid(struct ib_de
 	in->field_select = MLX5_HCA_VPORT_SEL_NODE_GUID;
 	in->node_guid = guid;
 	err = mlx5_core_modify_hca_vport_context(mdev, 1, 1, vf + 1, in);
-	if (!err)
+	if (!err) {
 		vfs_ctx[vf].node_guid = guid;
+		vfs_ctx[vf].node_guid_valid = 1;
+	}
 	kfree(in);
 	return err;
 }
@@ -185,8 +187,10 @@ static int set_vf_port_guid(struct ib_de
 	in->field_select = MLX5_HCA_VPORT_SEL_PORT_GUID;
 	in->port_guid = guid;
 	err = mlx5_core_modify_hca_vport_context(mdev, 1, 1, vf + 1, in);
-	if (!err)
+	if (!err) {
 		vfs_ctx[vf].port_guid = guid;
+		vfs_ctx[vf].port_guid_valid = 1;
+	}
 	kfree(in);
 	return err;
 }
@@ -208,20 +212,12 @@ int mlx5_ib_get_vf_guid(struct ib_device
 {
 	struct mlx5_ib_dev *dev = to_mdev(device);
 	struct mlx5_core_dev *mdev = dev->mdev;
-	struct mlx5_hca_vport_context *rep;
-	int err;
+	struct mlx5_vf_context *vfs_ctx = mdev->priv.sriov.vfs_ctx;
 
-	rep = kzalloc(sizeof(*rep), GFP_KERNEL);
-	if (!rep)
-		return -ENOMEM;
+	node_guid->guid =
+		vfs_ctx[vf].node_guid_valid ? vfs_ctx[vf].node_guid : 0;
+	port_guid->guid =
+		vfs_ctx[vf].port_guid_valid ? vfs_ctx[vf].port_guid : 0;
 
-	err = mlx5_query_hca_vport_context(mdev, 1, 1, vf+1, rep);
-	if (err)
-		goto ex;
-
-	port_guid->guid = rep->port_guid;
-	node_guid->guid = rep->node_guid;
-ex:
-	kfree(rep);
-	return err;
+	return 0;
 }
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -461,6 +461,11 @@ struct mlx5_vf_context {
 	int	enabled;
 	u64	port_guid;
 	u64	node_guid;
+	/* Valid bits are used to validate administrative guid only.
+	 * Enabled after ndo_set_vf_guid
+	 */
+	u8	port_guid_valid:1;
+	u8	node_guid_valid:1;
 	enum port_state_policy	policy;
 };
 


