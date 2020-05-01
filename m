Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC961C142B
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730393AbgEANg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:36:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730851AbgEANgX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:36:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8E26216FD;
        Fri,  1 May 2020 13:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340183;
        bh=RhizNEJwD+CwQC0rV67dcaCqGdRQnDrXrADI2/skOwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iBUQhKNNzXJqI31Ft4m2Pz1t5XM4cb+owoxpJqF1GV5s55VX0a5khNXcwH3F481oS
         3+SFTy8evo3ef9DXOWXqIMExrcdnOkQc3yQEyYLQMhFpqKJLcqVNHABKDDlEt3d9bF
         UjhZQmpFHwoRYngne64V4n17YerMSDWv35Tdf0u4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Schnelle <schnelle@linux.ibm.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.19 22/46] net/mlx5: Fix failing fw tracer allocation on s390
Date:   Fri,  1 May 2020 15:22:47 +0200
Message-Id: <20200501131506.530970636@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131457.023036302@linuxfoundation.org>
References: <20200501131457.023036302@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit a019b36123aec9700b21ae0724710f62928a8bc1 upstream.

On s390 FORCE_MAX_ZONEORDER is 9 instead of 11, thus a larger kzalloc()
allocation as done for the firmware tracer will always fail.

Looking at mlx5_fw_tracer_save_trace(), it is actually the driver itself
that copies the debug data into the trace array and there is no need for
the allocation to be contiguous in physical memory. We can therefor use
kvzalloc() instead of kzalloc() and get rid of the large contiguous
allcoation.

Fixes: f53aaa31cce7 ("net/mlx5: FW tracer, implement tracer logic")
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -796,7 +796,7 @@ struct mlx5_fw_tracer *mlx5_fw_tracer_cr
 		return NULL;
 	}
 
-	tracer = kzalloc(sizeof(*tracer), GFP_KERNEL);
+	tracer = kvzalloc(sizeof(*tracer), GFP_KERNEL);
 	if (!tracer)
 		return ERR_PTR(-ENOMEM);
 
@@ -842,7 +842,7 @@ destroy_workqueue:
 	tracer->dev = NULL;
 	destroy_workqueue(tracer->work_queue);
 free_tracer:
-	kfree(tracer);
+	kvfree(tracer);
 	return ERR_PTR(err);
 }
 
@@ -919,7 +919,7 @@ void mlx5_fw_tracer_destroy(struct mlx5_
 	mlx5_fw_tracer_destroy_log_buf(tracer);
 	flush_workqueue(tracer->work_queue);
 	destroy_workqueue(tracer->work_queue);
-	kfree(tracer);
+	kvfree(tracer);
 }
 
 void mlx5_fw_tracer_event(struct mlx5_core_dev *dev, struct mlx5_eqe *eqe)


