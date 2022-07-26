Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD1D758136A
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 14:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238210AbiGZMvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jul 2022 08:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbiGZMvX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jul 2022 08:51:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8F31D1D32E
        for <stable@vger.kernel.org>; Tue, 26 Jul 2022 05:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658839881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cUZPffc2iGWAkRDa4SlYxAuEhSJ5M3HLG7UhtiIHZEo=;
        b=fB61P8/PZqPEAtfqkiqYO4FS518zF7bVj0sNNhr7VrUtNiG3X5rHTnVFPcZiPyLEGZPjLX
        A+ozN779BGOyQmUEKXy388Z3IJaJsNFyvaGrE1nAF/fIyiL6/zbihHd4WOV1jIzxCTHh7v
        R+78iti0bwaSdsiIqXW63itVNXgoup0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-211-qeZyniYgOuy77UBQR1gM5g-1; Tue, 26 Jul 2022 08:51:20 -0400
X-MC-Unique: qeZyniYgOuy77UBQR1gM5g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 06BCB804197
        for <stable@vger.kernel.org>; Tue, 26 Jul 2022 12:51:20 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D761E492CA4;
        Tue, 26 Jul 2022 12:51:19 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     teigland@redhat.com
Cc:     cluster-devel@redhat.com, stable@vger.kernel.org,
        aahringo@redhat.com
Subject: [PATCHv3 dlm/next 2/2] fs: dlm: fix race between test_bit() and queue_work()
Date:   Tue, 26 Jul 2022 08:51:18 -0400
Message-Id: <20220726125118.955056-3-aahringo@redhat.com>
In-Reply-To: <20220726125118.955056-1-aahringo@redhat.com>
References: <20220726125118.955056-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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

