Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA4195804DB
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 21:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiGYTxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 15:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiGYTx3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 15:53:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 87DAC20BFD
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 12:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658778807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cUZPffc2iGWAkRDa4SlYxAuEhSJ5M3HLG7UhtiIHZEo=;
        b=PHPm5Wf+9vvjAbwJWybZs+aJWOb8n4w/uH54qf60ISpaDIu2Yx1UYoz+5IuyGQi9l7mKLA
        7zJiAEAEmaaHSryiPQCtWNM+BJxWQC8a/yUaef1FoBb+rP2jniRRS+qW2Ssml9FnT4iOGM
        TAPFPhgCjnSFnwi36cbaqY0TJGMKpIY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-kRFgp9EwM9uX2X1_J78yug-1; Mon, 25 Jul 2022 15:53:25 -0400
X-MC-Unique: kRFgp9EwM9uX2X1_J78yug-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9669C85A584
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 19:53:25 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 73DAF2026614;
        Mon, 25 Jul 2022 19:53:25 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     teigland@redhat.com
Cc:     cluster-devel@redhat.com, stable@vger.kernel.org,
        aahringo@redhat.com
Subject: [PATCHv2 dlm/next 2/2] fs: dlm: fix race between test_bit() and queue_work()
Date:   Mon, 25 Jul 2022 15:53:22 -0400
Message-Id: <20220725195322.857226-3-aahringo@redhat.com>
In-Reply-To: <20220725195322.857226-1-aahringo@redhat.com>
References: <20220725195322.857226-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch will fix a race by surround ls_cb_mutex in set_bit() and the
test_bit() and it's conditional code blocks for LSFL_CB_DELAY.

The function dlm_callback_stop() has the idea to stop all callbacks and
flush all currently queued onces. The set_bit() is not enough because
there can be still queue_work() around after the workqueue was flushed.
To avoid queue_work() after set_bit() we surround both by ls_cb_mutex
lock.

Cc: stable@vger.kernel.org
Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/ast.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/ast.c b/fs/dlm/ast.c
index 19ef136f9e4f..a44cc42b6317 100644
--- a/fs/dlm/ast.c
+++ b/fs/dlm/ast.c
@@ -200,13 +200,13 @@ void dlm_add_cb(struct dlm_lkb *lkb, uint32_t flags, int mode, int status,
 	if (!prev_seq) {
 		kref_get(&lkb->lkb_ref);
 
+		mutex_lock(&ls->ls_cb_mutex);
 		if (test_bit(LSFL_CB_DELAY, &ls->ls_flags)) {
-			mutex_lock(&ls->ls_cb_mutex);
 			list_add(&lkb->lkb_cb_list, &ls->ls_cb_delay);
-			mutex_unlock(&ls->ls_cb_mutex);
 		} else {
 			queue_work(ls->ls_callback_wq, &lkb->lkb_cb_work);
 		}
+		mutex_unlock(&ls->ls_cb_mutex);
 	}
  out:
 	mutex_unlock(&lkb->lkb_cb_mutex);
@@ -288,7 +288,9 @@ void dlm_callback_stop(struct dlm_ls *ls)
 
 void dlm_callback_suspend(struct dlm_ls *ls)
 {
+	mutex_lock(&ls->ls_cb_mutex);
 	set_bit(LSFL_CB_DELAY, &ls->ls_flags);
+	mutex_unlock(&ls->ls_cb_mutex);
 
 	if (ls->ls_callback_wq)
 		flush_workqueue(ls->ls_callback_wq);
-- 
2.31.1

