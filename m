Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521FB1C14CD
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731327AbgEANnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:43:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:43852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731078AbgEANnB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:43:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6453120757;
        Fri,  1 May 2020 13:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340580;
        bh=JIjDI1yWmotW1ixclDVHEKfcxGRhfZ1evqCSWr+9Ni4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FEf8r1AOOP4SmyUd5b4YXTbjSV7te6olWNJ8YpsZdoAltPq9339sL6v84pvq+Xo9f
         GXSyrk4+JAbDGU+Qyu5r5XJvUZStzeMYrskqNJ7a3l2w5P45ggyqDjTOmMUwry7V3d
         siAcmGVW3yU0CvMiy2djnvsJSoU0cSWnmnekl06Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Schnelle <schnelle@linux.ibm.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.6 052/106] net/mlx5: Fix failing fw tracer allocation on s390
Date:   Fri,  1 May 2020 15:23:25 +0200
Message-Id: <20200501131549.901718824@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
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
@@ -935,7 +935,7 @@ struct mlx5_fw_tracer *mlx5_fw_tracer_cr
 		return NULL;
 	}
 
-	tracer = kzalloc(sizeof(*tracer), GFP_KERNEL);
+	tracer = kvzalloc(sizeof(*tracer), GFP_KERNEL);
 	if (!tracer)
 		return ERR_PTR(-ENOMEM);
 
@@ -982,7 +982,7 @@ destroy_workqueue:
 	tracer->dev = NULL;
 	destroy_workqueue(tracer->work_queue);
 free_tracer:
-	kfree(tracer);
+	kvfree(tracer);
 	return ERR_PTR(err);
 }
 
@@ -1061,7 +1061,7 @@ void mlx5_fw_tracer_destroy(struct mlx5_
 	mlx5_fw_tracer_destroy_log_buf(tracer);
 	flush_workqueue(tracer->work_queue);
 	destroy_workqueue(tracer->work_queue);
-	kfree(tracer);
+	kvfree(tracer);
 }
 
 static int fw_tracer_event(struct notifier_block *nb, unsigned long action, void *data)


