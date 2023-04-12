Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B37A6DEA4D
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 06:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjDLEUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 00:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjDLEUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 00:20:12 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7675257;
        Tue, 11 Apr 2023 21:20:08 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id 21so1924935plg.12;
        Tue, 11 Apr 2023 21:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681273208; x=1683865208;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XFmD2pzcB4gE5woR4ogxyHFi9XlpeweHTwn/ukivpgM=;
        b=VXGGyynj1Z92gpFIPyfzKvCWeZinD9vYhjAMOvd6VfhxETWiHQG6/XnoC1oOVwpXMW
         xDb6p5KLZQy7D9iqZpxcTLUmfllfBwzQAqnnQ1zBCirZijqqWGPcNk96x+Ys24//3hKg
         WySSyYGGl2JmOEXZ1lDxy934b62QUPcfY+rUBnwmEBEISlLps+BQwlTdKuQGjClJl2tK
         vOMTB6uBUvT7sS0pgjQ03vxvx5gLEidvSFaAkCUgOAxrU/Faehc4eUq5X48ok1RLO6M0
         kRa7C5+cbZ/ca82Sx561VF7UH9AP09mhYNXEVhvUBy5XbznvFTneMhdidzih6hCOUmn+
         9ypw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681273208; x=1683865208;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XFmD2pzcB4gE5woR4ogxyHFi9XlpeweHTwn/ukivpgM=;
        b=v2T2bSDdOgS5RPww7gPhXeAO8eq5wUQEJbMF5NpyoX0hfy6CGyp8jVXGTR1Bz2HDOu
         B+bElu7bPkR+RAdrvoCcs67BGEE/nQzNlqLqTTbl4FxXdstrxyKdqXpP6QgD2KysXcPh
         8+AfbO833IRag4BOm+UzYQi7VuSqPVO7I+mcOjHOh+9IfR21f3iTxs9Xrw91uUatvAd6
         /VE8aHjwvu0po97m1ojvlBdhQ6YShWNGSEOCC2A0hjYj/N9x7EY3G/QErALt+17Rah/G
         +ARKa5StzQzU6gr4ez7PbEBq76IlVztcDwzY/w8Dd1W0UNID2tvTnkR+V+KSJaVrODgu
         zzSQ==
X-Gm-Message-State: AAQBX9clV9d9V+PFXxuJvuLrJpiJON21T0TqI7nxVtbiO/S2zyknDhiB
        TUFMk4cFxG/b5vSMo0r+Ff8Ebpki1tAafQ==
X-Google-Smtp-Source: AKy350Y2zWaO7jNBjLP6E6vnadYBU+56X63AfihZXJFkBvRD06aP6+GwQ2fB7ntSUUhsdNsn1awgdw==
X-Received: by 2002:a17:90b:38ce:b0:246:8f9b:d274 with SMTP id nn14-20020a17090b38ce00b002468f9bd274mr6814417pjb.21.1681273208182;
        Tue, 11 Apr 2023 21:20:08 -0700 (PDT)
Received: from virtualbox.www.tendawifi.com ([47.96.236.37])
        by smtp.gmail.com with ESMTPSA id t13-20020a1709028c8d00b001a19196af48sm10412381plo.64.2023.04.11.21.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 21:20:07 -0700 (PDT)
From:   Yang Bo <yyyeer.bo@gmail.com>
X-Google-Original-From: Yang Bo <yb203166@antfin.com>
To:     stable@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, mszeredi@redhat.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Yang Bo <yb203166@antfin.com>
Subject: [PATCH 2/6] virtiofs: split requests that exceed virtqueue size
Date:   Wed, 12 Apr 2023 12:19:31 +0800
Message-Id: <20230412041935.1556-3-yb203166@antfin.com>
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

From: Connor Kuehl <ckuehl@redhat.com>

commit a7f0d7aab0b4f3f0780b1f77356e2fe7202ac0cb upstream.

[backport for 5.10.y]

If an incoming FUSE request can't fit on the virtqueue, the request is
placed onto a workqueue so a worker can try to resubmit it later where
there will (hopefully) be space for it next time.

This is fine for requests that aren't larger than a virtqueue's maximum
capacity.  However, if a request's size exceeds the maximum capacity of the
virtqueue (even if the virtqueue is empty), it will be doomed to a life of
being placed on the workqueue, removed, discovered it won't fit, and placed
on the workqueue yet again.

