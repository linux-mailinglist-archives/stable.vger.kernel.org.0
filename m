Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5201564CAD8
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 14:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238273AbiLNNOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 08:14:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238496AbiLNNOB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 08:14:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC031D0C1
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 05:13:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671023600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tnY3LmLlLBt6rd5j5rYEchSWLdK3pgj1yadT46BPLZ8=;
        b=gqQp8iE6cOG3uoUIa9hbwweIvny030u5IP8JY2pGOczMiR1PNEos2plyb9+lfG9eT7OPO2
        nEsdP2gmSjZ9pxTcv8ttMcFAHf9DsebvwltJSOEQuspOF9EeHWmKtnRGXGedZT6r6UilEN
        LOcdamJOSSeDohWqjdp+60PVQ3HdGDQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-21-RhmTpw8wNYKHBimoz7jN-Q-1; Wed, 14 Dec 2022 08:13:17 -0500
X-MC-Unique: RhmTpw8wNYKHBimoz7jN-Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B4F3B100F904;
        Wed, 14 Dec 2022 13:13:16 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D902749BB6A;
        Wed, 14 Dec 2022 13:13:13 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, mchangir@redhat.com, vshankar@redhat.com,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v4 1/2] ceph: move mount state enum to fs/ceph/super.h
Date:   Wed, 14 Dec 2022 21:13:06 +0800
Message-Id: <20221214131307.42618-2-xiubli@redhat.com>
In-Reply-To: <20221214131307.42618-1-xiubli@redhat.com>
References: <20221214131307.42618-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

These flags are only used in ceph filesystem in fs/ceph, so just
move it to the place it should be.

Cc: stable@vger.kernel.org
URL: https://tracker.ceph.com/issues/57686
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/super.h              | 10 ++++++++++
 include/linux/ceph/libceph.h | 10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index e7662ff6f149..0d5cb0983831 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -103,6 +103,16 @@ struct ceph_mount_options {
 	struct fscrypt_dummy_policy dummy_enc_policy;
 };
 
+/* mount state */
+enum {
+	CEPH_MOUNT_MOUNTING,
+	CEPH_MOUNT_MOUNTED,
+	CEPH_MOUNT_UNMOUNTING,
+	CEPH_MOUNT_UNMOUNTED,
+	CEPH_MOUNT_SHUTDOWN,
+	CEPH_MOUNT_RECOVER,
+};
+
 #define CEPH_ASYNC_CREATE_CONFLICT_BITS 8
 
 struct ceph_fs_client {
diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index 00af2c98da75..4497d0a6772c 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -99,16 +99,6 @@ struct ceph_options {
 
 #define CEPH_AUTH_NAME_DEFAULT   "guest"
 
-/* mount state */
-enum {
-	CEPH_MOUNT_MOUNTING,
-	CEPH_MOUNT_MOUNTED,
-	CEPH_MOUNT_UNMOUNTING,
-	CEPH_MOUNT_UNMOUNTED,
-	CEPH_MOUNT_SHUTDOWN,
-	CEPH_MOUNT_RECOVER,
-};
-
 static inline unsigned long ceph_timeout_jiffies(unsigned long timeout)
 {
 	return timeout ?: MAX_SCHEDULE_TIMEOUT;
-- 
2.31.1

