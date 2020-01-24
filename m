Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1937C148091
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388377AbgAXLMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:12:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:48688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388374AbgAXLMX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:12:23 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9805A20663;
        Fri, 24 Jan 2020 11:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864343;
        bh=c6gzUqxlvOJ9c3CTRw7aCZ/FwMvPQlg8CdOj1USoyRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YqiCbFItUREyd9HAcEVHhn2R4hU8jih+Ukd5oYUjow4jvqAVAIk+AK06wiOBHHrnO
         SFIRlt2QbiN5HAm+ZhbRmfY9P+KubJxEkdDFTBM1OZ5RSuTLCJzYowOvYgSNt8xMsS
         Sd0aSNKPO4v1gR2NKKHBrOGtC/sV5H/zI9DQj80c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 217/639] net/mlx5: Delete unused FPGA QPN variable
Date:   Fri, 24 Jan 2020 10:26:27 +0100
Message-Id: <20200124093114.144719822@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

[ Upstream commit 566428375a53619196e31803130dd1a7010c4d7f ]

fpga_qpn was assigned but never used and compilation with W=1
produced the following warning:

drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c: In function _mlx5_fpga_event_:
drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c:320:6: warning:
variable _fpga_qpn_ set but not used [-Wunused-but-set-variable]
  u32 fpga_qpn;
      ^~~~~~~~

Fixes: 98db16bab59f ("net/mlx5: FPGA, Handle QP error event")
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c
index 436a8136f26ff..310f9e7d83200 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c
@@ -289,7 +289,6 @@ void mlx5_fpga_event(struct mlx5_core_dev *mdev, u8 event, void *data)
 	const char *event_name;
 	bool teardown = false;
 	unsigned long flags;
-	u32 fpga_qpn;
 	u8 syndrome;
 
 	switch (event) {
@@ -300,7 +299,6 @@ void mlx5_fpga_event(struct mlx5_core_dev *mdev, u8 event, void *data)
 	case MLX5_EVENT_TYPE_FPGA_QP_ERROR:
 		syndrome = MLX5_GET(fpga_qp_error_event, data, syndrome);
 		event_name = mlx5_fpga_qp_syndrome_to_string(syndrome);
-		fpga_qpn = MLX5_GET(fpga_qp_error_event, data, fpga_qpn);
 		break;
 	default:
 		mlx5_fpga_warn_ratelimited(fdev, "Unexpected event %u\n",
-- 
2.20.1



