Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54AF322D116
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 23:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgGXVii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jul 2020 17:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726835AbgGXVgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jul 2020 17:36:46 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FB8C0619E8
        for <stable@vger.kernel.org>; Fri, 24 Jul 2020 14:36:46 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id gc15so6399362pjb.0
        for <stable@vger.kernel.org>; Fri, 24 Jul 2020 14:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YLy0ZgqcjQnksBvi3DviLt6cbR749pq+3Sg+gKabpfk=;
        b=fKCBbMIZ3wdYF10uVKEMHpjA/Pyc5cd2gK6PF4DES9Hf/TmROG98SwIzq1cz3ecKbE
         4V95zYjMGsp3xFoSuaYl9TLiiKDAAoOMUx0gTdDeVtwLSn8fJo9z9X12CyOAVZQ+m6xX
         /jodBAjN9zbIl5vwaKZj5rSbmxaQztk2wdscQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YLy0ZgqcjQnksBvi3DviLt6cbR749pq+3Sg+gKabpfk=;
        b=PNX9pBUwsZ4UZ0oKE6btMECqvUsdq2NG1dewv8RcDoc4rfIr4bqoxRpY83sqq5ntPB
         Qs/Ft+nto4RAJvGOzT3JGmv6U1u6fOhACgfzrJ0Vd7dFQeLbQAJHigVtffxXUCT6P9a5
         Sc9lUJdrhhsw4Lvm1iDAvl9bCtvc6ybnwLxzJEupgRJZy/KhUBNoWc6KlHYDwAsEJza5
         W//ysMDqAECiGq/BcJK0ngFjobpOf12CgRQ6MDr9HXuVkQKaLWt1GIXukAQ8cuuMd8y6
         W64g8W5YS/L1UeJKcwqoA5ZvUu4j1nOU87CJU3t6z1FXsmyU14B49x0rd2GX905o22iC
         jo2A==
X-Gm-Message-State: AOAM533eOUUC0dhSil2WX07tttRhsydk7a6O95MZlOXMqQmeWCdQm79B
        2DiIvvNc2Oxu7GEcZq1Pohf3KA==
X-Google-Smtp-Source: ABdhPJzEgcuNxLo7+nIkeLiK3TbI31y3cje0lQLd0ywUWaYIzS1iN/WrgbXv7zFopX1hiOOQmatiMw==
X-Received: by 2002:a17:902:446:: with SMTP id 64mr9977003ple.157.1595626605892;
        Fri, 24 Jul 2020 14:36:45 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id o17sm6398650pjq.6.2020.07.24.14.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 14:36:43 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Scott Branden <scott.branden@broadcom.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Jessica Yu <jeyu@kernel.org>, SeongJae Park <sjpark@amazon.de>,
        KP Singh <kpsingh@chromium.org>, linux-efi@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 04/19] fs/kernel_read_file: Remove FIRMWARE_PREALLOC_BUFFER enum
Date:   Fri, 24 Jul 2020 14:36:25 -0700
Message-Id: <20200724213640.389191-5-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200724213640.389191-1-keescook@chromium.org>
References: <20200724213640.389191-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

FIRMWARE_PREALLOC_BUFFER is a "how", not a "what", and confuses the LSMs
that are interested in filtering between types of things. The "how"
should be an internal detail made uninteresting to the LSMs.

Fixes: a098ecd2fa7d ("firmware: support loading into a pre-allocated buffer")
Fixes: fd90bc559bfb ("ima: based on policy verify firmware signatures (pre-allocated buffer)")
Fixes: 4f0496d8ffa3 ("ima: based on policy warn about loading firmware (pre-allocated buffer)")
Cc: stable@vger.kernel.org
Acked-by: Scott Branden <scott.branden@broadcom.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
To aid in backporting, this change is made before moving
kernel_read_file() to separate header/source files.
---
 drivers/base/firmware_loader/main.c | 5 ++---
 fs/exec.c                           | 7 ++++---
 include/linux/fs.h                  | 2 +-
 kernel/module.c                     | 2 +-
 security/integrity/digsig.c         | 2 +-
 security/integrity/ima/ima_fs.c     | 2 +-
 security/integrity/ima/ima_main.c   | 6 ++----
 7 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
