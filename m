Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA50B99DDE
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391694AbfHVRqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:46:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391573AbfHVRW6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:22:58 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C00521743;
        Thu, 22 Aug 2019 17:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494578;
        bh=9UDlhyyS2aO2cxY5EODwhbEEZ833nR8tz9Zsgi607ws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O2Qh6WWFukX0brnqVgPHtTIdJzJ6I/Yrqpw9+ymSjF49cee58DN8ycBDsrRB4bg/T
         L9qpaQpY4vJgRfqQ/gtcN5WxHxiLI24ocDralbaWEpScF8GPNJdC5HRWzZjQkGULeg
         8C0PMCMMDNn14K5Hl/K6gRmdRM4JnzaCCFA13pJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Ledford <dledford@redhat.com>
Subject: [PATCH 4.4 70/78] IB/mlx5: Make coding style more consistent
Date:   Thu, 22 Aug 2019 10:19:14 -0700
Message-Id: <20190822171834.056892056@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171832.012773482@linuxfoundation.org>
References: <20190822171832.012773482@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Ledford <dledford@redhat.com>

commit 0025b0bdeae7c13b8ab1dce64b0108ed9c071e2e upstream.

These three related functions can't agree whether to put the
umrwr on the stack dirty and then memset it, or to initialize
it on the stack.  Make them all agree.

Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx5/mr.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -792,7 +792,7 @@ static struct mlx5_ib_mr *reg_umr(struct
 	struct device *ddev = dev->ib_dev.dma_device;
 	struct umr_common *umrc = &dev->umrc;
 	struct mlx5_ib_umr_context umr_context;
-	struct mlx5_umr_wr umrwr;
+	struct mlx5_umr_wr umrwr = {};
 	struct ib_send_wr *bad;
 	struct mlx5_ib_mr *mr;
 	struct ib_sge sg;
@@ -839,7 +839,6 @@ static struct mlx5_ib_mr *reg_umr(struct
 		goto free_pas;
 	}
 
-	memset(&umrwr, 0, sizeof(umrwr));
 	umrwr.wr.wr_id = (u64)(unsigned long)&umr_context;
 	prep_umr_reg_wqe(pd, &umrwr.wr, &sg, dma, npages, mr->mmr.key,
 			 page_shift, virt_addr, len, access_flags);
@@ -1163,11 +1162,10 @@ static int unreg_umr(struct mlx5_ib_dev
 {
 	struct umr_common *umrc = &dev->umrc;
 	struct mlx5_ib_umr_context umr_context;
-	struct mlx5_umr_wr umrwr;
+	struct mlx5_umr_wr umrwr = {};
 	struct ib_send_wr *bad;
 	int err;
 
-	memset(&umrwr.wr, 0, sizeof(umrwr));
 	umrwr.wr.wr_id = (u64)(unsigned long)&umr_context;
 	prep_umr_unreg_wqe(dev, &umrwr.wr, mr->mmr.key);
 


