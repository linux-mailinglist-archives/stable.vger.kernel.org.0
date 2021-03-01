Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738B6328FC2
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242410AbhCAT55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:57:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:55168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235958AbhCATot (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:44:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A55264DB2;
        Mon,  1 Mar 2021 17:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619232;
        bh=UALB3w1oSuiNJGgacHTkGxqPRuvUvwPNkbgoQVgz/pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJYMFVKbmZ5qbxrvPhcq6ymE5Gd3Pz6um1ZpKZ3rZpc8tEkpg0pslsWG3wWU3wTEf
         mMuPwfJ6mGLsLwoJOGXIN2tLQEplLUMHg1vQvRIqRaUaxeV+mhFWxXscZGZf5aN+0e
         j66rkEh0MRtEB8PZjdC6E4Wt7yf14ipnFNE+17ok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gioh Kim <gi-oh.kim@cloud.ionos.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 380/663] RDMA/rtrs-srv: fix memory leak by missing kobject free
Date:   Mon,  1 Mar 2021 17:10:28 +0100
Message-Id: <20210301161200.656980802@linuxfoundation.org>
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

[ Upstream commit f7452a7e96c120d73100387d5f87de9fce7133cb ]

kmemleak reported an error as below:

  unreferenced object 0xffff8880674b7640 (size 64):
    comm "kworker/4:1H", pid 113, jiffies 4296403507 (age 507.840s)
    hex dump (first 32 bytes):
      69 70 3a 31 39 32 2e 31 36 38 2e 31 32 32 2e 31  ip:192.168.122.1
      31 30 40 69 70 3a 31 39 32 2e 31 36 38 2e 31 32  10@ip:192.168.12
    backtrace:
      [<0000000054413611>] kstrdup+0x2e/0x60
      [<0000000078e3120a>] kobject_set_name_vargs+0x2f/0xb0
      [<00000000ca2be3ee>] kobject_init_and_add+0xb0/0x120
      [<0000000062ba5e78>] rtrs_srv_create_sess_files+0x14c/0x314 [rtrs_server]
      [<00000000b45b7217>] rtrs_srv_info_req_done+0x5b1/0x800 [rtrs_server]
      [<000000008fc5aa8f>] __ib_process_cq+0x94/0x100 [ib_core]
      [<00000000a9599cb4>] ib_cq_poll_work+0x32/0xc0 [ib_core]
      [<00000000cfc376be>] process_one_work+0x4bc/0x980
      [<0000000016e5c96a>] worker_thread+0x78/0x5c0
      [<00000000c20b8be0>] kthread+0x191/0x1e0
      [<000000006c9c0003>] ret_from_fork+0x3a/0x50

It is caused by the not-freed kobject of rtrs_srv_sess.  The kobject
embedded in rtrs_srv_sess has ref-counter 2 after calling
process_info_req(). Therefore it must call kobject_put twice.  Currently
it calls kobject_put only once at rtrs_srv_destroy_sess_files because
kobject_del removes the state_in_sysfs flag and then kobject_put in
free_sess() is not called.

This patch moves kobject_del() into free_sess() so that the kobject of
rtrs_srv_sess can be freed. And also this patch adds the missing call of
sysfs_remove_group() to clean-up the sysfs directory.

Fixes: 9cb837480424 ("RDMA/rtrs: server: main functionality")
Link: https://lore.kernel.org/r/20210212134525.103456-4-jinpu.wang@cloud.ionos.com
Signed-off-by: Gioh Kim <gi-oh.kim@cloud.ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c | 2 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c       | 6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c b/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
index 6a320b9b480dd..1c5f97102103f 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
@@ -308,7 +308,7 @@ void rtrs_srv_destroy_sess_files(struct rtrs_srv_sess *sess)
 	if (sess->kobj.state_in_sysfs) {
 		kobject_del(&sess->stats->kobj_stats);
 		kobject_put(&sess->stats->kobj_stats);
-		kobject_del(&sess->kobj);
+		sysfs_remove_group(&sess->kobj, &rtrs_srv_sess_attr_group);
 		kobject_put(&sess->kobj);
 
 		rtrs_srv_destroy_once_sysfs_root_folders(sess);
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 332418245dce3..717304c49d0c3 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1492,10 +1492,12 @@ static bool __is_path_w_addr_exists(struct rtrs_srv *srv,
 
 static void free_sess(struct rtrs_srv_sess *sess)
 {
-	if (sess->kobj.state_in_sysfs)
+	if (sess->kobj.state_in_sysfs) {
+		kobject_del(&sess->kobj);
 		kobject_put(&sess->kobj);
-	else
+	} else {
 		kfree(sess);
+	}
 }
 
 static void rtrs_srv_close_work(struct work_struct *work)
-- 
2.27.0



