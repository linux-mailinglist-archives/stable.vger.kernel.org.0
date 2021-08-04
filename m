Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7646B3E0624
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 18:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239634AbhHDQsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 12:48:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37044 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239632AbhHDQsV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 12:48:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628095688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=D/r6+kzYMCDVx1VLQXqiLSVKfFaLFfVPLYwPUC+uk6w=;
        b=fUsQThnOFcgnHBBWLyiuF9bshX5rvM1dhxU5scpbcbkFuYZZ/R5JOs5qtf+vePndVz76We
        wZW/NBl6B4pk76RcnWZ7EuDFkQgk2/e8cebbJYFT8d4572gWQ6OayPGZDmgE7kQQL4zNF7
        an/DQhdx02g7ytRjxqmUMdgjsUcDWPg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-jrlCdIc3P4OwL9rpjbE78w-1; Wed, 04 Aug 2021 12:48:07 -0400
X-MC-Unique: jrlCdIc3P4OwL9rpjbE78w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 494098799F9
        for <stable@vger.kernel.org>; Wed,  4 Aug 2021 16:48:06 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5AB755DD68;
        Wed,  4 Aug 2021 16:48:02 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     teigland@redhat.com
Cc:     cluster-devel@redhat.com, stable@vger.kernel.org
Subject: [PATCH] dlm: remove lock_sock to avoid scheduling while atomic
Date:   Wed,  4 Aug 2021 12:48:01 -0400
Message-Id: <20210804164801.962733-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

Before this patch, functions save_callbacks and restore_callbacks
called function lock_sock and release_sock to prevent other processes
from messing with the struct sock while the callbacks were saved and
restored. However, function add_sock calls write_lock_bh prior to
calling it save_callbacks, which disables preempts. So the call to
lock_sock would try to schedule when we can't schedule.

Cc: stable@vger.kernel.org # 4.9.x
Fixes: b81171cb6869 ("DLM: Save and restore socket callbacks properly")
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/lowcomms.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 0d8aaf9c61be..9a9fc5ce1166 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -519,24 +519,20 @@ static void lowcomms_error_report(struct sock *sk)
 /* Note: sk_callback_lock must be locked before calling this function. */
 static void save_callbacks(struct connection *con, struct sock *sk)
 {
-	lock_sock(sk);
 	con->orig_data_ready = sk->sk_data_ready;
 	con->orig_state_change = sk->sk_state_change;
 	con->orig_write_space = sk->sk_write_space;
 	con->orig_error_report = sk->sk_error_report;
-	release_sock(sk);
 }
 
 static void restore_callbacks(struct connection *con, struct sock *sk)
 {
 	write_lock_bh(&sk->sk_callback_lock);
-	lock_sock(sk);
 	sk->sk_user_data = NULL;
 	sk->sk_data_ready = con->orig_data_ready;
 	sk->sk_state_change = con->orig_state_change;
 	sk->sk_write_space = con->orig_write_space;
 	sk->sk_error_report = con->orig_error_report;
-	release_sock(sk);
 	write_unlock_bh(&sk->sk_callback_lock);
 }
 
-- 
2.27.0

