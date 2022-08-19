Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09E1A59A223
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352704AbiHSQct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353151AbiHSQap (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:30:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91F411C95A;
        Fri, 19 Aug 2022 09:04:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 852996181A;
        Fri, 19 Aug 2022 16:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775FEC433D6;
        Fri, 19 Aug 2022 16:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925091;
        bh=Q1XKlkSmNB0ooyHW5Aovx9xJyAFbdCyQd9xyTfaZqJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QRk1aIW+yfGFHAVld46MtZFY/YEtQMen13nZ+c72v+zRIYMk+bvb1B+ta9YAlRg5G
         hnMgn8eZTZjsyxYHy6Em1i56ORO6J8gXMGEvLzwT424GNqECoTRwb4BNX95+tUUTkr
         rfWtYuRTJOd2ndG6n6F18aTt1bSNYar2OkkkzH2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 351/545] RDMA/srpt: Introduce a reference count in struct srpt_device
Date:   Fri, 19 Aug 2022 17:42:01 +0200
Message-Id: <20220819153845.086670476@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit aa7dfbb41b5a60ab90e244d6f586b8cb5c791c3e ]

This will be used to keep struct srpt_device around as long as either the
RDMA port exists or a LIO target port is associated with the struct
srpt_device.

Link: https://lore.kernel.org/r/20220727193415.1583860-3-bvanassche@acm.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 17 +++++++++++++++--
 drivers/infiniband/ulp/srpt/ib_srpt.h |  2 ++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 4cecdcee606a..211d4e82e4ba 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3101,6 +3101,18 @@ static int srpt_use_srq(struct srpt_device *sdev, bool use_srq)
 	return ret;
 }
 
+static void srpt_free_sdev(struct kref *refcnt)
+{
+	struct srpt_device *sdev = container_of(refcnt, typeof(*sdev), refcnt);
+
+	kfree(sdev);
+}
+
+static void srpt_sdev_put(struct srpt_device *sdev)
+{
+	kref_put(&sdev->refcnt, srpt_free_sdev);
+}
+
 /**
  * srpt_add_one - InfiniBand device addition callback function
  * @device: Describes a HCA.
@@ -3118,6 +3130,7 @@ static int srpt_add_one(struct ib_device *device)
 	if (!sdev)
 		return -ENOMEM;
 
+	kref_init(&sdev->refcnt);
 	sdev->device = device;
 	mutex_init(&sdev->sdev_mutex);
 
@@ -3213,7 +3226,7 @@ static int srpt_add_one(struct ib_device *device)
 	srpt_free_srq(sdev);
 	ib_dealloc_pd(sdev->pd);
 free_dev:
-	kfree(sdev);
+	srpt_sdev_put(sdev);
 	pr_info("%s(%s) failed.\n", __func__, dev_name(&device->dev));
 	return ret;
 }
@@ -3257,7 +3270,7 @@ static void srpt_remove_one(struct ib_device *device, void *client_data)
 
 	ib_dealloc_pd(sdev->pd);
 
-	kfree(sdev);
+	srpt_sdev_put(sdev);
 }
 
 static struct ib_client srpt_client = {
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 1d28f13196c9..978a338f1f0e 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -434,6 +434,7 @@ struct srpt_port {
 
 /**
  * struct srpt_device - information associated by SRPT with a single HCA
+ * @refcnt:	   Reference count for this device.
  * @device:        Backpointer to the struct ib_device managed by the IB core.
  * @pd:            IB protection domain.
  * @lkey:          L_Key (local key) with write access to all local memory.
@@ -449,6 +450,7 @@ struct srpt_port {
  * @port:          Information about the ports owned by this HCA.
  */
 struct srpt_device {
+	struct kref		refcnt;
 	struct ib_device	*device;
 	struct ib_pd		*pd;
 	u32			lkey;
-- 
2.35.1



