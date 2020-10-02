Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5CA28196F
	for <lists+stable@lfdr.de>; Fri,  2 Oct 2020 19:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbgJBRif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Oct 2020 13:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388286AbgJBRie (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Oct 2020 13:38:34 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24BAC0613E3
        for <stable@vger.kernel.org>; Fri,  2 Oct 2020 10:38:34 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 5so1237886pgf.5
        for <stable@vger.kernel.org>; Fri, 02 Oct 2020 10:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zaz5SJSv7A3XIuY8irUlDYqrESCe7gCcbO5tyaj03YU=;
        b=P86pB/HXvB1w66ujMKVlopbZUXuUA9r/mPIuYxOvuiet70Gi6UIgoN+Kxio24CM2/7
         JfgmdRD8tgSfN3CFJ4Y75Bc4bn3m64UX/3OdRDLmD2nFCO6GweQosA22/MJXNgddI2Ip
         1C480tVdsX9QUYYwIHMsDzV2XEJnCWfTsf7Xc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zaz5SJSv7A3XIuY8irUlDYqrESCe7gCcbO5tyaj03YU=;
        b=Mgw0kTYyZ+yZIkhkssaIoY6mIg0MswgwqQt/hxQbty56TKcQktRy2ioWydTLpEg7uN
         qQyJuyVrbDmVCds/3UhvZvNKXmqnu3wAAefEMEMR2JbgDXZ/pqnSH7BEorX+OIRA7c6E
         LWsUcjHN16dyGNLOz+Y0viz2/qQloVSAmzBbgmjUxZYj6/6J8i/fGT1U+2gaKhjfVNi2
         S1F2U6AkJPfyBGYcDXcjATiYOW1ICbzFxuwsOoV+J9FgNMdGpqwkFNjaBFEJuZg0Pd32
         XTpeIHfbBBlI1JpOqcC04ox15bqsZGTAC21jEHh4tAKacxuAqvf40Q8TgrBNdSUfrDYh
         G5Rw==
X-Gm-Message-State: AOAM530uSe6GSwC4PfB9gwg03Tu73GXBSCkhaut/IoNXc9zdypJacntt
        OUg5UrbLl7n7/F+AS31IBoXrww==
X-Google-Smtp-Source: ABdhPJxJZ5x2VgwvjB+CQFTtiG0FWPNxJc97Kyr4F/xETn9n8wWrhHY845HJDJm4z1m1PHBe9jXOTw==
X-Received: by 2002:a63:121f:: with SMTP id h31mr3361167pgl.274.1601660313889;
        Fri, 02 Oct 2020 10:38:33 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j25sm2609285pfn.212.2020.10.02.10.38.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 10:38:33 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Scott Branden <scott.branden@broadcom.com>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Jessica Yu <jeyu@kernel.org>, SeongJae Park <sjpark@amazon.de>,
        KP Singh <kpsingh@chromium.org>, linux-efi@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 01/16] fs/kernel_read_file: Remove FIRMWARE_PREALLOC_BUFFER enum
Date:   Fri,  2 Oct 2020 10:38:13 -0700
Message-Id: <20201002173828.2099543-2-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201002173828.2099543-1-keescook@chromium.org>
References: <20201002173828.2099543-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

FIRMWARE_PREALLOC_BUFFER is a "how", not a "what", and confuses the LSMs
that are interested in filtering between types of things. The "how"
should be an internal detail made uninteresting to the LSMs.

Fixes: a098ecd2fa7d ("firmware: support loading into a pre-allocated buffer")
Fixes: fd90bc559bfb ("ima: based on policy verify firmware signatures (pre-allocated buffer)")
Fixes: 4f0496d8ffa3 ("ima: based on policy warn about loading firmware (pre-allocated buffer)")
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Acked-by: Scott Branden <scott.branden@broadcom.com>
Cc: stable@vger.kernel.org
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
index 63b9714a0154..b0ec2721f55d 100644
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -470,14 +470,12 @@ fw_get_filesystem_firmware(struct device *device, struct fw_priv *fw_priv,
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
 
@@ -501,7 +499,8 @@ fw_get_filesystem_firmware(struct device *device, struct fw_priv *fw_priv,
 
 		/* load firmware files from the mount namespace of init */
 		rc = kernel_read_file_from_path_initns(path, &buffer,
-						       &size, msize, id);
+						       &size, msize,
+						       READING_FIRMWARE);
 		if (rc) {
 			if (rc != -ENOENT)
 				dev_warn(device, "loading %s failed with error %d\n",
diff --git a/fs/exec.c b/fs/exec.c
index a91003e28eaa..9233cd50dc4c 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -954,6 +954,7 @@ int kernel_read_file(struct file *file, void **buf, loff_t *size,
 {
 	loff_t i_size, pos;
 	ssize_t bytes = 0;
+	void *allocated = NULL;
 	int ret;
 
 	if (!S_ISREG(file_inode(file)->i_mode) || max_size < 0)
@@ -977,8 +978,8 @@ int kernel_read_file(struct file *file, void **buf, loff_t *size,
 		goto out;
 	}
 
-	if (id != READING_FIRMWARE_PREALLOC_BUFFER)
-		*buf = vmalloc(i_size);
+	if (!*buf)
+		*buf = allocated = vmalloc(i_size);
 	if (!*buf) {
 		ret = -ENOMEM;
 		goto out;
@@ -1007,7 +1008,7 @@ int kernel_read_file(struct file *file, void **buf, loff_t *size,
 
 out_free:
 	if (ret < 0) {
-		if (id != READING_FIRMWARE_PREALLOC_BUFFER) {
+		if (allocated) {
 			vfree(*buf);
 			*buf = NULL;
 		}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7519ae003a08..7336e22d0c5d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2858,10 +2858,10 @@ static inline void i_readcount_inc(struct inode *inode)
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
index 1c5cff34d9f2..b2808acac46b 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -4035,7 +4035,7 @@ SYSCALL_DEFINE3(finit_module, int, fd, const char __user *, uargs, int, flags)
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
index 8a91711ca79b..2f187784c5bc 100644
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

