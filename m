Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31FA0412426
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348477AbhITSbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:31:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379307AbhITS26 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:28:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E0B0632DA;
        Mon, 20 Sep 2021 17:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158806;
        bh=CXCzy7tiYTN6nZ2fvrhXM7SroQ9LCi5oAHSmqNIicIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I/pcnEIWgOkh3J+sSVcLRRCzoVvdfscIQU1UvPy4SMueOTy+puTlj/XuZcfC9Nvi8
         AN5hYGpc7b8kDVU/Ig53HaXqy8457vcsGPROcdtDRDxy/uJHKo5W/08RZcPeZWlXwK
         q/fzQzmSqDyMUN2bMk3dYlB5AmlI3Kzq6Xf76bTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Pavel Machek (CIP)" <pavel@denx.de>,
        Saeed Mahameed <saeedm@nvidia.com>, Aya Levin <ayal@nvidia.com>
Subject: [PATCH 5.10 032/122] net/mlx5: FWTrace, cancel work on alloc pd error flow
Date:   Mon, 20 Sep 2021 18:43:24 +0200
Message-Id: <20210920163916.852916040@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

commit dfe6fd72b5f1878b16aa2c8603e031bbcd66b96d upstream.

Handle error flow on mlx5_core_alloc_pd() failure,
read_fw_strings_work must be canceled.

Fixes: c71ad41ccb0c ("net/mlx5: FW tracer, events handling")
Reported-by: Pavel Machek (CIP) <pavel@denx.de>
Suggested-by: Pavel Machek (CIP) <pavel@denx.de>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -1007,7 +1007,7 @@ int mlx5_fw_tracer_init(struct mlx5_fw_t
 	err = mlx5_core_alloc_pd(dev, &tracer->buff.pdn);
 	if (err) {
 		mlx5_core_warn(dev, "FWTracer: Failed to allocate PD %d\n", err);
-		return err;
+		goto err_cancel_work;
 	}
 
 	err = mlx5_fw_tracer_create_mkey(tracer);
@@ -1031,6 +1031,7 @@ err_notifier_unregister:
 	mlx5_core_destroy_mkey(dev, &tracer->buff.mkey);
 err_dealloc_pd:
 	mlx5_core_dealloc_pd(dev, tracer->buff.pdn);
+err_cancel_work:
 	cancel_work_sync(&tracer->read_fw_strings_work);
 	return err;
 }


