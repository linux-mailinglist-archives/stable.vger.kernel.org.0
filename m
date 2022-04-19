Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7764250777D
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 20:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356509AbiDSSQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 14:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiDSSPZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 14:15:25 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594253DA67;
        Tue, 19 Apr 2022 11:12:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 375FECE18A1;
        Tue, 19 Apr 2022 18:12:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C83C385AC;
        Tue, 19 Apr 2022 18:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650391937;
        bh=ol0lgWN959R6L5IddBQq5qQzGU96CwPOXcXBg6Qv/Uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GSUeLBfNCYJBYIH1MyV0Duoe/1YwIdNe9aCFYvJpez+dIhufY1/zR1T531pe30NX2
         7ILHd/Duz/oJlYtihkzD3w8Gj5R7zM31tC2V0q5lu3grbTuJC7hMqUxQR5noY7wxmL
         kA/jIL5rovYs2RHeQovqNIKeYRTwErab9m7KXBC3dudmD/VC48VSE9cx7ypwTJV4nw
         M0nTw3QD9uTS/67LE46AhwnfS5rdxGFHuc+im0ahjpq7HjUO2lt4GNtLNcIWVGcFVy
         OpYaxyUsvZz24Eug4GRip2o5bvm7nZEfok5ggMtTX8CruRELlF8fASkYVo2MZzdBgO
         44XkOquEk9BWw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Wu Bo <wubo40@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 24/34] scsi: iscsi: Release endpoint ID when its freed
Date:   Tue, 19 Apr 2022 14:10:51 -0400
Message-Id: <20220419181104.484667-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181104.484667-1-sashal@kernel.org>
References: <20220419181104.484667-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 3c6ae371b8a1ffba1fc415989fd581ebf841ed0a ]

We can't release the endpoint ID until all references to the endpoint have
been dropped or it could be allocated while in use. This has us use an idr
instead of looping over all conns to find a free ID and then free the ID
when all references have been dropped instead of when the device is only
deleted.

Link: https://lore.kernel.org/r/20220408001314.5014-4-michael.christie@oracle.com
Tested-by: Manish Rangankar <mrangankar@marvell.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Chris Leech <cleech@redhat.com>
Reviewed-by: Wu Bo <wubo40@huawei.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 71 ++++++++++++++---------------
 include/scsi/scsi_transport_iscsi.h |  2 +-
 2 files changed, 36 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 03cda2da80ef..e5f5ec631b55 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -86,6 +86,9 @@ struct iscsi_internal {
 	struct transport_container session_cont;
 };
 
+static DEFINE_IDR(iscsi_ep_idr);
+static DEFINE_MUTEX(iscsi_ep_idr_mutex);
+
 static atomic_t iscsi_session_nr; /* sysfs session id for next new session */
 static struct workqueue_struct *iscsi_eh_timer_workq;
 
@@ -169,6 +172,11 @@ struct device_attribute dev_attr_##_prefix##_##_name =	\
 static void iscsi_endpoint_release(struct device *dev)
 {
 	struct iscsi_endpoint *ep = iscsi_dev_to_endpoint(dev);
+
+	mutex_lock(&iscsi_ep_idr_mutex);
+	idr_remove(&iscsi_ep_idr, ep->id);
+	mutex_unlock(&iscsi_ep_idr_mutex);
+
 	kfree(ep);
 }
 
@@ -181,7 +189,7 @@ static ssize_t
 show_ep_handle(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct iscsi_endpoint *ep = iscsi_dev_to_endpoint(dev);
-	return sysfs_emit(buf, "%llu\n", (unsigned long long) ep->id);
+	return sysfs_emit(buf, "%d\n", ep->id);
 }
 static ISCSI_ATTR(ep, handle, S_IRUGO, show_ep_handle, NULL);
 
@@ -194,48 +202,32 @@ static struct attribute_group iscsi_endpoint_group = {
 	.attrs = iscsi_endpoint_attrs,
 };
 
-#define ISCSI_MAX_EPID -1
-
-static int iscsi_match_epid(struct device *dev, const void *data)
-{
-	struct iscsi_endpoint *ep = iscsi_dev_to_endpoint(dev);
-	const uint64_t *epid = data;
-
-	return *epid == ep->id;
-}
-
 struct iscsi_endpoint *
 iscsi_create_endpoint(int dd_size)
 {
-	struct device *dev;
 	struct iscsi_endpoint *ep;
-	uint64_t id;
-	int err;
-
-	for (id = 1; id < ISCSI_MAX_EPID; id++) {
-		dev = class_find_device(&iscsi_endpoint_class, NULL, &id,
-					iscsi_match_epid);
-		if (!dev)
-			break;
-		else
-			put_device(dev);
-	}
-	if (id == ISCSI_MAX_EPID) {
-		printk(KERN_ERR "Too many connections. Max supported %u\n",
-		       ISCSI_MAX_EPID - 1);
-		return NULL;
-	}
+	int err, id;
 
 	ep = kzalloc(sizeof(*ep) + dd_size, GFP_KERNEL);
 	if (!ep)
 		return NULL;
 
+	mutex_lock(&iscsi_ep_idr_mutex);
+	id = idr_alloc(&iscsi_ep_idr, ep, 0, -1, GFP_NOIO);
+	if (id < 0) {
+		mutex_unlock(&iscsi_ep_idr_mutex);
+		printk(KERN_ERR "Could not allocate endpoint ID. Error %d.\n",
+		       id);
+		goto free_ep;
+	}
+	mutex_unlock(&iscsi_ep_idr_mutex);
+
 	ep->id = id;
 	ep->dev.class = &iscsi_endpoint_class;
-	dev_set_name(&ep->dev, "ep-%llu", (unsigned long long) id);
+	dev_set_name(&ep->dev, "ep-%d", id);
 	err = device_register(&ep->dev);
         if (err)
-                goto free_ep;
+		goto free_id;
 
 	err = sysfs_create_group(&ep->dev.kobj, &iscsi_endpoint_group);
 	if (err)
@@ -249,6 +241,10 @@ iscsi_create_endpoint(int dd_size)
 	device_unregister(&ep->dev);
 	return NULL;
 
+free_id:
+	mutex_lock(&iscsi_ep_idr_mutex);
+	idr_remove(&iscsi_ep_idr, id);
+	mutex_unlock(&iscsi_ep_idr_mutex);
 free_ep:
 	kfree(ep);
 	return NULL;
@@ -276,14 +272,17 @@ EXPORT_SYMBOL_GPL(iscsi_put_endpoint);
  */
 struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle)
 {
-	struct device *dev;
+	struct iscsi_endpoint *ep;
 
-	dev = class_find_device(&iscsi_endpoint_class, NULL, &handle,
-				iscsi_match_epid);
-	if (!dev)
-		return NULL;
+	mutex_lock(&iscsi_ep_idr_mutex);
+	ep = idr_find(&iscsi_ep_idr, handle);
+	if (!ep)
+		goto unlock;
 
-	return iscsi_dev_to_endpoint(dev);
+	get_device(&ep->dev);
+unlock:
+	mutex_unlock(&iscsi_ep_idr_mutex);
+	return ep;
 }
 EXPORT_SYMBOL_GPL(iscsi_lookup_endpoint);
 
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index c5d7810fd792..dde93afe56cd 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -294,7 +294,7 @@ extern void iscsi_host_for_each_session(struct Scsi_Host *shost,
 struct iscsi_endpoint {
 	void *dd_data;			/* LLD private data */
 	struct device dev;
-	uint64_t id;
+	int id;
 	struct iscsi_cls_conn *conn;
 };
 
-- 
2.35.1

