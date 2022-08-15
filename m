Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 812D35936AC
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344133AbiHOTTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345123AbiHOTSK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:18:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913553D596;
        Mon, 15 Aug 2022 11:39:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B180B81084;
        Mon, 15 Aug 2022 18:39:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40039C433C1;
        Mon, 15 Aug 2022 18:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588772;
        bh=SiLhXUfK/WppfXJET+Ns4BzruEjYUXQU5bhguteG0oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lpoKSWdXQ62Z4WHY4vt8iOmVkilFuDfpJskV7Xp1pWi8xbYzZfRviNkj1hqJyE0/K
         xMCKOTjreIh4paeT1rXi5pS8qYzklnFKwobWZ7ernAo8MGIg3FunNlYYsN2kUgKTZ1
         lBf3wRPBRpgsChmqc0x6GolZeBMQRWmUdKAHPQoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vaishali Thakkar <vaishali.thakkar@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 509/779] RDMA/rtrs-clt: Rename rtrs_clt_sess to rtrs_clt_path
Date:   Mon, 15 Aug 2022 20:02:33 +0200
Message-Id: <20220815180359.020085034@linuxfoundation.org>
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

[ Upstream commit caa84d95c78f35168847e2ab861a3a7f87033d36 ]

rtrs_clt_sess is used for paths and not sessions on the client side. This
creates confusion so let's rename it to rtrs_clt_path. Also, rename
related variables and functions.

Coccinelle is used to do the transformations for most of the occurrences
and remaining ones were handled manually.

Link: https://lore.kernel.org/r/20220105180708.7774-4-jinpu.wang@ionos.com
Signed-off-by: Vaishali Thakkar <vaishali.thakkar@ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt-stats.c |   8 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c | 123 +--
 drivers/infiniband/ulp/rtrs/rtrs-clt.c       | 997 ++++++++++---------
 drivers/infiniband/ulp/rtrs/rtrs-clt.h       |  20 +-
 drivers/infiniband/ulp/rtrs/rtrs-pri.h       |   2 +-
 drivers/infiniband/ulp/rtrs/rtrs.h           |   4 +-
 6 files changed, 586 insertions(+), 568 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt-stats.c b/drivers/infiniband/ulp/rtrs/rtrs-clt-stats.c
