Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA523F34E1
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 21:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237272AbhHTUAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 16:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236939AbhHTUAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Aug 2021 16:00:17 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E361C061575
        for <stable@vger.kernel.org>; Fri, 20 Aug 2021 12:59:39 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id e9so6923542vst.6
        for <stable@vger.kernel.org>; Fri, 20 Aug 2021 12:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BFNBXlfiJU7uNRzMZwK8IYPx/e+2O5dCtqh9qOHydBo=;
        b=mpKzMuk94btzMQJFlqRWJ7DtUXbYWuWoSDBdL5pr8J1jKUlSIs9uxnCclHFTIbplK8
         UAvUrVd5OfVNONuPbpNlG3xwawOW1nwo7CqhHaaZh9Qja1j0j51F8mXmyeienGZujb9M
         gYjr+bla9oNiHA7KBQVN0glwi/RNVMks4ZhsZgrYGEv4FcRj9BRW0gQCJoX98TyhjmNW
         0QgfxCvoDPGDB12QrhUeHOTLZ/u4j7UCwUqd7sxE9ii33QbcXMoGhsGqmfbd0UK5BWsL
         rH/1hk77JoxmMncWPkoZOVm87Dg0Mqxcozv9X72M7xfeCdlXorzuwNOzwZIA0gftlJPV
         xHqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BFNBXlfiJU7uNRzMZwK8IYPx/e+2O5dCtqh9qOHydBo=;
        b=IZEeN4tbjLehD01PBPjChVHRb5PFtdKtlolZVfWFu+8tYpLzPHeE5mfgmdWFlfcp6C
         SBsMu1znhi6NybuCwWUBQbofYnapWUftyh3XZKSMVnwbIkJX2Gsx7ef4OgHaMR8S9tcm
         UZE1kgx2rNFBWOB7di7YdF9lN7ryNB5n2AenBnrbs1cwuPF4hCZDfuQfJ2Q10dGL+qVh
         cHLFX9a1Jn+ITIwddsyzrGGQucmDkg8eiM/zS24DgPm4RDqTh/t5/GhR9eQwLk/r72f/
         PkUY22knJF1ODW394jz8CHrR2MFuFFChd9s+RCtlzxDfFWK4l+oKpVIHbvOHyoMtGFaU
         9W6w==
X-Gm-Message-State: AOAM530lYNQk0B/R45DiZG2Zm2P4aPo1FOl0XOfG7kljAbF9qUHSghY9
        2XmW2MInkHkvtEJ3dGgbSDtwHOGJnBk=
X-Google-Smtp-Source: ABdhPJwZOAkAKLuYPro2LfdiSR6KnIanCESkBCSwUEjVq+Vu9MqkQ9MvFB0+7kGvwso50b0TjWwYGg==
X-Received: by 2002:a67:6e86:: with SMTP id j128mr18616236vsc.26.1629489578370;
        Fri, 20 Aug 2021 12:59:38 -0700 (PDT)
Received: from leah-cloudtop2.c.googlers.com.com (241.36.196.104.bc.googleusercontent.com. [104.196.36.241])
        by smtp.googlemail.com with ESMTPSA id s11sm616323vsl.8.2021.08.20.12.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 12:59:38 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     miklos@szeredi.hu, Murphy Zhou <jencce.kernel@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH] ovl: add splice file read write helper
Date:   Fri, 20 Aug 2021 19:59:29 +0000
Message-Id: <20210820195929.1926705-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Murphy Zhou <jencce.kernel@gmail.com>

Now overlayfs falls back to use default file splice read
and write, which is not compatiple with overlayfs, returning
EFAULT. xfstests generic/591 can reproduce part of this.

Tested this patch with xfstests auto group tests.

[ Needed in 5.4 to fix a deadlock triggered via
  xfstests overlay/019 -- Leah Rumancik ]

Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/file.c | 47 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 7a08a576f7b2..ab5e92897270 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -9,6 +9,9 @@
 #include <linux/xattr.h>
 #include <linux/uio.h>
 #include <linux/uaccess.h>
+#include <linux/splice.h>
+#include <linux/mm.h>
+#include <linux/fs.h>
 #include "overlayfs.h"
 
 static char ovl_whatisit(struct inode *inode, struct inode *realinode)
@@ -293,6 +296,48 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	return ret;
 }
 
+static ssize_t ovl_splice_read(struct file *in, loff_t *ppos,
+			 struct pipe_inode_info *pipe, size_t len,
+			 unsigned int flags)
+{
+	ssize_t ret;
+	struct fd real;
+	const struct cred *old_cred;
+
+	ret = ovl_real_fdget(in, &real);
+	if (ret)
+		return ret;
+
+	old_cred = ovl_override_creds(file_inode(in)->i_sb);
+	ret = generic_file_splice_read(real.file, ppos, pipe, len, flags);
+	revert_creds(old_cred);
+
+	ovl_file_accessed(in);
+	fdput(real);
+	return ret;
+}
+
+static ssize_t
+ovl_splice_write(struct pipe_inode_info *pipe, struct file *out,
+			  loff_t *ppos, size_t len, unsigned int flags)
+{
+	struct fd real;
+	const struct cred *old_cred;
+	ssize_t ret;
+
+	ret = ovl_real_fdget(out, &real);
+	if (ret)
+		return ret;
+
+	old_cred = ovl_override_creds(file_inode(out)->i_sb);
+	ret = iter_file_splice_write(pipe, real.file, ppos, len, flags);
+	revert_creds(old_cred);
+
+	ovl_file_accessed(out);
+	fdput(real);
+	return ret;
+}
+
 static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct fd real;
@@ -649,6 +694,8 @@ const struct file_operations ovl_file_operations = {
 	.fadvise	= ovl_fadvise,
 	.unlocked_ioctl	= ovl_ioctl,
 	.compat_ioctl	= ovl_compat_ioctl,
+	.splice_read    = ovl_splice_read,
+	.splice_write   = ovl_splice_write,
 
 	.copy_file_range	= ovl_copy_file_range,
 	.remap_file_range	= ovl_remap_file_range,
-- 
2.33.0.rc2.250.ged5fa647cd-goog

