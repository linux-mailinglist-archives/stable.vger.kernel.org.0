Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271D34F6AB2
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 21:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbiDFUAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 16:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232717AbiDFT7z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 15:59:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D1669939B7
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 10:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649266460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IyvFf+DCL2hc/t3WsFdKzZll3I/o2aU4yKX6j4s525g=;
        b=PnBdfTCjIfCG22AZXBLnLDNA1mQ13b5MG+xvdcCIxkX2myX2oPy+0xtN/sf/BUx0rUMila
        3ieMKp2Qc/S2dAJdmQTxjsp2LeFLrwTfGULJJxiI4K44gWcMv+L/ChByko2DPCn5V55iH/
        l4WkEPrhBeeTpQpbZ3iBpJ8s8Ve9pOE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-6WLyUdY9PD6WFmBA_VIRgg-1; Wed, 06 Apr 2022 13:34:18 -0400
X-MC-Unique: 6WLyUdY9PD6WFmBA_VIRgg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 681CF899EDA
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 17:34:18 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7905640D2825;
        Wed,  6 Apr 2022 17:34:17 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     teigland@redhat.com
Cc:     cluster-devel@redhat.com, stable@vger.kernel.org,
        aahringo@redhat.com
Subject: [PATCH dlm/next 1/2] fs: dlm: fix wake_up() calls for pending remove
Date:   Wed,  6 Apr 2022 13:34:15 -0400
Message-Id: <20220406173416.3882304-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch move the wake_up() call at the point when a remove message
completed. Before it was only when a remove message was going to be
sent. The possible waiter in wait_pending_remove() waits until a remove
is done if the resource name matches with the per ls variable
ls->ls_remove_name. If this is the case we must wait until a pending
remove is done which is indicated if DLM_WAIT_PENDING_COND() returns
false which will always be the case when ls_remove_len and
ls_remove_name are unset to indicate that a remove is not going on
anymore.

Fixes: 21d9ac1a5376 ("fs: dlm: use event based wait for pending remove")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/lock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 29e80039e7ca..137cf09b51e5 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -1810,7 +1810,6 @@ static void shrink_bucket(struct dlm_ls *ls, int b)
 		memcpy(ls->ls_remove_name, name, DLM_RESNAME_MAXLEN);
 		spin_unlock(&ls->ls_remove_spin);
 		spin_unlock(&ls->ls_rsbtbl[b].lock);
-		wake_up(&ls->ls_remove_wait);
 
 		send_remove(r);
 
@@ -1819,6 +1818,7 @@ static void shrink_bucket(struct dlm_ls *ls, int b)
 		ls->ls_remove_len = 0;
 		memset(ls->ls_remove_name, 0, DLM_RESNAME_MAXLEN);
 		spin_unlock(&ls->ls_remove_spin);
+		wake_up(&ls->ls_remove_wait);
 
 		dlm_free_rsb(r);
 	}
@@ -4096,7 +4096,6 @@ static void send_repeat_remove(struct dlm_ls *ls, char *ms_name, int len)
 	memcpy(ls->ls_remove_name, name, DLM_RESNAME_MAXLEN);
 	spin_unlock(&ls->ls_remove_spin);
 	spin_unlock(&ls->ls_rsbtbl[b].lock);
-	wake_up(&ls->ls_remove_wait);
 
 	rv = _create_message(ls, sizeof(struct dlm_message) + len,
 			     dir_nodeid, DLM_MSG_REMOVE, &ms, &mh);
@@ -4112,6 +4111,7 @@ static void send_repeat_remove(struct dlm_ls *ls, char *ms_name, int len)
 	ls->ls_remove_len = 0;
 	memset(ls->ls_remove_name, 0, DLM_RESNAME_MAXLEN);
 	spin_unlock(&ls->ls_remove_spin);
+	wake_up(&ls->ls_remove_wait);
 }
 
 static int receive_request(struct dlm_ls *ls, struct dlm_message *ms)
-- 
2.31.1

