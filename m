Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 781AC593849
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244711AbiHOTTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345090AbiHOTSG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:18:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45FEF56B9E;
        Mon, 15 Aug 2022 11:39:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D201AB8106C;
        Mon, 15 Aug 2022 18:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB92C4347C;
        Mon, 15 Aug 2022 18:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588768;
        bh=e3P9U3xf5GR5yElDPV4z2Sc7JZMhhxhffM7ZNlCg6XQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CjWNR0VebzXjNYRbqgccKuyPVtT5GCHA7xuugZeknWt+wVK3JyUkjEf5Wc6+0AI6B
         hr56CLHjKcdx8QipBqBlryR7SHNsWJZ66umT3fKINJ/PT8D8wVWXdpvpTeMjxUImqE
         6zp6Vc9GpKpWPI85f76wlFbfN/lQBEVjqSG7aU1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vaishali Thakkar <vaishali.thakkar@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 508/779] RDMA/rtrs-srv: Rename rtrs_srv_sess to rtrs_srv_path
Date:   Mon, 15 Aug 2022 20:02:32 +0200
Message-Id: <20220815180358.977178471@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Vaishali Thakkar <vaishali.thakkar@ionos.com>

[ Upstream commit ae4c81644e9105d9f7f713bb0d444737bb6a0cf1 ]

rtrs_srv_sess is used for paths and not sessions on the server side. This
creates confusion so let's rename it to rtrs_srv_path. Also, rename
related variables and functions.

Coccinelle is used to do the transformations for most of the occurrences
and remaining ones were handled manually.

Link: https://lore.kernel.org/r/20220105180708.7774-3-jinpu.wang@ionos.com
Signed-off-by: Vaishali Thakkar <vaishali.thakkar@ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rnbd/rnbd-srv.c                |  12 +-
 drivers/infiniband/ulp/rtrs/rtrs-pri.h       |   2 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c | 119 ++--
 drivers/infiniband/ulp/rtrs/rtrs-srv.c       | 627 ++++++++++---------
 drivers/infiniband/ulp/rtrs/rtrs-srv.h       |  10 +-
 drivers/infiniband/ulp/rtrs/rtrs.h           |   3 +-
 6 files changed, 392 insertions(+), 381 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.c
index aafecfe97055..1ba1a93a6fe7 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -266,12 +266,12 @@ static void destroy_sess(struct rnbd_srv_session *srv_sess)
 static int create_sess(struct rtrs_srv *rtrs)
 {
 	struct rnbd_srv_session *srv_sess;
-	char sessname[NAME_MAX];
+	char pathname[NAME_MAX];
 	int err;
 
-	err = rtrs_srv_get_sess_name(rtrs, sessname, sizeof(sessname));
+	err = rtrs_srv_get_path_name(rtrs, pathname, sizeof(pathname));
 	if (err) {
-		pr_err("rtrs_srv_get_sess_name(%s): %d\n", sessname, err);
+		pr_err("rtrs_srv_get_path_name(%s): %d\n", pathname, err);
 
 		return err;
 	}
@@ -284,8 +284,8 @@ static int create_sess(struct rtrs_srv *rtrs)
 			  offsetof(struct rnbd_dev_blk_io, bio),
 			  BIOSET_NEED_BVECS);
 	if (err) {
-		pr_err("Allocating srv_session for session %s failed\n",
-		       sessname);
+		pr_err("Allocating srv_session for path %s failed\n",
+		       pathname);
 		kfree(srv_sess);
 		return err;
 	}
@@ -298,7 +298,7 @@ static int create_sess(struct rtrs_srv *rtrs)
 	mutex_unlock(&sess_lock);
 
 	srv_sess->rtrs = rtrs;
