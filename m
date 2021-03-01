Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A36A328AB0
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239418AbhCASVh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:21:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:34038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234634AbhCASQO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:16:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37B5B651B5;
        Mon,  1 Mar 2021 17:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618988;
        bh=M9ylgQ5JoXbSNclTAL2v3OmRvsTAGD6vlXBNtM1N+8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HnQLXXDwiz9fCNh9wlhkLeqf2nyhdF2har/y+16U+EhsPr9Dv5P1ng0mqCI+mH3Xs
         v/9V+DYwYfDUiANwowwUE2kNg62acjZaSXq1s7vPiT9mtLwUdsfrmVTA5n4Znf3gpb
         ZZh/0UmZt+P1SOdym9aGBY/n8AdlG8kXfWCotK3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Md Haris Iqbal <haris.iqbal@cloud.ionos.com>,
        Gioh Kim <gi-oh.kim@cloud.ionos.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 290/663] RDMA/rtrs: Call kobject_put in the failure path
Date:   Mon,  1 Mar 2021 17:08:58 +0100
Message-Id: <20210301161156.180035909@linuxfoundation.org>
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

[ Upstream commit 424774c9f3fa100ef7d9cfb9ee211e2ba1cd5119 ]

Per the comment of kobject_init_and_add, we need to free the memory
by call kobject_put.

Fixes: 215378b838df ("RDMA/rtrs: client: sysfs interface functions")
Fixes: 91b11610af8d ("RDMA/rtrs: server: sysfs interface functions")
Link: https://lore.kernel.org/r/20201217141915.56989-8-jinpu.wang@cloud.ionos.com
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Reviewed-by: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
Reviewed-by: Gioh Kim <gi-oh.kim@cloud.ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c | 2 ++
 drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c b/drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c
index ac4c49cbf1538..2ee3806f2df5b 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c
@@ -408,6 +408,7 @@ int rtrs_clt_create_sess_files(struct rtrs_clt_sess *sess)
 				   "%s", str);
 	if (err) {
 		pr_err("kobject_init_and_add: %d\n", err);
+		kobject_put(&sess->kobj);
 		return err;
 	}
 	err = sysfs_create_group(&sess->kobj, &rtrs_clt_sess_attr_group);
@@ -419,6 +420,7 @@ int rtrs_clt_create_sess_files(struct rtrs_clt_sess *sess)
 				   &sess->kobj, "stats");
 	if (err) {
 		pr_err("kobject_init_and_add: %d\n", err);
+		kobject_put(&sess->stats->kobj_stats);
 		goto remove_group;
 	}
 
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c b/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
index 3c5dfe21bba68..6a320b9b480dd 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
@@ -239,6 +239,7 @@ static int rtrs_srv_create_stats_files(struct rtrs_srv_sess *sess)
 				   &sess->kobj, "stats");
 	if (err) {
 		rtrs_err(s, "kobject_init_and_add(): %d\n", err);
+		kobject_put(&sess->stats->kobj_stats);
 		return err;
 	}
 	err = sysfs_create_group(&sess->stats->kobj_stats,
@@ -295,8 +296,8 @@ remove_group:
 	sysfs_remove_group(&sess->kobj, &rtrs_srv_sess_attr_group);
 put_kobj:
 	kobject_del(&sess->kobj);
-	kobject_put(&sess->kobj);
 destroy_root:
+	kobject_put(&sess->kobj);
 	rtrs_srv_destroy_once_sysfs_root_folders(sess);
 
 	return err;
-- 
2.27.0



