Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2950E6DEA4B
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 06:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbjDLEUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 00:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDLEUF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 00:20:05 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A3C0524B;
        Tue, 11 Apr 2023 21:20:04 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id 21so1924780plg.12;
        Tue, 11 Apr 2023 21:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681273203; x=1683865203;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iaG9H/lSEJcf7mguAzuXhu8D51amsoNI4XT8e6mNVM0=;
        b=gE9RV8OggSiG+tjZIQSM0KH4R/v6YByA0S8HMkZW236d2wNMa/34J0eOcShTX4ucBY
         rPTpPk8u6XXQeTxf5fJ13xNhbumDwy+E9A8a7RsZ57Pmf3yYs03+5tOCTOV1eMHbi/je
         2KFCa+iNKQ+31OUYd9ZWkfSR9xYy88j+/KW1oiOvA5pYVwbfo65l+Lc2GWcLS7w7p77x
         tP3kCJCYsvuvl2X6PLdjDu1E/YSs0NgbA9QLqBVj+aYe87RmqBhNE9jdtrDn+6Uz7V0k
         OPhgl3/BT3rfisrTa5tQt7qqQxahK5QOjy5LslnMmBEpzcj/cQaFuXptLlkgzS3bZCWs
         fvFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681273203; x=1683865203;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iaG9H/lSEJcf7mguAzuXhu8D51amsoNI4XT8e6mNVM0=;
        b=RrwfW6JesYeyPqH8fTD8aUiRucR8qz7JaHIHOTjJF751rw+hXh8SPgAYuB0g2+RjQS
         s020F86HjVmlp0fX7f8sfMy7UPWWAuNBpU1LugdzObVVqXFtHqlbKDkbKgtYiLTqk0QN
         PsFL85yddFlLkoAFMKXR2zcZYEJCFhXln0gjd1+8w4+X2IqT0ILow7LkA4S11W8vpP1M
         G/6qY1a0vfl6M4w9iizuChYB1OziOMmp1fOvVCGsGonT0lDXVVKR71POSYLT998uubzu
         LsIserKHj+13K8mP4s0oItbmXxdRiGLfbpL/Tquje9yQjGbn9Tivd9X/D0OUpPof7mE9
         vfvw==
X-Gm-Message-State: AAQBX9d2c6D43Vg1HQgJeSAymvJ/q9d7ova/yOA4H72GU0Igy+m0ZgBw
        FHY38qEOpiwmcaOSiSp3e52+SungWfU5aw==
X-Google-Smtp-Source: AKy350aAvoIY5vnuSCfmqqtgJ6H+gQuEPxkr0gVRtmq90vkj+LhJ0iz1NdCP8UT4Cf1WQnYmo4+dWQ==
X-Received: by 2002:a17:902:d091:b0:1a5:254b:e85b with SMTP id v17-20020a170902d09100b001a5254be85bmr1064509plv.34.1681273203343;
        Tue, 11 Apr 2023 21:20:03 -0700 (PDT)
Received: from virtualbox.www.tendawifi.com ([47.96.236.37])
        by smtp.gmail.com with ESMTPSA id t13-20020a1709028c8d00b001a19196af48sm10412381plo.64.2023.04.11.21.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 21:20:02 -0700 (PDT)
From:   Yang Bo <yyyeer.bo@gmail.com>
X-Google-Original-From: Yang Bo <yb203166@antfin.com>
To:     stable@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, mszeredi@redhat.com,
        Yang Bo <yb203166@antfin.com>
Subject: [PATCH 1/6] virtiofs: clean up error handling in virtio_fs_get_tree()
Date:   Wed, 12 Apr 2023 12:19:30 +0800
Message-Id: <20230412041935.1556-2-yb203166@antfin.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412041935.1556-1-yb203166@antfin.com>
References: <20230412041935.1556-1-yb203166@antfin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 833c5a42e28beeefa1f9bd476a63fe8050c1e8ca upstream.

[backport for 5.10.y]

Avoid duplicating error cleanup.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Yang Bo <yb203166@antfin.com>
---
 fs/fuse/virtio_fs.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index b9cfb1165ff4..22d2145ce08d 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -1440,22 +1440,14 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
 		return -EINVAL;
 	}
 
+	err = -ENOMEM;
 	fc = kzalloc(sizeof(struct fuse_conn), GFP_KERNEL);
-	if (!fc) {
-		mutex_lock(&virtio_fs_mutex);
-		virtio_fs_put(fs);
-		mutex_unlock(&virtio_fs_mutex);
-		return -ENOMEM;
-	}
+	if (!fc)
+		goto out_err;
 
 	fm = kzalloc(sizeof(struct fuse_mount), GFP_KERNEL);
-	if (!fm) {
-		mutex_lock(&virtio_fs_mutex);
-		virtio_fs_put(fs);
-		mutex_unlock(&virtio_fs_mutex);
-		kfree(fc);
-		return -ENOMEM;
-	}
+	if (!fm)
+		goto out_err;
 
 	fuse_conn_init(fc, fm, fsc->user_ns, &virtio_fs_fiq_ops, fs);
 	fc->release = fuse_free_conn;
@@ -1483,6 +1475,13 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
 	WARN_ON(fsc->root);
 	fsc->root = dget(sb->s_root);
 	return 0;
+
+out_err:
+	kfree(fc);
+	mutex_lock(&virtio_fs_mutex);
+	virtio_fs_put(fs);
+	mutex_unlock(&virtio_fs_mutex);
+	return err;
 }
 
 static const struct fs_context_operations virtio_fs_context_ops = {
-- 
2.40.0

