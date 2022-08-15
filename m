Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3E4594DA5
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239810AbiHPAbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346640AbiHPAaV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:30:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EFB61849D2;
        Mon, 15 Aug 2022 13:35:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C11C6121A;
        Mon, 15 Aug 2022 20:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BECC433C1;
        Mon, 15 Aug 2022 20:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595747;
        bh=KM2BqJ70Ryu+d2ZegbEKyHkGysngUz+E2aiY5tWpnY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vgOmT7c6YNq86Y2SmXT3AvEZPJRMy9UQrxU/yVJXJkC9azjJkDlf025p5AFfC/NxI
         98G4Jgcbu20F/2kY//5BrlRbMVQ3Qnq6fjZ2hJ4sMdl7LAnODfOtqqqNP5mTsYBuMs
         vtm9Nxz+0XXDmJTOd48JboZD1k4JKII3oAl9HBeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0861/1157] RDMA/srpt: Introduce a reference count in struct srpt_device
Date:   Mon, 15 Aug 2022 20:03:37 +0200
Message-Id: <20220815180513.904605508@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index 8253d55b9c26..1fbce9225424 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3104,6 +3104,18 @@ static int srpt_use_srq(struct srpt_device *sdev, bool use_srq)
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
@@ -3122,6 +3134,7 @@ static int srpt_add_one(struct ib_device *device)
 	if (!sdev)
 		return -ENOMEM;
 
+	kref_init(&sdev->refcnt);
 	sdev->device = device;
 	mutex_init(&sdev->sdev_mutex);
 
@@ -3217,7 +3230,7 @@ static int srpt_add_one(struct ib_device *device)
 	srpt_free_srq(sdev);
 	ib_dealloc_pd(sdev->pd);
 free_dev:
-	kfree(sdev);
+	srpt_sdev_put(sdev);
 	pr_info("%s(%s) failed.\n", __func__, dev_name(&device->dev));
 	return ret;
 }
@@ -3261,7 +3274,7 @@ static void srpt_remove_one(struct ib_device *device, void *client_data)
 
 	ib_dealloc_pd(sdev->pd);
 
-	kfree(sdev);
+	srpt_sdev_put(sdev);
 }
 
 static struct ib_client srpt_client = {
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 3844a7058559..0cb867d580f1 100644
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