-	strscpy(srv_sess->sessname, sessname, sizeof(srv_sess->sessname));
+	strscpy(srv_sess->sessname, pathname, sizeof(srv_sess->sessname));
 
 	rtrs_srv_set_sess_priv(rtrs, srv_sess);
 
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-pri.h b/drivers/infiniband/ulp/rtrs/rtrs-pri.h
index fad06c707b9b..412cf5ce3e7c 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-pri.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs-pri.h
@@ -234,7 +234,7 @@ struct rtrs_msg_conn_rsp {
  */
 struct rtrs_msg_info_req {
 	__le16		type;
-	u8		sessname[NAME_MAX];
+	u8		pathname[NAME_MAX];
 	u8		reserved[15];
 };
 
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c b/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
index aedddc416003..309080184aac 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
@@ -15,10 +15,10 @@
 
 static void rtrs_srv_release(struct kobject *kobj)
 {
-	struct rtrs_srv_sess *sess;
+	struct rtrs_srv_path *srv_path;
 
-	sess = container_of(kobj, struct rtrs_srv_sess, kobj);
-	kfree(sess);
+	srv_path = container_of(kobj, struct rtrs_srv_path, kobj);
+	kfree(srv_path);
 }
 
 static struct kobj_type ktype = {
@@ -36,24 +36,25 @@ static ssize_t rtrs_srv_disconnect_store(struct kobject *kobj,
 					  struct kobj_attribute *attr,
 					  const char *buf, size_t count)
 {
-	struct rtrs_srv_sess *sess;
+	struct rtrs_srv_path *srv_path;
 	struct rtrs_path *s;
 	char str[MAXHOSTNAMELEN];
 
-	sess = container_of(kobj, struct rtrs_srv_sess, kobj);
-	s = &sess->s;
+	srv_path = container_of(kobj, struct rtrs_srv_path, kobj);
+	s = &srv_path->s;
 	if (!sysfs_streq(buf, "1")) {
 		rtrs_err(s, "%s: invalid value: '%s'\n",
 			  attr->attr.name, buf);
 		return -EINVAL;
 	}
 
-	sockaddr_to_str((struct sockaddr *)&sess->s.dst_addr, str, sizeof(str));
+	sockaddr_to_str((struct sockaddr *)&srv_path->s.dst_addr, str,
+			sizeof(str));
 
 	rtrs_info(s, "disconnect for path %s requested\n", str);
 	/* first remove sysfs itself to avoid deadlock */
-	sysfs_remove_file_self(&sess->kobj, &attr->attr);
-	close_sess(sess);
+	sysfs_remove_file_self(&srv_path->kobj, &attr->attr);
+	close_path(srv_path);
 
 	return count;
 }
@@ -66,11 +67,11 @@ static ssize_t rtrs_srv_hca_port_show(struct kobject *kobj,
 				       struct kobj_attribute *attr,
 				       char *page)
 {
-	struct rtrs_srv_sess *sess;
+	struct rtrs_srv_path *srv_path;
 	struct rtrs_con *usr_con;
 
-	sess = container_of(kobj, typeof(*sess), kobj);
-	usr_con = sess->s.con[0];
+	srv_path = container_of(kobj, typeof(*srv_path), kobj);
+	usr_con = srv_path->s.con[0];
 
 	return sysfs_emit(page, "%u\n", usr_con->cm_id->port_num);
 }
@@ -82,11 +83,11 @@ static ssize_t rtrs_srv_hca_name_show(struct kobject *kobj,
 				       struct kobj_attribute *attr,
 				       char *page)
 {
-	struct rtrs_srv_sess *sess;
+	struct rtrs_srv_path *srv_path;
 
-	sess = container_of(kobj, struct rtrs_srv_sess, kobj);
+	srv_path = container_of(kobj, struct rtrs_srv_path, kobj);
 
-	return sysfs_emit(page, "%s\n", sess->s.dev->ib_dev->name);
+	return sysfs_emit(page, "%s\n", srv_path->s.dev->ib_dev->name);
 }
 
 static struct kobj_attribute rtrs_srv_hca_name_attr =
@@ -96,11 +97,11 @@ static ssize_t rtrs_srv_src_addr_show(struct kobject *kobj,
 				       struct kobj_attribute *attr,
 				       char *page)
 {
-	struct rtrs_srv_sess *sess;
+	struct rtrs_srv_path *srv_path;
 	int cnt;
 
-	sess = container_of(kobj, struct rtrs_srv_sess, kobj);
-	cnt = sockaddr_to_str((struct sockaddr *)&sess->s.dst_addr,
+	srv_path = container_of(kobj, struct rtrs_srv_path, kobj);
+	cnt = sockaddr_to_str((struct sockaddr *)&srv_path->s.dst_addr,
 			      page, PAGE_SIZE);
 	return cnt + scnprintf(page + cnt, PAGE_SIZE - cnt, "\n");
 }
@@ -112,11 +113,11 @@ static ssize_t rtrs_srv_dst_addr_show(struct kobject *kobj,
 				       struct kobj_attribute *attr,
 				       char *page)
 {
-	struct rtrs_srv_sess *sess;
+	struct rtrs_srv_path *srv_path;
 	int len;
 
-	sess = container_of(kobj, struct rtrs_srv_sess, kobj);
-	len = sockaddr_to_str((struct sockaddr *)&sess->s.src_addr, page,
+	srv_path = container_of(kobj, struct rtrs_srv_path, kobj);
+	len = sockaddr_to_str((struct sockaddr *)&srv_path->s.src_addr, page,
 			      PAGE_SIZE);
 	len += sysfs_emit_at(page, len, "\n");
 	return len;
@@ -125,7 +126,7 @@ static ssize_t rtrs_srv_dst_addr_show(struct kobject *kobj,
 static struct kobj_attribute rtrs_srv_dst_addr_attr =
 	__ATTR(dst_addr, 0444, rtrs_srv_dst_addr_show, NULL);
 
-static struct attribute *rtrs_srv_sess_attrs[] = {
+static struct attribute *rtrs_srv_path_attrs[] = {
 	&rtrs_srv_hca_name_attr.attr,
 	&rtrs_srv_hca_port_attr.attr,
 	&rtrs_srv_src_addr_attr.attr,
@@ -134,8 +135,8 @@ static struct attribute *rtrs_srv_sess_attrs[] = {
 	NULL,
 };
 
-static const struct attribute_group rtrs_srv_sess_attr_group = {
-	.attrs = rtrs_srv_sess_attrs,
+static const struct attribute_group rtrs_srv_path_attr_group = {
+	.attrs = rtrs_srv_path_attrs,
 };
 
 STAT_ATTR(struct rtrs_srv_stats, rdma,
@@ -151,9 +152,9 @@ static const struct attribute_group rtrs_srv_stats_attr_group = {
 	.attrs = rtrs_srv_stats_attrs,
 };
 
-static int rtrs_srv_create_once_sysfs_root_folders(struct rtrs_srv_sess *sess)
+static int rtrs_srv_create_once_sysfs_root_folders(struct rtrs_srv_path *srv_path)
 {
-	struct rtrs_srv *srv = sess->srv;
+	struct rtrs_srv *srv = srv_path->srv;
 	int err = 0;
 
 	mutex_lock(&srv->paths_mutex);
@@ -164,7 +165,7 @@ static int rtrs_srv_create_once_sysfs_root_folders(struct rtrs_srv_sess *sess)
 		goto unlock;
 	}
 	srv->dev.class = rtrs_dev_class;
-	err = dev_set_name(&srv->dev, "%s", sess->s.sessname);
+	err = dev_set_name(&srv->dev, "%s", srv_path->s.sessname);
 	if (err)
 		goto unlock;
 
@@ -196,9 +197,9 @@ static int rtrs_srv_create_once_sysfs_root_folders(struct rtrs_srv_sess *sess)
 }
 
 static void
-rtrs_srv_destroy_once_sysfs_root_folders(struct rtrs_srv_sess *sess)
+rtrs_srv_destroy_once_sysfs_root_folders(struct rtrs_srv_path *srv_path)
 {
-	struct rtrs_srv *srv = sess->srv;
+	struct rtrs_srv *srv = srv_path->srv;
 
 	mutex_lock(&srv->paths_mutex);
 	if (!--srv->dev_ref) {
@@ -213,7 +214,7 @@ rtrs_srv_destroy_once_sysfs_root_folders(struct rtrs_srv_sess *sess)
 	}
 }
 
-static void rtrs_srv_sess_stats_release(struct kobject *kobj)
+static void rtrs_srv_path_stats_release(struct kobject *kobj)
 {
 	struct rtrs_srv_stats *stats;
 
@@ -224,22 +225,22 @@ static void rtrs_srv_sess_stats_release(struct kobject *kobj)
 
 static struct kobj_type ktype_stats = {
 	.sysfs_ops = &kobj_sysfs_ops,
-	.release = rtrs_srv_sess_stats_release,
+	.release = rtrs_srv_path_stats_release,
 };
 
-static int rtrs_srv_create_stats_files(struct rtrs_srv_sess *sess)
+static int rtrs_srv_create_stats_files(struct rtrs_srv_path *srv_path)
 {
 	int err;
-	struct rtrs_path *s = &sess->s;
+	struct rtrs_path *s = &srv_path->s;
 
-	err = kobject_init_and_add(&sess->stats->kobj_stats, &ktype_stats,
-				   &sess->kobj, "stats");
+	err = kobject_init_and_add(&srv_path->stats->kobj_stats, &ktype_stats,
+				   &srv_path->kobj, "stats");
 	if (err) {
 		rtrs_err(s, "kobject_init_and_add(): %d\n", err);
-		kobject_put(&sess->stats->kobj_stats);
+		kobject_put(&srv_path->stats->kobj_stats);
 		return err;
 	}
-	err = sysfs_create_group(&sess->stats->kobj_stats,
+	err = sysfs_create_group(&srv_path->stats->kobj_stats,
 				 &rtrs_srv_stats_attr_group);
 	if (err) {
 		rtrs_err(s, "sysfs_create_group(): %d\n", err);
@@ -249,64 +250,64 @@ static int rtrs_srv_create_stats_files(struct rtrs_srv_sess *sess)
 	return 0;
 
 err:
-	kobject_del(&sess->stats->kobj_stats);
-	kobject_put(&sess->stats->kobj_stats);
+	kobject_del(&srv_path->stats->kobj_stats);
+	kobject_put(&srv_path->stats->kobj_stats);
 
 	return err;
 }
 
-int rtrs_srv_create_sess_files(struct rtrs_srv_sess *sess)
+int rtrs_srv_create_path_files(struct rtrs_srv_path *srv_path)
 {
-	struct rtrs_srv *srv = sess->srv;
-	struct rtrs_path *s = &sess->s;
+	struct rtrs_srv *srv = srv_path->srv;
+	struct rtrs_path *s = &srv_path->s;
 	char str[NAME_MAX];
 	int err;
 	struct rtrs_addr path = {
-		.src = &sess->s.dst_addr,
-		.dst = &sess->s.src_addr,
+		.src = &srv_path->s.dst_addr,
+		.dst = &srv_path->s.src_addr,
 	};
 
 	rtrs_addr_to_str(&path, str, sizeof(str));
-	err = rtrs_srv_create_once_sysfs_root_folders(sess);
+	err = rtrs_srv_create_once_sysfs_root_folders(srv_path);
 	if (err)
 		return err;
 
-	err = kobject_init_and_add(&sess->kobj, &ktype, srv->kobj_paths,
+	err = kobject_init_and_add(&srv_path->kobj, &ktype, srv->kobj_paths,
 				   "%s", str);
 	if (err) {
 		rtrs_err(s, "kobject_init_and_add(): %d\n", err);
 		goto destroy_root;
 	}
-	err = sysfs_create_group(&sess->kobj, &rtrs_srv_sess_attr_group);
+	err = sysfs_create_group(&srv_path->kobj, &rtrs_srv_path_attr_group);
 	if (err) {
 		rtrs_err(s, "sysfs_create_group(): %d\n", err);
 		goto put_kobj;
 	}
-	err = rtrs_srv_create_stats_files(sess);
+	err = rtrs_srv_create_stats_files(srv_path);
 	if (err)
 		goto remove_group;
 
 	return 0;
 
 remove_group:
-	sysfs_remove_group(&sess->kobj, &rtrs_srv_sess_attr_group);
+	sysfs_remove_group(&srv_path->kobj, &rtrs_srv_path_attr_group);
 put_kobj:
-	kobject_del(&sess->kobj);
+	kobject_del(&srv_path->kobj);
 destroy_root:
-	kobject_put(&sess->kobj);
-	rtrs_srv_destroy_once_sysfs_root_folders(sess);
+	kobject_put(&srv_path->kobj);
+	rtrs_srv_destroy_once_sysfs_root_folders(srv_path);
 
 	return err;
 }
 
-void rtrs_srv_destroy_sess_files(struct rtrs_srv_sess *sess)
+void rtrs_srv_destroy_path_files(struct rtrs_srv_path *srv_path)
 {
-	if (sess->kobj.state_in_sysfs) {
-		kobject_del(&sess->stats->kobj_stats);
-		kobject_put(&sess->stats->kobj_stats);
-		sysfs_remove_group(&sess->kobj, &rtrs_srv_sess_attr_group);
-		kobject_put(&sess->kobj);
+	if (srv_path->kobj.state_in_sysfs) {
+		kobject_del(&srv_path->stats->kobj_stats);
+		kobject_put(&srv_path->stats->kobj_stats);
+		sysfs_remove_group(&srv_path->kobj, &rtrs_srv_path_attr_group);
+		kobject_put(&srv_path->kobj);
 
-		rtrs_srv_destroy_once_sysfs_root_folders(sess);
+		rtrs_srv_destroy_once_sysfs_root_folders(srv_path);
 	}
 }
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index de4f214233b6..1ca31b919e98 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -62,19 +62,19 @@ static inline struct rtrs_srv_con *to_srv_con(struct rtrs_con *c)
 	return container_of(c, struct rtrs_srv_con, c);
 }
 
-static inline struct rtrs_srv_sess *to_srv_sess(struct rtrs_path *s)
+static inline struct rtrs_srv_path *to_srv_path(struct rtrs_path *s)
 {
-	return container_of(s, struct rtrs_srv_sess, s);
+	return container_of(s, struct rtrs_srv_path, s);
 }
 
-static bool rtrs_srv_change_state(struct rtrs_srv_sess *sess,
+static bool rtrs_srv_change_state(struct rtrs_srv_path *srv_path,
 				  enum rtrs_srv_state new_state)
 {
 	enum rtrs_srv_state old_state;
 	bool changed = false;
 
-	spin_lock_irq(&sess->state_lock);
-	old_state = sess->state;
+	spin_lock_irq(&srv_path->state_lock);
+	old_state = srv_path->state;
 	switch (new_state) {
 	case RTRS_SRV_CONNECTED:
 		if (old_state == RTRS_SRV_CONNECTING)
@@ -93,8 +93,8 @@ static bool rtrs_srv_change_state(struct rtrs_srv_sess *sess,
 		break;
 	}
 	if (changed)
-		sess->state = new_state;
-	spin_unlock_irq(&sess->state_lock);
+		srv_path->state = new_state;
+	spin_unlock_irq(&srv_path->state_lock);
 
 	return changed;
 }
@@ -106,16 +106,16 @@ static void free_id(struct rtrs_srv_op *id)
 	kfree(id);
 }
 
-static void rtrs_srv_free_ops_ids(struct rtrs_srv_sess *sess)
+static void rtrs_srv_free_ops_ids(struct rtrs_srv_path *srv_path)
 {
-	struct rtrs_srv *srv = sess->srv;
+	struct rtrs_srv *srv = srv_path->srv;
 	int i;
 
-	if (sess->ops_ids) {
+	if (srv_path->ops_ids) {
 		for (i = 0; i < srv->queue_depth; i++)
-			free_id(sess->ops_ids[i]);
-		kfree(sess->ops_ids);
-		sess->ops_ids = NULL;
+			free_id(srv_path->ops_ids[i]);
+		kfree(srv_path->ops_ids);
+		srv_path->ops_ids = NULL;
 	}
 }
 
@@ -127,21 +127,24 @@ static struct ib_cqe io_comp_cqe = {
 
 static inline void rtrs_srv_inflight_ref_release(struct percpu_ref *ref)
 {
-	struct rtrs_srv_sess *sess = container_of(ref, struct rtrs_srv_sess, ids_inflight_ref);
+	struct rtrs_srv_path *srv_path = container_of(ref,
+						      struct rtrs_srv_path,
+						      ids_inflight_ref);
 
-	percpu_ref_exit(&sess->ids_inflight_ref);
-	complete(&sess->complete_done);
+	percpu_ref_exit(&srv_path->ids_inflight_ref);
+	complete(&srv_path->complete_done);
 }
 
-static int rtrs_srv_alloc_ops_ids(struct rtrs_srv_sess *sess)
+static int rtrs_srv_alloc_ops_ids(struct rtrs_srv_path *srv_path)
 {
-	struct rtrs_srv *srv = sess->srv;
+	struct rtrs_srv *srv = srv_path->srv;
 	struct rtrs_srv_op *id;
 	int i, ret;
 
-	sess->ops_ids = kcalloc(srv->queue_depth, sizeof(*sess->ops_ids),
-				GFP_KERNEL);
-	if (!sess->ops_ids)
+	srv_path->ops_ids = kcalloc(srv->queue_depth,
+				    sizeof(*srv_path->ops_ids),
+				    GFP_KERNEL);
+	if (!srv_path->ops_ids)
 		goto err;
 
 	for (i = 0; i < srv->queue_depth; ++i) {
@@ -149,44 +152,44 @@ static int rtrs_srv_alloc_ops_ids(struct rtrs_srv_sess *sess)
 		if (!id)
 			goto err;
 
-		sess->ops_ids[i] = id;
+		srv_path->ops_ids[i] = id;
 	}
 
-	ret = percpu_ref_init(&sess->ids_inflight_ref,
+	ret = percpu_ref_init(&srv_path->ids_inflight_ref,
 			      rtrs_srv_inflight_ref_release, 0, GFP_KERNEL);
 	if (ret) {
 		pr_err("Percpu reference init failed\n");
 		goto err;
 	}
-	init_completion(&sess->complete_done);
+	init_completion(&srv_path->complete_done);
 
 	return 0;
 
 err:
-	rtrs_srv_free_ops_ids(sess);
+	rtrs_srv_free_ops_ids(srv_path);
 	return -ENOMEM;
 }
 
-static inline void rtrs_srv_get_ops_ids(struct rtrs_srv_sess *sess)
+static inline void rtrs_srv_get_ops_ids(struct rtrs_srv_path *srv_path)
 {
-	percpu_ref_get(&sess->ids_inflight_ref);
+	percpu_ref_get(&srv_path->ids_inflight_ref);
 }
 
-static inline void rtrs_srv_put_ops_ids(struct rtrs_srv_sess *sess)
+static inline void rtrs_srv_put_ops_ids(struct rtrs_srv_path *srv_path)
 {
-	percpu_ref_put(&sess->ids_inflight_ref);
+	percpu_ref_put(&srv_path->ids_inflight_ref);
 }
 
 static void rtrs_srv_reg_mr_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct rtrs_srv_con *con = to_srv_con(wc->qp->qp_context);
 	struct rtrs_path *s = con->c.path;
-	struct rtrs_srv_sess *sess = to_srv_sess(s);
+	struct rtrs_srv_path *srv_path = to_srv_path(s);
 
 	if (wc->status != IB_WC_SUCCESS) {
 		rtrs_err(s, "REG MR failed: %s\n",
 			  ib_wc_status_msg(wc->status));
-		close_sess(sess);
+		close_path(srv_path);
 		return;
 	}
 }
@@ -198,8 +201,8 @@ static struct ib_cqe local_reg_cqe = {
 static int rdma_write_sg(struct rtrs_srv_op *id)
 {
 	struct rtrs_path *s = id->con->c.path;
-	struct rtrs_srv_sess *sess = to_srv_sess(s);
-	dma_addr_t dma_addr = sess->dma_addr[id->msg_id];
+	struct rtrs_srv_path *srv_path = to_srv_path(s);
+	dma_addr_t dma_addr = srv_path->dma_addr[id->msg_id];
 	struct rtrs_srv_mr *srv_mr;
 	struct ib_send_wr inv_wr;
 	struct ib_rdma_wr imm_wr;
@@ -233,7 +236,7 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 		return -EINVAL;
 	}
 
-	plist->lkey = sess->s.dev->ib_pd->local_dma_lkey;
+	plist->lkey = srv_path->s.dev->ib_pd->local_dma_lkey;
 	offset += plist->length;
 
 	wr->wr.sg_list	= plist;
@@ -284,7 +287,7 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 	if (always_invalidate) {
 		struct rtrs_msg_rkey_rsp *msg;
 
-		srv_mr = &sess->mrs[id->msg_id];
+		srv_mr = &srv_path->mrs[id->msg_id];
 		rwr.wr.opcode = IB_WR_REG_MR;
 		rwr.wr.wr_cqe = &local_reg_cqe;
 		rwr.wr.num_sge = 0;
@@ -300,11 +303,11 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 
 		list.addr   = srv_mr->iu->dma_addr;
 		list.length = sizeof(*msg);
-		list.lkey   = sess->s.dev->ib_pd->local_dma_lkey;
+		list.lkey   = srv_path->s.dev->ib_pd->local_dma_lkey;
 		imm_wr.wr.sg_list = &list;
 		imm_wr.wr.num_sge = 1;
 		imm_wr.wr.opcode = IB_WR_SEND_WITH_IMM;
-		ib_dma_sync_single_for_device(sess->s.dev->ib_dev,
+		ib_dma_sync_single_for_device(srv_path->s.dev->ib_dev,
 					      srv_mr->iu->dma_addr,
 					      srv_mr->iu->size, DMA_TO_DEVICE);
 	} else {
@@ -317,7 +320,7 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 							     0, need_inval));
 
 	imm_wr.wr.wr_cqe   = &io_comp_cqe;
-	ib_dma_sync_single_for_device(sess->s.dev->ib_dev, dma_addr,
+	ib_dma_sync_single_for_device(srv_path->s.dev->ib_dev, dma_addr,
 				      offset, DMA_BIDIRECTIONAL);
 
 	err = ib_post_send(id->con->c.qp, &id->tx_wr.wr, NULL);
@@ -342,7 +345,7 @@ static int send_io_resp_imm(struct rtrs_srv_con *con, struct rtrs_srv_op *id,
 			    int errno)
 {
 	struct rtrs_path *s = con->c.path;
-	struct rtrs_srv_sess *sess = to_srv_sess(s);
+	struct rtrs_srv_path *srv_path = to_srv_path(s);
 	struct ib_send_wr inv_wr, *wr = NULL;
 	struct ib_rdma_wr imm_wr;
 	struct ib_reg_wr rwr;
@@ -402,7 +405,7 @@ static int send_io_resp_imm(struct rtrs_srv_con *con, struct rtrs_srv_op *id,
 		struct ib_sge list;
 		struct rtrs_msg_rkey_rsp *msg;
 
-		srv_mr = &sess->mrs[id->msg_id];
+		srv_mr = &srv_path->mrs[id->msg_id];
 		rwr.wr.next = &imm_wr.wr;
 		rwr.wr.opcode = IB_WR_REG_MR;
 		rwr.wr.wr_cqe = &local_reg_cqe;
@@ -419,11 +422,11 @@ static int send_io_resp_imm(struct rtrs_srv_con *con, struct rtrs_srv_op *id,
 
 		list.addr   = srv_mr->iu->dma_addr;
 		list.length = sizeof(*msg);
-		list.lkey   = sess->s.dev->ib_pd->local_dma_lkey;
+		list.lkey   = srv_path->s.dev->ib_pd->local_dma_lkey;
 		imm_wr.wr.sg_list = &list;
 		imm_wr.wr.num_sge = 1;
 		imm_wr.wr.opcode = IB_WR_SEND_WITH_IMM;
-		ib_dma_sync_single_for_device(sess->s.dev->ib_dev,
+		ib_dma_sync_single_for_device(srv_path->s.dev->ib_dev,
 					      srv_mr->iu->dma_addr,
 					      srv_mr->iu->size, DMA_TO_DEVICE);
 	} else {
@@ -444,11 +447,11 @@ static int send_io_resp_imm(struct rtrs_srv_con *con, struct rtrs_srv_op *id,
 	return err;
 }
 
-void close_sess(struct rtrs_srv_sess *sess)
+void close_path(struct rtrs_srv_path *srv_path)
 {
-	if (rtrs_srv_change_state(sess, RTRS_SRV_CLOSING))
-		queue_work(rtrs_wq, &sess->close_work);
-	WARN_ON(sess->state != RTRS_SRV_CLOSING);
+	if (rtrs_srv_change_state(srv_path, RTRS_SRV_CLOSING))
+		queue_work(rtrs_wq, &srv_path->close_work);
+	WARN_ON(srv_path->state != RTRS_SRV_CLOSING);
 }
 
 static inline const char *rtrs_srv_state_str(enum rtrs_srv_state state)
@@ -480,7 +483,7 @@ static inline const char *rtrs_srv_state_str(enum rtrs_srv_state state)
  */
 bool rtrs_srv_resp_rdma(struct rtrs_srv_op *id, int status)
 {
-	struct rtrs_srv_sess *sess;
+	struct rtrs_srv_path *srv_path;
 	struct rtrs_srv_con *con;
 	struct rtrs_path *s;
 	int err;
@@ -490,25 +493,25 @@ bool rtrs_srv_resp_rdma(struct rtrs_srv_op *id, int status)
 
 	con = id->con;
 	s = con->c.path;
-	sess = to_srv_sess(s);
+	srv_path = to_srv_path(s);
 
 	id->status = status;
 
-	if (sess->state != RTRS_SRV_CONNECTED) {
+	if (srv_path->state != RTRS_SRV_CONNECTED) {
 		rtrs_err_rl(s,
-			    "Sending I/O response failed,  session %s is disconnected, sess state %s\n",
-			    kobject_name(&sess->kobj),
-			    rtrs_srv_state_str(sess->state));
+			    "Sending I/O response failed,  server path %s is disconnected, path state %s\n",
+			    kobject_name(&srv_path->kobj),
+			    rtrs_srv_state_str(srv_path->state));
 		goto out;
 	}
 	if (always_invalidate) {
-		struct rtrs_srv_mr *mr = &sess->mrs[id->msg_id];
+		struct rtrs_srv_mr *mr = &srv_path->mrs[id->msg_id];
 
 		ib_update_fast_reg_key(mr->mr, ib_inc_rkey(mr->mr->rkey));
 	}
 	if (atomic_sub_return(1, &con->c.sq_wr_avail) < 0) {
-		rtrs_err(s, "IB send queue full: sess=%s cid=%d\n",
-			 kobject_name(&sess->kobj),
+		rtrs_err(s, "IB send queue full: srv_path=%s cid=%d\n",
+			 kobject_name(&srv_path->kobj),
 			 con->c.cid);
 		atomic_add(1, &con->c.sq_wr_avail);
 		spin_lock(&con->rsp_wr_wait_lock);
@@ -523,12 +526,12 @@ bool rtrs_srv_resp_rdma(struct rtrs_srv_op *id, int status)
 		err = rdma_write_sg(id);
 
 	if (err) {
-		rtrs_err_rl(s, "IO response failed: %d: sess=%s\n", err,
-			    kobject_name(&sess->kobj));
-		close_sess(sess);
+		rtrs_err_rl(s, "IO response failed: %d: srv_path=%s\n", err,
+			    kobject_name(&srv_path->kobj));
+		close_path(srv_path);
 	}
 out:
-	rtrs_srv_put_ops_ids(sess);
+	rtrs_srv_put_ops_ids(srv_path);
 	return true;
 }
 EXPORT_SYMBOL(rtrs_srv_resp_rdma);
@@ -544,27 +547,27 @@ void rtrs_srv_set_sess_priv(struct rtrs_srv *srv, void *priv)
 }
 EXPORT_SYMBOL(rtrs_srv_set_sess_priv);
 
-static void unmap_cont_bufs(struct rtrs_srv_sess *sess)
+static void unmap_cont_bufs(struct rtrs_srv_path *srv_path)
 {
 	int i;
 
-	for (i = 0; i < sess->mrs_num; i++) {
+	for (i = 0; i < srv_path->mrs_num; i++) {
 		struct rtrs_srv_mr *srv_mr;
 
-		srv_mr = &sess->mrs[i];
-		rtrs_iu_free(srv_mr->iu, sess->s.dev->ib_dev, 1);
+		srv_mr = &srv_path->mrs[i];
+		rtrs_iu_free(srv_mr->iu, srv_path->s.dev->ib_dev, 1);
 		ib_dereg_mr(srv_mr->mr);
-		ib_dma_unmap_sg(sess->s.dev->ib_dev, srv_mr->sgt.sgl,
+		ib_dma_unmap_sg(srv_path->s.dev->ib_dev, srv_mr->sgt.sgl,
 				srv_mr->sgt.nents, DMA_BIDIRECTIONAL);
 		sg_free_table(&srv_mr->sgt);
 	}
-	kfree(sess->mrs);
+	kfree(srv_path->mrs);
 }
 
-static int map_cont_bufs(struct rtrs_srv_sess *sess)
+static int map_cont_bufs(struct rtrs_srv_path *srv_path)
 {
-	struct rtrs_srv *srv = sess->srv;
-	struct rtrs_path *ss = &sess->s;
+	struct rtrs_srv *srv = srv_path->srv;
+	struct rtrs_path *ss = &srv_path->s;
 	int i, mri, err, mrs_num;
 	unsigned int chunk_bits;
 	int chunks_per_mr = 1;
@@ -581,19 +584,19 @@ static int map_cont_bufs(struct rtrs_srv_sess *sess)
 		mrs_num = srv->queue_depth;
 	} else {
 		chunks_per_mr =
-			sess->s.dev->ib_dev->attrs.max_fast_reg_page_list_len;
+			srv_path->s.dev->ib_dev->attrs.max_fast_reg_page_list_len;
 		mrs_num = DIV_ROUND_UP(srv->queue_depth, chunks_per_mr);
 		chunks_per_mr = DIV_ROUND_UP(srv->queue_depth, mrs_num);
 	}
 
-	sess->mrs = kcalloc(mrs_num, sizeof(*sess->mrs), GFP_KERNEL);
-	if (!sess->mrs)
+	srv_path->mrs = kcalloc(mrs_num, sizeof(*srv_path->mrs), GFP_KERNEL);
+	if (!srv_path->mrs)
 		return -ENOMEM;
 
-	sess->mrs_num = mrs_num;
+	srv_path->mrs_num = mrs_num;
 
 	for (mri = 0; mri < mrs_num; mri++) {
-		struct rtrs_srv_mr *srv_mr = &sess->mrs[mri];
+		struct rtrs_srv_mr *srv_mr = &srv_path->mrs[mri];
 		struct sg_table *sgt = &srv_mr->sgt;
 		struct scatterlist *s;
 		struct ib_mr *mr;
@@ -612,13 +615,13 @@ static int map_cont_bufs(struct rtrs_srv_sess *sess)
 			sg_set_page(s, srv->chunks[chunks + i],
 				    max_chunk_size, 0);
 
-		nr = ib_dma_map_sg(sess->s.dev->ib_dev, sgt->sgl,
+		nr = ib_dma_map_sg(srv_path->s.dev->ib_dev, sgt->sgl,
 				   sgt->nents, DMA_BIDIRECTIONAL);
 		if (nr < sgt->nents) {
 			err = nr < 0 ? nr : -EINVAL;
 			goto free_sg;
 		}
-		mr = ib_alloc_mr(sess->s.dev->ib_pd, IB_MR_TYPE_MEM_REG,
+		mr = ib_alloc_mr(srv_path->s.dev->ib_pd, IB_MR_TYPE_MEM_REG,
 				 sgt->nents);
 		if (IS_ERR(mr)) {
 			err = PTR_ERR(mr);
@@ -634,7 +637,7 @@ static int map_cont_bufs(struct rtrs_srv_sess *sess)
 		if (always_invalidate) {
 			srv_mr->iu = rtrs_iu_alloc(1,
 					sizeof(struct rtrs_msg_rkey_rsp),
-					GFP_KERNEL, sess->s.dev->ib_dev,
+					GFP_KERNEL, srv_path->s.dev->ib_dev,
 					DMA_TO_DEVICE, rtrs_srv_rdma_done);
 			if (!srv_mr->iu) {
 				err = -ENOMEM;
@@ -644,7 +647,7 @@ static int map_cont_bufs(struct rtrs_srv_sess *sess)
 		}
 		/* Eventually dma addr for each chunk can be cached */
 		for_each_sg(sgt->sgl, s, sgt->orig_nents, i)
-			sess->dma_addr[chunks + i] = sg_dma_address(s);
+			srv_path->dma_addr[chunks + i] = sg_dma_address(s);
 
 		ib_update_fast_reg_key(mr, ib_inc_rkey(mr->rkey));
 		srv_mr->mr = mr;
@@ -652,75 +655,75 @@ static int map_cont_bufs(struct rtrs_srv_sess *sess)
 		continue;
 err:
 		while (mri--) {
-			srv_mr = &sess->mrs[mri];
+			srv_mr = &srv_path->mrs[mri];
 			sgt = &srv_mr->sgt;
 			mr = srv_mr->mr;
-			rtrs_iu_free(srv_mr->iu, sess->s.dev->ib_dev, 1);
+			rtrs_iu_free(srv_mr->iu, srv_path->s.dev->ib_dev, 1);
 dereg_mr:
 			ib_dereg_mr(mr);
 unmap_sg:
-			ib_dma_unmap_sg(sess->s.dev->ib_dev, sgt->sgl,
+			ib_dma_unmap_sg(srv_path->s.dev->ib_dev, sgt->sgl,
 					sgt->nents, DMA_BIDIRECTIONAL);
 free_sg:
 			sg_free_table(sgt);
 		}
-		kfree(sess->mrs);
+		kfree(srv_path->mrs);
 
 		return err;
 	}
 
 	chunk_bits = ilog2(srv->queue_depth - 1) + 1;
-	sess->mem_bits = (MAX_IMM_PAYL_BITS - chunk_bits);
+	srv_path->mem_bits = (MAX_IMM_PAYL_BITS - chunk_bits);
 
 	return 0;
 }
 
 static void rtrs_srv_hb_err_handler(struct rtrs_con *c)
 {
-	close_sess(to_srv_sess(c->path));
+	close_path(to_srv_path(c->path));
 }
 
-static void rtrs_srv_init_hb(struct rtrs_srv_sess *sess)
+static void rtrs_srv_init_hb(struct rtrs_srv_path *srv_path)
 {
-	rtrs_init_hb(&sess->s, &io_comp_cqe,
+	rtrs_init_hb(&srv_path->s, &io_comp_cqe,
 		      RTRS_HB_INTERVAL_MS,
 		      RTRS_HB_MISSED_MAX,
 		      rtrs_srv_hb_err_handler,
 		      rtrs_wq);
 }
 
-static void rtrs_srv_start_hb(struct rtrs_srv_sess *sess)
+static void rtrs_srv_start_hb(struct rtrs_srv_path *srv_path)
 {
-	rtrs_start_hb(&sess->s);
+	rtrs_start_hb(&srv_path->s);
 }
 
-static void rtrs_srv_stop_hb(struct rtrs_srv_sess *sess)
+static void rtrs_srv_stop_hb(struct rtrs_srv_path *srv_path)
 {
-	rtrs_stop_hb(&sess->s);
+	rtrs_stop_hb(&srv_path->s);
 }
 
 static void rtrs_srv_info_rsp_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct rtrs_srv_con *con = to_srv_con(wc->qp->qp_context);
 	struct rtrs_path *s = con->c.path;
-	struct rtrs_srv_sess *sess = to_srv_sess(s);
+	struct rtrs_srv_path *srv_path = to_srv_path(s);
 	struct rtrs_iu *iu;
 
 	iu = container_of(wc->wr_cqe, struct rtrs_iu, cqe);
-	rtrs_iu_free(iu, sess->s.dev->ib_dev, 1);
+	rtrs_iu_free(iu, srv_path->s.dev->ib_dev, 1);
 
 	if (wc->status != IB_WC_SUCCESS) {
 		rtrs_err(s, "Sess info response send failed: %s\n",
 			  ib_wc_status_msg(wc->status));
-		close_sess(sess);
+		close_path(srv_path);
 		return;
 	}
 	WARN_ON(wc->opcode != IB_WC_SEND);
 }
 
-static void rtrs_srv_sess_up(struct rtrs_srv_sess *sess)
+static void rtrs_srv_path_up(struct rtrs_srv_path *srv_path)
 {
-	struct rtrs_srv *srv = sess->srv;
+	struct rtrs_srv *srv = srv_path->srv;
 	struct rtrs_srv_ctx *ctx = srv->ctx;
 	int up;
 
@@ -731,18 +734,18 @@ static void rtrs_srv_sess_up(struct rtrs_srv_sess *sess)
 	mutex_unlock(&srv->paths_ev_mutex);
 
 	/* Mark session as established */
-	sess->established = true;
+	srv_path->established = true;
 }
 
-static void rtrs_srv_sess_down(struct rtrs_srv_sess *sess)
+static void rtrs_srv_path_down(struct rtrs_srv_path *srv_path)
 {
-	struct rtrs_srv *srv = sess->srv;
+	struct rtrs_srv *srv = srv_path->srv;
 	struct rtrs_srv_ctx *ctx = srv->ctx;
 
-	if (!sess->established)
+	if (!srv_path->established)
 		return;
 
-	sess->established = false;
+	srv_path->established = false;
 	mutex_lock(&srv->paths_ev_mutex);
 	WARN_ON(!srv->paths_up);
 	if (--srv->paths_up == 0)
@@ -750,11 +753,11 @@ static void rtrs_srv_sess_down(struct rtrs_srv_sess *sess)
 	mutex_unlock(&srv->paths_ev_mutex);
 }
 
-static bool exist_sessname(struct rtrs_srv_ctx *ctx,
-			   const char *sessname, const uuid_t *path_uuid)
+static bool exist_pathname(struct rtrs_srv_ctx *ctx,
+			   const char *pathname, const uuid_t *path_uuid)
 {
 	struct rtrs_srv *srv;
-	struct rtrs_srv_sess *sess;
+	struct rtrs_srv_path *srv_path;
 	bool found = false;
 
 	mutex_lock(&ctx->srv_mutex);
@@ -767,9 +770,9 @@ static bool exist_sessname(struct rtrs_srv_ctx *ctx,
 			continue;
 		}
 
-		list_for_each_entry(sess, &srv->paths_list, s.entry) {
-			if (strlen(sess->s.sessname) == strlen(sessname) &&
-			    !strcmp(sess->s.sessname, sessname)) {
+		list_for_each_entry(srv_path, &srv->paths_list, s.entry) {
+			if (strlen(srv_path->s.sessname) == strlen(pathname) &&
+			    !strcmp(srv_path->s.sessname, pathname)) {
 				found = true;
 				break;
 			}
@@ -782,14 +785,14 @@ static bool exist_sessname(struct rtrs_srv_ctx *ctx,
 	return found;
 }
 
-static int post_recv_sess(struct rtrs_srv_sess *sess);
+static int post_recv_path(struct rtrs_srv_path *srv_path);
 static int rtrs_rdma_do_reject(struct rdma_cm_id *cm_id, int errno);
 
 static int process_info_req(struct rtrs_srv_con *con,
 			    struct rtrs_msg_info_req *msg)
 {
 	struct rtrs_path *s = con->c.path;
-	struct rtrs_srv_sess *sess = to_srv_sess(s);
+	struct rtrs_srv_path *srv_path = to_srv_path(s);
 	struct ib_send_wr *reg_wr = NULL;
 	struct rtrs_msg_info_rsp *rsp;
 	struct rtrs_iu *tx_iu;
@@ -797,31 +800,32 @@ static int process_info_req(struct rtrs_srv_con *con,
 	int mri, err;
 	size_t tx_sz;
 
-	err = post_recv_sess(sess);
+	err = post_recv_path(srv_path);
 	if (err) {
-		rtrs_err(s, "post_recv_sess(), err: %d\n", err);
+		rtrs_err(s, "post_recv_path(), err: %d\n", err);
 		return err;
 	}
 
-	if (strchr(msg->sessname, '/') || strchr(msg->sessname, '.')) {
-		rtrs_err(s, "sessname cannot contain / and .\n");
+	if (strchr(msg->pathname, '/') || strchr(msg->pathname, '.')) {
+		rtrs_err(s, "pathname cannot contain / and .\n");
 		return -EINVAL;
 	}
 
-	if (exist_sessname(sess->srv->ctx,
-			   msg->sessname, &sess->srv->paths_uuid)) {
-		rtrs_err(s, "sessname is duplicated: %s\n", msg->sessname);
+	if (exist_pathname(srv_path->srv->ctx,
+			   msg->pathname, &srv_path->srv->paths_uuid)) {
+		rtrs_err(s, "pathname is duplicated: %s\n", msg->pathname);
 		return -EPERM;
 	}
-	strscpy(sess->s.sessname, msg->sessname, sizeof(sess->s.sessname));
+	strscpy(srv_path->s.sessname, msg->pathname,
+		sizeof(srv_path->s.sessname));
 
-	rwr = kcalloc(sess->mrs_num, sizeof(*rwr), GFP_KERNEL);
+	rwr = kcalloc(srv_path->mrs_num, sizeof(*rwr), GFP_KERNEL);
 	if (!rwr)
 		return -ENOMEM;
 
 	tx_sz  = sizeof(*rsp);
-	tx_sz += sizeof(rsp->desc[0]) * sess->mrs_num;
-	tx_iu = rtrs_iu_alloc(1, tx_sz, GFP_KERNEL, sess->s.dev->ib_dev,
+	tx_sz += sizeof(rsp->desc[0]) * srv_path->mrs_num;
+	tx_iu = rtrs_iu_alloc(1, tx_sz, GFP_KERNEL, srv_path->s.dev->ib_dev,
 			       DMA_TO_DEVICE, rtrs_srv_info_rsp_done);
 	if (!tx_iu) {
 		err = -ENOMEM;
@@ -830,10 +834,10 @@ static int process_info_req(struct rtrs_srv_con *con,
 
 	rsp = tx_iu->buf;
 	rsp->type = cpu_to_le16(RTRS_MSG_INFO_RSP);
-	rsp->sg_cnt = cpu_to_le16(sess->mrs_num);
+	rsp->sg_cnt = cpu_to_le16(srv_path->mrs_num);
 
-	for (mri = 0; mri < sess->mrs_num; mri++) {
-		struct ib_mr *mr = sess->mrs[mri].mr;
+	for (mri = 0; mri < srv_path->mrs_num; mri++) {
+		struct ib_mr *mr = srv_path->mrs[mri].mr;
 
 		rsp->desc[mri].addr = cpu_to_le64(mr->iova);
 		rsp->desc[mri].key  = cpu_to_le32(mr->rkey);
@@ -854,13 +858,13 @@ static int process_info_req(struct rtrs_srv_con *con,
 		reg_wr = &rwr[mri].wr;
 	}
 
-	err = rtrs_srv_create_sess_files(sess);
+	err = rtrs_srv_create_path_files(srv_path);
 	if (err)
 		goto iu_free;
-	kobject_get(&sess->kobj);
-	get_device(&sess->srv->dev);
-	rtrs_srv_change_state(sess, RTRS_SRV_CONNECTED);
-	rtrs_srv_start_hb(sess);
+	kobject_get(&srv_path->kobj);
+	get_device(&srv_path->srv->dev);
+	rtrs_srv_change_state(srv_path, RTRS_SRV_CONNECTED);
+	rtrs_srv_start_hb(srv_path);
 
 	/*
 	 * We do not account number of established connections at the current
@@ -868,9 +872,10 @@ static int process_info_req(struct rtrs_srv_con *con,
 	 * all connections are successfully established.  Thus, simply notify
 	 * listener with a proper event if we are the first path.
 	 */
-	rtrs_srv_sess_up(sess);
+	rtrs_srv_path_up(srv_path);
 
-	ib_dma_sync_single_for_device(sess->s.dev->ib_dev, tx_iu->dma_addr,
+	ib_dma_sync_single_for_device(srv_path->s.dev->ib_dev,
+				      tx_iu->dma_addr,
 				      tx_iu->size, DMA_TO_DEVICE);
 
 	/* Send info response */
@@ -878,7 +883,7 @@ static int process_info_req(struct rtrs_srv_con *con,
 	if (err) {
 		rtrs_err(s, "rtrs_iu_post_send(), err: %d\n", err);
 iu_free:
-		rtrs_iu_free(tx_iu, sess->s.dev->ib_dev, 1);
+		rtrs_iu_free(tx_iu, srv_path->s.dev->ib_dev, 1);
 	}
 rwr_free:
 	kfree(rwr);
@@ -890,7 +895,7 @@ static void rtrs_srv_info_req_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct rtrs_srv_con *con = to_srv_con(wc->qp->qp_context);
 	struct rtrs_path *s = con->c.path;
-	struct rtrs_srv_sess *sess = to_srv_sess(s);
+	struct rtrs_srv_path *srv_path = to_srv_path(s);
 	struct rtrs_msg_info_req *msg;
 	struct rtrs_iu *iu;
 	int err;
@@ -910,7 +915,7 @@ static void rtrs_srv_info_req_done(struct ib_cq *cq, struct ib_wc *wc)
 			  wc->byte_len);
 		goto close;
 	}
-	ib_dma_sync_single_for_cpu(sess->s.dev->ib_dev, iu->dma_addr,
+	ib_dma_sync_single_for_cpu(srv_path->s.dev->ib_dev, iu->dma_addr,
 				   iu->size, DMA_FROM_DEVICE);
 	msg = iu->buf;
 	if (le16_to_cpu(msg->type) != RTRS_MSG_INFO_REQ) {
@@ -923,22 +928,22 @@ static void rtrs_srv_info_req_done(struct ib_cq *cq, struct ib_wc *wc)
 		goto close;
 
 out:
-	rtrs_iu_free(iu, sess->s.dev->ib_dev, 1);
+	rtrs_iu_free(iu, srv_path->s.dev->ib_dev, 1);
 	return;
 close:
-	close_sess(sess);
+	close_path(srv_path);
 	goto out;
 }
 
 static int post_recv_info_req(struct rtrs_srv_con *con)
 {
 	struct rtrs_path *s = con->c.path;
-	struct rtrs_srv_sess *sess = to_srv_sess(s);
+	struct rtrs_srv_path *srv_path = to_srv_path(s);
 	struct rtrs_iu *rx_iu;
 	int err;
 
 	rx_iu = rtrs_iu_alloc(1, sizeof(struct rtrs_msg_info_req),
-			       GFP_KERNEL, sess->s.dev->ib_dev,
+			       GFP_KERNEL, srv_path->s.dev->ib_dev,
 			       DMA_FROM_DEVICE, rtrs_srv_info_req_done);
 	if (!rx_iu)
 		return -ENOMEM;
@@ -946,7 +951,7 @@ static int post_recv_info_req(struct rtrs_srv_con *con)
 	err = rtrs_iu_post_recv(&con->c, rx_iu);
 	if (err) {
 		rtrs_err(s, "rtrs_iu_post_recv(), err: %d\n", err);
-		rtrs_iu_free(rx_iu, sess->s.dev->ib_dev, 1);
+		rtrs_iu_free(rx_iu, srv_path->s.dev->ib_dev, 1);
 		return err;
 	}
 
@@ -966,20 +971,20 @@ static int post_recv_io(struct rtrs_srv_con *con, size_t q_size)
 	return 0;
 }
 
-static int post_recv_sess(struct rtrs_srv_sess *sess)
+static int post_recv_path(struct rtrs_srv_path *srv_path)
 {
-	struct rtrs_srv *srv = sess->srv;
-	struct rtrs_path *s = &sess->s;
+	struct rtrs_srv *srv = srv_path->srv;
+	struct rtrs_path *s = &srv_path->s;
 	size_t q_size;
 	int err, cid;
 
-	for (cid = 0; cid < sess->s.con_num; cid++) {
+	for (cid = 0; cid < srv_path->s.con_num; cid++) {
 		if (cid == 0)
 			q_size = SERVICE_CON_QUEUE_DEPTH;
 		else
 			q_size = srv->queue_depth;
 
-		err = post_recv_io(to_srv_con(sess->s.con[cid]), q_size);
+		err = post_recv_io(to_srv_con(srv_path->s.con[cid]), q_size);
 		if (err) {
 			rtrs_err(s, "post_recv_io(), err: %d\n", err);
 			return err;
@@ -994,8 +999,8 @@ static void process_read(struct rtrs_srv_con *con,
 			 u32 buf_id, u32 off)
 {
 	struct rtrs_path *s = con->c.path;
-	struct rtrs_srv_sess *sess = to_srv_sess(s);
-	struct rtrs_srv *srv = sess->srv;
+	struct rtrs_srv_path *srv_path = to_srv_path(s);
+	struct rtrs_srv *srv = srv_path->srv;
 	struct rtrs_srv_ctx *ctx = srv->ctx;
 	struct rtrs_srv_op *id;
 
@@ -1003,10 +1008,10 @@ static void process_read(struct rtrs_srv_con *con,
 	void *data;
 	int ret;
 
-	if (sess->state != RTRS_SRV_CONNECTED) {
+	if (srv_path->state != RTRS_SRV_CONNECTED) {
 		rtrs_err_rl(s,
 			     "Processing read request failed,  session is disconnected, sess state %s\n",
-			     rtrs_srv_state_str(sess->state));
+			     rtrs_srv_state_str(srv_path->state));
 		return;
 	}
 	if (msg->sg_cnt != 1 && msg->sg_cnt != 0) {
@@ -1014,9 +1019,9 @@ static void process_read(struct rtrs_srv_con *con,
 			    "Processing read request failed, invalid message\n");
 		return;
 	}
-	rtrs_srv_get_ops_ids(sess);
-	rtrs_srv_update_rdma_stats(sess->stats, off, READ);
-	id = sess->ops_ids[buf_id];
+	rtrs_srv_get_ops_ids(srv_path);
+	rtrs_srv_update_rdma_stats(srv_path->stats, off, READ);
+	id = srv_path->ops_ids[buf_id];
 	id->con		= con;
 	id->dir		= READ;
 	id->msg_id	= buf_id;
@@ -1042,9 +1047,9 @@ static void process_read(struct rtrs_srv_con *con,
 		rtrs_err_rl(s,
 			     "Sending err msg for failed RDMA-Write-Req failed, msg_id %d, err: %d\n",
 			     buf_id, ret);
-		close_sess(sess);
+		close_path(srv_path);
 	}
-	rtrs_srv_put_ops_ids(sess);
+	rtrs_srv_put_ops_ids(srv_path);
 }
 
 static void process_write(struct rtrs_srv_con *con,
@@ -1052,8 +1057,8 @@ static void process_write(struct rtrs_srv_con *con,
 			  u32 buf_id, u32 off)
 {
 	struct rtrs_path *s = con->c.path;
-	struct rtrs_srv_sess *sess = to_srv_sess(s);
-	struct rtrs_srv *srv = sess->srv;
+	struct rtrs_srv_path *srv_path = to_srv_path(s);
+	struct rtrs_srv *srv = srv_path->srv;
 	struct rtrs_srv_ctx *ctx = srv->ctx;
 	struct rtrs_srv_op *id;
 
@@ -1061,15 +1066,15 @@ static void process_write(struct rtrs_srv_con *con,
 	void *data;
 	int ret;
 
-	if (sess->state != RTRS_SRV_CONNECTED) {
+	if (srv_path->state != RTRS_SRV_CONNECTED) {
 		rtrs_err_rl(s,
 			     "Processing write request failed,  session is disconnected, sess state %s\n",
-			     rtrs_srv_state_str(sess->state));
+			     rtrs_srv_state_str(srv_path->state));
 		return;
 	}
-	rtrs_srv_get_ops_ids(sess);
-	rtrs_srv_update_rdma_stats(sess->stats, off, WRITE);
-	id = sess->ops_ids[buf_id];
+	rtrs_srv_get_ops_ids(srv_path);
+	rtrs_srv_update_rdma_stats(srv_path->stats, off, WRITE);
+	id = srv_path->ops_ids[buf_id];
 	id->con    = con;
 	id->dir    = WRITE;
 	id->msg_id = buf_id;
@@ -1094,20 +1099,21 @@ static void process_write(struct rtrs_srv_con *con,
 		rtrs_err_rl(s,
 			     "Processing write request failed, sending I/O response failed, msg_id %d, err: %d\n",
 			     buf_id, ret);
-		close_sess(sess);
+		close_path(srv_path);
 	}
-	rtrs_srv_put_ops_ids(sess);
+	rtrs_srv_put_ops_ids(srv_path);
 }
 
 static void process_io_req(struct rtrs_srv_con *con, void *msg,
 			   u32 id, u32 off)
 {
 	struct rtrs_path *s = con->c.path;
-	struct rtrs_srv_sess *sess = to_srv_sess(s);
+	struct rtrs_srv_path *srv_path = to_srv_path(s);
 	struct rtrs_msg_rdma_hdr *hdr;
 	unsigned int type;
 
-	ib_dma_sync_single_for_cpu(sess->s.dev->ib_dev, sess->dma_addr[id],
+	ib_dma_sync_single_for_cpu(srv_path->s.dev->ib_dev,
+				   srv_path->dma_addr[id],
 				   max_chunk_size, DMA_BIDIRECTIONAL);
 	hdr = msg;
 	type = le16_to_cpu(hdr->type);
@@ -1129,7 +1135,7 @@ static void process_io_req(struct rtrs_srv_con *con, void *msg,
 	return;
 
 err:
-	close_sess(sess);
+	close_path(srv_path);
 }
 
 static void rtrs_srv_inv_rkey_done(struct ib_cq *cq, struct ib_wc *wc)
@@ -1138,15 +1144,15 @@ static void rtrs_srv_inv_rkey_done(struct ib_cq *cq, struct ib_wc *wc)
 		container_of(wc->wr_cqe, typeof(*mr), inv_cqe);
 	struct rtrs_srv_con *con = to_srv_con(wc->qp->qp_context);
 	struct rtrs_path *s = con->c.path;
-	struct rtrs_srv_sess *sess = to_srv_sess(s);
-	struct rtrs_srv *srv = sess->srv;
+	struct rtrs_srv_path *srv_path = to_srv_path(s);
+	struct rtrs_srv *srv = srv_path->srv;
 	u32 msg_id, off;
 	void *data;
 
 	if (wc->status != IB_WC_SUCCESS) {
 		rtrs_err(s, "Failed IB_WR_LOCAL_INV: %s\n",
 			  ib_wc_status_msg(wc->status));
-		close_sess(sess);
+		close_path(srv_path);
 	}
 	msg_id = mr->msg_id;
 	off = mr->msg_off;
@@ -1195,8 +1201,8 @@ static void rtrs_srv_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct rtrs_srv_con *con = to_srv_con(wc->qp->qp_context);
 	struct rtrs_path *s = con->c.path;
-	struct rtrs_srv_sess *sess = to_srv_sess(s);
-	struct rtrs_srv *srv = sess->srv;
+	struct rtrs_srv_path *srv_path = to_srv_path(s);
+	struct rtrs_srv *srv = srv_path->srv;
 	u32 imm_type, imm_payload;
 	int err;
 
@@ -1206,7 +1212,7 @@ static void rtrs_srv_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 				  "%s (wr_cqe: %p, type: %d, vendor_err: 0x%x, len: %u)\n",
 				  ib_wc_status_msg(wc->status), wc->wr_cqe,
 				  wc->opcode, wc->vendor_err, wc->byte_len);
-			close_sess(sess);
+			close_path(srv_path);
 		}
 		return;
 	}
@@ -1222,7 +1228,7 @@ static void rtrs_srv_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 		err = rtrs_post_recv_empty(&con->c, &io_comp_cqe);
 		if (err) {
 			rtrs_err(s, "rtrs_post_recv(), err: %d\n", err);
-			close_sess(sess);
+			close_path(srv_path);
 			break;
 		}
 		rtrs_from_imm(be32_to_cpu(wc->ex.imm_data),
@@ -1231,16 +1237,16 @@ static void rtrs_srv_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 			u32 msg_id, off;
 			void *data;
 
-			msg_id = imm_payload >> sess->mem_bits;
-			off = imm_payload & ((1 << sess->mem_bits) - 1);
+			msg_id = imm_payload >> srv_path->mem_bits;
+			off = imm_payload & ((1 << srv_path->mem_bits) - 1);
 			if (msg_id >= srv->queue_depth || off >= max_chunk_size) {
 				rtrs_err(s, "Wrong msg_id %u, off %u\n",
 					  msg_id, off);
-				close_sess(sess);
+				close_path(srv_path);
 				return;
 			}
 			if (always_invalidate) {
-				struct rtrs_srv_mr *mr = &sess->mrs[msg_id];
+				struct rtrs_srv_mr *mr = &srv_path->mrs[msg_id];
 
 				mr->msg_off = off;
 				mr->msg_id = msg_id;
@@ -1248,7 +1254,7 @@ static void rtrs_srv_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 				if (err) {
 					rtrs_err(s, "rtrs_post_recv(), err: %d\n",
 						  err);
-					close_sess(sess);
+					close_path(srv_path);
 					break;
 				}
 			} else {
@@ -1257,10 +1263,10 @@ static void rtrs_srv_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 			}
 		} else if (imm_type == RTRS_HB_MSG_IMM) {
 			WARN_ON(con->c.cid);
-			rtrs_send_hb_ack(&sess->s);
+			rtrs_send_hb_ack(&srv_path->s);
 		} else if (imm_type == RTRS_HB_ACK_IMM) {
 			WARN_ON(con->c.cid);
-			sess->s.hb_missed_cnt = 0;
+			srv_path->s.hb_missed_cnt = 0;
 		} else {
 			rtrs_wrn(s, "Unknown IMM type %u\n", imm_type);
 		}
@@ -1284,22 +1290,23 @@ static void rtrs_srv_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 }
 
 /**
- * rtrs_srv_get_sess_name() - Get rtrs_srv peer hostname.
+ * rtrs_srv_get_path_name() - Get rtrs_srv peer hostname.
  * @srv:	Session
- * @sessname:	Sessname buffer
+ * @pathname:	Pathname buffer
  * @len:	Length of sessname buffer
  */
-int rtrs_srv_get_sess_name(struct rtrs_srv *srv, char *sessname, size_t len)
+int rtrs_srv_get_path_name(struct rtrs_srv *srv, char *pathname,
+			   size_t len)
 {
-	struct rtrs_srv_sess *sess;
+	struct rtrs_srv_path *srv_path;
 	int err = -ENOTCONN;
 
 	mutex_lock(&srv->paths_mutex);
-	list_for_each_entry(sess, &srv->paths_list, s.entry) {
-		if (sess->state != RTRS_SRV_CONNECTED)
+	list_for_each_entry(srv_path, &srv->paths_list, s.entry) {
+		if (srv_path->state != RTRS_SRV_CONNECTED)
 			continue;
-		strscpy(sessname, sess->s.sessname,
-		       min_t(size_t, sizeof(sess->s.sessname), len));
+		strscpy(pathname, srv_path->s.sessname,
+			min_t(size_t, sizeof(srv_path->s.sessname), len));
 		err = 0;
 		break;
 	}
@@ -1307,7 +1314,7 @@ int rtrs_srv_get_sess_name(struct rtrs_srv *srv, char *sessname, size_t len)
 
 	return err;
 }
-EXPORT_SYMBOL(rtrs_srv_get_sess_name);
+EXPORT_SYMBOL(rtrs_srv_get_path_name);
 
 /**
  * rtrs_srv_get_queue_depth() - Get rtrs_srv qdepth.
@@ -1319,22 +1326,22 @@ int rtrs_srv_get_queue_depth(struct rtrs_srv *srv)
 }
 EXPORT_SYMBOL(rtrs_srv_get_queue_depth);
 
-static int find_next_bit_ring(struct rtrs_srv_sess *sess)
+static int find_next_bit_ring(struct rtrs_srv_path *srv_path)
 {
-	struct ib_device *ib_dev = sess->s.dev->ib_dev;
+	struct ib_device *ib_dev = srv_path->s.dev->ib_dev;
 	int v;
 
-	v = cpumask_next(sess->cur_cq_vector, &cq_affinity_mask);
+	v = cpumask_next(srv_path->cur_cq_vector, &cq_affinity_mask);
 	if (v >= nr_cpu_ids || v >= ib_dev->num_comp_vectors)
 		v = cpumask_first(&cq_affinity_mask);
 	return v;
 }
 
-static int rtrs_srv_get_next_cq_vector(struct rtrs_srv_sess *sess)
+static int rtrs_srv_get_next_cq_vector(struct rtrs_srv_path *srv_path)
 {
-	sess->cur_cq_vector = find_next_bit_ring(sess);
+	srv_path->cur_cq_vector = find_next_bit_ring(srv_path);
 
-	return sess->cur_cq_vector;
+	return srv_path->cur_cq_vector;
 }
 
 static void rtrs_srv_dev_release(struct device *dev)
@@ -1439,22 +1446,22 @@ static void put_srv(struct rtrs_srv *srv)
 }
 
 static void __add_path_to_srv(struct rtrs_srv *srv,
-			      struct rtrs_srv_sess *sess)
+			      struct rtrs_srv_path *srv_path)
 {
-	list_add_tail(&sess->s.entry, &srv->paths_list);
+	list_add_tail(&srv_path->s.entry, &srv->paths_list);
 	srv->paths_num++;
 	WARN_ON(srv->paths_num >= MAX_PATHS_NUM);
 }
 
-static void del_path_from_srv(struct rtrs_srv_sess *sess)
+static void del_path_from_srv(struct rtrs_srv_path *srv_path)
 {
-	struct rtrs_srv *srv = sess->srv;
+	struct rtrs_srv *srv = srv_path->srv;
 
 	if (WARN_ON(!srv))
 		return;
 
 	mutex_lock(&srv->paths_mutex);
-	list_del(&sess->s.entry);
+	list_del(&srv_path->s.entry);
 	WARN_ON(!srv->paths_num);
 	srv->paths_num--;
 	mutex_unlock(&srv->paths_mutex);
@@ -1487,44 +1494,44 @@ static int sockaddr_cmp(const struct sockaddr *a, const struct sockaddr *b)
 static bool __is_path_w_addr_exists(struct rtrs_srv *srv,
 				    struct rdma_addr *addr)
 {
-	struct rtrs_srv_sess *sess;
+	struct rtrs_srv_path *srv_path;
 
-	list_for_each_entry(sess, &srv->paths_list, s.entry)
-		if (!sockaddr_cmp((struct sockaddr *)&sess->s.dst_addr,
+	list_for_each_entry(srv_path, &srv->paths_list, s.entry)
+		if (!sockaddr_cmp((struct sockaddr *)&srv_path->s.dst_addr,
 				  (struct sockaddr *)&addr->dst_addr) &&
-		    !sockaddr_cmp((struct sockaddr *)&sess->s.src_addr,
+		    !sockaddr_cmp((struct sockaddr *)&srv_path->s.src_addr,
 				  (struct sockaddr *)&addr->src_addr))
 			return true;
 
 	return false;
 }
 
-static void free_sess(struct rtrs_srv_sess *sess)
+static void free_path(struct rtrs_srv_path *srv_path)
 {
-	if (sess->kobj.state_in_sysfs) {
-		kobject_del(&sess->kobj);
-		kobject_put(&sess->kobj);
+	if (srv_path->kobj.state_in_sysfs) {
+		kobject_del(&srv_path->kobj);
+		kobject_put(&srv_path->kobj);
 	} else {
-		kfree(sess->stats);
-		kfree(sess);
+		kfree(srv_path->stats);
+		kfree(srv_path);
 	}
 }
 
 static void rtrs_srv_close_work(struct work_struct *work)
 {
-	struct rtrs_srv_sess *sess;
+	struct rtrs_srv_path *srv_path;
 	struct rtrs_srv_con *con;
 	int i;
 
-	sess = container_of(work, typeof(*sess), close_work);
+	srv_path = container_of(work, typeof(*srv_path), close_work);
 
-	rtrs_srv_destroy_sess_files(sess);
-	rtrs_srv_stop_hb(sess);
+	rtrs_srv_destroy_path_files(srv_path);
+	rtrs_srv_stop_hb(srv_path);
 
-	for (i = 0; i < sess->s.con_num; i++) {
-		if (!sess->s.con[i])
+	for (i = 0; i < srv_path->s.con_num; i++) {
+		if (!srv_path->s.con[i])
 			continue;
-		con = to_srv_con(sess->s.con[i]);
+		con = to_srv_con(srv_path->s.con[i]);
 		rdma_disconnect(con->c.cm_id);
 		ib_drain_qp(con->c.qp);
 	}
@@ -1533,41 +1540,41 @@ static void rtrs_srv_close_work(struct work_struct *work)
 	 * Degrade ref count to the usual model with a single shared
 	 * atomic_t counter
 	 */
-	percpu_ref_kill(&sess->ids_inflight_ref);
+	percpu_ref_kill(&srv_path->ids_inflight_ref);
 
 	/* Wait for all completion */
-	wait_for_completion(&sess->complete_done);
+	wait_for_completion(&srv_path->complete_done);
 
 	/* Notify upper layer if we are the last path */
-	rtrs_srv_sess_down(sess);
+	rtrs_srv_path_down(srv_path);
 
-	unmap_cont_bufs(sess);
-	rtrs_srv_free_ops_ids(sess);
+	unmap_cont_bufs(srv_path);
+	rtrs_srv_free_ops_ids(srv_path);
 
-	for (i = 0; i < sess->s.con_num; i++) {
-		if (!sess->s.con[i])
+	for (i = 0; i < srv_path->s.con_num; i++) {
+		if (!srv_path->s.con[i])
 			continue;
-		con = to_srv_con(sess->s.con[i]);
+		con = to_srv_con(srv_path->s.con[i]);
 		rtrs_cq_qp_destroy(&con->c);
 		rdma_destroy_id(con->c.cm_id);
 		kfree(con);
 	}
-	rtrs_ib_dev_put(sess->s.dev);
+	rtrs_ib_dev_put(srv_path->s.dev);
 
-	del_path_from_srv(sess);
-	put_srv(sess->srv);
-	sess->srv = NULL;
-	rtrs_srv_change_state(sess, RTRS_SRV_CLOSED);
+	del_path_from_srv(srv_path);
+	put_srv(srv_path->srv);
+	srv_path->srv = NULL;
+	rtrs_srv_change_state(srv_path, RTRS_SRV_CLOSED);
 
-	kfree(sess->dma_addr);
-	kfree(sess->s.con);
-	free_sess(sess);
+	kfree(srv_path->dma_addr);
+	kfree(srv_path->s.con);
+	free_path(srv_path);
 }
 
-static int rtrs_rdma_do_accept(struct rtrs_srv_sess *sess,
+static int rtrs_rdma_do_accept(struct rtrs_srv_path *srv_path,
 			       struct rdma_cm_id *cm_id)
 {
-	struct rtrs_srv *srv = sess->srv;
+	struct rtrs_srv *srv = srv_path->srv;
 	struct rtrs_msg_conn_rsp msg;
 	struct rdma_conn_param param;
 	int err;
@@ -1615,25 +1622,25 @@ static int rtrs_rdma_do_reject(struct rdma_cm_id *cm_id, int errno)
 	return errno;
 }
 
-static struct rtrs_srv_sess *
-__find_sess(struct rtrs_srv *srv, const uuid_t *sess_uuid)
+static struct rtrs_srv_path *
+__find_path(struct rtrs_srv *srv, const uuid_t *sess_uuid)
 {
-	struct rtrs_srv_sess *sess;
+	struct rtrs_srv_path *srv_path;
 
-	list_for_each_entry(sess, &srv->paths_list, s.entry) {
-		if (uuid_equal(&sess->s.uuid, sess_uuid))
-			return sess;
+	list_for_each_entry(srv_path, &srv->paths_list, s.entry) {
+		if (uuid_equal(&srv_path->s.uuid, sess_uuid))
+			return srv_path;
 	}
 
 	return NULL;
 }
 
-static int create_con(struct rtrs_srv_sess *sess,
+static int create_con(struct rtrs_srv_path *srv_path,
 		      struct rdma_cm_id *cm_id,
 		      unsigned int cid)
 {
-	struct rtrs_srv *srv = sess->srv;
-	struct rtrs_path *s = &sess->s;
+	struct rtrs_srv *srv = srv_path->srv;
+	struct rtrs_path *s = &srv_path->s;
 	struct rtrs_srv_con *con;
 
 	u32 cq_num, max_send_wr, max_recv_wr, wr_limit;
@@ -1648,10 +1655,10 @@ static int create_con(struct rtrs_srv_sess *sess,
 	spin_lock_init(&con->rsp_wr_wait_lock);
 	INIT_LIST_HEAD(&con->rsp_wr_wait_list);
 	con->c.cm_id = cm_id;
-	con->c.path = &sess->s;
+	con->c.path = &srv_path->s;
 	con->c.cid = cid;
 	atomic_set(&con->c.wr_cnt, 1);
-	wr_limit = sess->s.dev->ib_dev->attrs.max_qp_wr;
+	wr_limit = srv_path->s.dev->ib_dev->attrs.max_qp_wr;
 
 	if (con->c.cid == 0) {
 		/*
@@ -1684,10 +1691,10 @@ static int create_con(struct rtrs_srv_sess *sess,
 	}
 	cq_num = max_send_wr + max_recv_wr;
 	atomic_set(&con->c.sq_wr_avail, max_send_wr);
-	cq_vector = rtrs_srv_get_next_cq_vector(sess);
+	cq_vector = rtrs_srv_get_next_cq_vector(srv_path);
 
 	/* TODO: SOFTIRQ can be faster, but be careful with softirq context */
-	err = rtrs_cq_qp_create(&sess->s, &con->c, 1, cq_vector, cq_num,
+	err = rtrs_cq_qp_create(&srv_path->s, &con->c, 1, cq_vector, cq_num,
 				 max_send_wr, max_recv_wr,
 				 IB_POLL_WORKQUEUE);
 	if (err) {
@@ -1699,8 +1706,8 @@ static int create_con(struct rtrs_srv_sess *sess,
 		if (err)
 			goto free_cqqp;
 	}
-	WARN_ON(sess->s.con[cid]);
-	sess->s.con[cid] = &con->c;
+	WARN_ON(srv_path->s.con[cid]);
+	srv_path->s.con[cid] = &con->c;
 
 	/*
 	 * Change context from server to current connection.  The other
@@ -1719,13 +1726,13 @@ static int create_con(struct rtrs_srv_sess *sess,
 	return err;
 }
 
-static struct rtrs_srv_sess *__alloc_sess(struct rtrs_srv *srv,
+static struct rtrs_srv_path *__alloc_path(struct rtrs_srv *srv,
 					   struct rdma_cm_id *cm_id,
 					   unsigned int con_num,
 					   unsigned int recon_cnt,
 					   const uuid_t *uuid)
 {
-	struct rtrs_srv_sess *sess;
+	struct rtrs_srv_path *srv_path;
 	int err = -ENOMEM;
 	char str[NAME_MAX];
 	struct rtrs_addr path;
@@ -1739,74 +1746,76 @@ static struct rtrs_srv_sess *__alloc_sess(struct rtrs_srv *srv,
 		pr_err("Path with same addr exists\n");
 		goto err;
 	}
-	sess = kzalloc(sizeof(*sess), GFP_KERNEL);
-	if (!sess)
+	srv_path = kzalloc(sizeof(*srv_path), GFP_KERNEL);
+	if (!srv_path)
 		goto err;
 
-	sess->stats = kzalloc(sizeof(*sess->stats), GFP_KERNEL);
-	if (!sess->stats)
+	srv_path->stats = kzalloc(sizeof(*srv_path->stats), GFP_KERNEL);
+	if (!srv_path->stats)
 		goto err_free_sess;
 
-	sess->stats->sess = sess;
+	srv_path->stats->srv_path = srv_path;
 
-	sess->dma_addr = kcalloc(srv->queue_depth, sizeof(*sess->dma_addr),
-				 GFP_KERNEL);
-	if (!sess->dma_addr)
+	srv_path->dma_addr = kcalloc(srv->queue_depth,
+				     sizeof(*srv_path->dma_addr),
+				     GFP_KERNEL);
+	if (!srv_path->dma_addr)
 		goto err_free_stats;
 
-	sess->s.con = kcalloc(con_num, sizeof(*sess->s.con), GFP_KERNEL);
-	if (!sess->s.con)
+	srv_path->s.con = kcalloc(con_num, sizeof(*srv_path->s.con),
+				  GFP_KERNEL);
+	if (!srv_path->s.con)
 		goto err_free_dma_addr;
 
-	sess->state = RTRS_SRV_CONNECTING;
-	sess->srv = srv;
-	sess->cur_cq_vector = -1;
-	sess->s.dst_addr = cm_id->route.addr.dst_addr;
-	sess->s.src_addr = cm_id->route.addr.src_addr;
+	srv_path->state = RTRS_SRV_CONNECTING;
+	srv_path->srv = srv;
+	srv_path->cur_cq_vector = -1;
+	srv_path->s.dst_addr = cm_id->route.addr.dst_addr;
+	srv_path->s.src_addr = cm_id->route.addr.src_addr;
 
 	/* temporary until receiving session-name from client */
-	path.src = &sess->s.src_addr;
-	path.dst = &sess->s.dst_addr;
+	path.src = &srv_path->s.src_addr;
+	path.dst = &srv_path->s.dst_addr;
 	rtrs_addr_to_str(&path, str, sizeof(str));
-	strscpy(sess->s.sessname, str, sizeof(sess->s.sessname));
-
-	sess->s.con_num = con_num;
-	sess->s.irq_con_num = con_num;
-	sess->s.recon_cnt = recon_cnt;
-	uuid_copy(&sess->s.uuid, uuid);
-	spin_lock_init(&sess->state_lock);
-	INIT_WORK(&sess->close_work, rtrs_srv_close_work);
-	rtrs_srv_init_hb(sess);
-
-	sess->s.dev = rtrs_ib_dev_find_or_add(cm_id->device, &dev_pd);
-	if (!sess->s.dev) {
+	strscpy(srv_path->s.sessname, str, sizeof(srv_path->s.sessname));
+
+	srv_path->s.con_num = con_num;
+	srv_path->s.irq_con_num = con_num;
+	srv_path->s.recon_cnt = recon_cnt;
+	uuid_copy(&srv_path->s.uuid, uuid);
+	spin_lock_init(&srv_path->state_lock);
+	INIT_WORK(&srv_path->close_work, rtrs_srv_close_work);
+	rtrs_srv_init_hb(srv_path);
+
+	srv_path->s.dev = rtrs_ib_dev_find_or_add(cm_id->device, &dev_pd);
+	if (!srv_path->s.dev) {
 		err = -ENOMEM;
 		goto err_free_con;
 	}
-	err = map_cont_bufs(sess);
+	err = map_cont_bufs(srv_path);
 	if (err)
 		goto err_put_dev;
 
-	err = rtrs_srv_alloc_ops_ids(sess);
+	err = rtrs_srv_alloc_ops_ids(srv_path);
 	if (err)
 		goto err_unmap_bufs;
 
-	__add_path_to_srv(srv, sess);
+	__add_path_to_srv(srv, srv_path);
 
-	return sess;
+	return srv_path;
 
 err_unmap_bufs:
-	unmap_cont_bufs(sess);
+	unmap_cont_bufs(srv_path);
 err_put_dev:
-	rtrs_ib_dev_put(sess->s.dev);
+	rtrs_ib_dev_put(srv_path->s.dev);
 err_free_con:
-	kfree(sess->s.con);
+	kfree(srv_path->s.con);
 err_free_dma_addr:
-	kfree(sess->dma_addr);
+	kfree(srv_path->dma_addr);
 err_free_stats:
-	kfree(sess->stats);
+	kfree(srv_path->stats);
 err_free_sess:
-	kfree(sess);
+	kfree(srv_path);
 err:
 	return ERR_PTR(err);
 }
@@ -1816,7 +1825,7 @@ static int rtrs_rdma_connect(struct rdma_cm_id *cm_id,
 			      size_t len)
 {
 	struct rtrs_srv_ctx *ctx = cm_id->context;
-	struct rtrs_srv_sess *sess;
+	struct rtrs_srv_path *srv_path;
 	struct rtrs_srv *srv;
 
 	u16 version, con_num, cid;
@@ -1857,16 +1866,16 @@ static int rtrs_rdma_connect(struct rdma_cm_id *cm_id,
 		goto reject_w_err;
 	}
 	mutex_lock(&srv->paths_mutex);
-	sess = __find_sess(srv, &msg->sess_uuid);
-	if (sess) {
-		struct rtrs_path *s = &sess->s;
+	srv_path = __find_path(srv, &msg->sess_uuid);
+	if (srv_path) {
+		struct rtrs_path *s = &srv_path->s;
 
 		/* Session already holds a reference */
 		put_srv(srv);
 
-		if (sess->state != RTRS_SRV_CONNECTING) {
+		if (srv_path->state != RTRS_SRV_CONNECTING) {
 			rtrs_err(s, "Session in wrong state: %s\n",
-				  rtrs_srv_state_str(sess->state));
+				  rtrs_srv_state_str(srv_path->state));
 			mutex_unlock(&srv->paths_mutex);
 			goto reject_w_err;
 		}
@@ -1886,19 +1895,19 @@ static int rtrs_rdma_connect(struct rdma_cm_id *cm_id,
 			goto reject_w_err;
 		}
 	} else {
-		sess = __alloc_sess(srv, cm_id, con_num, recon_cnt,
+		srv_path = __alloc_path(srv, cm_id, con_num, recon_cnt,
 				    &msg->sess_uuid);
-		if (IS_ERR(sess)) {
+		if (IS_ERR(srv_path)) {
 			mutex_unlock(&srv->paths_mutex);
 			put_srv(srv);
-			err = PTR_ERR(sess);
+			err = PTR_ERR(srv_path);
 			pr_err("RTRS server session allocation failed: %d\n", err);
 			goto reject_w_err;
 		}
 	}
-	err = create_con(sess, cm_id, cid);
+	err = create_con(srv_path, cm_id, cid);
 	if (err) {
-		rtrs_err((&sess->s), "create_con(), error %d\n", err);
+		rtrs_err((&srv_path->s), "create_con(), error %d\n", err);
 		rtrs_rdma_do_reject(cm_id, err);
 		/*
 		 * Since session has other connections we follow normal way
@@ -1907,9 +1916,9 @@ static int rtrs_rdma_connect(struct rdma_cm_id *cm_id,
 		 */
 		goto close_and_return_err;
 	}
-	err = rtrs_rdma_do_accept(sess, cm_id);
+	err = rtrs_rdma_do_accept(srv_path, cm_id);
 	if (err) {
-		rtrs_err((&sess->s), "rtrs_rdma_do_accept(), error %d\n", err);
+		rtrs_err((&srv_path->s), "rtrs_rdma_do_accept(), error %d\n", err);
 		rtrs_rdma_do_reject(cm_id, err);
 		/*
 		 * Since current connection was successfully added to the
@@ -1929,7 +1938,7 @@ static int rtrs_rdma_connect(struct rdma_cm_id *cm_id,
 
 close_and_return_err:
 	mutex_unlock(&srv->paths_mutex);
-	close_sess(sess);
+	close_path(srv_path);
 
 	return err;
 }
@@ -1937,14 +1946,14 @@ static int rtrs_rdma_connect(struct rdma_cm_id *cm_id,
 static int rtrs_srv_rdma_cm_handler(struct rdma_cm_id *cm_id,
 				     struct rdma_cm_event *ev)
 {
-	struct rtrs_srv_sess *sess = NULL;
+	struct rtrs_srv_path *srv_path = NULL;
 	struct rtrs_path *s = NULL;
 
 	if (ev->event != RDMA_CM_EVENT_CONNECT_REQUEST) {
 		struct rtrs_con *c = cm_id->context;
 
 		s = c->path;
-		sess = to_srv_sess(s);
+		srv_path = to_srv_path(s);
 	}
 
 	switch (ev->event) {
@@ -1968,7 +1977,7 @@ static int rtrs_srv_rdma_cm_handler(struct rdma_cm_id *cm_id,
 	case RDMA_CM_EVENT_ADDR_CHANGE:
 	case RDMA_CM_EVENT_TIMEWAIT_EXIT:
 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
-		close_sess(sess);
+		close_path(srv_path);
 		break;
 	default:
 		pr_err("Ignoring unexpected CM event %s, err %d\n",
@@ -2176,13 +2185,13 @@ struct rtrs_srv_ctx *rtrs_srv_open(struct rtrs_srv_ops *ops, u16 port)
 }
 EXPORT_SYMBOL(rtrs_srv_open);
 
-static void close_sessions(struct rtrs_srv *srv)
+static void close_paths(struct rtrs_srv *srv)
 {
-	struct rtrs_srv_sess *sess;
+	struct rtrs_srv_path *srv_path;
 
 	mutex_lock(&srv->paths_mutex);
-	list_for_each_entry(sess, &srv->paths_list, s.entry)
-		close_sess(sess);
+	list_for_each_entry(srv_path, &srv->paths_list, s.entry)
+		close_path(srv_path);
 	mutex_unlock(&srv->paths_mutex);
 }
 
@@ -2192,7 +2201,7 @@ static void close_ctx(struct rtrs_srv_ctx *ctx)
 
 	mutex_lock(&ctx->srv_mutex);
 	list_for_each_entry(srv, &ctx->srv_list, ctx_list)
-		close_sessions(srv);
+		close_paths(srv);
 	mutex_unlock(&ctx->srv_mutex);
 	flush_workqueue(rtrs_wq);
 }
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.h b/drivers/infiniband/ulp/rtrs/rtrs-srv.h
index f0fbd8bf8871..ee3578b9aa01 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.h
@@ -37,7 +37,7 @@ struct rtrs_srv_stats_rdma_stats {
 struct rtrs_srv_stats {
 	struct kobject				kobj_stats;
 	struct rtrs_srv_stats_rdma_stats	rdma_stats;
-	struct rtrs_srv_sess			*sess;
+	struct rtrs_srv_path			*srv_path;
 };
 
 struct rtrs_srv_con {
@@ -71,7 +71,7 @@ struct rtrs_srv_mr {
 	struct rtrs_iu	*iu;		/* send buffer for new rkey msg */
 };
 
-struct rtrs_srv_sess {
+struct rtrs_srv_path {
 	struct rtrs_path	s;
 	struct rtrs_srv	*srv;
 	struct work_struct	close_work;
@@ -125,7 +125,7 @@ struct rtrs_srv_ib_ctx {
 
 extern struct class *rtrs_dev_class;
 
-void close_sess(struct rtrs_srv_sess *sess);
+void close_path(struct rtrs_srv_path *srv_path);
 
 static inline void rtrs_srv_update_rdma_stats(struct rtrs_srv_stats *s,
 					      size_t size, int d)
@@ -143,7 +143,7 @@ ssize_t rtrs_srv_reset_all_help(struct rtrs_srv_stats *stats,
 				 char *page, size_t len);
 
 /* functions which are implemented in rtrs-srv-sysfs.c */
-int rtrs_srv_create_sess_files(struct rtrs_srv_sess *sess);
-void rtrs_srv_destroy_sess_files(struct rtrs_srv_sess *sess);
+int rtrs_srv_create_path_files(struct rtrs_srv_path *srv_path);
+void rtrs_srv_destroy_path_files(struct rtrs_srv_path *srv_path);
 
 #endif /* RTRS_SRV_H */
diff --git a/drivers/infiniband/ulp/rtrs/rtrs.h b/drivers/infiniband/ulp/rtrs/rtrs.h
index 859c79685daf..9da9202fbee5 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs.h
@@ -175,7 +175,8 @@ bool rtrs_srv_resp_rdma(struct rtrs_srv_op *id, int errno);
 
 void rtrs_srv_set_sess_priv(struct rtrs_srv *sess, void *priv);
 
-int rtrs_srv_get_sess_name(struct rtrs_srv *sess, char *sessname, size_t len);
+int rtrs_srv_get_path_name(struct rtrs_srv *sess, char *pathname,
+			   size_t len);
 
 int rtrs_srv_get_queue_depth(struct rtrs_srv *sess);
 
-- 
2.35.1



