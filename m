Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B196686BF
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 23:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240222AbjALWUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 17:20:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240290AbjALWUJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 17:20:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360ADFCE4
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673561458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JMm1f2frpbxJdNyR4zkxzGw0Qqo5865oQRkDuBdCmQI=;
        b=O5oXHOsIws0qPBNAbFmZPOeNnuYR5H33rKgoHaIlc/AI3X0my5D4NLKc9pfASTFxdXBQV3
        SvNTepGhYOLDpkKby+QY8bacWp/YdXE5zQNxUDbG0qjStcITvMt4bf+/pf3w5bBA5CalJR
        xbz7OdUpMLC7y6/9C7IO6WvxAa39+oo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-Elzo3rv-MkeHWmgKEMUF4Q-1; Thu, 12 Jan 2023 17:10:56 -0500
X-MC-Unique: Elzo3rv-MkeHWmgKEMUF4Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D8B33813F34
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 22:10:56 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40ABB1121314;
        Thu, 12 Jan 2023 22:10:56 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     teigland@redhat.com
Cc:     cluster-devel@redhat.com, aahringo@redhat.com,
        stable@vger.kernel.org
Subject: [PATCH dlm/next 1/7] fs: dlm: start first midcomms then scand
Date:   Thu, 12 Jan 2023 17:10:31 -0500
Message-Id: <20230112221037.1882548-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The scand kthread can send dlm messages out, especially dlm remove
messages to free memory for unused rsb on other nodes. To send out dlm
messages it is required that midcomms is right initialized. This patch
moves the midcomms start before scand is started.

Cc: stable@vger.kernel.org
Fixes: e7fd41792fc0 ("[DLM] The core of the DLM for GFS2/CLVM")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/lockspace.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index d0b4e2181a5f..99bc96f90779 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -381,23 +381,23 @@ static int threads_start(void)
 {
 	int error;
 
-	error = dlm_scand_start();
+	/* Thread for sending/receiving messages for all lockspace's */
+	error = dlm_midcomms_start();
 	if (error) {
-		log_print("cannot start dlm_scand thread %d", error);
+		log_print("cannot start dlm midcomms %d", error);
 		goto fail;
 	}
 
-	/* Thread for sending/receiving messages for all lockspace's */
-	error = dlm_midcomms_start();
+	error = dlm_scand_start();
 	if (error) {
-		log_print("cannot start dlm midcomms %d", error);
-		goto scand_fail;
+		log_print("cannot start dlm_scand thread %d", error);
+		goto midcomms_fail;
 	}
 
 	return 0;
 
- scand_fail:
-	dlm_scand_stop();
+ midcomms_fail:
+	dlm_midcomms_stop();
  fail:
 	return error;
 }
-- 
2.31.1

