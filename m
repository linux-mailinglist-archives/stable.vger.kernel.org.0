Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582FC328CDA
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238142AbhCATAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:00:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:58456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240786AbhCASxz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:53:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEDB960241;
        Mon,  1 Mar 2021 17:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619103;
        bh=MlCNaozikj7dZsiSVfzXOoHx/DXdC6FL94fFywA+2wg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xSF18KW71+rJfgD39tDWABqgIogd8cWJ4BNtoaUBn3xVhLXLZaDlJQvHHdhrQylcD
         qb+r8o+Hx+R6mP2Kl2OdvzwnCgwV9++bAUU9J85KLRK5qP1RI4mcWxaHS6+jfdB/Ot
         4wgj4bvxIAv4fWkBkKQrbM1z1RGHM2ldgFeVEqvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Md Haris Iqbal <haris.iqbal@cloud.ionos.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 292/663] RDMA/rtrs-clt: Refactor the failure cases in alloc_clt
Date:   Mon,  1 Mar 2021 17:09:00 +0100
Message-Id: <20210301161156.280535732@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>

[ Upstream commit eab098246625e91c1cbd6e8f75b09e4c9c28a9fc ]

Make all failure cases go to the common path to avoid duplicate code.
And some issued existed before.

1. clt need to be freed to avoid memory leak.

2. return ERR_PTR(-ENOMEM) if kobject_create_and_add fails, because
   rtrs_clt_open checks the return value of by call "IS_ERR(clt)".

Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
Link: https://lore.kernel.org/r/20201217141915.56989-15-jinpu.wang@cloud.ionos.com
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Reviewed-by: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 88397bf4b044b..6115db7ca2030 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -2576,11 +2576,8 @@ static struct rtrs_clt *alloc_clt(const char *sessname, size_t paths_num,
 	clt->dev.class = rtrs_clt_dev_class;
 	clt->dev.release = rtrs_clt_dev_release;
 	err = dev_set_name(&clt->dev, "%s", sessname);
-	if (err) {
-		free_percpu(clt->pcpu_path);
-		kfree(clt);
-		return ERR_PTR(err);
-	}
+	if (err)
+		goto err;
 	/*
 	 * Suppress user space notification until
 	 * sysfs files are created
@@ -2588,29 +2585,31 @@ static struct rtrs_clt *alloc_clt(const char *sessname, size_t paths_num,
 	dev_set_uevent_suppress(&clt->dev, true);
 	err = device_register(&clt->dev);
 	if (err) {
-		free_percpu(clt->pcpu_path);
 		put_device(&clt->dev);
-		return ERR_PTR(err);
+		goto err;
 	}
 
 	clt->kobj_paths = kobject_create_and_add("paths", &clt->dev.kobj);
 	if (!clt->kobj_paths) {
-		free_percpu(clt->pcpu_path);
-		device_unregister(&clt->dev);
-		return NULL;
+		err = -ENOMEM;
+		goto err_dev;
 	}
 	err = rtrs_clt_create_sysfs_root_files(clt);
 	if (err) {
-		free_percpu(clt->pcpu_path);
 		kobject_del(clt->kobj_paths);
 		kobject_put(clt->kobj_paths);
-		device_unregister(&clt->dev);
-		return ERR_PTR(err);
+		goto err_dev;
 	}
 	dev_set_uevent_suppress(&clt->dev, false);
 	kobject_uevent(&clt->dev.kobj, KOBJ_ADD);
 
 	return clt;
+err_dev:
+	device_unregister(&clt->dev);
+err:
+	free_percpu(clt->pcpu_path);
+	kfree(clt);
+	return ERR_PTR(err);
 }
 
 static void wait_for_inflight_permits(struct rtrs_clt *clt)
-- 
2.27.0



