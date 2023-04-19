Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5FD6E76AF
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 11:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbjDSJtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 05:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbjDSJta (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 05:49:30 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A065259F5;
        Wed, 19 Apr 2023 02:49:29 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-63b5c4c76aaso2251832b3a.2;
        Wed, 19 Apr 2023 02:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681897769; x=1684489769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XFmD2pzcB4gE5woR4ogxyHFi9XlpeweHTwn/ukivpgM=;
        b=hFswG54HuXGkrLNbrA+NwYpJpe5JEwXOgHNcICUMQSAhRfrK95mrvPyofjtBf+hfn6
         Eh0oMSdKJVfSgUXRlqWNwOku/6LaHv4nUcjVDWZn2Aq7n6Sh1bfkdd5jvO1hxxxc83Je
         bBwfJ54g7NIKRfTsfD8P31aELWLcGzA6JG8n2fdFVxynSk4QD+QvHv7n0NKR94joAuS9
         nb9Q2orwrvvHhl4M3eg6fyRqjW1WC7wUkf2/9mX7bJeA7LXxW1wVirEROo7SYZVjPJh2
         obA+9AN2o+dUUN17qSGVUHlzIaPfWZE+1ZDWekspEyV/5BGl2G6cIzXYoIziYLpr0CEB
         7HHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681897769; x=1684489769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XFmD2pzcB4gE5woR4ogxyHFi9XlpeweHTwn/ukivpgM=;
        b=fEsGk0X4bw32Ah4QSzLXNm1Ldev+x2vP9cdkOEUNHNozay0gomxopOXn0dXRqUf50c
         lD+xZW2wfXfvu3XsS4rnY2T328qd3Sw8+dmtKR1L+oohFK0CyxyS3hAMog2f4JTYGW1j
         q2OG1wjdDNXq7j1apbmmIvVYbn7QDH1aDPBjGWyLVXwNegDRnmYu6ls4+TePyQm3OoOk
         evo5PnXlNdZed9LRnflbq3oX+AU0/KrsAhQIWuP3vPqgloLkTzKMtEW6bd/0XCcSr3w5
         0r4tuQ+0033UH0ybUyBaiU/AtXtuN7AoqxJs72j2RTvfkTXuOxfxkayHu5DUNzZlXIzJ
         HXnQ==
X-Gm-Message-State: AAQBX9eUsyj3AQPnxNq2LU4Wn+hm95naSAI9DVpoEYuutyRetl15nx71
        JQC44wGqnPCUgfFOvnUrcwWnCClGot5QFw==
X-Google-Smtp-Source: AKy350b3gcUJJXRc7d6Eq56Fje4ZYJnVWPS24Dsink3hLf5Ww/LO8OnW6iY/sE3EUn2GmQuD17DTtQ==
X-Received: by 2002:a05:6a00:2e01:b0:637:253a:531c with SMTP id fc1-20020a056a002e0100b00637253a531cmr3578973pfb.27.1681897768700;
        Wed, 19 Apr 2023 02:49:28 -0700 (PDT)
Received: from localhost.localdomain ([47.96.236.37])
        by smtp.gmail.com with ESMTPSA id g15-20020a62e30f000000b0063b86aff031sm6231207pfh.108.2023.04.19.02.49.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 02:49:28 -0700 (PDT)
From:   Yang Bo <yyyeer.bo@gmail.com>
X-Google-Original-From: Yang Bo <yb203166@antfin.com>
To:     stable@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, mszeredi@redhat.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Yang Bo <yb203166@antfin.com>
Subject: [PATCH 2/6] virtiofs: split requests that exceed virtqueue size
Date:   Wed, 19 Apr 2023 17:48:40 +0800
Message-Id: <20230419094844.51110-3-yb203166@antfin.com>
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

