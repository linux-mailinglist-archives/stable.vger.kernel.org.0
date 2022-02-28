Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25F944C7594
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239156AbiB1Rzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:55:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240237AbiB1RyH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:54:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3399DB12D9;
        Mon, 28 Feb 2022 09:41:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A144B815BA;
        Mon, 28 Feb 2022 17:41:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5A1C340F1;
        Mon, 28 Feb 2022 17:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070107;
        bh=S8J+aiyOcgabjctDUgCUvtmL825UWRiMZ0r3ZLPkzCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N7cb9nddZIYkXLXUz73gKwiVmFdRrUr0V277vCBHFgu2OL8lF8xwgsxkTfyaE44jM
         S/WidmhS5CE4wE+p5FPHQo5RVquEskQi6j3omJJxQLpEgyTLx4NI4lzihjCzQlIAQR
         3GmxUCHywqlkT41vHiCJHaCfbKnrQFpY/jNAyvYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Md Haris Iqbal <haris.iqbal@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/139] RDMA/rtrs-clt: Fix possible double free in error case
Date:   Mon, 28 Feb 2022 18:24:23 +0100
Message-Id: <20220228172357.000407449@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Md Haris Iqbal <haris.iqbal@ionos.com>

[ Upstream commit 8700af2cc18c919b2a83e74e0479038fd113c15d ]

Callback function rtrs_clt_dev_release() for put_device() calls kfree(clt)
to free memory. We shouldn't call kfree(clt) again, and we can't use the
clt after kfree too.

Replace device_register() with device_initialize() and device_add() so that
dev_set_name can() be used appropriately.

Move mutex_destroy() to the release function so it can be called in
the alloc_clt err path.

Fixes: eab098246625 ("RDMA/rtrs-clt: Refactor the failure cases in alloc_clt")
Link: https://lore.kernel.org/r/20220217030929.323849-1-haris.iqbal@ionos.com
Reported-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 37 ++++++++++++++------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 55ebe01ec9951..3272514f05405 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -2664,6 +2664,8 @@ static void rtrs_clt_dev_release(struct device *dev)
 {
 	struct rtrs_clt *clt = container_of(dev, struct rtrs_clt, dev);
 
+	mutex_destroy(&clt->paths_ev_mutex);
+	mutex_destroy(&clt->paths_mutex);
 	kfree(clt);
 }
 
@@ -2693,6 +2695,8 @@ static struct rtrs_clt *alloc_clt(const char *sessname, size_t paths_num,
 		return ERR_PTR(-ENOMEM);
 	}
 
+	clt->dev.class = rtrs_clt_dev_class;
+	clt->dev.release = rtrs_clt_dev_release;
 	uuid_gen(&clt->paths_uuid);
 	INIT_LIST_HEAD_RCU(&clt->paths_list);
 	clt->paths_num = paths_num;
@@ -2709,43 +2713,41 @@ static struct rtrs_clt *alloc_clt(const char *sessname, size_t paths_num,
 	init_waitqueue_head(&clt->permits_wait);
 	mutex_init(&clt->paths_ev_mutex);
 	mutex_init(&clt->paths_mutex);
+	device_initialize(&clt->dev);
 
-	clt->dev.class = rtrs_clt_dev_class;
-	clt->dev.release = rtrs_clt_dev_release;
 	err = dev_set_name(&clt->dev, "%s", sessname);
 	if (err)
-		goto err;
+		goto err_put;
+
 	/*
 	 * Suppress user space notification until
 	 * sysfs files are created
 	 */
 	dev_set_uevent_suppress(&clt->dev, true);
-	err = device_register(&clt->dev);
-	if (err) {
-		put_device(&clt->dev);
-		goto err;
-	}
+	err = device_add(&clt->dev);
+	if (err)
+		goto err_put;
 
 	clt->kobj_paths = kobject_create_and_add("paths", &clt->dev.kobj);
 	if (!clt->kobj_paths) {
 		err = -ENOMEM;
-		goto err_dev;
+		goto err_del;
 	}
 	err = rtrs_clt_create_sysfs_root_files(clt);
 	if (err) {
 		kobject_del(clt->kobj_paths);
 		kobject_put(clt->kobj_paths);
-		goto err_dev;
+		goto err_del;
 	}
 	dev_set_uevent_suppress(&clt->dev, false);
 	kobject_uevent(&clt->dev.kobj, KOBJ_ADD);
 
 	return clt;
-err_dev:
-	device_unregister(&clt->dev);
-err:
+err_del:
+	device_del(&clt->dev);
+err_put:
 	free_percpu(clt->pcpu_path);
-	kfree(clt);
+	put_device(&clt->dev);
 	return ERR_PTR(err);
 }
 
@@ -2753,9 +2755,10 @@ static void free_clt(struct rtrs_clt *clt)
 {
 	free_permits(clt);
 	free_percpu(clt->pcpu_path);
-	mutex_destroy(&clt->paths_ev_mutex);
-	mutex_destroy(&clt->paths_mutex);
-	/* release callback will free clt in last put */
+
+	/*
+	 * release callback will free clt and destroy mutexes in last put
+	 */
 	device_unregister(&clt->dev);
 }
 
-- 
2.34.1



