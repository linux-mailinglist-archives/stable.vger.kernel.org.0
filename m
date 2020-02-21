Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C52D0167362
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732272AbgBUILq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:11:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:47316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732522AbgBUILo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:11:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD206206ED;
        Fri, 21 Feb 2020 08:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272703;
        bh=MKD/d1HpsdK+H30i3L+CguO/x1O7XcUgODhV2+4aquk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zra2cALqOaNL9RcojlXUZF5UpfcgEb1A4oEHRQOUQCl+aGw1+R6/unAMlHc+adzLc
         3mekKIWJGHlSkDuePRDjPd4zVWprYC9hfeglfyY8st18WUU2IpokrqLS5gnDFAmnsZ
         SZEjjXmibEcESbXPO4pt0BFm7g7afBmgAK6fhEpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 243/344] RDMA/mlx5: Dont fake udata for kernel path
Date:   Fri, 21 Feb 2020 08:40:42 +0100
Message-Id: <20200221072411.448691012@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

[ Upstream commit 4835709176e8ccf6561abc9f5c405293e008095f ]

Kernel paths must not set udata and provide NULL pointer,
instead of faking zeroed udata struct.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 34 +++++++++++++++----------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index e1cfbedefcbc9..9a918db9e8db4 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -829,6 +829,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 				struct ib_device_attr *props,
 				struct ib_udata *uhw)
 {
+	size_t uhw_outlen = (uhw) ? uhw->outlen : 0;
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 	struct mlx5_core_dev *mdev = dev->mdev;
 	int err = -ENOMEM;
@@ -842,12 +843,12 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	u64 max_tso;
 
 	resp_len = sizeof(resp.comp_mask) + sizeof(resp.response_length);
-	if (uhw->outlen && uhw->outlen < resp_len)
+	if (uhw_outlen && uhw_outlen < resp_len)
 		return -EINVAL;
 	else
 		resp.response_length = resp_len;
 
-	if (uhw->inlen && !ib_is_udata_cleared(uhw, 0, uhw->inlen))
+	if (uhw && uhw->inlen && !ib_is_udata_cleared(uhw, 0, uhw->inlen))
 		return -EINVAL;
 
 	memset(props, 0, sizeof(*props));
@@ -911,7 +912,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 			props->raw_packet_caps |=
 				IB_RAW_PACKET_CAP_CVLAN_STRIPPING;
 
-		if (field_avail(typeof(resp), tso_caps, uhw->outlen)) {
+		if (field_avail(typeof(resp), tso_caps, uhw_outlen)) {
 			max_tso = MLX5_CAP_ETH(mdev, max_lso_cap);
 			if (max_tso) {
 				resp.tso_caps.max_tso = 1 << max_tso;
@@ -921,7 +922,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 			}
 		}
 
-		if (field_avail(typeof(resp), rss_caps, uhw->outlen)) {
+		if (field_avail(typeof(resp), rss_caps, uhw_outlen)) {
 			resp.rss_caps.rx_hash_function =
 						MLX5_RX_HASH_FUNC_TOEPLITZ;
 			resp.rss_caps.rx_hash_fields_mask =
@@ -941,9 +942,9 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 			resp.response_length += sizeof(resp.rss_caps);
 		}
 	} else {
-		if (field_avail(typeof(resp), tso_caps, uhw->outlen))
+		if (field_avail(typeof(resp), tso_caps, uhw_outlen))
 			resp.response_length += sizeof(resp.tso_caps);
-		if (field_avail(typeof(resp), rss_caps, uhw->outlen))
+		if (field_avail(typeof(resp), rss_caps, uhw_outlen))
 			resp.response_length += sizeof(resp.rss_caps);
 	}
 
@@ -1066,7 +1067,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 						MLX5_MAX_CQ_PERIOD;
 	}
 
-	if (field_avail(typeof(resp), cqe_comp_caps, uhw->outlen)) {
+	if (field_avail(typeof(resp), cqe_comp_caps, uhw_outlen)) {
 		resp.response_length += sizeof(resp.cqe_comp_caps);
 
 		if (MLX5_CAP_GEN(dev->mdev, cqe_compression)) {
@@ -1084,7 +1085,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		}
 	}
 
-	if (field_avail(typeof(resp), packet_pacing_caps, uhw->outlen) &&
+	if (field_avail(typeof(resp), packet_pacing_caps, uhw_outlen) &&
 	    raw_support) {
 		if (MLX5_CAP_QOS(mdev, packet_pacing) &&
 		    MLX5_CAP_GEN(mdev, qos)) {
@@ -1103,7 +1104,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	}
 
 	if (field_avail(typeof(resp), mlx5_ib_support_multi_pkt_send_wqes,
-			uhw->outlen)) {
+			uhw_outlen)) {
 		if (MLX5_CAP_ETH(mdev, multi_pkt_send_wqe))
 			resp.mlx5_ib_support_multi_pkt_send_wqes =
 				MLX5_IB_ALLOW_MPW;
@@ -1116,7 +1117,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 			sizeof(resp.mlx5_ib_support_multi_pkt_send_wqes);
 	}
 
-	if (field_avail(typeof(resp), flags, uhw->outlen)) {
+	if (field_avail(typeof(resp), flags, uhw_outlen)) {
 		resp.response_length += sizeof(resp.flags);
 
 		if (MLX5_CAP_GEN(mdev, cqe_compression_128))
@@ -1132,8 +1133,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		resp.flags |= MLX5_IB_QUERY_DEV_RESP_FLAGS_SCAT2CQE_DCT;
 	}
 
-	if (field_avail(typeof(resp), sw_parsing_caps,
-			uhw->outlen)) {
+	if (field_avail(typeof(resp), sw_parsing_caps, uhw_outlen)) {
 		resp.response_length += sizeof(resp.sw_parsing_caps);
 		if (MLX5_CAP_ETH(mdev, swp)) {
 			resp.sw_parsing_caps.sw_parsing_offloads |=
@@ -1153,7 +1153,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		}
 	}
 
-	if (field_avail(typeof(resp), striding_rq_caps, uhw->outlen) &&
+	if (field_avail(typeof(resp), striding_rq_caps, uhw_outlen) &&
 	    raw_support) {
 		resp.response_length += sizeof(resp.striding_rq_caps);
 		if (MLX5_CAP_GEN(mdev, striding_rq)) {
@@ -1170,8 +1170,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		}
 	}
 
-	if (field_avail(typeof(resp), tunnel_offloads_caps,
-			uhw->outlen)) {
+	if (field_avail(typeof(resp), tunnel_offloads_caps, uhw_outlen)) {
 		resp.response_length += sizeof(resp.tunnel_offloads_caps);
 		if (MLX5_CAP_ETH(mdev, tunnel_stateless_vxlan))
 			resp.tunnel_offloads_caps |=
@@ -1192,7 +1191,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 				MLX5_IB_TUNNELED_OFFLOADS_MPLS_UDP;
 	}
 
-	if (uhw->outlen) {
+	if (uhw_outlen) {
 		err = ib_copy_to_udata(uhw, &resp, resp.response_length);
 
 		if (err)
@@ -4738,7 +4737,6 @@ static int __get_port_caps(struct mlx5_ib_dev *dev, u8 port)
 	struct ib_device_attr *dprops = NULL;
 	struct ib_port_attr *pprops = NULL;
 	int err = -ENOMEM;
-	struct ib_udata uhw = {.inlen = 0, .outlen = 0};
 
 	pprops = kzalloc(sizeof(*pprops), GFP_KERNEL);
 	if (!pprops)
@@ -4748,7 +4746,7 @@ static int __get_port_caps(struct mlx5_ib_dev *dev, u8 port)
 	if (!dprops)
 		goto out;
 
-	err = mlx5_ib_query_device(&dev->ib_dev, dprops, &uhw);
+	err = mlx5_ib_query_device(&dev->ib_dev, dprops, NULL);
 	if (err) {
 		mlx5_ib_warn(dev, "query_device failed %d\n", err);
 		goto out;
-- 
2.20.1