index ca871b13524e..c2f57cedcd6f 100644
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -465,14 +465,12 @@ fw_get_filesystem_firmware(struct device *device, struct fw_priv *fw_priv,
 	int i, len;
 	int rc = -ENOENT;
 	char *path;
-	enum kernel_read_file_id id = READING_FIRMWARE;
 	size_t msize = INT_MAX;
 	void *buffer = NULL;
 
 	/* Already populated data member means we're loading into a buffer */
 	if (!decompress && fw_priv->data) {
 		buffer = fw_priv->data;
-		id = READING_FIRMWARE_PREALLOC_BUFFER;
 		msize = fw_priv->allocated_size;
 	}
 
@@ -496,7 +494,8 @@ fw_get_filesystem_firmware(struct device *device, struct fw_priv *fw_priv,
 
 		/* load firmware files from the mount namespace of init */
 		rc = kernel_read_file_from_path_initns(path, &buffer,
-						       &size, msize, id);
+						       &size, msize,
+						       READING_FIRMWARE);
 		if (rc) {
 			if (rc != -ENOENT)
 				dev_warn(device, "loading %s failed with error %d\n",
diff --git a/fs/exec.c b/fs/exec.c
index e6e8a9a70327..2bf549757ce7 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -927,6 +927,7 @@ int kernel_read_file(struct file *file, void **buf, loff_t *size,
 {
 	loff_t i_size, pos;
 	ssize_t bytes = 0;
+	void *allocated = NULL;
 	int ret;
 
 	if (!S_ISREG(file_inode(file)->i_mode) || max_size < 0)
@@ -950,8 +951,8 @@ int kernel_read_file(struct file *file, void **buf, loff_t *size,
 		goto out;
 	}
 
-	if (id != READING_FIRMWARE_PREALLOC_BUFFER)
-		*buf = vmalloc(i_size);
+	if (!*buf)
+		*buf = allocated = vmalloc(i_size);
 	if (!*buf) {
 		ret = -ENOMEM;
 		goto out;
@@ -980,7 +981,7 @@ int kernel_read_file(struct file *file, void **buf, loff_t *size,
 
 out_free:
 	if (ret < 0) {
-		if (id != READING_FIRMWARE_PREALLOC_BUFFER) {
+		if (allocated) {
 			vfree(*buf);
 			*buf = NULL;
 		}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3f881a892ea7..95fc775ed937 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2993,10 +2993,10 @@ static inline void i_readcount_inc(struct inode *inode)
 #endif
 extern int do_pipe_flags(int *, int);
 
+/* This is a list of *what* is being read, not *how*. */
 #define __kernel_read_file_id(id) \
 	id(UNKNOWN, unknown)		\
 	id(FIRMWARE, firmware)		\
-	id(FIRMWARE_PREALLOC_BUFFER, firmware)	\
 	id(FIRMWARE_EFI_EMBEDDED, firmware)	\
 	id(MODULE, kernel-module)		\
 	id(KEXEC_IMAGE, kexec-image)		\
diff --git a/kernel/module.c b/kernel/module.c
index 0c6573b98c36..26105148f4d2 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3988,7 +3988,7 @@ SYSCALL_DEFINE3(finit_module, int, fd, const char __user *, uargs, int, flags)
 {
 	struct load_info info = { };
 	loff_t size;
-	void *hdr;
+	void *hdr = NULL;
 	int err;
 
 	err = may_init_module();
diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
index e9cbadade74b..ac02b7632353 100644
--- a/security/integrity/digsig.c
+++ b/security/integrity/digsig.c
@@ -169,7 +169,7 @@ int __init integrity_add_key(const unsigned int id, const void *data,
 
 int __init integrity_load_x509(const unsigned int id, const char *path)
 {
-	void *data;
+	void *data = NULL;
 	loff_t size;
 	int rc;
 	key_perm_t perm;
diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index e3fcad871861..15a44c5022f7 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -272,7 +272,7 @@ static const struct file_operations ima_ascii_measurements_ops = {
 
 static ssize_t ima_read_policy(char *path)
 {
-	void *data;
+	void *data = NULL;
 	char *datap;
 	loff_t size;
 	int rc, pathlen = strlen(path);
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index c1583d98c5e5..f80ee4ce4669 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -611,19 +611,17 @@ void ima_post_path_mknod(struct dentry *dentry)
 int ima_read_file(struct file *file, enum kernel_read_file_id read_id)
 {
 	/*
-	 * READING_FIRMWARE_PREALLOC_BUFFER
-	 *
 	 * Do devices using pre-allocated memory run the risk of the
 	 * firmware being accessible to the device prior to the completion
 	 * of IMA's signature verification any more than when using two
-	 * buffers?
+	 * buffers? It may be desirable to include the buffer address
+	 * in this API and walk all the dma_map_single() mappings to check.
 	 */
 	return 0;
 }
 
 const int read_idmap[READING_MAX_ID] = {
 	[READING_FIRMWARE] = FIRMWARE_CHECK,
-	[READING_FIRMWARE_PREALLOC_BUFFER] = FIRMWARE_CHECK,
 	[READING_MODULE] = MODULE_CHECK,
 	[READING_KEXEC_IMAGE] = KEXEC_KERNEL_CHECK,
 	[READING_KEXEC_INITRAMFS] = KEXEC_INITRAMFS_CHECK,
-- 
2.25.1

