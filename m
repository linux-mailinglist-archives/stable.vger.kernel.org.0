Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B78C5A9C81
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 18:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234403AbiIAQFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 12:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234810AbiIAQFl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 12:05:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812633E772
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 09:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662048338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mpdcGQ0GF+A0yYLLGVffsdC12t7hCV6cWDG/7dolI9U=;
        b=Vr47MPHow5qxVQY29OUE46Mji0Lh8Bj4TwEHIg8g/XhpgFu4C9x9spIbI6s+sGDxZtmKEr
        fkMq+NasEcKWGbYwSaPPldt/7fb2uSFs2Z5Kzfk+ybtd+Jhh4d4sxSioEU+lCOgzG307rQ
        E0/ymjNJOgdIgKK1+eN/jHrAAJO82OU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-573-rDWru-1BPoWYN2Xf9ufOFA-1; Thu, 01 Sep 2022 12:05:36 -0400
X-MC-Unique: rDWru-1BPoWYN2Xf9ufOFA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF88A801231;
        Thu,  1 Sep 2022 16:05:35 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 82F652166B26;
        Thu,  1 Sep 2022 16:05:35 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     teigland@redhat.com
Cc:     cluster-devel@redhat.com, dan.carpenter@oracle.com,
        stable@vger.kernel.org, aahringo@redhat.com
Subject: [PATCH] fs: dlm: fix possible use after free if tracing
Date:   Thu,  1 Sep 2022 12:05:32 -0400
Message-Id: <20220901160532.2894491-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch fixes a possible use after free if tracing for the specific
event is enabled. To avoid the use after free we introduce a out_put
label like all other user lock specific requests and safe in a boolean
to do a put or not which depends on the execution path of
dlm_user_request().

Cc: stable@vger.kernel.org
Fixes: 7a3de7324c2b ("fs: dlm: trace user space callbacks")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/lock.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index c830feb26384..94a72ede5764 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -5835,6 +5835,7 @@ int dlm_user_request(struct dlm_ls *ls, struct dlm_user_args *ua,
 {
 	struct dlm_lkb *lkb;
 	struct dlm_args args;
+	bool do_put = true;
 	int error;
 
 	dlm_lock_recovery(ls);
@@ -5851,9 +5852,8 @@ int dlm_user_request(struct dlm_ls *ls, struct dlm_user_args *ua,
 		ua->lksb.sb_lvbptr = kzalloc(DLM_USER_LVB_LEN, GFP_NOFS);
 		if (!ua->lksb.sb_lvbptr) {
 			kfree(ua);
-			__put_lkb(ls, lkb);
 			error = -ENOMEM;
-			goto out_trace_end;
+			goto out_put;
 		}
 	}
 #ifdef CONFIG_DLM_DEPRECATED_API
@@ -5867,8 +5867,7 @@ int dlm_user_request(struct dlm_ls *ls, struct dlm_user_args *ua,
 		kfree(ua->lksb.sb_lvbptr);
 		ua->lksb.sb_lvbptr = NULL;
 		kfree(ua);
-		__put_lkb(ls, lkb);
-		goto out_trace_end;
+		goto out_put;
 	}
 
 	/* After ua is attached to lkb it will be freed by dlm_free_lkb().
@@ -5887,8 +5886,7 @@ int dlm_user_request(struct dlm_ls *ls, struct dlm_user_args *ua,
 		error = 0;
 		fallthrough;
 	default:
-		__put_lkb(ls, lkb);
-		goto out_trace_end;
+		goto out_put;
 	}
 
 	/* add this new lkb to the per-process list of locks */
@@ -5896,8 +5894,11 @@ int dlm_user_request(struct dlm_ls *ls, struct dlm_user_args *ua,
 	hold_lkb(lkb);
 	list_add_tail(&lkb->lkb_ownqueue, &ua->proc->locks);
 	spin_unlock(&ua->proc->locks_spin);
- out_trace_end:
+	do_put = false;
+ out_put:
 	trace_dlm_lock_end(ls, lkb, name, namelen, mode, flags, error, false);
+	if (do_put)
+		__put_lkb(ls, lkb);
  out:
 	dlm_unlock_recovery(ls);
 	return error;
-- 
2.31.1