index 40b4d6dd4924..e7b57bdfe3ea 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt-stats.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt-stats.c
@@ -13,8 +13,8 @@
 
 void rtrs_clt_update_wc_stats(struct rtrs_clt_con *con)
 {
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
-	struct rtrs_clt_stats *stats = sess->stats;
+	struct rtrs_clt_path *clt_path = to_clt_path(con->c.path);
+	struct rtrs_clt_stats *stats = clt_path->stats;
 	struct rtrs_clt_stats_pcpu *s;
 	int cpu;
 
@@ -174,8 +174,8 @@ static inline void rtrs_clt_update_rdma_stats(struct rtrs_clt_stats *stats,
 void rtrs_clt_update_all_stats(struct rtrs_clt_io_req *req, int dir)
 {
 	struct rtrs_clt_con *con = req->con;
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
-	struct rtrs_clt_stats *stats = sess->stats;
+	struct rtrs_clt_path *clt_path = to_clt_path(con->c.path);
+	struct rtrs_clt_stats *stats = clt_path->stats;
 	unsigned int len;
 
 	len = req->usr_len + req->data_len;
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c b/drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c
index 4ee592ccf979..dbf9a778c3bd 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c
@@ -16,21 +16,21 @@
 #define MIN_MAX_RECONN_ATT -1
 #define MAX_MAX_RECONN_ATT 9999
 
-static void rtrs_clt_sess_release(struct kobject *kobj)
+static void rtrs_clt_path_release(struct kobject *kobj)
 {
-	struct rtrs_clt_sess *sess;
+	struct rtrs_clt_path *clt_path;
 
-	sess = container_of(kobj, struct rtrs_clt_sess, kobj);
+	clt_path = container_of(kobj, struct rtrs_clt_path, kobj);
 
-	free_sess(sess);
+	free_path(clt_path);
 }
 
 static struct kobj_type ktype_sess = {
 	.sysfs_ops = &kobj_sysfs_ops,
-	.release = rtrs_clt_sess_release
+	.release = rtrs_clt_path_release
 };
 
-static void rtrs_clt_sess_stats_release(struct kobject *kobj)
+static void rtrs_clt_path_stats_release(struct kobject *kobj)
 {
 	struct rtrs_clt_stats *stats;
 
@@ -43,7 +43,7 @@ static void rtrs_clt_sess_stats_release(struct kobject *kobj)
 
 static struct kobj_type ktype_stats = {
 	.sysfs_ops = &kobj_sysfs_ops,
-	.release = rtrs_clt_sess_stats_release,
+	.release = rtrs_clt_path_stats_release,
 };
 
 static ssize_t max_reconnect_attempts_show(struct device *dev,
@@ -197,10 +197,10 @@ static DEVICE_ATTR_RW(add_path);
 static ssize_t rtrs_clt_state_show(struct kobject *kobj,
 				    struct kobj_attribute *attr, char *page)
 {
-	struct rtrs_clt_sess *sess;
+	struct rtrs_clt_path *clt_path;
 
-	sess = container_of(kobj, struct rtrs_clt_sess, kobj);
-	if (sess->state == RTRS_CLT_CONNECTED)
+	clt_path = container_of(kobj, struct rtrs_clt_path, kobj);
+	if (clt_path->state == RTRS_CLT_CONNECTED)
 		return sysfs_emit(page, "connected\n");
 
 	return sysfs_emit(page, "disconnected\n");
@@ -219,16 +219,16 @@ static ssize_t rtrs_clt_reconnect_store(struct kobject *kobj,
 					 struct kobj_attribute *attr,
 					 const char *buf, size_t count)
 {
-	struct rtrs_clt_sess *sess;
+	struct rtrs_clt_path *clt_path;
 	int ret;
 
-	sess = container_of(kobj, struct rtrs_clt_sess, kobj);
+	clt_path = container_of(kobj, struct rtrs_clt_path, kobj);
 	if (!sysfs_streq(buf, "1")) {
-		rtrs_err(sess->clt, "%s: unknown value: '%s'\n",
+		rtrs_err(clt_path->clt, "%s: unknown value: '%s'\n",
 			  attr->attr.name, buf);
 		return -EINVAL;
 	}
-	ret = rtrs_clt_reconnect_from_sysfs(sess);
+	ret = rtrs_clt_reconnect_from_sysfs(clt_path);
 	if (ret)
 		return ret;
 
@@ -249,15 +249,15 @@ static ssize_t rtrs_clt_disconnect_store(struct kobject *kobj,
 					  struct kobj_attribute *attr,
 					  const char *buf, size_t count)
 {
-	struct rtrs_clt_sess *sess;
+	struct rtrs_clt_path *clt_path;
 
-	sess = container_of(kobj, struct rtrs_clt_sess, kobj);
+	clt_path = container_of(kobj, struct rtrs_clt_path, kobj);
 	if (!sysfs_streq(buf, "1")) {
-		rtrs_err(sess->clt, "%s: unknown value: '%s'\n",
+		rtrs_err(clt_path->clt, "%s: unknown value: '%s'\n",
 			  attr->attr.name, buf);
 		return -EINVAL;
 	}
-	rtrs_clt_close_conns(sess, true);
+	rtrs_clt_close_conns(clt_path, true);
 
 	return count;
 }
@@ -276,16 +276,16 @@ static ssize_t rtrs_clt_remove_path_store(struct kobject *kobj,
 					   struct kobj_attribute *attr,
 					   const char *buf, size_t count)
 {
-	struct rtrs_clt_sess *sess;
+	struct rtrs_clt_path *clt_path;
 	int ret;
 
-	sess = container_of(kobj, struct rtrs_clt_sess, kobj);
+	clt_path = container_of(kobj, struct rtrs_clt_path, kobj);
 	if (!sysfs_streq(buf, "1")) {
-		rtrs_err(sess->clt, "%s: unknown value: '%s'\n",
+		rtrs_err(clt_path->clt, "%s: unknown value: '%s'\n",
 			  attr->attr.name, buf);
 		return -EINVAL;
 	}
-	ret = rtrs_clt_remove_path_from_sysfs(sess, &attr->attr);
+	ret = rtrs_clt_remove_path_from_sysfs(clt_path, &attr->attr);
 	if (ret)
 		return ret;
 
@@ -328,11 +328,11 @@ static ssize_t rtrs_clt_hca_port_show(struct kobject *kobj,
 				       struct kobj_attribute *attr,
 				       char *page)
 {
-	struct rtrs_clt_sess *sess;
+	struct rtrs_clt_path *clt_path;
 
-	sess = container_of(kobj, typeof(*sess), kobj);
+	clt_path = container_of(kobj, typeof(*clt_path), kobj);
 
-	return sysfs_emit(page, "%u\n", sess->hca_port);
+	return sysfs_emit(page, "%u\n", clt_path->hca_port);
 }
 
 static struct kobj_attribute rtrs_clt_hca_port_attr =
@@ -342,11 +342,11 @@ static ssize_t rtrs_clt_hca_name_show(struct kobject *kobj,
 				       struct kobj_attribute *attr,
 				       char *page)
 {
-	struct rtrs_clt_sess *sess;
+	struct rtrs_clt_path *clt_path;
 
-	sess = container_of(kobj, struct rtrs_clt_sess, kobj);
+	clt_path = container_of(kobj, struct rtrs_clt_path, kobj);
 
-	return sysfs_emit(page, "%s\n", sess->hca_name);
+	return sysfs_emit(page, "%s\n", clt_path->hca_name);
 }
 
 static struct kobj_attribute rtrs_clt_hca_name_attr =
@@ -356,12 +356,12 @@ static ssize_t rtrs_clt_cur_latency_show(struct kobject *kobj,
 				    struct kobj_attribute *attr,
 				    char *page)
 {
-	struct rtrs_clt_sess *sess;
+	struct rtrs_clt_path *clt_path;
 
-	sess = container_of(kobj, struct rtrs_clt_sess, kobj);
+	clt_path = container_of(kobj, struct rtrs_clt_path, kobj);
 
 	return sysfs_emit(page, "%lld ns\n",
-			  ktime_to_ns(sess->s.hb_cur_latency));
+			  ktime_to_ns(clt_path->s.hb_cur_latency));
 }
 
 static struct kobj_attribute rtrs_clt_cur_latency_attr =
@@ -371,11 +371,11 @@ static ssize_t rtrs_clt_src_addr_show(struct kobject *kobj,
 				       struct kobj_attribute *attr,
 				       char *page)
 {
-	struct rtrs_clt_sess *sess;
+	struct rtrs_clt_path *clt_path;
 	int len;
 
-	sess = container_of(kobj, struct rtrs_clt_sess, kobj);
-	len = sockaddr_to_str((struct sockaddr *)&sess->s.src_addr, page,
+	clt_path = container_of(kobj, struct rtrs_clt_path, kobj);
+	len = sockaddr_to_str((struct sockaddr *)&clt_path->s.src_addr, page,
 			      PAGE_SIZE);
 	len += sysfs_emit_at(page, len, "\n");
 	return len;
@@ -388,11 +388,11 @@ static ssize_t rtrs_clt_dst_addr_show(struct kobject *kobj,
 				       struct kobj_attribute *attr,
 				       char *page)
 {
-	struct rtrs_clt_sess *sess;
+	struct rtrs_clt_path *clt_path;
 	int len;
 
-	sess = container_of(kobj, struct rtrs_clt_sess, kobj);
-	len = sockaddr_to_str((struct sockaddr *)&sess->s.dst_addr, page,
+	clt_path = container_of(kobj, struct rtrs_clt_path, kobj);
+	len = sockaddr_to_str((struct sockaddr *)&clt_path->s.dst_addr, page,
 			      PAGE_SIZE);
 	len += sysfs_emit_at(page, len, "\n");
 	return len;
@@ -401,7 +401,7 @@ static ssize_t rtrs_clt_dst_addr_show(struct kobject *kobj,
 static struct kobj_attribute rtrs_clt_dst_addr_attr =
 	__ATTR(dst_addr, 0444, rtrs_clt_dst_addr_show, NULL);
 
-static struct attribute *rtrs_clt_sess_attrs[] = {
+static struct attribute *rtrs_clt_path_attrs[] = {
 	&rtrs_clt_hca_name_attr.attr,
 	&rtrs_clt_hca_port_attr.attr,
 	&rtrs_clt_src_addr_attr.attr,
@@ -414,42 +414,43 @@ static struct attribute *rtrs_clt_sess_attrs[] = {
 	NULL,
 };
 
-static const struct attribute_group rtrs_clt_sess_attr_group = {
-	.attrs = rtrs_clt_sess_attrs,
+static const struct attribute_group rtrs_clt_path_attr_group = {
+	.attrs = rtrs_clt_path_attrs,
 };
 
-int rtrs_clt_create_sess_files(struct rtrs_clt_sess *sess)
+int rtrs_clt_create_path_files(struct rtrs_clt_path *clt_path)
 {
-	struct rtrs_clt *clt = sess->clt;
+	struct rtrs_clt *clt = clt_path->clt;
 	char str[NAME_MAX];
 	int err;
 	struct rtrs_addr path = {
-		.src = &sess->s.src_addr,
-		.dst = &sess->s.dst_addr,
+		.src = &clt_path->s.src_addr,
+		.dst = &clt_path->s.dst_addr,
 	};
 
 	rtrs_addr_to_str(&path, str, sizeof(str));
-	err = kobject_init_and_add(&sess->kobj, &ktype_sess, clt->kobj_paths,
+	err = kobject_init_and_add(&clt_path->kobj, &ktype_sess,
+				   clt->kobj_paths,
 				   "%s", str);
 	if (err) {
 		pr_err("kobject_init_and_add: %d\n", err);
-		kobject_put(&sess->kobj);
+		kobject_put(&clt_path->kobj);
 		return err;
 	}
-	err = sysfs_create_group(&sess->kobj, &rtrs_clt_sess_attr_group);
+	err = sysfs_create_group(&clt_path->kobj, &rtrs_clt_path_attr_group);
 	if (err) {
 		pr_err("sysfs_create_group(): %d\n", err);
 		goto put_kobj;
 	}
-	err = kobject_init_and_add(&sess->stats->kobj_stats, &ktype_stats,
-				   &sess->kobj, "stats");
+	err = kobject_init_and_add(&clt_path->stats->kobj_stats, &ktype_stats,
+				   &clt_path->kobj, "stats");
 	if (err) {
 		pr_err("kobject_init_and_add: %d\n", err);
-		kobject_put(&sess->stats->kobj_stats);
+		kobject_put(&clt_path->stats->kobj_stats);
 		goto remove_group;
 	}
 
-	err = sysfs_create_group(&sess->stats->kobj_stats,
+	err = sysfs_create_group(&clt_path->stats->kobj_stats,
 				 &rtrs_clt_stats_attr_group);
 	if (err) {
 		pr_err("failed to create stats sysfs group, err: %d\n", err);
@@ -459,25 +460,25 @@ int rtrs_clt_create_sess_files(struct rtrs_clt_sess *sess)
 	return 0;
 
 put_kobj_stats:
-	kobject_del(&sess->stats->kobj_stats);
-	kobject_put(&sess->stats->kobj_stats);
+	kobject_del(&clt_path->stats->kobj_stats);
+	kobject_put(&clt_path->stats->kobj_stats);
 remove_group:
-	sysfs_remove_group(&sess->kobj, &rtrs_clt_sess_attr_group);
+	sysfs_remove_group(&clt_path->kobj, &rtrs_clt_path_attr_group);
 put_kobj:
-	kobject_del(&sess->kobj);
-	kobject_put(&sess->kobj);
+	kobject_del(&clt_path->kobj);
+	kobject_put(&clt_path->kobj);
 
 	return err;
 }
 
-void rtrs_clt_destroy_sess_files(struct rtrs_clt_sess *sess,
+void rtrs_clt_destroy_path_files(struct rtrs_clt_path *clt_path,
 				  const struct attribute *sysfs_self)
 {
-	kobject_del(&sess->stats->kobj_stats);
-	kobject_put(&sess->stats->kobj_stats);
+	kobject_del(&clt_path->stats->kobj_stats);
+	kobject_put(&clt_path->stats->kobj_stats);
 	if (sysfs_self)
-		sysfs_remove_file_self(&sess->kobj, sysfs_self);
-	kobject_del(&sess->kobj);
+		sysfs_remove_file_self(&clt_path->kobj, sysfs_self);
+	kobject_del(&clt_path->kobj);
 }
 
 static struct attribute *rtrs_clt_attrs[] = {
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 5e73127f2adc..a46ef2821e36 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -48,12 +48,12 @@ static struct class *rtrs_clt_dev_class;
 
 static inline bool rtrs_clt_is_connected(const struct rtrs_clt *clt)
 {
-	struct rtrs_clt_sess *sess;
+	struct rtrs_clt_path *clt_path;
 	bool connected = false;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(sess, &clt->paths_list, s.entry)
-		connected |= READ_ONCE(sess->state) == RTRS_CLT_CONNECTED;
+	list_for_each_entry_rcu(clt_path, &clt->paths_list, s.entry)
+		connected |= READ_ONCE(clt_path->state) == RTRS_CLT_CONNECTED;
 	rcu_read_unlock();
 
 	return connected;
@@ -163,29 +163,29 @@ EXPORT_SYMBOL(rtrs_clt_put_permit);
 
 /**
  * rtrs_permit_to_clt_con() - returns RDMA connection pointer by the permit
- * @sess: client session pointer
+ * @clt_path: client path pointer
  * @permit: permit for the allocation of the RDMA buffer
  * Note:
  *     IO connection starts from 1.
  *     0 connection is for user messages.
  */
 static
-struct rtrs_clt_con *rtrs_permit_to_clt_con(struct rtrs_clt_sess *sess,
+struct rtrs_clt_con *rtrs_permit_to_clt_con(struct rtrs_clt_path *clt_path,
 					    struct rtrs_permit *permit)
 {
 	int id = 0;
 
 	if (permit->con_type == RTRS_IO_CON)
-		id = (permit->cpu_id % (sess->s.irq_con_num - 1)) + 1;
+		id = (permit->cpu_id % (clt_path->s.irq_con_num - 1)) + 1;
 
-	return to_clt_con(sess->s.con[id]);
+	return to_clt_con(clt_path->s.con[id]);
 }
 
 /**
  * rtrs_clt_change_state() - change the session state through session state
  * machine.
  *
- * @sess: client session to change the state of.
+ * @clt_path: client path to change the state of.
  * @new_state: state to change to.
  *
  * returns true if sess's state is changed to new state, otherwise return false.
@@ -193,15 +193,15 @@ struct rtrs_clt_con *rtrs_permit_to_clt_con(struct rtrs_clt_sess *sess,
  * Locks:
  * state_wq lock must be hold.
  */
-static bool rtrs_clt_change_state(struct rtrs_clt_sess *sess,
+static bool rtrs_clt_change_state(struct rtrs_clt_path *clt_path,
 				     enum rtrs_clt_state new_state)
 {
 	enum rtrs_clt_state old_state;
 	bool changed = false;
 
-	lockdep_assert_held(&sess->state_wq.lock);
+	lockdep_assert_held(&clt_path->state_wq.lock);
 
-	old_state = sess->state;
+	old_state = clt_path->state;
 	switch (new_state) {
 	case RTRS_CLT_CONNECTING:
 		switch (old_state) {
@@ -275,42 +275,42 @@ static bool rtrs_clt_change_state(struct rtrs_clt_sess *sess,
 		break;
 	}
 	if (changed) {
-		sess->state = new_state;
-		wake_up_locked(&sess->state_wq);
+		clt_path->state = new_state;
+		wake_up_locked(&clt_path->state_wq);
 	}
 
 	return changed;
 }
 
-static bool rtrs_clt_change_state_from_to(struct rtrs_clt_sess *sess,
+static bool rtrs_clt_change_state_from_to(struct rtrs_clt_path *clt_path,
 					   enum rtrs_clt_state old_state,
 					   enum rtrs_clt_state new_state)
 {
 	bool changed = false;
 
-	spin_lock_irq(&sess->state_wq.lock);
-	if (sess->state == old_state)
-		changed = rtrs_clt_change_state(sess, new_state);
-	spin_unlock_irq(&sess->state_wq.lock);
+	spin_lock_irq(&clt_path->state_wq.lock);
+	if (clt_path->state == old_state)
+		changed = rtrs_clt_change_state(clt_path, new_state);
+	spin_unlock_irq(&clt_path->state_wq.lock);
 
 	return changed;
 }
 
 static void rtrs_rdma_error_recovery(struct rtrs_clt_con *con)
 {
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
+	struct rtrs_clt_path *clt_path = to_clt_path(con->c.path);
 
-	if (rtrs_clt_change_state_from_to(sess,
+	if (rtrs_clt_change_state_from_to(clt_path,
 					   RTRS_CLT_CONNECTED,
 					   RTRS_CLT_RECONNECTING)) {
-		struct rtrs_clt *clt = sess->clt;
+		struct rtrs_clt *clt = clt_path->clt;
 		unsigned int delay_ms;
 
 		/*
 		 * Normal scenario, reconnect if we were successfully connected
 		 */
 		delay_ms = clt->reconnect_delay_sec * 1000;
-		queue_delayed_work(rtrs_wq, &sess->reconnect_dwork,
+		queue_delayed_work(rtrs_wq, &clt_path->reconnect_dwork,
 				   msecs_to_jiffies(delay_ms +
 						    prandom_u32() % RTRS_RECONNECT_SEED));
 	} else {
@@ -319,7 +319,7 @@ static void rtrs_rdma_error_recovery(struct rtrs_clt_con *con)
 		 * so notify waiter with error state, waiter is responsible
 		 * for cleaning the rest and reconnect if needed.
 		 */
-		rtrs_clt_change_state_from_to(sess,
+		rtrs_clt_change_state_from_to(clt_path,
 					       RTRS_CLT_CONNECTING,
 					       RTRS_CLT_CONNECTING_ERR);
 	}
@@ -380,14 +380,14 @@ static void complete_rdma_req(struct rtrs_clt_io_req *req, int errno,
 			      bool notify, bool can_wait)
 {
 	struct rtrs_clt_con *con = req->con;
-	struct rtrs_clt_sess *sess;
+	struct rtrs_clt_path *clt_path;
 	int err;
 
 	if (WARN_ON(!req->in_use))
 		return;
 	if (WARN_ON(!req->con))
 		return;
-	sess = to_clt_sess(con->c.path);
+	clt_path = to_clt_path(con->c.path);
 
 	if (req->sg_cnt) {
 		if (req->dir == DMA_FROM_DEVICE && req->need_inv) {
@@ -433,21 +433,21 @@ static void complete_rdma_req(struct rtrs_clt_io_req *req, int errno,
 			if (!refcount_dec_and_test(&req->ref))
 				return;
 		}
-		ib_dma_unmap_sg(sess->s.dev->ib_dev, req->sglist,
+		ib_dma_unmap_sg(clt_path->s.dev->ib_dev, req->sglist,
 				req->sg_cnt, req->dir);
 	}
 	if (!refcount_dec_and_test(&req->ref))
 		return;
 	if (req->mp_policy == MP_POLICY_MIN_INFLIGHT)
-		atomic_dec(&sess->stats->inflight);
+		atomic_dec(&clt_path->stats->inflight);
 
 	req->in_use = false;
 	req->con = NULL;
 
 	if (errno) {
 		rtrs_err_rl(con->c.path, "IO request failed: error=%d path=%s [%s:%u] notify=%d\n",
-			    errno, kobject_name(&sess->kobj), sess->hca_name,
-			    sess->hca_port, notify);
+			    errno, kobject_name(&clt_path->kobj), clt_path->hca_name,
+			    clt_path->hca_port, notify);
 	}
 
 	if (notify)
@@ -459,7 +459,7 @@ static int rtrs_post_send_rdma(struct rtrs_clt_con *con,
 				struct rtrs_rbuf *rbuf, u32 off,
 				u32 imm, struct ib_send_wr *wr)
 {
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
+	struct rtrs_clt_path *clt_path = to_clt_path(con->c.path);
 	enum ib_send_flags flags;
 	struct ib_sge sge;
 
@@ -472,16 +472,17 @@ static int rtrs_post_send_rdma(struct rtrs_clt_con *con,
 	/* user data and user message in the first list element */
 	sge.addr   = req->iu->dma_addr;
 	sge.length = req->sg_size;
-	sge.lkey   = sess->s.dev->ib_pd->local_dma_lkey;
+	sge.lkey   = clt_path->s.dev->ib_pd->local_dma_lkey;
 
 	/*
 	 * From time to time we have to post signalled sends,
 	 * or send queue will fill up and only QP reset can help.
 	 */
-	flags = atomic_inc_return(&con->c.wr_cnt) % sess->s.signal_interval ?
+	flags = atomic_inc_return(&con->c.wr_cnt) % clt_path->s.signal_interval ?
 			0 : IB_SEND_SIGNALED;
 
-	ib_dma_sync_single_for_device(sess->s.dev->ib_dev, req->iu->dma_addr,
+	ib_dma_sync_single_for_device(clt_path->s.dev->ib_dev,
+				      req->iu->dma_addr,
 				      req->sg_size, DMA_TO_DEVICE);
 
 	return rtrs_iu_post_rdma_write_imm(&con->c, req->iu, &sge, 1,
@@ -489,15 +490,15 @@ static int rtrs_post_send_rdma(struct rtrs_clt_con *con,
 					    imm, flags, wr, NULL);
 }
 
-static void process_io_rsp(struct rtrs_clt_sess *sess, u32 msg_id,
+static void process_io_rsp(struct rtrs_clt_path *clt_path, u32 msg_id,
 			   s16 errno, bool w_inval)
 {
 	struct rtrs_clt_io_req *req;
 
-	if (WARN_ON(msg_id >= sess->queue_depth))
+	if (WARN_ON(msg_id >= clt_path->queue_depth))
 		return;
 
-	req = &sess->reqs[msg_id];
+	req = &clt_path->reqs[msg_id];
 	/* Drop need_inv if server responded with send with invalidation */
 	req->need_inv &= !w_inval;
 	complete_rdma_req(req, errno, true, false);
@@ -507,9 +508,9 @@ static void rtrs_clt_recv_done(struct rtrs_clt_con *con, struct ib_wc *wc)
 {
 	struct rtrs_iu *iu;
 	int err;
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
+	struct rtrs_clt_path *clt_path = to_clt_path(con->c.path);
 
-	WARN_ON((sess->flags & RTRS_MSG_NEW_RKEY_F) == 0);
+	WARN_ON((clt_path->flags & RTRS_MSG_NEW_RKEY_F) == 0);
 	iu = container_of(wc->wr_cqe, struct rtrs_iu,
 			  cqe);
 	err = rtrs_iu_post_recv(&con->c, iu);
@@ -521,7 +522,7 @@ static void rtrs_clt_recv_done(struct rtrs_clt_con *con, struct ib_wc *wc)
 
 static void rtrs_clt_rkey_rsp_done(struct rtrs_clt_con *con, struct ib_wc *wc)
 {
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
+	struct rtrs_clt_path *clt_path = to_clt_path(con->c.path);
 	struct rtrs_msg_rkey_rsp *msg;
 	u32 imm_type, imm_payload;
 	bool w_inval = false;
@@ -529,7 +530,7 @@ static void rtrs_clt_rkey_rsp_done(struct rtrs_clt_con *con, struct ib_wc *wc)
 	u32 buf_id;
 	int err;
 
-	WARN_ON((sess->flags & RTRS_MSG_NEW_RKEY_F) == 0);
+	WARN_ON((clt_path->flags & RTRS_MSG_NEW_RKEY_F) == 0);
 
 	iu = container_of(wc->wr_cqe, struct rtrs_iu, cqe);
 
@@ -538,16 +539,17 @@ static void rtrs_clt_rkey_rsp_done(struct rtrs_clt_con *con, struct ib_wc *wc)
 			  wc->byte_len);
 		goto out;
 	}
-	ib_dma_sync_single_for_cpu(sess->s.dev->ib_dev, iu->dma_addr,
+	ib_dma_sync_single_for_cpu(clt_path->s.dev->ib_dev, iu->dma_addr,
 				   iu->size, DMA_FROM_DEVICE);
 	msg = iu->buf;
 	if (le16_to_cpu(msg->type) != RTRS_MSG_RKEY_RSP) {
-		rtrs_err(sess->clt, "rkey response is malformed: type %d\n",
+		rtrs_err(clt_path->clt,
+			  "rkey response is malformed: type %d\n",
 			  le16_to_cpu(msg->type));
 		goto out;
 	}
 	buf_id = le16_to_cpu(msg->buf_id);
-	if (WARN_ON(buf_id >= sess->queue_depth))
+	if (WARN_ON(buf_id >= clt_path->queue_depth))
 		goto out;
 
 	rtrs_from_imm(be32_to_cpu(wc->ex.imm_data), &imm_type, &imm_payload);
@@ -560,10 +562,10 @@ static void rtrs_clt_rkey_rsp_done(struct rtrs_clt_con *con, struct ib_wc *wc)
 
 		if (WARN_ON(buf_id != msg_id))
 			goto out;
-		sess->rbufs[buf_id].rkey = le32_to_cpu(msg->rkey);
-		process_io_rsp(sess, msg_id, err, w_inval);
+		clt_path->rbufs[buf_id].rkey = le32_to_cpu(msg->rkey);
+		process_io_rsp(clt_path, msg_id, err, w_inval);
 	}
-	ib_dma_sync_single_for_device(sess->s.dev->ib_dev, iu->dma_addr,
+	ib_dma_sync_single_for_device(clt_path->s.dev->ib_dev, iu->dma_addr,
 				      iu->size, DMA_FROM_DEVICE);
 	return rtrs_clt_recv_done(con, wc);
 out:
@@ -600,14 +602,14 @@ static int rtrs_post_recv_empty_x2(struct rtrs_con *con, struct ib_cqe *cqe)
 static void rtrs_clt_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct rtrs_clt_con *con = to_clt_con(wc->qp->qp_context);
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
+	struct rtrs_clt_path *clt_path = to_clt_path(con->c.path);
 	u32 imm_type, imm_payload;
 	bool w_inval = false;
 	int err;
 
 	if (wc->status != IB_WC_SUCCESS) {
 		if (wc->status != IB_WC_WR_FLUSH_ERR) {
-			rtrs_err(sess->clt, "RDMA failed: %s\n",
+			rtrs_err(clt_path->clt, "RDMA failed: %s\n",
 				  ib_wc_status_msg(wc->status));
 			rtrs_rdma_error_recovery(con);
 		}
@@ -632,18 +634,18 @@ static void rtrs_clt_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 			w_inval = (imm_type == RTRS_IO_RSP_W_INV_IMM);
 			rtrs_from_io_rsp_imm(imm_payload, &msg_id, &err);
 
-			process_io_rsp(sess, msg_id, err, w_inval);
+			process_io_rsp(clt_path, msg_id, err, w_inval);
 		} else if (imm_type == RTRS_HB_MSG_IMM) {
 			WARN_ON(con->c.cid);
-			rtrs_send_hb_ack(&sess->s);
-			if (sess->flags & RTRS_MSG_NEW_RKEY_F)
+			rtrs_send_hb_ack(&clt_path->s);
+			if (clt_path->flags & RTRS_MSG_NEW_RKEY_F)
 				return  rtrs_clt_recv_done(con, wc);
 		} else if (imm_type == RTRS_HB_ACK_IMM) {
 			WARN_ON(con->c.cid);
-			sess->s.hb_missed_cnt = 0;
-			sess->s.hb_cur_latency =
-				ktime_sub(ktime_get(), sess->s.hb_last_sent);
-			if (sess->flags & RTRS_MSG_NEW_RKEY_F)
+			clt_path->s.hb_missed_cnt = 0;
+			clt_path->s.hb_cur_latency =
+				ktime_sub(ktime_get(), clt_path->s.hb_last_sent);
+			if (clt_path->flags & RTRS_MSG_NEW_RKEY_F)
 				return  rtrs_clt_recv_done(con, wc);
 		} else {
 			rtrs_wrn(con->c.path, "Unknown IMM type %u\n",
@@ -670,7 +672,7 @@ static void rtrs_clt_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 		WARN_ON(!(wc->wc_flags & IB_WC_WITH_INVALIDATE ||
 			  wc->wc_flags & IB_WC_WITH_IMM));
 		WARN_ON(wc->wr_cqe->done != rtrs_clt_rdma_done);
-		if (sess->flags & RTRS_MSG_NEW_RKEY_F) {
+		if (clt_path->flags & RTRS_MSG_NEW_RKEY_F) {
 			if (wc->wc_flags & IB_WC_WITH_INVALIDATE)
 				return  rtrs_clt_recv_done(con, wc);
 
@@ -685,7 +687,7 @@ static void rtrs_clt_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 		break;
 
 	default:
-		rtrs_wrn(sess->clt, "Unexpected WC type: %d\n", wc->opcode);
+		rtrs_wrn(clt_path->clt, "Unexpected WC type: %d\n", wc->opcode);
 		return;
 	}
 }
@@ -693,10 +695,10 @@ static void rtrs_clt_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 static int post_recv_io(struct rtrs_clt_con *con, size_t q_size)
 {
 	int err, i;
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
+	struct rtrs_clt_path *clt_path = to_clt_path(con->c.path);
 
 	for (i = 0; i < q_size; i++) {
-		if (sess->flags & RTRS_MSG_NEW_RKEY_F) {
+		if (clt_path->flags & RTRS_MSG_NEW_RKEY_F) {
 			struct rtrs_iu *iu = &con->rsp_ius[i];
 
 			err = rtrs_iu_post_recv(&con->c, iu);
@@ -710,16 +712,16 @@ static int post_recv_io(struct rtrs_clt_con *con, size_t q_size)
 	return 0;
 }
 
-static int post_recv_sess(struct rtrs_clt_sess *sess)
+static int post_recv_path(struct rtrs_clt_path *clt_path)
 {
 	size_t q_size = 0;
 	int err, cid;
 
-	for (cid = 0; cid < sess->s.con_num; cid++) {
+	for (cid = 0; cid < clt_path->s.con_num; cid++) {
 		if (cid == 0)
 			q_size = SERVICE_CON_QUEUE_DEPTH;
 		else
-			q_size = sess->queue_depth;
+			q_size = clt_path->queue_depth;
 
 		/*
 		 * x2 for RDMA read responses + FR key invalidations,
@@ -727,9 +729,10 @@ static int post_recv_sess(struct rtrs_clt_sess *sess)
 		 */
 		q_size *= 2;
 
-		err = post_recv_io(to_clt_con(sess->s.con[cid]), q_size);
+		err = post_recv_io(to_clt_con(clt_path->s.con[cid]), q_size);
 		if (err) {
-			rtrs_err(sess->clt, "post_recv_io(), err: %d\n", err);
+			rtrs_err(clt_path->clt, "post_recv_io(), err: %d\n",
+				 err);
 			return err;
 		}
 	}
@@ -741,7 +744,7 @@ struct path_it {
 	int i;
 	struct list_head skip_list;
 	struct rtrs_clt *clt;
-	struct rtrs_clt_sess *(*next_path)(struct path_it *it);
+	struct rtrs_clt_path *(*next_path)(struct path_it *it);
 };
 
 /**
@@ -773,10 +776,10 @@ struct path_it {
  * Locks:
  *    rcu_read_lock() must be hold.
  */
-static struct rtrs_clt_sess *get_next_path_rr(struct path_it *it)
+static struct rtrs_clt_path *get_next_path_rr(struct path_it *it)
 {
-	struct rtrs_clt_sess __rcu **ppcpu_path;
-	struct rtrs_clt_sess *path;
+	struct rtrs_clt_path __rcu **ppcpu_path;
+	struct rtrs_clt_path *path;
 	struct rtrs_clt *clt;
 
 	clt = it->clt;
@@ -811,26 +814,26 @@ static struct rtrs_clt_sess *get_next_path_rr(struct path_it *it)
  * Locks:
  *    rcu_read_lock() must be hold.
  */
-static struct rtrs_clt_sess *get_next_path_min_inflight(struct path_it *it)
+static struct rtrs_clt_path *get_next_path_min_inflight(struct path_it *it)
 {
-	struct rtrs_clt_sess *min_path = NULL;
+	struct rtrs_clt_path *min_path = NULL;
 	struct rtrs_clt *clt = it->clt;
-	struct rtrs_clt_sess *sess;
+	struct rtrs_clt_path *clt_path;
 	int min_inflight = INT_MAX;
 	int inflight;
 
-	list_for_each_entry_rcu(sess, &clt->paths_list, s.entry) {
-		if (READ_ONCE(sess->state) != RTRS_CLT_CONNECTED)
+	list_for_each_entry_rcu(clt_path, &clt->paths_list, s.entry) {
+		if (READ_ONCE(clt_path->state) != RTRS_CLT_CONNECTED)
 			continue;
 
-		if (!list_empty(raw_cpu_ptr(sess->mp_skip_entry)))
+		if (!list_empty(raw_cpu_ptr(clt_path->mp_skip_entry)))
 			continue;
 
-		inflight = atomic_read(&sess->stats->inflight);
+		inflight = atomic_read(&clt_path->stats->inflight);
 
 		if (inflight < min_inflight) {
 			min_inflight = inflight;
-			min_path = sess;
+			min_path = clt_path;
 		}
 	}
 
@@ -862,26 +865,26 @@ static struct rtrs_clt_sess *get_next_path_min_inflight(struct path_it *it)
  * Therefore the caller MUST check the returned
  * path is NULL and trigger the IO error.
  */
-static struct rtrs_clt_sess *get_next_path_min_latency(struct path_it *it)
+static struct rtrs_clt_path *get_next_path_min_latency(struct path_it *it)
 {
-	struct rtrs_clt_sess *min_path = NULL;
+	struct rtrs_clt_path *min_path = NULL;
 	struct rtrs_clt *clt = it->clt;
-	struct rtrs_clt_sess *sess;
+	struct rtrs_clt_path *clt_path;
 	ktime_t min_latency = KTIME_MAX;
 	ktime_t latency;
 
-	list_for_each_entry_rcu(sess, &clt->paths_list, s.entry) {
-		if (READ_ONCE(sess->state) != RTRS_CLT_CONNECTED)
+	list_for_each_entry_rcu(clt_path, &clt->paths_list, s.entry) {
+		if (READ_ONCE(clt_path->state) != RTRS_CLT_CONNECTED)
 			continue;
 
-		if (!list_empty(raw_cpu_ptr(sess->mp_skip_entry)))
+		if (!list_empty(raw_cpu_ptr(clt_path->mp_skip_entry)))
 			continue;
 
-		latency = sess->s.hb_cur_latency;
+		latency = clt_path->s.hb_cur_latency;
 
 		if (latency < min_latency) {
 			min_latency = latency;
-			min_path = sess;
+			min_path = clt_path;
 		}
 	}
 
@@ -928,7 +931,7 @@ static inline void path_it_deinit(struct path_it *it)
  * the corresponding buffer of rtrs_iu (req->iu->buf), which later on will
  * also hold the control message of rtrs.
  * @req: an io request holding information about IO.
- * @sess: client session
+ * @clt_path: client path
  * @conf: conformation callback function to notify upper layer.
  * @permit: permit for allocation of RDMA remote buffer
  * @priv: private pointer
@@ -940,7 +943,7 @@ static inline void path_it_deinit(struct path_it *it)
  * @dir: direction of the IO.
  */
 static void rtrs_clt_init_req(struct rtrs_clt_io_req *req,
-			      struct rtrs_clt_sess *sess,
+			      struct rtrs_clt_path *clt_path,
 			      void (*conf)(void *priv, int errno),
 			      struct rtrs_permit *permit, void *priv,
 			      const struct kvec *vec, size_t usr_len,
@@ -958,13 +961,13 @@ static void rtrs_clt_init_req(struct rtrs_clt_io_req *req,
 	req->sg_cnt = sg_cnt;
 	req->priv = priv;
 	req->dir = dir;
-	req->con = rtrs_permit_to_clt_con(sess, permit);
+	req->con = rtrs_permit_to_clt_con(clt_path, permit);
 	req->conf = conf;
 	req->need_inv = false;
 	req->need_inv_comp = false;
 	req->inv_errno = 0;
 	refcount_set(&req->ref, 1);
-	req->mp_policy = sess->clt->mp_policy;
+	req->mp_policy = clt_path->clt->mp_policy;
 
 	iov_iter_kvec(&iter, READ, vec, 1, usr_len);
 	len = _copy_from_iter(req->iu->buf, usr_len, &iter);
@@ -974,7 +977,7 @@ static void rtrs_clt_init_req(struct rtrs_clt_io_req *req,
 }
 
 static struct rtrs_clt_io_req *
-rtrs_clt_get_req(struct rtrs_clt_sess *sess,
+rtrs_clt_get_req(struct rtrs_clt_path *clt_path,
 		 void (*conf)(void *priv, int errno),
 		 struct rtrs_permit *permit, void *priv,
 		 const struct kvec *vec, size_t usr_len,
@@ -983,14 +986,14 @@ rtrs_clt_get_req(struct rtrs_clt_sess *sess,
 {
 	struct rtrs_clt_io_req *req;
 
-	req = &sess->reqs[permit->mem_id];
-	rtrs_clt_init_req(req, sess, conf, permit, priv, vec, usr_len,
+	req = &clt_path->reqs[permit->mem_id];
+	rtrs_clt_init_req(req, clt_path, conf, permit, priv, vec, usr_len,
 			   sg, sg_cnt, data_len, dir);
 	return req;
 }
 
 static struct rtrs_clt_io_req *
-rtrs_clt_get_copy_req(struct rtrs_clt_sess *alive_sess,
+rtrs_clt_get_copy_req(struct rtrs_clt_path *alive_path,
 		       struct rtrs_clt_io_req *fail_req)
 {
 	struct rtrs_clt_io_req *req;
@@ -999,8 +1002,8 @@ rtrs_clt_get_copy_req(struct rtrs_clt_sess *alive_sess,
 		.iov_len  = fail_req->usr_len
 	};
 
-	req = &alive_sess->reqs[fail_req->permit->mem_id];
-	rtrs_clt_init_req(req, alive_sess, fail_req->conf, fail_req->permit,
+	req = &alive_path->reqs[fail_req->permit->mem_id];
+	rtrs_clt_init_req(req, alive_path, fail_req->conf, fail_req->permit,
 			   fail_req->priv, &vec, fail_req->usr_len,
 			   fail_req->sglist, fail_req->sg_cnt,
 			   fail_req->data_len, fail_req->dir);
@@ -1013,7 +1016,7 @@ static int rtrs_post_rdma_write_sg(struct rtrs_clt_con *con,
 				   u32 size, u32 imm, struct ib_send_wr *wr,
 				   struct ib_send_wr *tail)
 {
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
+	struct rtrs_clt_path *clt_path = to_clt_path(con->c.path);
 	struct ib_sge *sge = req->sge;
 	enum ib_send_flags flags;
 	struct scatterlist *sg;
@@ -1033,22 +1036,23 @@ static int rtrs_post_rdma_write_sg(struct rtrs_clt_con *con,
 		for_each_sg(req->sglist, sg, req->sg_cnt, i) {
 			sge[i].addr   = sg_dma_address(sg);
 			sge[i].length = sg_dma_len(sg);
-			sge[i].lkey   = sess->s.dev->ib_pd->local_dma_lkey;
+			sge[i].lkey   = clt_path->s.dev->ib_pd->local_dma_lkey;
 		}
 		num_sge = 1 + req->sg_cnt;
 	}
 	sge[i].addr   = req->iu->dma_addr;
 	sge[i].length = size;
-	sge[i].lkey   = sess->s.dev->ib_pd->local_dma_lkey;
+	sge[i].lkey   = clt_path->s.dev->ib_pd->local_dma_lkey;
 
 	/*
 	 * From time to time we have to post signalled sends,
 	 * or send queue will fill up and only QP reset can help.
 	 */
-	flags = atomic_inc_return(&con->c.wr_cnt) % sess->s.signal_interval ?
+	flags = atomic_inc_return(&con->c.wr_cnt) % clt_path->s.signal_interval ?
 			0 : IB_SEND_SIGNALED;
 
-	ib_dma_sync_single_for_device(sess->s.dev->ib_dev, req->iu->dma_addr,
+	ib_dma_sync_single_for_device(clt_path->s.dev->ib_dev,
+				      req->iu->dma_addr,
 				      size, DMA_TO_DEVICE);
 
 	return rtrs_iu_post_rdma_write_imm(&con->c, req->iu, sge, num_sge,
@@ -1075,7 +1079,7 @@ static int rtrs_clt_write_req(struct rtrs_clt_io_req *req)
 {
 	struct rtrs_clt_con *con = req->con;
 	struct rtrs_path *s = con->c.path;
-	struct rtrs_clt_sess *sess = to_clt_sess(s);
+	struct rtrs_clt_path *clt_path = to_clt_path(s);
 	struct rtrs_msg_rdma_write *msg;
 
 	struct rtrs_rbuf *rbuf;
@@ -1088,13 +1092,13 @@ static int rtrs_clt_write_req(struct rtrs_clt_io_req *req)
 
 	const size_t tsize = sizeof(*msg) + req->data_len + req->usr_len;
 
-	if (tsize > sess->chunk_size) {
+	if (tsize > clt_path->chunk_size) {
 		rtrs_wrn(s, "Write request failed, size too big %zu > %d\n",
-			  tsize, sess->chunk_size);
+			  tsize, clt_path->chunk_size);
 		return -EMSGSIZE;
 	}
 	if (req->sg_cnt) {
-		count = ib_dma_map_sg(sess->s.dev->ib_dev, req->sglist,
+		count = ib_dma_map_sg(clt_path->s.dev->ib_dev, req->sglist,
 				      req->sg_cnt, req->dir);
 		if (!count) {
 			rtrs_wrn(s, "Write request failed, map failed\n");
@@ -1111,7 +1115,7 @@ static int rtrs_clt_write_req(struct rtrs_clt_io_req *req)
 	imm = rtrs_to_io_req_imm(imm);
 	buf_id = req->permit->mem_id;
 	req->sg_size = tsize;
-	rbuf = &sess->rbufs[buf_id];
+	rbuf = &clt_path->rbufs[buf_id];
 
 	if (count) {
 		ret = rtrs_map_sg_fr(req, count);
@@ -1119,7 +1123,7 @@ static int rtrs_clt_write_req(struct rtrs_clt_io_req *req)
 			rtrs_err_rl(s,
 				    "Write request failed, failed to map fast reg. data, err: %d\n",
 				    ret);
-			ib_dma_unmap_sg(sess->s.dev->ib_dev, req->sglist,
+			ib_dma_unmap_sg(clt_path->s.dev->ib_dev, req->sglist,
 					req->sg_cnt, req->dir);
 			return ret;
 		}
@@ -1153,12 +1157,12 @@ static int rtrs_clt_write_req(struct rtrs_clt_io_req *req)
 	if (ret) {
 		rtrs_err_rl(s,
 			    "Write request failed: error=%d path=%s [%s:%u]\n",
-			    ret, kobject_name(&sess->kobj), sess->hca_name,
-			    sess->hca_port);
+			    ret, kobject_name(&clt_path->kobj), clt_path->hca_name,
+			    clt_path->hca_port);
 		if (req->mp_policy == MP_POLICY_MIN_INFLIGHT)
-			atomic_dec(&sess->stats->inflight);
+			atomic_dec(&clt_path->stats->inflight);
 		if (req->sg_cnt)
-			ib_dma_unmap_sg(sess->s.dev->ib_dev, req->sglist,
+			ib_dma_unmap_sg(clt_path->s.dev->ib_dev, req->sglist,
 					req->sg_cnt, req->dir);
 	}
 
@@ -1169,9 +1173,9 @@ static int rtrs_clt_read_req(struct rtrs_clt_io_req *req)
 {
 	struct rtrs_clt_con *con = req->con;
 	struct rtrs_path *s = con->c.path;
-	struct rtrs_clt_sess *sess = to_clt_sess(s);
+	struct rtrs_clt_path *clt_path = to_clt_path(s);
 	struct rtrs_msg_rdma_read *msg;
-	struct rtrs_ib_dev *dev = sess->s.dev;
+	struct rtrs_ib_dev *dev = clt_path->s.dev;
 
 	struct ib_reg_wr rwr;
 	struct ib_send_wr *wr = NULL;
@@ -1181,10 +1185,10 @@ static int rtrs_clt_read_req(struct rtrs_clt_io_req *req)
 
 	const size_t tsize = sizeof(*msg) + req->data_len + req->usr_len;
 
-	if (tsize > sess->chunk_size) {
+	if (tsize > clt_path->chunk_size) {
 		rtrs_wrn(s,
 			  "Read request failed, message size is %zu, bigger than CHUNK_SIZE %d\n",
-			  tsize, sess->chunk_size);
+			  tsize, clt_path->chunk_size);
 		return -EMSGSIZE;
 	}
 
@@ -1254,15 +1258,15 @@ static int rtrs_clt_read_req(struct rtrs_clt_io_req *req)
 	 */
 	rtrs_clt_update_all_stats(req, READ);
 
-	ret = rtrs_post_send_rdma(req->con, req, &sess->rbufs[buf_id],
+	ret = rtrs_post_send_rdma(req->con, req, &clt_path->rbufs[buf_id],
 				   req->data_len, imm, wr);
 	if (ret) {
 		rtrs_err_rl(s,
 			    "Read request failed: error=%d path=%s [%s:%u]\n",
-			    ret, kobject_name(&sess->kobj), sess->hca_name,
-			    sess->hca_port);
+			    ret, kobject_name(&clt_path->kobj), clt_path->hca_name,
+			    clt_path->hca_port);
 		if (req->mp_policy == MP_POLICY_MIN_INFLIGHT)
-			atomic_dec(&sess->stats->inflight);
+			atomic_dec(&clt_path->stats->inflight);
 		req->need_inv = false;
 		if (req->sg_cnt)
 			ib_dma_unmap_sg(dev->ib_dev, req->sglist,
@@ -1280,18 +1284,18 @@ static int rtrs_clt_read_req(struct rtrs_clt_io_req *req)
 static int rtrs_clt_failover_req(struct rtrs_clt *clt,
 				 struct rtrs_clt_io_req *fail_req)
 {
-	struct rtrs_clt_sess *alive_sess;
+	struct rtrs_clt_path *alive_path;
 	struct rtrs_clt_io_req *req;
 	int err = -ECONNABORTED;
 	struct path_it it;
 
 	rcu_read_lock();
 	for (path_it_init(&it, clt);
-	     (alive_sess = it.next_path(&it)) && it.i < it.clt->paths_num;
+	     (alive_path = it.next_path(&it)) && it.i < it.clt->paths_num;
 	     it.i++) {
-		if (READ_ONCE(alive_sess->state) != RTRS_CLT_CONNECTED)
+		if (READ_ONCE(alive_path->state) != RTRS_CLT_CONNECTED)
 			continue;
-		req = rtrs_clt_get_copy_req(alive_sess, fail_req);
+		req = rtrs_clt_get_copy_req(alive_path, fail_req);
 		if (req->dir == DMA_TO_DEVICE)
 			err = rtrs_clt_write_req(req);
 		else
@@ -1301,7 +1305,7 @@ static int rtrs_clt_failover_req(struct rtrs_clt *clt,
 			continue;
 		}
 		/* Success path */
-		rtrs_clt_inc_failover_cnt(alive_sess->stats);
+		rtrs_clt_inc_failover_cnt(alive_path->stats);
 		break;
 	}
 	path_it_deinit(&it);
@@ -1310,16 +1314,16 @@ static int rtrs_clt_failover_req(struct rtrs_clt *clt,
 	return err;
 }
 
-static void fail_all_outstanding_reqs(struct rtrs_clt_sess *sess)
+static void fail_all_outstanding_reqs(struct rtrs_clt_path *clt_path)
 {
-	struct rtrs_clt *clt = sess->clt;
+	struct rtrs_clt *clt = clt_path->clt;
 	struct rtrs_clt_io_req *req;
 	int i, err;
 
-	if (!sess->reqs)
+	if (!clt_path->reqs)
 		return;
-	for (i = 0; i < sess->queue_depth; ++i) {
-		req = &sess->reqs[i];
+	for (i = 0; i < clt_path->queue_depth; ++i) {
+		req = &clt_path->reqs[i];
 		if (!req->in_use)
 			continue;
 
@@ -1337,38 +1341,39 @@ static void fail_all_outstanding_reqs(struct rtrs_clt_sess *sess)
 	}
 }
 
-static void free_sess_reqs(struct rtrs_clt_sess *sess)
+static void free_path_reqs(struct rtrs_clt_path *clt_path)
 {
 	struct rtrs_clt_io_req *req;
 	int i;
 
-	if (!sess->reqs)
+	if (!clt_path->reqs)
 		return;
-	for (i = 0; i < sess->queue_depth; ++i) {
-		req = &sess->reqs[i];
+	for (i = 0; i < clt_path->queue_depth; ++i) {
+		req = &clt_path->reqs[i];
 		if (req->mr)
 			ib_dereg_mr(req->mr);
 		kfree(req->sge);
-		rtrs_iu_free(req->iu, sess->s.dev->ib_dev, 1);
+		rtrs_iu_free(req->iu, clt_path->s.dev->ib_dev, 1);
 	}
-	kfree(sess->reqs);
-	sess->reqs = NULL;
+	kfree(clt_path->reqs);
+	clt_path->reqs = NULL;
 }
 
-static int alloc_sess_reqs(struct rtrs_clt_sess *sess)
+static int alloc_path_reqs(struct rtrs_clt_path *clt_path)
 {
 	struct rtrs_clt_io_req *req;
 	int i, err = -ENOMEM;
 
-	sess->reqs = kcalloc(sess->queue_depth, sizeof(*sess->reqs),
-			     GFP_KERNEL);
-	if (!sess->reqs)
+	clt_path->reqs = kcalloc(clt_path->queue_depth,
+				 sizeof(*clt_path->reqs),
+				 GFP_KERNEL);
+	if (!clt_path->reqs)
 		return -ENOMEM;
 
-	for (i = 0; i < sess->queue_depth; ++i) {
-		req = &sess->reqs[i];
-		req->iu = rtrs_iu_alloc(1, sess->max_hdr_size, GFP_KERNEL,
-					 sess->s.dev->ib_dev,
+	for (i = 0; i < clt_path->queue_depth; ++i) {
+		req = &clt_path->reqs[i];
+		req->iu = rtrs_iu_alloc(1, clt_path->max_hdr_size, GFP_KERNEL,
+					 clt_path->s.dev->ib_dev,
 					 DMA_TO_DEVICE,
 					 rtrs_clt_rdma_done);
 		if (!req->iu)
@@ -1378,13 +1383,14 @@ static int alloc_sess_reqs(struct rtrs_clt_sess *sess)
 		if (!req->sge)
 			goto out;
 
-		req->mr = ib_alloc_mr(sess->s.dev->ib_pd, IB_MR_TYPE_MEM_REG,
-				      sess->max_pages_per_mr);
+		req->mr = ib_alloc_mr(clt_path->s.dev->ib_pd,
+				      IB_MR_TYPE_MEM_REG,
+				      clt_path->max_pages_per_mr);
 		if (IS_ERR(req->mr)) {
 			err = PTR_ERR(req->mr);
 			req->mr = NULL;
-			pr_err("Failed to alloc sess->max_pages_per_mr %d\n",
-			       sess->max_pages_per_mr);
+			pr_err("Failed to alloc clt_path->max_pages_per_mr %d\n",
+			       clt_path->max_pages_per_mr);
 			goto out;
 		}
 
@@ -1394,7 +1400,7 @@ static int alloc_sess_reqs(struct rtrs_clt_sess *sess)
 	return 0;
 
 out:
-	free_sess_reqs(sess);
+	free_path_reqs(clt_path);
 
 	return err;
 }
@@ -1447,13 +1453,13 @@ static void free_permits(struct rtrs_clt *clt)
 	clt->permits = NULL;
 }
 
-static void query_fast_reg_mode(struct rtrs_clt_sess *sess)
+static void query_fast_reg_mode(struct rtrs_clt_path *clt_path)
 {
 	struct ib_device *ib_dev;
 	u64 max_pages_per_mr;
 	int mr_page_shift;
 
-	ib_dev = sess->s.dev->ib_dev;
+	ib_dev = clt_path->s.dev->ib_dev;
 
 	/*
 	 * Use the smallest page size supported by the HCA, down to a
@@ -1463,24 +1469,24 @@ static void query_fast_reg_mode(struct rtrs_clt_sess *sess)
 	mr_page_shift      = max(12, ffs(ib_dev->attrs.page_size_cap) - 1);
 	max_pages_per_mr   = ib_dev->attrs.max_mr_size;
 	do_div(max_pages_per_mr, (1ull << mr_page_shift));
-	sess->max_pages_per_mr =
-		min3(sess->max_pages_per_mr, (u32)max_pages_per_mr,
+	clt_path->max_pages_per_mr =
+		min3(clt_path->max_pages_per_mr, (u32)max_pages_per_mr,
 		     ib_dev->attrs.max_fast_reg_page_list_len);
-	sess->clt->max_segments =
-		min(sess->max_pages_per_mr, sess->clt->max_segments);
+	clt_path->clt->max_segments =
+		min(clt_path->max_pages_per_mr, clt_path->clt->max_segments);
 }
 
-static bool rtrs_clt_change_state_get_old(struct rtrs_clt_sess *sess,
+static bool rtrs_clt_change_state_get_old(struct rtrs_clt_path *clt_path,
 					   enum rtrs_clt_state new_state,
 					   enum rtrs_clt_state *old_state)
 {
 	bool changed;
 
-	spin_lock_irq(&sess->state_wq.lock);
+	spin_lock_irq(&clt_path->state_wq.lock);
 	if (old_state)
-		*old_state = sess->state;
-	changed = rtrs_clt_change_state(sess, new_state);
-	spin_unlock_irq(&sess->state_wq.lock);
+		*old_state = clt_path->state;
+	changed = rtrs_clt_change_state(clt_path, new_state);
+	spin_unlock_irq(&clt_path->state_wq.lock);
 
 	return changed;
 }
@@ -1492,9 +1498,9 @@ static void rtrs_clt_hb_err_handler(struct rtrs_con *c)
 	rtrs_rdma_error_recovery(con);
 }
 
-static void rtrs_clt_init_hb(struct rtrs_clt_sess *sess)
+static void rtrs_clt_init_hb(struct rtrs_clt_path *clt_path)
 {
-	rtrs_init_hb(&sess->s, &io_comp_cqe,
+	rtrs_init_hb(&clt_path->s, &io_comp_cqe,
 		      RTRS_HB_INTERVAL_MS,
 		      RTRS_HB_MISSED_MAX,
 		      rtrs_clt_hb_err_handler,
@@ -1504,17 +1510,17 @@ static void rtrs_clt_init_hb(struct rtrs_clt_sess *sess)
 static void rtrs_clt_reconnect_work(struct work_struct *work);
 static void rtrs_clt_close_work(struct work_struct *work);
 
-static struct rtrs_clt_sess *alloc_sess(struct rtrs_clt *clt,
+static struct rtrs_clt_path *alloc_path(struct rtrs_clt *clt,
 					const struct rtrs_addr *path,
 					size_t con_num, u32 nr_poll_queues)
 {
-	struct rtrs_clt_sess *sess;
+	struct rtrs_clt_path *clt_path;
 	int err = -ENOMEM;
 	int cpu;
 	size_t total_con;
 
-	sess = kzalloc(sizeof(*sess), GFP_KERNEL);
-	if (!sess)
+	clt_path = kzalloc(sizeof(*clt_path), GFP_KERNEL);
+	if (!clt_path)
 		goto err;
 
 	/*
@@ -1522,20 +1528,21 @@ static struct rtrs_clt_sess *alloc_sess(struct rtrs_clt *clt,
 	 * +1: Extra connection for user messages
 	 */
 	total_con = con_num + nr_poll_queues + 1;
-	sess->s.con = kcalloc(total_con, sizeof(*sess->s.con), GFP_KERNEL);
-	if (!sess->s.con)
-		goto err_free_sess;
+	clt_path->s.con = kcalloc(total_con, sizeof(*clt_path->s.con),
+				  GFP_KERNEL);
+	if (!clt_path->s.con)
+		goto err_free_path;
 
-	sess->s.con_num = total_con;
-	sess->s.irq_con_num = con_num + 1;
+	clt_path->s.con_num = total_con;
+	clt_path->s.irq_con_num = con_num + 1;
 
-	sess->stats = kzalloc(sizeof(*sess->stats), GFP_KERNEL);
-	if (!sess->stats)
+	clt_path->stats = kzalloc(sizeof(*clt_path->stats), GFP_KERNEL);
+	if (!clt_path->stats)
 		goto err_free_con;
 
-	mutex_init(&sess->init_mutex);
-	uuid_gen(&sess->s.uuid);
-	memcpy(&sess->s.dst_addr, path->dst,
+	mutex_init(&clt_path->init_mutex);
+	uuid_gen(&clt_path->s.uuid);
+	memcpy(&clt_path->s.dst_addr, path->dst,
 	       rdma_addr_size((struct sockaddr *)path->dst));
 
 	/*
@@ -1544,53 +1551,54 @@ static struct rtrs_clt_sess *alloc_sess(struct rtrs_clt *clt,
 	 * the sess->src_addr will contain only zeros, which is then fine.
 	 */
 	if (path->src)
-		memcpy(&sess->s.src_addr, path->src,
+		memcpy(&clt_path->s.src_addr, path->src,
 		       rdma_addr_size((struct sockaddr *)path->src));
-	strscpy(sess->s.sessname, clt->sessname, sizeof(sess->s.sessname));
-	sess->clt = clt;
-	sess->max_pages_per_mr = RTRS_MAX_SEGMENTS;
-	init_waitqueue_head(&sess->state_wq);
-	sess->state = RTRS_CLT_CONNECTING;
-	atomic_set(&sess->connected_cnt, 0);
-	INIT_WORK(&sess->close_work, rtrs_clt_close_work);
-	INIT_DELAYED_WORK(&sess->reconnect_dwork, rtrs_clt_reconnect_work);
-	rtrs_clt_init_hb(sess);
-
-	sess->mp_skip_entry = alloc_percpu(typeof(*sess->mp_skip_entry));
-	if (!sess->mp_skip_entry)
+	strscpy(clt_path->s.sessname, clt->sessname,
+		sizeof(clt_path->s.sessname));
+	clt_path->clt = clt;
+	clt_path->max_pages_per_mr = RTRS_MAX_SEGMENTS;
+	init_waitqueue_head(&clt_path->state_wq);
+	clt_path->state = RTRS_CLT_CONNECTING;
+	atomic_set(&clt_path->connected_cnt, 0);
+	INIT_WORK(&clt_path->close_work, rtrs_clt_close_work);
+	INIT_DELAYED_WORK(&clt_path->reconnect_dwork, rtrs_clt_reconnect_work);
+	rtrs_clt_init_hb(clt_path);
+
+	clt_path->mp_skip_entry = alloc_percpu(typeof(*clt_path->mp_skip_entry));
+	if (!clt_path->mp_skip_entry)
 		goto err_free_stats;
 
 	for_each_possible_cpu(cpu)
-		INIT_LIST_HEAD(per_cpu_ptr(sess->mp_skip_entry, cpu));
+		INIT_LIST_HEAD(per_cpu_ptr(clt_path->mp_skip_entry, cpu));
 
-	err = rtrs_clt_init_stats(sess->stats);
+	err = rtrs_clt_init_stats(clt_path->stats);
 	if (err)
 		goto err_free_percpu;
 
-	return sess;
+	return clt_path;
 
 err_free_percpu:
-	free_percpu(sess->mp_skip_entry);
+	free_percpu(clt_path->mp_skip_entry);
 err_free_stats:
-	kfree(sess->stats);
+	kfree(clt_path->stats);
 err_free_con:
-	kfree(sess->s.con);
-err_free_sess:
-	kfree(sess);
+	kfree(clt_path->s.con);
+err_free_path:
+	kfree(clt_path);
 err:
 	return ERR_PTR(err);
 }
 
-void free_sess(struct rtrs_clt_sess *sess)
+void free_path(struct rtrs_clt_path *clt_path)
 {
-	free_percpu(sess->mp_skip_entry);
-	mutex_destroy(&sess->init_mutex);
-	kfree(sess->s.con);
-	kfree(sess->rbufs);
-	kfree(sess);
+	free_percpu(clt_path->mp_skip_entry);
+	mutex_destroy(&clt_path->init_mutex);
+	kfree(clt_path->s.con);
+	kfree(clt_path->rbufs);
+	kfree(clt_path);
 }
 
-static int create_con(struct rtrs_clt_sess *sess, unsigned int cid)
+static int create_con(struct rtrs_clt_path *clt_path, unsigned int cid)
 {
 	struct rtrs_clt_con *con;
 
@@ -1601,28 +1609,28 @@ static int create_con(struct rtrs_clt_sess *sess, unsigned int cid)
 	/* Map first two connections to the first CPU */
 	con->cpu  = (cid ? cid - 1 : 0) % nr_cpu_ids;
 	con->c.cid = cid;
-	con->c.path = &sess->s;
+	con->c.path = &clt_path->s;
 	/* Align with srv, init as 1 */
 	atomic_set(&con->c.wr_cnt, 1);
 	mutex_init(&con->con_mutex);
 
-	sess->s.con[cid] = &con->c;
+	clt_path->s.con[cid] = &con->c;
 
 	return 0;
 }
 
 static void destroy_con(struct rtrs_clt_con *con)
 {
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
+	struct rtrs_clt_path *clt_path = to_clt_path(con->c.path);
 
-	sess->s.con[con->c.cid] = NULL;
+	clt_path->s.con[con->c.cid] = NULL;
 	mutex_destroy(&con->con_mutex);
 	kfree(con);
 }
 
 static int create_con_cq_qp(struct rtrs_clt_con *con)
 {
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
+	struct rtrs_clt_path *clt_path = to_clt_path(con->c.path);
 	u32 max_send_wr, max_recv_wr, cq_num, max_send_sge, wr_limit;
 	int err, cq_vector;
 	struct rtrs_msg_rkey_rsp *rsp;
@@ -1631,7 +1639,7 @@ static int create_con_cq_qp(struct rtrs_clt_con *con)
 	if (con->c.cid == 0) {
 		max_send_sge = 1;
 		/* We must be the first here */
-		if (WARN_ON(sess->s.dev))
+		if (WARN_ON(clt_path->s.dev))
 			return -EINVAL;
 
 		/*
@@ -1639,16 +1647,16 @@ static int create_con_cq_qp(struct rtrs_clt_con *con)
 		 * Be careful not to close user connection before ib dev
 		 * is gracefully put.
 		 */
-		sess->s.dev = rtrs_ib_dev_find_or_add(con->c.cm_id->device,
+		clt_path->s.dev = rtrs_ib_dev_find_or_add(con->c.cm_id->device,
 						       &dev_pd);
-		if (!sess->s.dev) {
-			rtrs_wrn(sess->clt,
+		if (!clt_path->s.dev) {
+			rtrs_wrn(clt_path->clt,
 				  "rtrs_ib_dev_find_get_or_add(): no memory\n");
 			return -ENOMEM;
 		}
-		sess->s.dev_ref = 1;
-		query_fast_reg_mode(sess);
-		wr_limit = sess->s.dev->ib_dev->attrs.max_qp_wr;
+		clt_path->s.dev_ref = 1;
+		query_fast_reg_mode(clt_path);
+		wr_limit = clt_path->s.dev->ib_dev->attrs.max_qp_wr;
 		/*
 		 * Two (request + registration) completion for send
 		 * Two for recv if always_invalidate is set on server
@@ -1665,27 +1673,28 @@ static int create_con_cq_qp(struct rtrs_clt_con *con)
 		 * This is always true if user connection (cid == 0) is
 		 * established first.
 		 */
-		if (WARN_ON(!sess->s.dev))
+		if (WARN_ON(!clt_path->s.dev))
 			return -EINVAL;
-		if (WARN_ON(!sess->queue_depth))
+		if (WARN_ON(!clt_path->queue_depth))
 			return -EINVAL;
 
-		wr_limit = sess->s.dev->ib_dev->attrs.max_qp_wr;
+		wr_limit = clt_path->s.dev->ib_dev->attrs.max_qp_wr;
 		/* Shared between connections */
-		sess->s.dev_ref++;
+		clt_path->s.dev_ref++;
 		max_send_wr = min_t(int, wr_limit,
 			      /* QD * (REQ + RSP + FR REGS or INVS) + drain */
-			      sess->queue_depth * 3 + 1);
+			      clt_path->queue_depth * 3 + 1);
 		max_recv_wr = min_t(int, wr_limit,
-			      sess->queue_depth * 3 + 1);
+			      clt_path->queue_depth * 3 + 1);
 		max_send_sge = 2;
 	}
 	atomic_set(&con->c.sq_wr_avail, max_send_wr);
 	cq_num = max_send_wr + max_recv_wr;
 	/* alloc iu to recv new rkey reply when server reports flags set */
-	if (sess->flags & RTRS_MSG_NEW_RKEY_F || con->c.cid == 0) {
+	if (clt_path->flags & RTRS_MSG_NEW_RKEY_F || con->c.cid == 0) {
 		con->rsp_ius = rtrs_iu_alloc(cq_num, sizeof(*rsp),
-					      GFP_KERNEL, sess->s.dev->ib_dev,
+					      GFP_KERNEL,
+					      clt_path->s.dev->ib_dev,
 					      DMA_FROM_DEVICE,
 					      rtrs_clt_rdma_done);
 		if (!con->rsp_ius)
@@ -1693,13 +1702,13 @@ static int create_con_cq_qp(struct rtrs_clt_con *con)
 		con->queue_num = cq_num;
 	}
 	cq_num = max_send_wr + max_recv_wr;
-	cq_vector = con->cpu % sess->s.dev->ib_dev->num_comp_vectors;
-	if (con->c.cid >= sess->s.irq_con_num)
-		err = rtrs_cq_qp_create(&sess->s, &con->c, max_send_sge,
+	cq_vector = con->cpu % clt_path->s.dev->ib_dev->num_comp_vectors;
+	if (con->c.cid >= clt_path->s.irq_con_num)
+		err = rtrs_cq_qp_create(&clt_path->s, &con->c, max_send_sge,
 					cq_vector, cq_num, max_send_wr,
 					max_recv_wr, IB_POLL_DIRECT);
 	else
-		err = rtrs_cq_qp_create(&sess->s, &con->c, max_send_sge,
+		err = rtrs_cq_qp_create(&clt_path->s, &con->c, max_send_sge,
 					cq_vector, cq_num, max_send_wr,
 					max_recv_wr, IB_POLL_SOFTIRQ);
 	/*
@@ -1711,7 +1720,7 @@ static int create_con_cq_qp(struct rtrs_clt_con *con)
 
 static void destroy_con_cq_qp(struct rtrs_clt_con *con)
 {
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
+	struct rtrs_clt_path *clt_path = to_clt_path(con->c.path);
 
 	/*
 	 * Be careful here: destroy_con_cq_qp() can be called even
@@ -1720,13 +1729,14 @@ static void destroy_con_cq_qp(struct rtrs_clt_con *con)
 	lockdep_assert_held(&con->con_mutex);
 	rtrs_cq_qp_destroy(&con->c);
 	if (con->rsp_ius) {
-		rtrs_iu_free(con->rsp_ius, sess->s.dev->ib_dev, con->queue_num);
+		rtrs_iu_free(con->rsp_ius, clt_path->s.dev->ib_dev,
+			     con->queue_num);
 		con->rsp_ius = NULL;
 		con->queue_num = 0;
 	}
-	if (sess->s.dev_ref && !--sess->s.dev_ref) {
-		rtrs_ib_dev_put(sess->s.dev);
-		sess->s.dev = NULL;
+	if (clt_path->s.dev_ref && !--clt_path->s.dev_ref) {
+		rtrs_ib_dev_put(clt_path->s.dev);
+		clt_path->s.dev = NULL;
 	}
 }
 
@@ -1764,8 +1774,8 @@ static int rtrs_rdma_addr_resolved(struct rtrs_clt_con *con)
 
 static int rtrs_rdma_route_resolved(struct rtrs_clt_con *con)
 {
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
-	struct rtrs_clt *clt = sess->clt;
+	struct rtrs_clt_path *clt_path = to_clt_path(con->c.path);
+	struct rtrs_clt *clt = clt_path->clt;
 	struct rtrs_msg_conn_req msg;
 	struct rdma_conn_param param;
 
@@ -1782,11 +1792,11 @@ static int rtrs_rdma_route_resolved(struct rtrs_clt_con *con)
 		.magic = cpu_to_le16(RTRS_MAGIC),
 		.version = cpu_to_le16(RTRS_PROTO_VER),
 		.cid = cpu_to_le16(con->c.cid),
-		.cid_num = cpu_to_le16(sess->s.con_num),
-		.recon_cnt = cpu_to_le16(sess->s.recon_cnt),
+		.cid_num = cpu_to_le16(clt_path->s.con_num),
+		.recon_cnt = cpu_to_le16(clt_path->s.recon_cnt),
 	};
-	msg.first_conn = sess->for_new_clt ? FIRST_CONN : 0;
-	uuid_copy(&msg.sess_uuid, &sess->s.uuid);
+	msg.first_conn = clt_path->for_new_clt ? FIRST_CONN : 0;
+	uuid_copy(&msg.sess_uuid, &clt_path->s.uuid);
 	uuid_copy(&msg.paths_uuid, &clt->paths_uuid);
 
 	err = rdma_connect_locked(con->c.cm_id, &param);
@@ -1799,8 +1809,8 @@ static int rtrs_rdma_route_resolved(struct rtrs_clt_con *con)
 static int rtrs_rdma_conn_established(struct rtrs_clt_con *con,
 				       struct rdma_cm_event *ev)
 {
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
-	struct rtrs_clt *clt = sess->clt;
+	struct rtrs_clt_path *clt_path = to_clt_path(con->c.path);
+	struct rtrs_clt *clt = clt_path->clt;
 	const struct rtrs_msg_conn_rsp *msg;
 	u16 version, queue_depth;
 	int errno;
@@ -1831,31 +1841,32 @@ static int rtrs_rdma_conn_established(struct rtrs_clt_con *con,
 	if (con->c.cid == 0) {
 		queue_depth = le16_to_cpu(msg->queue_depth);
 
-		if (sess->queue_depth > 0 && queue_depth != sess->queue_depth) {
+		if (clt_path->queue_depth > 0 && queue_depth != clt_path->queue_depth) {
 			rtrs_err(clt, "Error: queue depth changed\n");
 
 			/*
 			 * Stop any more reconnection attempts
 			 */
-			sess->reconnect_attempts = -1;
+			clt_path->reconnect_attempts = -1;
 			rtrs_err(clt,
 				"Disabling auto-reconnect. Trigger a manual reconnect after issue is resolved\n");
 			return -ECONNRESET;
 		}
 
-		if (!sess->rbufs) {
-			sess->rbufs = kcalloc(queue_depth, sizeof(*sess->rbufs),
-					      GFP_KERNEL);
-			if (!sess->rbufs)
+		if (!clt_path->rbufs) {
+			clt_path->rbufs = kcalloc(queue_depth,
+						  sizeof(*clt_path->rbufs),
+						  GFP_KERNEL);
+			if (!clt_path->rbufs)
 				return -ENOMEM;
 		}
-		sess->queue_depth = queue_depth;
-		sess->s.signal_interval = min_not_zero(queue_depth,
+		clt_path->queue_depth = queue_depth;
+		clt_path->s.signal_interval = min_not_zero(queue_depth,
 						(unsigned short) SERVICE_CON_QUEUE_DEPTH);
-		sess->max_hdr_size = le32_to_cpu(msg->max_hdr_size);
-		sess->max_io_size = le32_to_cpu(msg->max_io_size);
-		sess->flags = le32_to_cpu(msg->flags);
-		sess->chunk_size = sess->max_io_size + sess->max_hdr_size;
+		clt_path->max_hdr_size = le32_to_cpu(msg->max_hdr_size);
+		clt_path->max_io_size = le32_to_cpu(msg->max_io_size);
+		clt_path->flags = le32_to_cpu(msg->flags);
+		clt_path->chunk_size = clt_path->max_io_size + clt_path->max_hdr_size;
 
 		/*
 		 * Global IO size is always a minimum.
@@ -1866,20 +1877,20 @@ static int rtrs_rdma_conn_established(struct rtrs_clt_con *con,
 		 * connections in parallel, use lock.
 		 */
 		mutex_lock(&clt->paths_mutex);
-		clt->queue_depth = sess->queue_depth;
-		clt->max_io_size = min_not_zero(sess->max_io_size,
+		clt->queue_depth = clt_path->queue_depth;
+		clt->max_io_size = min_not_zero(clt_path->max_io_size,
 						clt->max_io_size);
 		mutex_unlock(&clt->paths_mutex);
 
 		/*
 		 * Cache the hca_port and hca_name for sysfs
 		 */
-		sess->hca_port = con->c.cm_id->port_num;
-		scnprintf(sess->hca_name, sizeof(sess->hca_name),
-			  sess->s.dev->ib_dev->name);
-		sess->s.src_addr = con->c.cm_id->route.addr.src_addr;
+		clt_path->hca_port = con->c.cm_id->port_num;
+		scnprintf(clt_path->hca_name, sizeof(clt_path->hca_name),
+			  clt_path->s.dev->ib_dev->name);
+		clt_path->s.src_addr = con->c.cm_id->route.addr.src_addr;
 		/* set for_new_clt, to allow future reconnect on any path */
-		sess->for_new_clt = 1;
+		clt_path->for_new_clt = 1;
 	}
 
 	return 0;
@@ -1887,9 +1898,9 @@ static int rtrs_rdma_conn_established(struct rtrs_clt_con *con,
 
 static inline void flag_success_on_conn(struct rtrs_clt_con *con)
 {
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
+	struct rtrs_clt_path *clt_path = to_clt_path(con->c.path);
 
-	atomic_inc(&sess->connected_cnt);
+	atomic_inc(&clt_path->connected_cnt);
 	con->cm_err = 1;
 }
 
@@ -1924,23 +1935,23 @@ static int rtrs_rdma_conn_rejected(struct rtrs_clt_con *con,
 	return -ECONNRESET;
 }
 
-void rtrs_clt_close_conns(struct rtrs_clt_sess *sess, bool wait)
+void rtrs_clt_close_conns(struct rtrs_clt_path *clt_path, bool wait)
 {
-	if (rtrs_clt_change_state_get_old(sess, RTRS_CLT_CLOSING, NULL))
-		queue_work(rtrs_wq, &sess->close_work);
+	if (rtrs_clt_change_state_get_old(clt_path, RTRS_CLT_CLOSING, NULL))
+		queue_work(rtrs_wq, &clt_path->close_work);
 	if (wait)
-		flush_work(&sess->close_work);
+		flush_work(&clt_path->close_work);
 }
 
 static inline void flag_error_on_conn(struct rtrs_clt_con *con, int cm_err)
 {
 	if (con->cm_err == 1) {
-		struct rtrs_clt_sess *sess;
+		struct rtrs_clt_path *clt_path;
 
-		sess = to_clt_sess(con->c.path);
-		if (atomic_dec_and_test(&sess->connected_cnt))
+		clt_path = to_clt_path(con->c.path);
+		if (atomic_dec_and_test(&clt_path->connected_cnt))
 
-			wake_up(&sess->state_wq);
+			wake_up(&clt_path->state_wq);
 	}
 	con->cm_err = cm_err;
 }
@@ -1950,7 +1961,7 @@ static int rtrs_clt_rdma_cm_handler(struct rdma_cm_id *cm_id,
 {
 	struct rtrs_clt_con *con = cm_id->context;
 	struct rtrs_path *s = con->c.path;
-	struct rtrs_clt_sess *sess = to_clt_sess(s);
+	struct rtrs_clt_path *clt_path = to_clt_path(s);
 	int cm_err = 0;
 
 	switch (ev->event) {
@@ -1968,7 +1979,7 @@ static int rtrs_clt_rdma_cm_handler(struct rdma_cm_id *cm_id,
 			 * i.e. wake up without state change, but we set cm_err.
 			 */
 			flag_success_on_conn(con);
-			wake_up(&sess->state_wq);
+			wake_up(&clt_path->state_wq);
 			return 0;
 		}
 		break;
@@ -1997,7 +2008,7 @@ static int rtrs_clt_rdma_cm_handler(struct rdma_cm_id *cm_id,
 		/*
 		 * Device removal is a special case.  Queue close and return 0.
 		 */
-		rtrs_clt_close_conns(sess, false);
+		rtrs_clt_close_conns(clt_path, false);
 		return 0;
 	default:
 		rtrs_err(s, "Unexpected RDMA CM error (CM event: %s, err: %d)\n",
@@ -2021,12 +2032,12 @@ static int rtrs_clt_rdma_cm_handler(struct rdma_cm_id *cm_id,
 static int create_cm(struct rtrs_clt_con *con)
 {
 	struct rtrs_path *s = con->c.path;
-	struct rtrs_clt_sess *sess = to_clt_sess(s);
+	struct rtrs_clt_path *clt_path = to_clt_path(s);
 	struct rdma_cm_id *cm_id;
 	int err;
 
 	cm_id = rdma_create_id(&init_net, rtrs_clt_rdma_cm_handler, con,
-			       sess->s.dst_addr.ss_family == AF_IB ?
+			       clt_path->s.dst_addr.ss_family == AF_IB ?
 			       RDMA_PS_IB : RDMA_PS_TCP, IB_QPT_RC);
 	if (IS_ERR(cm_id)) {
 		err = PTR_ERR(cm_id);
@@ -2042,8 +2053,8 @@ static int create_cm(struct rtrs_clt_con *con)
 		rtrs_err(s, "Set address reuse failed, err: %d\n", err);
 		goto destroy_cm;
 	}
-	err = rdma_resolve_addr(cm_id, (struct sockaddr *)&sess->s.src_addr,
-				(struct sockaddr *)&sess->s.dst_addr,
+	err = rdma_resolve_addr(cm_id, (struct sockaddr *)&clt_path->s.src_addr,
+				(struct sockaddr *)&clt_path->s.dst_addr,
 				RTRS_CONNECT_TIMEOUT_MS);
 	if (err) {
 		rtrs_err(s, "Failed to resolve address, err: %d\n", err);
@@ -2055,8 +2066,8 @@ static int create_cm(struct rtrs_clt_con *con)
 	 * or session state was really changed to error by device removal.
 	 */
 	err = wait_event_interruptible_timeout(
-			sess->state_wq,
-			con->cm_err || sess->state != RTRS_CLT_CONNECTING,
+			clt_path->state_wq,
+			con->cm_err || clt_path->state != RTRS_CLT_CONNECTING,
 			msecs_to_jiffies(RTRS_CONNECT_TIMEOUT_MS));
 	if (err == 0 || err == -ERESTARTSYS) {
 		if (err == 0)
@@ -2068,7 +2079,7 @@ static int create_cm(struct rtrs_clt_con *con)
 		err = con->cm_err;
 		goto errr;
 	}
-	if (READ_ONCE(sess->state) != RTRS_CLT_CONNECTING) {
+	if (READ_ONCE(clt_path->state) != RTRS_CLT_CONNECTING) {
 		/* Device removal */
 		err = -ECONNABORTED;
 		goto errr;
@@ -2087,9 +2098,9 @@ static int create_cm(struct rtrs_clt_con *con)
 	return err;
 }
 
-static void rtrs_clt_sess_up(struct rtrs_clt_sess *sess)
+static void rtrs_clt_path_up(struct rtrs_clt_path *clt_path)
 {
-	struct rtrs_clt *clt = sess->clt;
+	struct rtrs_clt *clt = clt_path->clt;
 	int up;
 
 	/*
@@ -2113,19 +2124,19 @@ static void rtrs_clt_sess_up(struct rtrs_clt_sess *sess)
 	mutex_unlock(&clt->paths_ev_mutex);
 
 	/* Mark session as established */
-	sess->established = true;
-	sess->reconnect_attempts = 0;
-	sess->stats->reconnects.successful_cnt++;
+	clt_path->established = true;
+	clt_path->reconnect_attempts = 0;
+	clt_path->stats->reconnects.successful_cnt++;
 }
 
-static void rtrs_clt_sess_down(struct rtrs_clt_sess *sess)
+static void rtrs_clt_path_down(struct rtrs_clt_path *clt_path)
 {
-	struct rtrs_clt *clt = sess->clt;
+	struct rtrs_clt *clt = clt_path->clt;
 
-	if (!sess->established)
+	if (!clt_path->established)
 		return;
 
-	sess->established = false;
+	clt_path->established = false;
 	mutex_lock(&clt->paths_ev_mutex);
 	WARN_ON(!clt->paths_up);
 	if (--clt->paths_up == 0)
@@ -2133,19 +2144,19 @@ static void rtrs_clt_sess_down(struct rtrs_clt_sess *sess)
 	mutex_unlock(&clt->paths_ev_mutex);
 }
 
-static void rtrs_clt_stop_and_destroy_conns(struct rtrs_clt_sess *sess)
+static void rtrs_clt_stop_and_destroy_conns(struct rtrs_clt_path *clt_path)
 {
 	struct rtrs_clt_con *con;
 	unsigned int cid;
 
-	WARN_ON(READ_ONCE(sess->state) == RTRS_CLT_CONNECTED);
+	WARN_ON(READ_ONCE(clt_path->state) == RTRS_CLT_CONNECTED);
 
 	/*
 	 * Possible race with rtrs_clt_open(), when DEVICE_REMOVAL comes
 	 * exactly in between.  Start destroying after it finishes.
 	 */
-	mutex_lock(&sess->init_mutex);
-	mutex_unlock(&sess->init_mutex);
+	mutex_lock(&clt_path->init_mutex);
+	mutex_unlock(&clt_path->init_mutex);
 
 	/*
 	 * All IO paths must observe !CONNECTED state before we
@@ -2153,7 +2164,7 @@ static void rtrs_clt_stop_and_destroy_conns(struct rtrs_clt_sess *sess)
 	 */
 	synchronize_rcu();
 
-	rtrs_stop_hb(&sess->s);
+	rtrs_stop_hb(&clt_path->s);
 
 	/*
 	 * The order it utterly crucial: firstly disconnect and complete all
@@ -2162,15 +2173,15 @@ static void rtrs_clt_stop_and_destroy_conns(struct rtrs_clt_sess *sess)
 	 * eventually notify upper layer about session disconnection.
 	 */
 
-	for (cid = 0; cid < sess->s.con_num; cid++) {
-		if (!sess->s.con[cid])
+	for (cid = 0; cid < clt_path->s.con_num; cid++) {
+		if (!clt_path->s.con[cid])
 			break;
-		con = to_clt_con(sess->s.con[cid]);
+		con = to_clt_con(clt_path->s.con[cid]);
 		stop_cm(con);
 	}
-	fail_all_outstanding_reqs(sess);
-	free_sess_reqs(sess);
-	rtrs_clt_sess_down(sess);
+	fail_all_outstanding_reqs(clt_path);
+	free_path_reqs(clt_path);
+	rtrs_clt_path_down(clt_path);
 
 	/*
 	 * Wait for graceful shutdown, namely when peer side invokes
@@ -2180,13 +2191,14 @@ static void rtrs_clt_stop_and_destroy_conns(struct rtrs_clt_sess *sess)
 	 * since CM does not fire anything.  That is fine, we are not in
 	 * hurry.
 	 */
-	wait_event_timeout(sess->state_wq, !atomic_read(&sess->connected_cnt),
+	wait_event_timeout(clt_path->state_wq,
+			   !atomic_read(&clt_path->connected_cnt),
 			   msecs_to_jiffies(RTRS_CONNECT_TIMEOUT_MS));
 
-	for (cid = 0; cid < sess->s.con_num; cid++) {
-		if (!sess->s.con[cid])
+	for (cid = 0; cid < clt_path->s.con_num; cid++) {
+		if (!clt_path->s.con[cid])
 			break;
-		con = to_clt_con(sess->s.con[cid]);
+		con = to_clt_con(clt_path->s.con[cid]);
 		mutex_lock(&con->con_mutex);
 		destroy_con_cq_qp(con);
 		mutex_unlock(&con->con_mutex);
@@ -2195,26 +2207,26 @@ static void rtrs_clt_stop_and_destroy_conns(struct rtrs_clt_sess *sess)
 	}
 }
 
-static inline bool xchg_sessions(struct rtrs_clt_sess __rcu **rcu_ppcpu_path,
-				 struct rtrs_clt_sess *sess,
-				 struct rtrs_clt_sess *next)
+static inline bool xchg_paths(struct rtrs_clt_path __rcu **rcu_ppcpu_path,
+			      struct rtrs_clt_path *clt_path,
+			      struct rtrs_clt_path *next)
 {
-	struct rtrs_clt_sess **ppcpu_path;
+	struct rtrs_clt_path **ppcpu_path;
 
 	/* Call cmpxchg() without sparse warnings */
 	ppcpu_path = (typeof(ppcpu_path))rcu_ppcpu_path;
-	return sess == cmpxchg(ppcpu_path, sess, next);
+	return clt_path == cmpxchg(ppcpu_path, clt_path, next);
 }
 
-static void rtrs_clt_remove_path_from_arr(struct rtrs_clt_sess *sess)
+static void rtrs_clt_remove_path_from_arr(struct rtrs_clt_path *clt_path)
 {
-	struct rtrs_clt *clt = sess->clt;
-	struct rtrs_clt_sess *next;
+	struct rtrs_clt *clt = clt_path->clt;
+	struct rtrs_clt_path *next;
 	bool wait_for_grace = false;
 	int cpu;
 
 	mutex_lock(&clt->paths_mutex);
-	list_del_rcu(&sess->s.entry);
+	list_del_rcu(&clt_path->s.entry);
 
 	/* Make sure everybody observes path removal. */
 	synchronize_rcu();
@@ -2255,7 +2267,7 @@ static void rtrs_clt_remove_path_from_arr(struct rtrs_clt_sess *sess)
 	 * removed.  If @sess is the last element, then @next is NULL.
 	 */
 	rcu_read_lock();
-	next = list_next_or_null_rr_rcu(&clt->paths_list, &sess->s.entry,
+	next = list_next_or_null_rr_rcu(&clt->paths_list, &clt_path->s.entry,
 					typeof(*next), s.entry);
 	rcu_read_unlock();
 
@@ -2264,11 +2276,11 @@ static void rtrs_clt_remove_path_from_arr(struct rtrs_clt_sess *sess)
 	 * removed, so change the pointer manually.
 	 */
 	for_each_possible_cpu(cpu) {
-		struct rtrs_clt_sess __rcu **ppcpu_path;
+		struct rtrs_clt_path __rcu **ppcpu_path;
 
 		ppcpu_path = per_cpu_ptr(clt->pcpu_path, cpu);
 		if (rcu_dereference_protected(*ppcpu_path,
-			lockdep_is_held(&clt->paths_mutex)) != sess)
+			lockdep_is_held(&clt->paths_mutex)) != clt_path)
 			/*
 			 * synchronize_rcu() was called just after deleting
 			 * entry from the list, thus IO code path cannot
@@ -2281,7 +2293,7 @@ static void rtrs_clt_remove_path_from_arr(struct rtrs_clt_sess *sess)
 		 * We race with IO code path, which also changes pointer,
 		 * thus we have to be careful not to overwrite it.
 		 */
-		if (xchg_sessions(ppcpu_path, sess, next))
+		if (xchg_paths(ppcpu_path, clt_path, next))
 			/*
 			 * @ppcpu_path was successfully replaced with @next,
 			 * that means that someone could also pick up the
@@ -2296,29 +2308,29 @@ static void rtrs_clt_remove_path_from_arr(struct rtrs_clt_sess *sess)
 	mutex_unlock(&clt->paths_mutex);
 }
 
-static void rtrs_clt_add_path_to_arr(struct rtrs_clt_sess *sess)
+static void rtrs_clt_add_path_to_arr(struct rtrs_clt_path *clt_path)
 {
-	struct rtrs_clt *clt = sess->clt;
+	struct rtrs_clt *clt = clt_path->clt;
 
 	mutex_lock(&clt->paths_mutex);
 	clt->paths_num++;
 
-	list_add_tail_rcu(&sess->s.entry, &clt->paths_list);
+	list_add_tail_rcu(&clt_path->s.entry, &clt->paths_list);
 	mutex_unlock(&clt->paths_mutex);
 }
 
 static void rtrs_clt_close_work(struct work_struct *work)
 {
-	struct rtrs_clt_sess *sess;
+	struct rtrs_clt_path *clt_path;
 
-	sess = container_of(work, struct rtrs_clt_sess, close_work);
+	clt_path = container_of(work, struct rtrs_clt_path, close_work);
 
-	cancel_delayed_work_sync(&sess->reconnect_dwork);
-	rtrs_clt_stop_and_destroy_conns(sess);
-	rtrs_clt_change_state_get_old(sess, RTRS_CLT_CLOSED, NULL);
+	cancel_delayed_work_sync(&clt_path->reconnect_dwork);
+	rtrs_clt_stop_and_destroy_conns(clt_path);
+	rtrs_clt_change_state_get_old(clt_path, RTRS_CLT_CLOSED, NULL);
 }
 
-static int init_conns(struct rtrs_clt_sess *sess)
+static int init_conns(struct rtrs_clt_path *clt_path)
 {
 	unsigned int cid;
 	int err;
@@ -2328,31 +2340,31 @@ static int init_conns(struct rtrs_clt_sess *sess)
 	 * to avoid clashes with previous sessions not yet closed
 	 * sessions on a server side.
 	 */
-	sess->s.recon_cnt++;
+	clt_path->s.recon_cnt++;
 
 	/* Establish all RDMA connections  */
-	for (cid = 0; cid < sess->s.con_num; cid++) {
-		err = create_con(sess, cid);
+	for (cid = 0; cid < clt_path->s.con_num; cid++) {
+		err = create_con(clt_path, cid);
 		if (err)
 			goto destroy;
 
-		err = create_cm(to_clt_con(sess->s.con[cid]));
+		err = create_cm(to_clt_con(clt_path->s.con[cid]));
 		if (err) {
-			destroy_con(to_clt_con(sess->s.con[cid]));
+			destroy_con(to_clt_con(clt_path->s.con[cid]));
 			goto destroy;
 		}
 	}
-	err = alloc_sess_reqs(sess);
+	err = alloc_path_reqs(clt_path);
 	if (err)
 		goto destroy;
 
-	rtrs_start_hb(&sess->s);
+	rtrs_start_hb(&clt_path->s);
 
 	return 0;
 
 destroy:
 	while (cid--) {
-		struct rtrs_clt_con *con = to_clt_con(sess->s.con[cid]);
+		struct rtrs_clt_con *con = to_clt_con(clt_path->s.con[cid]);
 
 		stop_cm(con);
 
@@ -2367,7 +2379,7 @@ static int init_conns(struct rtrs_clt_sess *sess)
 	 * doing rdma_resolve_addr(), switch to CONNECTION_ERR state
 	 * manually to keep reconnecting.
 	 */
-	rtrs_clt_change_state_get_old(sess, RTRS_CLT_CONNECTING_ERR, NULL);
+	rtrs_clt_change_state_get_old(clt_path, RTRS_CLT_CONNECTING_ERR, NULL);
 
 	return err;
 }
@@ -2375,31 +2387,32 @@ static int init_conns(struct rtrs_clt_sess *sess)
 static void rtrs_clt_info_req_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct rtrs_clt_con *con = to_clt_con(wc->qp->qp_context);
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
+	struct rtrs_clt_path *clt_path = to_clt_path(con->c.path);
 	struct rtrs_iu *iu;
 
 	iu = container_of(wc->wr_cqe, struct rtrs_iu, cqe);
-	rtrs_iu_free(iu, sess->s.dev->ib_dev, 1);
+	rtrs_iu_free(iu, clt_path->s.dev->ib_dev, 1);
 
 	if (wc->status != IB_WC_SUCCESS) {
-		rtrs_err(sess->clt, "Sess info request send failed: %s\n",
+		rtrs_err(clt_path->clt, "Path info request send failed: %s\n",
 			  ib_wc_status_msg(wc->status));
-		rtrs_clt_change_state_get_old(sess, RTRS_CLT_CONNECTING_ERR, NULL);
+		rtrs_clt_change_state_get_old(clt_path, RTRS_CLT_CONNECTING_ERR, NULL);
 		return;
 	}
 
 	rtrs_clt_update_wc_stats(con);
 }
 
-static int process_info_rsp(struct rtrs_clt_sess *sess,
+static int process_info_rsp(struct rtrs_clt_path *clt_path,
 			    const struct rtrs_msg_info_rsp *msg)
 {
 	unsigned int sg_cnt, total_len;
 	int i, sgi;
 
 	sg_cnt = le16_to_cpu(msg->sg_cnt);
-	if (!sg_cnt || (sess->queue_depth % sg_cnt)) {
-		rtrs_err(sess->clt, "Incorrect sg_cnt %d, is not multiple\n",
+	if (!sg_cnt || (clt_path->queue_depth % sg_cnt)) {
+		rtrs_err(clt_path->clt,
+			  "Incorrect sg_cnt %d, is not multiple\n",
 			  sg_cnt);
 		return -EINVAL;
 	}
@@ -2408,15 +2421,15 @@ static int process_info_rsp(struct rtrs_clt_sess *sess,
 	 * Check if IB immediate data size is enough to hold the mem_id and
 	 * the offset inside the memory chunk.
 	 */
-	if ((ilog2(sg_cnt - 1) + 1) + (ilog2(sess->chunk_size - 1) + 1) >
+	if ((ilog2(sg_cnt - 1) + 1) + (ilog2(clt_path->chunk_size - 1) + 1) >
 	    MAX_IMM_PAYL_BITS) {
-		rtrs_err(sess->clt,
+		rtrs_err(clt_path->clt,
 			  "RDMA immediate size (%db) not enough to encode %d buffers of size %dB\n",
-			  MAX_IMM_PAYL_BITS, sg_cnt, sess->chunk_size);
+			  MAX_IMM_PAYL_BITS, sg_cnt, clt_path->chunk_size);
 		return -EINVAL;
 	}
 	total_len = 0;
-	for (sgi = 0, i = 0; sgi < sg_cnt && i < sess->queue_depth; sgi++) {
+	for (sgi = 0, i = 0; sgi < sg_cnt && i < clt_path->queue_depth; sgi++) {
 		const struct rtrs_sg_desc *desc = &msg->desc[sgi];
 		u32 len, rkey;
 		u64 addr;
@@ -2427,26 +2440,28 @@ static int process_info_rsp(struct rtrs_clt_sess *sess,
 
 		total_len += len;
 
-		if (!len || (len % sess->chunk_size)) {
-			rtrs_err(sess->clt, "Incorrect [%d].len %d\n", sgi,
+		if (!len || (len % clt_path->chunk_size)) {
+			rtrs_err(clt_path->clt, "Incorrect [%d].len %d\n",
+				  sgi,
 				  len);
 			return -EINVAL;
 		}
-		for ( ; len && i < sess->queue_depth; i++) {
-			sess->rbufs[i].addr = addr;
-			sess->rbufs[i].rkey = rkey;
+		for ( ; len && i < clt_path->queue_depth; i++) {
+			clt_path->rbufs[i].addr = addr;
+			clt_path->rbufs[i].rkey = rkey;
 
-			len  -= sess->chunk_size;
-			addr += sess->chunk_size;
+			len  -= clt_path->chunk_size;
+			addr += clt_path->chunk_size;
 		}
 	}
 	/* Sanity check */
-	if (sgi != sg_cnt || i != sess->queue_depth) {
-		rtrs_err(sess->clt, "Incorrect sg vector, not fully mapped\n");
+	if (sgi != sg_cnt || i != clt_path->queue_depth) {
+		rtrs_err(clt_path->clt,
+			 "Incorrect sg vector, not fully mapped\n");
 		return -EINVAL;
 	}
-	if (total_len != sess->chunk_size * sess->queue_depth) {
-		rtrs_err(sess->clt, "Incorrect total_len %d\n", total_len);
+	if (total_len != clt_path->chunk_size * clt_path->queue_depth) {
+		rtrs_err(clt_path->clt, "Incorrect total_len %d\n", total_len);
 		return -EINVAL;
 	}
 
@@ -2456,7 +2471,7 @@ static int process_info_rsp(struct rtrs_clt_sess *sess,
 static void rtrs_clt_info_rsp_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct rtrs_clt_con *con = to_clt_con(wc->qp->qp_context);
-	struct rtrs_clt_sess *sess = to_clt_sess(con->c.path);
+	struct rtrs_clt_path *clt_path = to_clt_path(con->c.path);
 	struct rtrs_msg_info_rsp *msg;
 	enum rtrs_clt_state state;
 	struct rtrs_iu *iu;
@@ -2468,37 +2483,37 @@ static void rtrs_clt_info_rsp_done(struct ib_cq *cq, struct ib_wc *wc)
 	WARN_ON(con->c.cid);
 	iu = container_of(wc->wr_cqe, struct rtrs_iu, cqe);
 	if (wc->status != IB_WC_SUCCESS) {
-		rtrs_err(sess->clt, "Sess info response recv failed: %s\n",
+		rtrs_err(clt_path->clt, "Path info response recv failed: %s\n",
 			  ib_wc_status_msg(wc->status));
 		goto out;
 	}
 	WARN_ON(wc->opcode != IB_WC_RECV);
 
 	if (wc->byte_len < sizeof(*msg)) {
-		rtrs_err(sess->clt, "Sess info response is malformed: size %d\n",
+		rtrs_err(clt_path->clt, "Path info response is malformed: size %d\n",
 			  wc->byte_len);
 		goto out;
 	}
-	ib_dma_sync_single_for_cpu(sess->s.dev->ib_dev, iu->dma_addr,
+	ib_dma_sync_single_for_cpu(clt_path->s.dev->ib_dev, iu->dma_addr,
 				   iu->size, DMA_FROM_DEVICE);
 	msg = iu->buf;
 	if (le16_to_cpu(msg->type) != RTRS_MSG_INFO_RSP) {
-		rtrs_err(sess->clt, "Sess info response is malformed: type %d\n",
+		rtrs_err(clt_path->clt, "Path info response is malformed: type %d\n",
 			  le16_to_cpu(msg->type));
 		goto out;
 	}
 	rx_sz  = sizeof(*msg);
 	rx_sz += sizeof(msg->desc[0]) * le16_to_cpu(msg->sg_cnt);
 	if (wc->byte_len < rx_sz) {
-		rtrs_err(sess->clt, "Sess info response is malformed: size %d\n",
+		rtrs_err(clt_path->clt, "Path info response is malformed: size %d\n",
 			  wc->byte_len);
 		goto out;
 	}
-	err = process_info_rsp(sess, msg);
+	err = process_info_rsp(clt_path, msg);
 	if (err)
 		goto out;
 
-	err = post_recv_sess(sess);
+	err = post_recv_path(clt_path);
 	if (err)
 		goto out;
 
@@ -2506,25 +2521,25 @@ static void rtrs_clt_info_rsp_done(struct ib_cq *cq, struct ib_wc *wc)
 
 out:
 	rtrs_clt_update_wc_stats(con);
-	rtrs_iu_free(iu, sess->s.dev->ib_dev, 1);
-	rtrs_clt_change_state_get_old(sess, state, NULL);
+	rtrs_iu_free(iu, clt_path->s.dev->ib_dev, 1);
+	rtrs_clt_change_state_get_old(clt_path, state, NULL);
 }
 
-static int rtrs_send_sess_info(struct rtrs_clt_sess *sess)
+static int rtrs_send_path_info(struct rtrs_clt_path *clt_path)
 {
-	struct rtrs_clt_con *usr_con = to_clt_con(sess->s.con[0]);
+	struct rtrs_clt_con *usr_con = to_clt_con(clt_path->s.con[0]);
 	struct rtrs_msg_info_req *msg;
 	struct rtrs_iu *tx_iu, *rx_iu;
 	size_t rx_sz;
 	int err;
 
 	rx_sz  = sizeof(struct rtrs_msg_info_rsp);
-	rx_sz += sizeof(struct rtrs_sg_desc) * sess->queue_depth;
+	rx_sz += sizeof(struct rtrs_sg_desc) * clt_path->queue_depth;
 
 	tx_iu = rtrs_iu_alloc(1, sizeof(struct rtrs_msg_info_req), GFP_KERNEL,
-			       sess->s.dev->ib_dev, DMA_TO_DEVICE,
+			       clt_path->s.dev->ib_dev, DMA_TO_DEVICE,
 			       rtrs_clt_info_req_done);
-	rx_iu = rtrs_iu_alloc(1, rx_sz, GFP_KERNEL, sess->s.dev->ib_dev,
+	rx_iu = rtrs_iu_alloc(1, rx_sz, GFP_KERNEL, clt_path->s.dev->ib_dev,
 			       DMA_FROM_DEVICE, rtrs_clt_info_rsp_done);
 	if (!tx_iu || !rx_iu) {
 		err = -ENOMEM;
@@ -2533,33 +2548,34 @@ static int rtrs_send_sess_info(struct rtrs_clt_sess *sess)
 	/* Prepare for getting info response */
 	err = rtrs_iu_post_recv(&usr_con->c, rx_iu);
 	if (err) {
-		rtrs_err(sess->clt, "rtrs_iu_post_recv(), err: %d\n", err);
+		rtrs_err(clt_path->clt, "rtrs_iu_post_recv(), err: %d\n", err);
 		goto out;
 	}
 	rx_iu = NULL;
 
 	msg = tx_iu->buf;
 	msg->type = cpu_to_le16(RTRS_MSG_INFO_REQ);
-	memcpy(msg->sessname, sess->s.sessname, sizeof(msg->sessname));
+	memcpy(msg->pathname, clt_path->s.sessname, sizeof(msg->pathname));
 
-	ib_dma_sync_single_for_device(sess->s.dev->ib_dev, tx_iu->dma_addr,
+	ib_dma_sync_single_for_device(clt_path->s.dev->ib_dev,
+				      tx_iu->dma_addr,
 				      tx_iu->size, DMA_TO_DEVICE);
 
 	/* Send info request */
 	err = rtrs_iu_post_send(&usr_con->c, tx_iu, sizeof(*msg), NULL);
 	if (err) {
-		rtrs_err(sess->clt, "rtrs_iu_post_send(), err: %d\n", err);
+		rtrs_err(clt_path->clt, "rtrs_iu_post_send(), err: %d\n", err);
 		goto out;
 	}
 	tx_iu = NULL;
 
 	/* Wait for state change */
-	wait_event_interruptible_timeout(sess->state_wq,
-					 sess->state != RTRS_CLT_CONNECTING,
+	wait_event_interruptible_timeout(clt_path->state_wq,
+					 clt_path->state != RTRS_CLT_CONNECTING,
 					 msecs_to_jiffies(
 						 RTRS_CONNECT_TIMEOUT_MS));
-	if (READ_ONCE(sess->state) != RTRS_CLT_CONNECTED) {
-		if (READ_ONCE(sess->state) == RTRS_CLT_CONNECTING_ERR)
+	if (READ_ONCE(clt_path->state) != RTRS_CLT_CONNECTED) {
+		if (READ_ONCE(clt_path->state) == RTRS_CLT_CONNECTING_ERR)
 			err = -ECONNRESET;
 		else
 			err = -ETIMEDOUT;
@@ -2567,82 +2583,82 @@ static int rtrs_send_sess_info(struct rtrs_clt_sess *sess)
 
 out:
 	if (tx_iu)
-		rtrs_iu_free(tx_iu, sess->s.dev->ib_dev, 1);
+		rtrs_iu_free(tx_iu, clt_path->s.dev->ib_dev, 1);
 	if (rx_iu)
-		rtrs_iu_free(rx_iu, sess->s.dev->ib_dev, 1);
+		rtrs_iu_free(rx_iu, clt_path->s.dev->ib_dev, 1);
 	if (err)
 		/* If we've never taken async path because of malloc problems */
-		rtrs_clt_change_state_get_old(sess, RTRS_CLT_CONNECTING_ERR, NULL);
+		rtrs_clt_change_state_get_old(clt_path,
+					      RTRS_CLT_CONNECTING_ERR, NULL);
 
 	return err;
 }
 
 /**
- * init_sess() - establishes all session connections and does handshake
- * @sess: client session.
+ * init_path() - establishes all path connections and does handshake
+ * @clt_path: client path.
  * In case of error full close or reconnect procedure should be taken,
  * because reconnect or close async works can be started.
  */
-static int init_sess(struct rtrs_clt_sess *sess)
+static int init_path(struct rtrs_clt_path *clt_path)
 {
 	int err;
 	char str[NAME_MAX];
 	struct rtrs_addr path = {
-		.src = &sess->s.src_addr,
-		.dst = &sess->s.dst_addr,
+		.src = &clt_path->s.src_addr,
+		.dst = &clt_path->s.dst_addr,
 	};
 
 	rtrs_addr_to_str(&path, str, sizeof(str));
 
-	mutex_lock(&sess->init_mutex);
-	err = init_conns(sess);
+	mutex_lock(&clt_path->init_mutex);
+	err = init_conns(clt_path);
 	if (err) {
-		rtrs_err(sess->clt,
+		rtrs_err(clt_path->clt,
 			 "init_conns() failed: err=%d path=%s [%s:%u]\n", err,
-			 str, sess->hca_name, sess->hca_port);
+			 str, clt_path->hca_name, clt_path->hca_port);
 		goto out;
 	}
-	err = rtrs_send_sess_info(sess);
+	err = rtrs_send_path_info(clt_path);
 	if (err) {
-		rtrs_err(
-			sess->clt,
-			"rtrs_send_sess_info() failed: err=%d path=%s [%s:%u]\n",
-			err, str, sess->hca_name, sess->hca_port);
+		rtrs_err(clt_path->clt,
+			 "rtrs_send_path_info() failed: err=%d path=%s [%s:%u]\n",
+			 err, str, clt_path->hca_name, clt_path->hca_port);
 		goto out;
 	}
-	rtrs_clt_sess_up(sess);
+	rtrs_clt_path_up(clt_path);
 out:
-	mutex_unlock(&sess->init_mutex);
+	mutex_unlock(&clt_path->init_mutex);
 
 	return err;
 }
 
 static void rtrs_clt_reconnect_work(struct work_struct *work)
 {
-	struct rtrs_clt_sess *sess;
+	struct rtrs_clt_path *clt_path;
 	struct rtrs_clt *clt;
 	unsigned int delay_ms;
 	int err;
 
-	sess = container_of(to_delayed_work(work), struct rtrs_clt_sess,
-			    reconnect_dwork);
-	clt = sess->clt;
+	clt_path = container_of(to_delayed_work(work), struct rtrs_clt_path,
+				reconnect_dwork);
+	clt = clt_path->clt;
 
-	if (READ_ONCE(sess->state) != RTRS_CLT_RECONNECTING)
+	if (READ_ONCE(clt_path->state) != RTRS_CLT_RECONNECTING)
 		return;
 
-	if (sess->reconnect_attempts >= clt->max_reconnect_attempts) {
-		/* Close a session completely if max attempts is reached */
-		rtrs_clt_close_conns(sess, false);
+	if (clt_path->reconnect_attempts >= clt->max_reconnect_attempts) {
+		/* Close a path completely if max attempts is reached */
+		rtrs_clt_close_conns(clt_path, false);
 		return;
 	}
-	sess->reconnect_attempts++;
+	clt_path->reconnect_attempts++;
 
 	/* Stop everything */
-	rtrs_clt_stop_and_destroy_conns(sess);
+	rtrs_clt_stop_and_destroy_conns(clt_path);
 	msleep(RTRS_RECONNECT_BACKOFF);
-	if (rtrs_clt_change_state_get_old(sess, RTRS_CLT_CONNECTING, NULL)) {
-		err = init_sess(sess);
+	if (rtrs_clt_change_state_get_old(clt_path, RTRS_CLT_CONNECTING, NULL)) {
+		err = init_path(clt_path);
 		if (err)
 			goto reconnect_again;
 	}
@@ -2650,10 +2666,10 @@ static void rtrs_clt_reconnect_work(struct work_struct *work)
 	return;
 
 reconnect_again:
-	if (rtrs_clt_change_state_get_old(sess, RTRS_CLT_RECONNECTING, NULL)) {
-		sess->stats->reconnects.fail_cnt++;
+	if (rtrs_clt_change_state_get_old(clt_path, RTRS_CLT_RECONNECTING, NULL)) {
+		clt_path->stats->reconnects.fail_cnt++;
 		delay_ms = clt->reconnect_delay_sec * 1000;
-		queue_delayed_work(rtrs_wq, &sess->reconnect_dwork,
+		queue_delayed_work(rtrs_wq, &clt_path->reconnect_dwork,
 				   msecs_to_jiffies(delay_ms +
 						    prandom_u32() %
 						    RTRS_RECONNECT_SEED));
@@ -2762,7 +2778,7 @@ static void free_clt(struct rtrs_clt *clt)
 }
 
 /**
- * rtrs_clt_open() - Open a session to an RTRS server
+ * rtrs_clt_open() - Open a path to an RTRS server
  * @ops: holds the link event callback and the private pointer.
  * @sessname: name of the session
  * @paths: Paths to be established defined by their src and dst addresses
@@ -2780,23 +2796,23 @@ static void free_clt(struct rtrs_clt *clt)
  * Return a valid pointer on success otherwise PTR_ERR.
  */
 struct rtrs_clt *rtrs_clt_open(struct rtrs_clt_ops *ops,
-				 const char *sessname,
+				 const char *pathname,
 				 const struct rtrs_addr *paths,
 				 size_t paths_num, u16 port,
 				 size_t pdu_sz, u8 reconnect_delay_sec,
 				 s16 max_reconnect_attempts, u32 nr_poll_queues)
 {
-	struct rtrs_clt_sess *sess, *tmp;
+	struct rtrs_clt_path *clt_path, *tmp;
 	struct rtrs_clt *clt;
 	int err, i;
 
-	if (strchr(sessname, '/') || strchr(sessname, '.')) {
-		pr_err("sessname cannot contain / and .\n");
+	if (strchr(pathname, '/') || strchr(pathname, '.')) {
+		pr_err("pathname cannot contain / and .\n");
 		err = -EINVAL;
 		goto out;
 	}
 
-	clt = alloc_clt(sessname, paths_num, port, pdu_sz, ops->priv,
+	clt = alloc_clt(pathname, paths_num, port, pdu_sz, ops->priv,
 			ops->link_ev,
 			reconnect_delay_sec,
 			max_reconnect_attempts);
@@ -2805,49 +2821,49 @@ struct rtrs_clt *rtrs_clt_open(struct rtrs_clt_ops *ops,
 		goto out;
 	}
 	for (i = 0; i < paths_num; i++) {
-		struct rtrs_clt_sess *sess;
+		struct rtrs_clt_path *clt_path;
 
-		sess = alloc_sess(clt, &paths[i], nr_cpu_ids,
+		clt_path = alloc_path(clt, &paths[i], nr_cpu_ids,
 				  nr_poll_queues);
-		if (IS_ERR(sess)) {
-			err = PTR_ERR(sess);
-			goto close_all_sess;
+		if (IS_ERR(clt_path)) {
+			err = PTR_ERR(clt_path);
+			goto close_all_path;
 		}
 		if (!i)
-			sess->for_new_clt = 1;
-		list_add_tail_rcu(&sess->s.entry, &clt->paths_list);
+			clt_path->for_new_clt = 1;
+		list_add_tail_rcu(&clt_path->s.entry, &clt->paths_list);
 
-		err = init_sess(sess);
+		err = init_path(clt_path);
 		if (err) {
-			list_del_rcu(&sess->s.entry);
-			rtrs_clt_close_conns(sess, true);
-			free_percpu(sess->stats->pcpu_stats);
-			kfree(sess->stats);
-			free_sess(sess);
-			goto close_all_sess;
+			list_del_rcu(&clt_path->s.entry);
+			rtrs_clt_close_conns(clt_path, true);
+			free_percpu(clt_path->stats->pcpu_stats);
+			kfree(clt_path->stats);
+			free_path(clt_path);
+			goto close_all_path;
 		}
 
-		err = rtrs_clt_create_sess_files(sess);
+		err = rtrs_clt_create_path_files(clt_path);
 		if (err) {
-			list_del_rcu(&sess->s.entry);
-			rtrs_clt_close_conns(sess, true);
-			free_percpu(sess->stats->pcpu_stats);
-			kfree(sess->stats);
-			free_sess(sess);
-			goto close_all_sess;
+			list_del_rcu(&clt_path->s.entry);
+			rtrs_clt_close_conns(clt_path, true);
+			free_percpu(clt_path->stats->pcpu_stats);
+			kfree(clt_path->stats);
+			free_path(clt_path);
+			goto close_all_path;
 		}
 	}
 	err = alloc_permits(clt);
 	if (err)
-		goto close_all_sess;
+		goto close_all_path;
 
 	return clt;
 
-close_all_sess:
-	list_for_each_entry_safe(sess, tmp, &clt->paths_list, s.entry) {
-		rtrs_clt_destroy_sess_files(sess, NULL);
-		rtrs_clt_close_conns(sess, true);
-		kobject_put(&sess->kobj);
+close_all_path:
+	list_for_each_entry_safe(clt_path, tmp, &clt->paths_list, s.entry) {
+		rtrs_clt_destroy_path_files(clt_path, NULL);
+		rtrs_clt_close_conns(clt_path, true);
+		kobject_put(&clt_path->kobj);
 	}
 	rtrs_clt_destroy_sysfs_root(clt);
 	free_clt(clt);
@@ -2858,38 +2874,39 @@ struct rtrs_clt *rtrs_clt_open(struct rtrs_clt_ops *ops,
 EXPORT_SYMBOL(rtrs_clt_open);
 
 /**
- * rtrs_clt_close() - Close a session
+ * rtrs_clt_close() - Close a path
  * @clt: Session handle. Session is freed upon return.
  */
 void rtrs_clt_close(struct rtrs_clt *clt)
 {
-	struct rtrs_clt_sess *sess, *tmp;
+	struct rtrs_clt_path *clt_path, *tmp;
 
 	/* Firstly forbid sysfs access */
 	rtrs_clt_destroy_sysfs_root(clt);
 
 	/* Now it is safe to iterate over all paths without locks */
-	list_for_each_entry_safe(sess, tmp, &clt->paths_list, s.entry) {
-		rtrs_clt_close_conns(sess, true);
-		rtrs_clt_destroy_sess_files(sess, NULL);
-		kobject_put(&sess->kobj);
+	list_for_each_entry_safe(clt_path, tmp, &clt->paths_list, s.entry) {
+		rtrs_clt_close_conns(clt_path, true);
+		rtrs_clt_destroy_path_files(clt_path, NULL);
+		kobject_put(&clt_path->kobj);
 	}
 	free_permits(clt);
 	free_clt(clt);
 }
 EXPORT_SYMBOL(rtrs_clt_close);
 
-int rtrs_clt_reconnect_from_sysfs(struct rtrs_clt_sess *sess)
+int rtrs_clt_reconnect_from_sysfs(struct rtrs_clt_path *clt_path)
 {
 	enum rtrs_clt_state old_state;
 	int err = -EBUSY;
 	bool changed;
 
-	changed = rtrs_clt_change_state_get_old(sess, RTRS_CLT_RECONNECTING,
+	changed = rtrs_clt_change_state_get_old(clt_path,
+						 RTRS_CLT_RECONNECTING,
 						 &old_state);
 	if (changed) {
-		sess->reconnect_attempts = 0;
-		queue_delayed_work(rtrs_wq, &sess->reconnect_dwork, 0);
+		clt_path->reconnect_attempts = 0;
+		queue_delayed_work(rtrs_wq, &clt_path->reconnect_dwork, 0);
 	}
 	if (changed || old_state == RTRS_CLT_RECONNECTING) {
 		/*
@@ -2897,15 +2914,15 @@ int rtrs_clt_reconnect_from_sysfs(struct rtrs_clt_sess *sess)
 		 * execution, so do the flush if we have queued something
 		 * right now or work is pending.
 		 */
-		flush_delayed_work(&sess->reconnect_dwork);
-		err = (READ_ONCE(sess->state) ==
+		flush_delayed_work(&clt_path->reconnect_dwork);
+		err = (READ_ONCE(clt_path->state) ==
 		       RTRS_CLT_CONNECTED ? 0 : -ENOTCONN);
 	}
 
 	return err;
 }
 
-int rtrs_clt_remove_path_from_sysfs(struct rtrs_clt_sess *sess,
+int rtrs_clt_remove_path_from_sysfs(struct rtrs_clt_path *clt_path,
 				     const struct attribute *sysfs_self)
 {
 	enum rtrs_clt_state old_state;
@@ -2921,16 +2938,16 @@ int rtrs_clt_remove_path_from_sysfs(struct rtrs_clt_sess *sess,
 	 *    removing the path.
 	 */
 	do {
-		rtrs_clt_close_conns(sess, true);
-		changed = rtrs_clt_change_state_get_old(sess,
+		rtrs_clt_close_conns(clt_path, true);
+		changed = rtrs_clt_change_state_get_old(clt_path,
 							RTRS_CLT_DEAD,
 							&old_state);
 	} while (!changed && old_state != RTRS_CLT_DEAD);
 
 	if (changed) {
-		rtrs_clt_remove_path_from_arr(sess);
-		rtrs_clt_destroy_sess_files(sess, sysfs_self);
-		kobject_put(&sess->kobj);
+		rtrs_clt_remove_path_from_arr(clt_path);
+		rtrs_clt_destroy_path_files(clt_path, sysfs_self);
+		kobject_put(&clt_path->kobj);
 	}
 
 	return 0;
@@ -2976,7 +2993,7 @@ int rtrs_clt_request(int dir, struct rtrs_clt_req_ops *ops,
 		      struct scatterlist *sg, unsigned int sg_cnt)
 {
 	struct rtrs_clt_io_req *req;
-	struct rtrs_clt_sess *sess;
+	struct rtrs_clt_path *clt_path;
 
 	enum dma_data_direction dma_dir;
 	int err = -ECONNABORTED, i;
@@ -2998,19 +3015,19 @@ int rtrs_clt_request(int dir, struct rtrs_clt_req_ops *ops,
 
 	rcu_read_lock();
 	for (path_it_init(&it, clt);
-	     (sess = it.next_path(&it)) && it.i < it.clt->paths_num; it.i++) {
-		if (READ_ONCE(sess->state) != RTRS_CLT_CONNECTED)
+	     (clt_path = it.next_path(&it)) && it.i < it.clt->paths_num; it.i++) {
+		if (READ_ONCE(clt_path->state) != RTRS_CLT_CONNECTED)
 			continue;
 
-		if (usr_len + hdr_len > sess->max_hdr_size) {
-			rtrs_wrn_rl(sess->clt,
+		if (usr_len + hdr_len > clt_path->max_hdr_size) {
+			rtrs_wrn_rl(clt_path->clt,
 				     "%s request failed, user message size is %zu and header length %zu, but max size is %u\n",
 				     dir == READ ? "Read" : "Write",
-				     usr_len, hdr_len, sess->max_hdr_size);
+				     usr_len, hdr_len, clt_path->max_hdr_size);
 			err = -EMSGSIZE;
 			break;
 		}
-		req = rtrs_clt_get_req(sess, ops->conf_fn, permit, ops->priv,
+		req = rtrs_clt_get_req(clt_path, ops->conf_fn, permit, ops->priv,
 				       vec, usr_len, sg, sg_cnt, data_len,
 				       dma_dir);
 		if (dir == READ)
@@ -3036,16 +3053,16 @@ int rtrs_clt_rdma_cq_direct(struct rtrs_clt *clt, unsigned int index)
 	/* If no path, return -1 for block layer not to try again */
 	int cnt = -1;
 	struct rtrs_con *con;
-	struct rtrs_clt_sess *sess;
+	struct rtrs_clt_path *clt_path;
 	struct path_it it;
 
 	rcu_read_lock();
 	for (path_it_init(&it, clt);
-	     (sess = it.next_path(&it)) && it.i < it.clt->paths_num; it.i++) {
-		if (READ_ONCE(sess->state) != RTRS_CLT_CONNECTED)
+	     (clt_path = it.next_path(&it)) && it.i < it.clt->paths_num; it.i++) {
+		if (READ_ONCE(clt_path->state) != RTRS_CLT_CONNECTED)
 			continue;
 
-		con = sess->s.con[index + 1];
+		con = clt_path->s.con[index + 1];
 		cnt = ib_process_cq_direct(con->cq, -1);
 		if (cnt)
 			break;
@@ -3083,12 +3100,12 @@ EXPORT_SYMBOL(rtrs_clt_query);
 int rtrs_clt_create_path_from_sysfs(struct rtrs_clt *clt,
 				     struct rtrs_addr *addr)
 {
-	struct rtrs_clt_sess *sess;
+	struct rtrs_clt_path *clt_path;
 	int err;
 
-	sess = alloc_sess(clt, addr, nr_cpu_ids, 0);
-	if (IS_ERR(sess))
-		return PTR_ERR(sess);
+	clt_path = alloc_path(clt, addr, nr_cpu_ids, 0);
+	if (IS_ERR(clt_path))
+		return PTR_ERR(clt_path);
 
 	mutex_lock(&clt->paths_mutex);
 	if (clt->paths_num == 0) {
@@ -3097,7 +3114,7 @@ int rtrs_clt_create_path_from_sysfs(struct rtrs_clt *clt,
 		 * the addition of the first path is like a new session for
 		 * the storage server
 		 */
-		sess->for_new_clt = 1;
+		clt_path->for_new_clt = 1;
 	}
 
 	mutex_unlock(&clt->paths_mutex);
@@ -3107,24 +3124,24 @@ int rtrs_clt_create_path_from_sysfs(struct rtrs_clt *clt,
 	 * IO will never grab it.  Also it is very important to add
 	 * path before init, since init fires LINK_CONNECTED event.
 	 */
-	rtrs_clt_add_path_to_arr(sess);
+	rtrs_clt_add_path_to_arr(clt_path);
 
-	err = init_sess(sess);
+	err = init_path(clt_path);
 	if (err)
-		goto close_sess;
+		goto close_path;
 
-	err = rtrs_clt_create_sess_files(sess);
+	err = rtrs_clt_create_path_files(clt_path);
 	if (err)
-		goto close_sess;
+		goto close_path;
 
 	return 0;
 
-close_sess:
-	rtrs_clt_remove_path_from_arr(sess);
-	rtrs_clt_close_conns(sess, true);
-	free_percpu(sess->stats->pcpu_stats);
-	kfree(sess->stats);
-	free_sess(sess);
+close_path:
+	rtrs_clt_remove_path_from_arr(clt_path);
+	rtrs_clt_close_conns(clt_path, true);
+	free_percpu(clt_path->stats->pcpu_stats);
+	kfree(clt_path->stats);
+	free_path(clt_path);
 
 	return err;
 }
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.h b/drivers/infiniband/ulp/rtrs/rtrs-clt.h
index d616f325bc40..7f2a64995fb6 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.h
@@ -124,7 +124,7 @@ struct rtrs_rbuf {
 	u32 rkey;
 };
 
-struct rtrs_clt_sess {
+struct rtrs_clt_path {
 	struct rtrs_path	s;
 	struct rtrs_clt	*clt;
 	wait_queue_head_t	state_wq;
@@ -156,7 +156,7 @@ struct rtrs_clt_sess {
 struct rtrs_clt {
 	struct list_head	paths_list; /* rcu protected list */
 	size_t			paths_num;
-	struct rtrs_clt_sess
+	struct rtrs_clt_path
 	__rcu * __percpu	*pcpu_path;
 	uuid_t			paths_uuid;
 	int			paths_up;
@@ -186,9 +186,9 @@ static inline struct rtrs_clt_con *to_clt_con(struct rtrs_con *c)
 	return container_of(c, struct rtrs_clt_con, c);
 }
 
-static inline struct rtrs_clt_sess *to_clt_sess(struct rtrs_path *s)
+static inline struct rtrs_clt_path *to_clt_path(struct rtrs_path *s)
 {
-	return container_of(s, struct rtrs_clt_sess, s);
+	return container_of(s, struct rtrs_clt_path, s);
 }
 
 static inline int permit_size(struct rtrs_clt *clt)
@@ -201,16 +201,16 @@ static inline struct rtrs_permit *get_permit(struct rtrs_clt *clt, int idx)
 	return (struct rtrs_permit *)(clt->permits + permit_size(clt) * idx);
 }
 
-int rtrs_clt_reconnect_from_sysfs(struct rtrs_clt_sess *sess);
-void rtrs_clt_close_conns(struct rtrs_clt_sess *sess, bool wait);
+int rtrs_clt_reconnect_from_sysfs(struct rtrs_clt_path *path);
+void rtrs_clt_close_conns(struct rtrs_clt_path *clt_path, bool wait);
 int rtrs_clt_create_path_from_sysfs(struct rtrs_clt *clt,
 				     struct rtrs_addr *addr);
-int rtrs_clt_remove_path_from_sysfs(struct rtrs_clt_sess *sess,
+int rtrs_clt_remove_path_from_sysfs(struct rtrs_clt_path *path,
 				     const struct attribute *sysfs_self);
 
 void rtrs_clt_set_max_reconnect_attempts(struct rtrs_clt *clt, int value);
 int rtrs_clt_get_max_reconnect_attempts(const struct rtrs_clt *clt);
-void free_sess(struct rtrs_clt_sess *sess);
+void free_path(struct rtrs_clt_path *clt_path);
 
 /* rtrs-clt-stats.c */
 
@@ -243,8 +243,8 @@ ssize_t rtrs_clt_reset_all_help(struct rtrs_clt_stats *stats,
 int rtrs_clt_create_sysfs_root_files(struct rtrs_clt *clt);
 void rtrs_clt_destroy_sysfs_root(struct rtrs_clt *clt);
 
-int rtrs_clt_create_sess_files(struct rtrs_clt_sess *sess);
-void rtrs_clt_destroy_sess_files(struct rtrs_clt_sess *sess,
+int rtrs_clt_create_path_files(struct rtrs_clt_path *clt_path);
+void rtrs_clt_destroy_path_files(struct rtrs_clt_path *clt_path,
 				  const struct attribute *sysfs_self);
 
 #endif /* RTRS_CLT_H */
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-pri.h b/drivers/infiniband/ulp/rtrs/rtrs-pri.h
index 412cf5ce3e7c..b69fa1fe9a70 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-pri.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs-pri.h
@@ -230,7 +230,7 @@ struct rtrs_msg_conn_rsp {
 /**
  * struct rtrs_msg_info_req
  * @type:		@RTRS_MSG_INFO_REQ
- * @sessname:		Session name chosen by client
+ * @pathname:		Path name chosen by client
  */
 struct rtrs_msg_info_req {
 	__le16		type;
diff --git a/drivers/infiniband/ulp/rtrs/rtrs.h b/drivers/infiniband/ulp/rtrs/rtrs.h
index 9da9202fbee5..c529b6d63c9a 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs.h
@@ -53,13 +53,13 @@ struct rtrs_clt_ops {
 };
 
 struct rtrs_clt *rtrs_clt_open(struct rtrs_clt_ops *ops,
-				 const char *sessname,
+				 const char *pathname,
 				 const struct rtrs_addr *paths,
 				 size_t path_cnt, u16 port,
 				 size_t pdu_sz, u8 reconnect_delay_sec,
 				 s16 max_reconnect_attempts, u32 nr_poll_queues);
 
-void rtrs_clt_close(struct rtrs_clt *sess);
+void rtrs_clt_close(struct rtrs_clt *clt_path);
 
 enum wait_type {
 	RTRS_PERMIT_NOWAIT = 0,
-- 
2.35.1



