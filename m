Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A607328A1F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239202AbhCASMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:12:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:58284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239082AbhCASFj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:05:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0213D64E04;
        Mon,  1 Mar 2021 17:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619235;
        bh=/yQWPPpYDpsQPtXvR87xm7pGg6ojykL9qZPjFe1zRbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q7ELpDDqyv1KbiIQ98Iu2JleAjQ3zAmaQes8V6KHzdyRPOOOJSzR71DHwNcl4ui41
         DQb+L+H9bXETw9jLN9ni3lcc9J4naW8Sw2Baw4ZW4vVi0VoSCA8/dWBYWI0zCpBCJq
         YbPtfQ8E8pq/UNxKxbBPotGeKMy5VllBOW4G8hkY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gioh Kim <gi-oh.kim@cloud.ionos.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 381/663] RDMA/rtrs-srv-sysfs: fix missing put_device
Date:   Mon,  1 Mar 2021 17:10:29 +0100
Message-Id: <20210301161200.709261079@linuxfoundation.org>
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

From: Gioh Kim <gi-oh.kim@cloud.ionos.com>

[ Upstream commit e2853c49477d104c01d3c7944e1fb5074eb11d9f ]

put_device() decreases the ref-count and then the device will be
cleaned-up, while at is also add missing put_device in
rtrs_srv_create_once_sysfs_root_folders

This patch solves a kmemleak error as below:

  unreferenced object 0xffff88809a7a0710 (size 8):
    comm "kworker/4:1H", pid 113, jiffies 4295833049 (age 6212.380s)
    hex dump (first 8 bytes):
      62 6c 61 00 6b 6b 6b a5                          bla.kkk.
    backtrace:
      [<0000000054413611>] kstrdup+0x2e/0x60
      [<0000000078e3120a>] kobject_set_name_vargs+0x2f/0xb0
      [<00000000f1a17a6b>] dev_set_name+0xab/0xe0
      [<00000000d5502e32>] rtrs_srv_create_sess_files+0x2fb/0x314 [rtrs_server]
      [<00000000ed11a1ef>] rtrs_srv_info_req_done+0x631/0x800 [rtrs_server]
      [<000000008fc5aa8f>] __ib_process_cq+0x94/0x100 [ib_core]
      [<00000000a9599cb4>] ib_cq_poll_work+0x32/0xc0 [ib_core]
      [<00000000cfc376be>] process_one_work+0x4bc/0x980
      [<0000000016e5c96a>] worker_thread+0x78/0x5c0
      [<00000000c20b8be0>] kthread+0x191/0x1e0
      [<000000006c9c0003>] ret_from_fork+0x3a/0x50

Fixes: baa5b28b7a47 ("RDMA/rtrs-srv: Replace device_register with device_initialize and device_add")
Link: https://lore.kernel.org/r/20210212134525.103456-5-jinpu.wang@cloud.ionos.com
Signed-off-by: Gioh Kim <gi-oh.kim@cloud.ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c b/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
index 1c5f97102103f..39708ab4f26e5 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
@@ -186,6 +186,7 @@ static int rtrs_srv_create_once_sysfs_root_folders(struct rtrs_srv_sess *sess)
 		err = -ENOMEM;
 		pr_err("kobject_create_and_add(): %d\n", err);
 		device_del(&srv->dev);
+		put_device(&srv->dev);
 		goto unlock;
 	}
 	dev_set_uevent_suppress(&srv->dev, false);
@@ -211,6 +212,7 @@ rtrs_srv_destroy_once_sysfs_root_folders(struct rtrs_srv_sess *sess)
 		kobject_put(srv->kobj_paths);
 		mutex_unlock(&srv->paths_mutex);
 		device_del(&srv->dev);
+		put_device(&srv->dev);
 	} else {
 		mutex_unlock(&srv->paths_mutex);
 	}
-- 
2.27.0



