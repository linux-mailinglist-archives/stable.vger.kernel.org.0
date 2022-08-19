Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA7B459A124
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352479AbiHSQ0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352756AbiHSQZa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:25:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCAEC17AA5;
        Fri, 19 Aug 2022 09:03:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26517B82813;
        Fri, 19 Aug 2022 16:03:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D311C433C1;
        Fri, 19 Aug 2022 16:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925001;
        bh=I6UYSXbz5OYNgyJ2rDliSNcz2acQXi3EoNGfxqWWMms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZjhKfKaFF39USUK7fkEQJcR6N/uhePdjUG8Ll7tosdsdzQ7ilO5joyC0lHXQulA4P
         +ce+BiGKWxiceYwi2rBSl2P+BdV8jGeBuxDa4eETEIP4xPjr/NgLuByh63Q1X2vii8
         fyIetnZQxBUf4WNLb2xHhCICB10kIfUz+OhbhVuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Zhijian <lizhijian@fujitsu.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 352/545] RDMA/srpt: Fix a use-after-free
Date:   Fri, 19 Aug 2022 17:42:02 +0200
Message-Id: <20220819153845.130296281@linuxfoundation.org>
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

[ Upstream commit b5605148e6ce36bb21020d49010b617693933128 ]

Change the LIO port members inside struct srpt_port from regular members
into pointers. Allocate the LIO port data structures from inside
srpt_make_tport() and free these from inside srpt_make_tport(). Keep
struct srpt_device as long as either an RDMA port or a LIO target port is
associated with it. This patch decouples the lifetime of struct srpt_port
(controlled by the RDMA core) and struct srpt_port_id (controlled by LIO).
This patch fixes the following KASAN complaint:

  BUG: KASAN: use-after-free in srpt_enable_tpg+0x31/0x70 [ib_srpt]
  Read of size 8 at addr ffff888141cc34b8 by task check/5093

  Call Trace:
   <TASK>
   show_stack+0x4e/0x53
   dump_stack_lvl+0x51/0x66
   print_address_description.constprop.0.cold+0xea/0x41e
   print_report.cold+0x90/0x205
   kasan_report+0xb9/0xf0
   __asan_load8+0x69/0x90
   srpt_enable_tpg+0x31/0x70 [ib_srpt]
   target_fabric_tpg_base_enable_store+0xe2/0x140 [target_core_mod]
   configfs_write_iter+0x18b/0x210
   new_sync_write+0x1f2/0x2f0
   vfs_write+0x3e3/0x540
   ksys_write+0xbb/0x140
   __x64_sys_write+0x42/0x50
   do_syscall_64+0x34/0x80
   entry_SYSCALL_64_after_hwframe+0x46/0xb0
   </TASK>

Link: https://lore.kernel.org/r/20220727193415.1583860-4-bvanassche@acm.org
Reported-by: Li Zhijian <lizhijian@fujitsu.com>
Tested-by: Li Zhijian <lizhijian@fujitsu.com>
Fixes: a42d985bd5b2 ("ib_srpt: Initial SRP Target merge for v3.3-rc1")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 130 ++++++++++++++++++--------
 drivers/infiniband/ulp/srpt/ib_srpt.h |  10 +-
 2 files changed, 94 insertions(+), 46 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 211d4e82e4ba..c0ed08fcab48 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -565,18 +565,12 @@ static int srpt_refresh_port(struct srpt_port *sport)
 	if (ret)
 		return ret;
 
-	sport->port_guid_id.wwn.priv = sport;
 	srpt_format_guid(sport->guid_name, ARRAY_SIZE(sport->guid_name),
 			 &sport->gid.global.interface_id);
-	memcpy(sport->port_guid_id.name, sport->guid_name,
-	       ARRAY_SIZE(sport->guid_name));
-	sport->port_gid_id.wwn.priv = sport;
 	snprintf(sport->gid_name, ARRAY_SIZE(sport->gid_name),
 		 "0x%016llx%016llx",
 		 be64_to_cpu(sport->gid.global.subnet_prefix),
 		 be64_to_cpu(sport->gid.global.interface_id));
-	memcpy(sport->port_gid_id.name, sport->gid_name,
-	       ARRAY_SIZE(sport->gid_name));
 
 	if (rdma_protocol_iwarp(sport->sdev->device, sport->port))
 		return 0;
@@ -2313,31 +2307,35 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
 	tag_num = ch->rq_size;
 	tag_size = 1; /* ib_srpt does not use se_sess->sess_cmd_map */
 