Furthermore, from section 2.6.5.3.1 (Driver Requirements: Indirect
Descriptors) of the virtio spec:

  "A driver MUST NOT create a descriptor chain longer than the Queue
  Size of the device."

To fix this, limit the number of pages FUSE will use for an overall
request.  This way, each request can realistically fit on the virtqueue
when it is decomposed into a scattergather list and avoid violating section
2.6.5.3.1 of the virtio spec.

Signed-off-by: Connor Kuehl <ckuehl@redhat.com>
Reviewed-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Yang Bo <yb203166@antfin.com>
---
 fs/fuse/fuse_i.h    |  3 +++
 fs/fuse/inode.c     |  3 ++-
 fs/fuse/virtio_fs.c | 19 +++++++++++++++++--
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index b10cddd72355..ceaa6868386e 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -556,6 +556,9 @@ struct fuse_conn {
 	/** Maxmum number of pages that can be used in a single request */
 	unsigned int max_pages;
 
+	/** Constrain ->max_pages to this value during feature negotiation */
+	unsigned int max_pages_limit;
+
 	/** Input queue */
 	struct fuse_iqueue iq;
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 2ede05df7d06..058bb82dee40 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -710,6 +710,7 @@ void fuse_conn_init(struct fuse_conn *fc, struct fuse_mount *fm,
 	fc->pid_ns = get_pid_ns(task_active_pid_ns(current));
 	fc->user_ns = get_user_ns(user_ns);
 	fc->max_pages = FUSE_DEFAULT_MAX_PAGES_PER_REQ;
+	fc->max_pages_limit = FUSE_MAX_MAX_PAGES;
 
 	INIT_LIST_HEAD(&fc->mounts);
 	list_add(&fm->fc_entry, &fc->mounts);
@@ -1056,7 +1057,7 @@ static void process_init_reply(struct fuse_mount *fm, struct fuse_args *args,
 				fc->abort_err = 1;
 			if (arg->flags & FUSE_MAX_PAGES) {
 				fc->max_pages =
-					min_t(unsigned int, FUSE_MAX_MAX_PAGES,
+					min_t(unsigned int, fc->max_pages_limit,
 					max_t(unsigned int, arg->max_pages, 1));
 			}
 			if (IS_ENABLED(CONFIG_FUSE_DAX) &&
diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 22d2145ce08d..6aaaa74438f3 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -18,6 +18,12 @@
 #include <linux/uio.h>
 #include "fuse_i.h"
 
+/* Used to help calculate the FUSE connection's max_pages limit for a request's
+ * size. Parts of the struct fuse_req are sliced into scattergather lists in
+ * addition to the pages used, so this can help account for that overhead.
+ */
+#define FUSE_HEADER_OVERHEAD    4
+
 /* List of virtio-fs device instances and a lock for the list. Also provides
  * mutual exclusion in device removal and mounting path
  */
@@ -1426,9 +1432,10 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
 {
 	struct virtio_fs *fs;
 	struct super_block *sb;
-	struct fuse_conn *fc;
+	struct fuse_conn *fc = NULL;
 	struct fuse_mount *fm;
-	int err;
+	unsigned int virtqueue_size;
+	int err = -EIO;
 
 	/* This gets a reference on virtio_fs object. This ptr gets installed
 	 * in fc->iq->priv. Once fuse_conn is going away, it calls ->put()
@@ -1440,6 +1447,10 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
 		return -EINVAL;
 	}
 
+	virtqueue_size = virtqueue_get_vring_size(fs->vqs[VQ_REQUEST].vq);
+	if (WARN_ON(virtqueue_size <= FUSE_HEADER_OVERHEAD))
+		goto out_err;
+
 	err = -ENOMEM;
 	fc = kzalloc(sizeof(struct fuse_conn), GFP_KERNEL);
 	if (!fc)
@@ -1454,6 +1465,10 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
 	fc->delete_stale = true;
 	fc->auto_submounts = true;
 
+	/* Tell FUSE to split requests that exceed the virtqueue's size */
+	fc->max_pages_limit = min_t(unsigned int, fc->max_pages_limit,
+				    virtqueue_size - FUSE_HEADER_OVERHEAD);
+
 	fsc->s_fs_info = fm;
 	sb = sget_fc(fsc, virtio_fs_test_super, virtio_fs_set_super);
 	fuse_mount_put(fm);
-- 
2.40.0

