Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73EAC57AC7E
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241284AbiGTBSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241398AbiGTBSh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:18:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CDA476C122
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 18:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658279693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=55yHQ44rkH6DdWsZLM6+Nkqv8+VaygTgHAkn6qqUXbI=;
        b=cbBkW2Vvb7F/xksYuyVhniC+NIx8z179lJmBpifzy+46Yt5z3U382dZZaIZKbXloShecwW
        tbC2l0HdjU+Pon4uq3+rkqtC0jTYuNqszu39MAwPCz84v/fR2pu9b4X3V99icNI/oCTr+n
        spmR/iOA3/eai1m4P7I+vklGZ97mbAw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-210-fQMOATj8M1K3KKndC_ZIUQ-1; Tue, 19 Jul 2022 21:14:51 -0400
X-MC-Unique: fQMOATj8M1K3KKndC_ZIUQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C37A98037B7
        for <stable@vger.kernel.org>; Wed, 20 Jul 2022 01:14:50 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E73640D0160;
        Wed, 20 Jul 2022 01:14:50 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     teigland@redhat.com
Cc:     cluster-devel@redhat.com, stable@vger.kernel.org,
        aahringo@redhat.com
Subject: [PATCH dlm/next ] fs: dlm: handle -EBUSY as first
Date:   Tue, 19 Jul 2022 21:14:45 -0400
Message-Id: <20220720011445.2928575-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In case of lock args validation we should at first check on -EBUSY then
on -EINVAL. The -EINVAL conditions checks against lkb state variables
which are not stable in case something is in -EBUSY lkb condition state
e.g. lkb->lkb_grmode. This patch checks at first if -EBUSY condition is
not met, then it's will check on -EINVAL condition.

Cc: stable@vger.kernel.org
Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/lock.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index dac7eb75dba9..c23413da40f5 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -2864,17 +2864,9 @@ static int set_unlock_args(uint32_t flags, void *astarg, struct dlm_args *args)
 static int validate_lock_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 			      struct dlm_args *args)
 {
-	int rv = -EINVAL;
+	int rv = -EBUSY;
 
 	if (args->flags & DLM_LKF_CONVERT) {
-		if (lkb->lkb_flags & DLM_IFL_MSTCPY)
-			goto out;
-
-		if (args->flags & DLM_LKF_QUECVT &&
-		    !__quecvt_compat_matrix[lkb->lkb_grmode+1][args->mode+1])
-			goto out;
-
-		rv = -EBUSY;
 		if (lkb->lkb_status != DLM_LKSTS_GRANTED)
 			goto out;
 
@@ -2884,6 +2876,14 @@ static int validate_lock_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 
 		if (is_overlap(lkb))
 			goto out;
+
+		rv = -EINVAL;
+		if (lkb->lkb_flags & DLM_IFL_MSTCPY)
+			goto out;
+
+		if (args->flags & DLM_LKF_QUECVT &&
+		    !__quecvt_compat_matrix[lkb->lkb_grmode+1][args->mode+1])
+			goto out;
 	}
 
 	lkb->lkb_exflags = args->flags;
-- 
2.31.1