-	mutex_lock(&sport->port_guid_id.mutex);
-	list_for_each_entry(stpg, &sport->port_guid_id.tpg_list, entry) {
-		if (!IS_ERR_OR_NULL(ch->sess))
-			break;
-		ch->sess = target_setup_session(&stpg->tpg, tag_num,
+	if (sport->guid_id) {
+		mutex_lock(&sport->guid_id->mutex);
+		list_for_each_entry(stpg, &sport->guid_id->tpg_list, entry) {
+			if (!IS_ERR_OR_NULL(ch->sess))
+				break;
+			ch->sess = target_setup_session(&stpg->tpg, tag_num,
 						tag_size, TARGET_PROT_NORMAL,
 						ch->sess_name, ch, NULL);
+		}
+		mutex_unlock(&sport->guid_id->mutex);
 	}
-	mutex_unlock(&sport->port_guid_id.mutex);
 
-	mutex_lock(&sport->port_gid_id.mutex);
-	list_for_each_entry(stpg, &sport->port_gid_id.tpg_list, entry) {
-		if (!IS_ERR_OR_NULL(ch->sess))
-			break;
-		ch->sess = target_setup_session(&stpg->tpg, tag_num,
+	if (sport->gid_id) {
+		mutex_lock(&sport->gid_id->mutex);
+		list_for_each_entry(stpg, &sport->gid_id->tpg_list, entry) {
+			if (!IS_ERR_OR_NULL(ch->sess))
+				break;
+			ch->sess = target_setup_session(&stpg->tpg, tag_num,
 					tag_size, TARGET_PROT_NORMAL, i_port_id,
 					ch, NULL);
-		if (!IS_ERR_OR_NULL(ch->sess))
-			break;
-		/* Retry without leading "0x" */
-		ch->sess = target_setup_session(&stpg->tpg, tag_num,
+			if (!IS_ERR_OR_NULL(ch->sess))
+				break;
+			/* Retry without leading "0x" */
+			ch->sess = target_setup_session(&stpg->tpg, tag_num,
 						tag_size, TARGET_PROT_NORMAL,
 						i_port_id + 2, ch, NULL);
+		}
+		mutex_unlock(&sport->gid_id->mutex);
 	}
-	mutex_unlock(&sport->port_gid_id.mutex);
 
 	if (IS_ERR_OR_NULL(ch->sess)) {
 		WARN_ON_ONCE(ch->sess == NULL);
@@ -2983,7 +2981,12 @@ static int srpt_release_sport(struct srpt_port *sport)
 	return 0;
 }
 
-static struct se_wwn *__srpt_lookup_wwn(const char *name)
+struct port_and_port_id {
+	struct srpt_port *sport;
+	struct srpt_port_id **port_id;
+};
+
+static struct port_and_port_id __srpt_lookup_port(const char *name)
 {
 	struct ib_device *dev;
 	struct srpt_device *sdev;
@@ -2998,25 +3001,38 @@ static struct se_wwn *__srpt_lookup_wwn(const char *name)
 		for (i = 0; i < dev->phys_port_cnt; i++) {
 			sport = &sdev->port[i];
 
-			if (strcmp(sport->port_guid_id.name, name) == 0)
-				return &sport->port_guid_id.wwn;
-			if (strcmp(sport->port_gid_id.name, name) == 0)
-				return &sport->port_gid_id.wwn;
+			if (strcmp(sport->guid_name, name) == 0) {
+				kref_get(&sdev->refcnt);
+				return (struct port_and_port_id){
+					sport, &sport->guid_id};
+			}
+			if (strcmp(sport->gid_name, name) == 0) {
+				kref_get(&sdev->refcnt);
+				return (struct port_and_port_id){
+					sport, &sport->gid_id};
+			}
 		}
 	}
 
-	return NULL;
+	return (struct port_and_port_id){};
 }
 
-static struct se_wwn *srpt_lookup_wwn(const char *name)
+/**
+ * srpt_lookup_port() - Look up an RDMA port by name
+ * @name: ASCII port name
+ *
+ * Increments the RDMA port reference count if an RDMA port pointer is returned.
+ * The caller must drop that reference count by calling srpt_port_put_ref().
+ */
+static struct port_and_port_id srpt_lookup_port(const char *name)
 {
-	struct se_wwn *wwn;
+	struct port_and_port_id papi;
 
 	spin_lock(&srpt_dev_lock);
-	wwn = __srpt_lookup_wwn(name);
+	papi = __srpt_lookup_port(name);
 	spin_unlock(&srpt_dev_lock);
 
-	return wwn;
+	return papi;
 }
 
 static void srpt_free_srq(struct srpt_device *sdev)
@@ -3194,10 +3210,6 @@ static int srpt_add_one(struct ib_device *device)
 		sport->port_attrib.srp_sq_size = DEF_SRPT_SQ_SIZE;
 		sport->port_attrib.use_srq = false;
 		INIT_WORK(&sport->work, srpt_refresh_port_work);
-		mutex_init(&sport->port_guid_id.mutex);
-		INIT_LIST_HEAD(&sport->port_guid_id.tpg_list);
-		mutex_init(&sport->port_gid_id.mutex);
-		INIT_LIST_HEAD(&sport->port_gid_id.tpg_list);
 
 		ret = srpt_refresh_port(sport);
 		if (ret) {
@@ -3298,10 +3310,10 @@ static struct srpt_port_id *srpt_wwn_to_sport_id(struct se_wwn *wwn)
 {
 	struct srpt_port *sport = wwn->priv;
 
-	if (wwn == &sport->port_guid_id.wwn)
-		return &sport->port_guid_id;
-	if (wwn == &sport->port_gid_id.wwn)
-		return &sport->port_gid_id;
+	if (sport->guid_id && &sport->guid_id->wwn == wwn)
+		return sport->guid_id;
+	if (sport->gid_id && &sport->gid_id->wwn == wwn)
+		return sport->gid_id;
 	WARN_ON_ONCE(true);
 	return NULL;
 }
@@ -3816,7 +3828,31 @@ static struct se_wwn *srpt_make_tport(struct target_fabric_configfs *tf,
 				      struct config_group *group,
 				      const char *name)
 {
-	return srpt_lookup_wwn(name) ? : ERR_PTR(-EINVAL);
+	struct port_and_port_id papi = srpt_lookup_port(name);
+	struct srpt_port *sport = papi.sport;
+	struct srpt_port_id *port_id;
+
+	if (!papi.port_id)
+		return ERR_PTR(-EINVAL);
+	if (*papi.port_id) {
+		/* Attempt to create a directory that already exists. */
+		WARN_ON_ONCE(true);
+		return &(*papi.port_id)->wwn;
+	}
+	port_id = kzalloc(sizeof(*port_id), GFP_KERNEL);
+	if (!port_id) {
+		srpt_sdev_put(sport->sdev);
+		return ERR_PTR(-ENOMEM);
+	}
+	mutex_init(&port_id->mutex);
+	INIT_LIST_HEAD(&port_id->tpg_list);
+	port_id->wwn.priv = sport;
+	memcpy(port_id->name, port_id == sport->guid_id ? sport->guid_name :
+	       sport->gid_name, ARRAY_SIZE(port_id->name));
+
+	*papi.port_id = port_id;
+
+	return &port_id->wwn;
 }
 
 /**
@@ -3825,6 +3861,18 @@ static struct se_wwn *srpt_make_tport(struct target_fabric_configfs *tf,
  */
 static void srpt_drop_tport(struct se_wwn *wwn)
 {
+	struct srpt_port_id *port_id = container_of(wwn, typeof(*port_id), wwn);
+	struct srpt_port *sport = wwn->priv;
+
+	if (sport->guid_id == port_id)
+		sport->guid_id = NULL;
+	else if (sport->gid_id == port_id)
+		sport->gid_id = NULL;
+	else
+		WARN_ON_ONCE(true);
+
+	srpt_sdev_put(sport->sdev);
+	kfree(port_id);
 }
 
 static ssize_t srpt_wwn_version_show(struct config_item *item, char *buf)
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 978a338f1f0e..2bf381ecd482 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -393,7 +393,7 @@ struct srpt_port_id {
 };
 
 /**
- * struct srpt_port - information associated by SRPT with a single IB port
+ * struct srpt_port - SRPT RDMA port information
  * @sdev:      backpointer to the HCA information.
  * @mad_agent: per-port management datagram processing information.
  * @enabled:   Whether or not this target port is enabled.
@@ -403,9 +403,9 @@ struct srpt_port_id {
  * @gid:       cached value of the port's gid.
  * @work:      work structure for refreshing the aforementioned cached values.
  * @guid_name: port name in GUID format.
- * @port_guid_id: LIO target port information for the port name in GUID format.
+ * @guid_id:   LIO target port information for the port name in GUID format.
  * @gid_name:  port name in GID format.
- * @port_gid_id: LIO target port information for the port name in GID format.
+ * @gid_id:    LIO target port information for the port name in GID format.
  * @port_attrib:   Port attributes that can be accessed through configfs.
  * @refcount:	   Number of objects associated with this port.
  * @freed_channels: Completion that will be signaled once @refcount becomes 0.
@@ -422,9 +422,9 @@ struct srpt_port {
 	union ib_gid		gid;
 	struct work_struct	work;
 	char			guid_name[64];
-	struct srpt_port_id	port_guid_id;
+	struct srpt_port_id	*guid_id;
 	char			gid_name[64];
-	struct srpt_port_id	port_gid_id;
+	struct srpt_port_id	*gid_id;
 	struct srpt_port_attrib port_attrib;
 	atomic_t		refcount;
 	struct completion	*freed_channels;
-- 
2.35.1



