Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6359357D64A
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 23:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233766AbiGUVxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 17:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233828AbiGUVxy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 17:53:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 938B993690
        for <stable@vger.kernel.org>; Thu, 21 Jul 2022 14:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658440432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rcfNYTFwyREDaV1Nfvkh12HnpQ13aA8Y/GR8maGj63A=;
        b=XcA149OgIhZOQ8QWEoCxG5mzZ8YyiPDQwGv4yxq1EHRCMUIDiVMisLFulbFMkH/1WtRTmv
        IuFA8SIwaCTTT9NcyZ7ymgMfV3WDA66EcCyyufK0qxp+44lcUX1h3uZ0Gg27iw++BpcJMk
        DW/ulO6YOyi7GtUNYlaGATxRA5jSfjE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-85-JRSnYuiHNSmRAttJn9NoMQ-1; Thu, 21 Jul 2022 17:53:51 -0400
X-MC-Unique: JRSnYuiHNSmRAttJn9NoMQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE3448001EA
        for <stable@vger.kernel.org>; Thu, 21 Jul 2022 21:53:50 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA1E62026D64;
        Thu, 21 Jul 2022 21:53:50 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     teigland@redhat.com
Cc:     cluster-devel@redhat.com, stable@vger.kernel.org,
        aahringo@redhat.com
Subject: [PATCH dlm/next 3/3] fs: dlm: fix refcount handling for dlm_add_cb()
Date:   Thu, 21 Jul 2022 17:53:40 -0400
Message-Id: <20220721215340.936838-4-aahringo@redhat.com>
In-Reply-To: <20220721215340.936838-1-aahringo@redhat.com>
References: <20220721215340.936838-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Each time dlm_add_cb() queues work or adds the lkb for queuing later to
the ls->ls_cb_delay list it increments a refcount. However if the work
is already queued or being added to the list we need to revert the
incrementation of the refcount. The function dlm_add_cb() can be called
multiple times without handling the related dlm_callback_work() work
function where it's get a put call. This patch reverts the kref_get()
when it's necessary in cases if already queued or not.

In case of dlm_callback_resume() we need to ensure that the
LSFL_CB_DELAY bit is cleared after all ls->ls_cb_delay lkbs are queued for
work. As the ls->ls_cb_delay list handling is there for queuing work for
later it should not be the case that a work was already queued, if so we
drop a warning.

Cc: stable@vger.kernel.org
Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/ast.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/dlm/ast.c b/fs/dlm/ast.c
index 0271796d36b1..68e09ed8234e 100644
--- a/fs/dlm/ast.c
+++ b/fs/dlm/ast.c
@@ -177,6 +177,7 @@ void dlm_add_cb(struct dlm_lkb *lkb, uint32_t flags, int mode, int status,
 {
 	struct dlm_ls *ls = lkb->lkb_resource->res_ls;
 	uint64_t new_seq, prev_seq;
+	bool queued = true;
 	int rv;
 
 	spin_lock(&dlm_cb_seq_spin);
@@ -202,13 +203,19 @@ void dlm_add_cb(struct dlm_lkb *lkb, uint32_t flags, int mode, int status,
 
 		mutex_lock(&ls->ls_cb_mutex);
 		if (test_bit(LSFL_CB_DELAY, &ls->ls_flags)) {
-			if (list_empty(&lkb->lkb_cb_list))
+			if (list_empty(&lkb->lkb_cb_list)) {
 				list_add(&lkb->lkb_cb_list, &ls->ls_cb_delay);
+				queued = false;
+			}
 		} else {
-			queue_work(ls->ls_callback_wq, &lkb->lkb_cb_work);
+			queued = !queue_work(ls->ls_callback_wq, &lkb->lkb_cb_work);
 		}
 		mutex_unlock(&ls->ls_cb_mutex);
+
+		if (queued)
+			dlm_put_lkb(lkb);
 	}
+
  out:
 	mutex_unlock(&lkb->lkb_cb_mutex);
 }
@@ -303,9 +310,7 @@ void dlm_callback_resume(struct dlm_ls *ls)
 {
 	struct dlm_lkb *lkb, *safe;
 	int count = 0, sum = 0;
-	bool empty;
-
-	clear_bit(LSFL_CB_DELAY, &ls->ls_flags);
+	bool empty, queued;
 
 	if (!ls->ls_callback_wq)
 		return;
@@ -314,12 +319,16 @@ void dlm_callback_resume(struct dlm_ls *ls)
 	mutex_lock(&ls->ls_cb_mutex);
 	list_for_each_entry_safe(lkb, safe, &ls->ls_cb_delay, lkb_cb_list) {
 		list_del_init(&lkb->lkb_cb_list);
-		queue_work(ls->ls_callback_wq, &lkb->lkb_cb_work);
+		queued = queue_work(ls->ls_callback_wq, &lkb->lkb_cb_work);
+		WARN_ON_ONCE(!queued);
+
 		count++;
 		if (count == MAX_CB_QUEUE)
 			break;
 	}
 	empty = list_empty(&ls->ls_cb_delay);
+	if (empty)
+		clear_bit(LSFL_CB_DELAY, &ls->ls_flags);
 	mutex_unlock(&ls->ls_cb_mutex);
 
 	sum += count;
-- 
2.31.1

