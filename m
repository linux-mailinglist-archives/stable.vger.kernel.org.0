Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55EA76E76AD
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 11:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232526AbjDSJt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 05:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232488AbjDSJtZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 05:49:25 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25C84C01;
        Wed, 19 Apr 2023 02:49:24 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-63b70f0b320so3047839b3a.1;
        Wed, 19 Apr 2023 02:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681897764; x=1684489764;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iaG9H/lSEJcf7mguAzuXhu8D51amsoNI4XT8e6mNVM0=;
        b=avZuHYFfbG/VsPkgYIDwlWmaiiHc3Qa/QJPMXi0QQ2LEpQupmArKRx8Z7smMqORguq
         u0X/2a/fv6U0gbdAn6AdolS4WVuogYC78XHx8aJtXZLdfULnAWemchgXfvZxnMEhV44S
         t9LFrI5mRIUtCarH2RZ5jlhsyQhMJbOH9We5fwAMClrMcu93EoH2sZvhd1w3i7AAJSCF
         s9rYgx+sWj6MxB+iZbJycOUrx3lY+0yb4JnU//dasic2vquUjHHkxh/Ne2G0ER1ssLx7
         8eQP/TsIEcQnkOU28T5Fy/8+dCrw/JdBLnubIuXiirEwig4lkUq4vr43L6lBl7//lXyB
         PjiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681897764; x=1684489764;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iaG9H/lSEJcf7mguAzuXhu8D51amsoNI4XT8e6mNVM0=;
        b=UMsbl0mRwzymckLFv6mgskKyuyalPJDe2rnRUqPN9TnllF2QqphAbCFKxOWKco6Dwl
         usi6Uz4zhCEjrVDz7Iq3lPY8Uc3FUFVEkJt7Hde8E5/NTExSOHDThwx0K4Gwn7pEPNMf
         QTVTB5C8Ctg6ZMkiwAz5TvDwZuLtwWx97N5L/wYIVRJrYLq9DzzVzHRbatbNeXlfrM/w
         dKagz3IuxZlo9pVoQqNRwz67seWQcnXu1N0zxnEHy0v9XCIMFyY70f3DTNIoiC+Qc0PH
         W51z2tXzwlAIvW7Dqv1d0V6H/00krhGWCRjnPwTwQJtFWNfJpFL+wbdC1fmi3QOS7ITy
         ndBQ==
X-Gm-Message-State: AAQBX9c+FxhDvfMEYKM7eBQCmk4687U9eQckzZpsxd6WwmCL0rWxAwCM
        Np99Qh3YgD6CwYq+8XBWyzpp5FONBfJY5g==
X-Google-Smtp-Source: AKy350b1jrMLvxu8KgwyzZEstRVYugYdTgFr1S2v4b8fFsBgcjN+TMmoXASZTZpqqkl39IRP93e1OA==
X-Received: by 2002:a05:6a00:1407:b0:63c:6485:d5fd with SMTP id l7-20020a056a00140700b0063c6485d5fdmr3417052pfu.2.1681897763945;
        Wed, 19 Apr 2023 02:49:23 -0700 (PDT)
Received: from localhost.localdomain ([47.96.236.37])
        by smtp.gmail.com with ESMTPSA id g15-20020a62e30f000000b0063b86aff031sm6231207pfh.108.2023.04.19.02.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 02:49:23 -0700 (PDT)
From:   Yang Bo <yyyeer.bo@gmail.com>
X-Google-Original-From: Yang Bo <yb203166@antfin.com>
To:     stable@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, mszeredi@redhat.com,
        Yang Bo <yb203166@antfin.com>
Subject: [PATCH 1/6] virtiofs: clean up error handling in virtio_fs_get_tree()
Date:   Wed, 19 Apr 2023 17:48:39 +0800
Message-Id: <20230419094844.51110-2-yb203166@antfin.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230419094844.51110-1-yb203166@antfin.com>
References: <20230419094844.51110-1-yb203166@antfin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

