Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63B26DD013
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 05:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjDKDV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 23:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjDKDVZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 23:21:25 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0718F132
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 20:21:24 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id o2-20020a17090a0a0200b00246da660bd2so781299pjo.0
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 20:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681183283; x=1683775283;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Wv2dX2FXi7aYzQEiamw0zcvZfbxZKwmpV+flWkorMes=;
        b=V8Uoijkv4RZOvQbZ3e7sh2/JYtH6+FPg6n0yZ39QxUDq8r3mafkzhwYoClhbTpdmo2
         3DHpK1UnNB6d8rze3bfLRC5Uglz4xEGW8bd41u5H0wYvUMFDtnYlj8/dO9QpGLLRX/qO
         Fa4OiNxnNDsWJ56/DQAAAE+o2QtUio9gp6oYMUnqqPSRHa2gniI88RT06RZTpWmag06K
         YcNJN4s35NQd4eO0e/KklkVKjLAy0Il5Ifh4v+/vKjr45Gn6s38gPQwEbIfTv1WGFGnV
         qJyh+6g/JJi+bwkW5LfP24THz5xT2CTGoMhOPzVc36FC91Gq+HI2wl5g4Irvm+uIOE+E
         cr0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681183283; x=1683775283;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wv2dX2FXi7aYzQEiamw0zcvZfbxZKwmpV+flWkorMes=;
        b=cJcFouOs80TTsySKAExAqpCkZxYEWYJyOd/5pvzmYj2XbCi/ltEutFZGIrewAPxn42
         0yUgc7CWSUNr2JtA8NdrYnh1qTxTd//Ck2WxAcg7arhaXKenc/lZTvJaABiKl2Y0hOFj
         lY5NxrEJrIAC14jrfkSraoNM1pRZXsex7B90+3AkiDFHlqvHYPOyrgxvzzh7UiTNm1nO
         Ndy4a39tLvnENeMXa/xBCWAgIsUB9WGn6AnTP9dstFLJPXilCnkZqEhTdvZ9i1Xf5p5n
         gj8g/4q91aQmjaeduYm5PrkZ99kIKbWL4z150rauZRZrvcEDigCZsj00E7kOa6a02/zy
         Xiqw==
X-Gm-Message-State: AAQBX9feQJ9xpel+xEvYsmhLtSh9iS8s2xMxJNBt6rhcMmXan8LczttO
        PzZTPCh5gJi3BjUI0K5/uNj3o8f2p+4RcA==
X-Google-Smtp-Source: AKy350aLBODkyYeGK0zcEYx7tQbplmwcTBGJzLNXcF3Da09N8/gu8L0oPVSDzbqofHe6DeladZIpLw==
X-Received: by 2002:a05:6a20:1e68:b0:da:eebd:7f6c with SMTP id cy40-20020a056a201e6800b000daeebd7f6cmr1019308pzb.56.1681183283164;
        Mon, 10 Apr 2023 20:21:23 -0700 (PDT)
Received: from localhost.localdomain ([47.96.236.37])
        by smtp.gmail.com with ESMTPSA id m4-20020a63fd44000000b004ff6b744248sm7743195pgj.48.2023.04.10.20.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 20:21:22 -0700 (PDT)
From:   Yang Bo <yyyeer.bo@gmail.com>
X-Google-Original-From: Yang Bo <yb203166@antfin.com>
To:     stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 1/6] virtiofs: clean up error handling in virtio_fs_get_tree()
Date:   Tue, 11 Apr 2023 11:21:06 +0800
Message-Id: <20230411032111.1213-1-yb203166@antfin.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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

