Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3C3652CA7
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 07:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234336AbiLUGDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 01:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234460AbiLUGDo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 01:03:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5668E1E716
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 22:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671602540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tnY3LmLlLBt6rd5j5rYEchSWLdK3pgj1yadT46BPLZ8=;
        b=YSlJ5Txd5XorqdUUMZLxoH32qXk62qODxeHrVRQk9AThsntmDbTojCn8feaUf0ulIVwkm6
        IJJMo22rCVAFcpw8KtA0jGwR+PXLkGQpge1qwEooodsHOmkH/vxUny9lDDhPN2ZWmyc9lv
        fFBmXMJ6cjCnqXoRLSmTpZ44G9yMIuA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-93-_wPmmcpGOAu2_xO5YSSWlA-1; Wed, 21 Dec 2022 01:02:17 -0500
X-MC-Unique: _wPmmcpGOAu2_xO5YSSWlA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13DB43811F47;
        Wed, 21 Dec 2022 06:02:17 +0000 (UTC)
Received: from fedora.redhat.com (ovpn-13-96.pek2.redhat.com [10.72.13.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A2DE62026D4B;
        Wed, 21 Dec 2022 06:02:12 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, mchangir@redhat.com, vshankar@redhat.com,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v5 1/2] ceph: move mount state enum to fs/ceph/super.h
Date:   Wed, 21 Dec 2022 14:02:05 +0800
Message-Id: <20221221060206.1859329-2-xiubli@redhat.com>
In-Reply-To: <20221221060206.1859329-1-xiubli@redhat.com>
References: <20221221060206.1859329-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
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

