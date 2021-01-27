Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8348730525C
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 06:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbhA0FrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 00:47:03 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:12987 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234603AbhA0FXD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jan 2021 00:23:03 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6010f8850000>; Tue, 26 Jan 2021 21:22:13 -0800
Received: from sx1.lan (172.20.145.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 27 Jan 2021 05:22:10
 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>
CC:     Roi Dayan <roid@nvidia.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH -stable v5.{7,8,9}] net/mlx5: E-Switch, fix changing mode to switchdev
Date:   Tue, 26 Jan 2021 21:22:00 -0800
Message-ID: <20210127052200.219549-1-saeedm@nvidia.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611724933; bh=GuUG5wYl7d3IDK2Gp9QK7R1CQ+nteUbx3AqsflNp9YQ=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=HgHzQCcJpHpa+S3kfzThOSqY1itq1EEnaqdjn8kafcOe/Oz+QxV++tb1rWZkxJWrg
         rvrsYkYzDXEa/IlXbSAHigPnAadLWdTnjpqJLMY0dktk5SX0BMNKXvES8PBIOTUwpl
         +2MbBjnLfZTIxGVSHXj48Vyo6e5b+xFed7GFMKgMdnWPMv7qW5bWs/RPRO6F/W3YUn
         eifJv88E2B95B3xSgNbx1upqCv1i4br6PbEMEZXuISZHVR53jL3+8PV4laQfSAq09K
         oNIklUqM/v4AyuROzO+Dg/I7njTH7WkkGct4hOe2xSclsvo1h45A+xNfSlprnSa2FZ
         wFTggmC9HKnpg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Miss rule creation is always done with ignore flow level bit set.
Older firmwares do not support that. Check FW support before setting the
ignore flow level bit.

The issue doesn't exist upstream, it was already fixed by a refactoring
commit ae430332557a ("net/mlx5: Refactor multi chains and prios support")
which was merged on v5.10.

Fixes: 278d51f24330 ("net/mlx5: E-Switch, Increase number of chains and pri=
orities")
Reported-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/chains.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/chains.c b/drivers=
/net/ethernet/mellanox/mlx5/core/esw/chains.c
index 029001040737..b801825b3292 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/chains.c
@@ -419,7 +419,9 @@ mlx5_esw_chains_add_miss_rule(struct fdb_chain *fdb_cha=
in,
 	struct mlx5_flow_destination dest =3D {};
 	struct mlx5_flow_act act =3D {};
=20
-	act.flags  =3D FLOW_ACT_IGNORE_FLOW_LEVEL | FLOW_ACT_NO_APPEND;
+	act.flags  =3D FLOW_ACT_NO_APPEND;
+	if (fdb_ignore_flow_level_supported(esw))
+		act.flags |=3D FLOW_ACT_IGNORE_FLOW_LEVEL;
 	act.action =3D MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	dest.type  =3D MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest.ft =3D next_fdb;
--=20
2.29.2

