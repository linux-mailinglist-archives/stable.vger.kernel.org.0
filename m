Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D60A2A5205
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730596AbgKCUqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:46:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:34866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731125AbgKCUqA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:46:00 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BEFA22404;
        Tue,  3 Nov 2020 20:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436359;
        bh=CActLLvD+q74dzhnUMx7ltTT/sprag6VygVBUVQD3HI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=REigPqKFDuP+L2WCZyhnFHTAVeLK6WhvBkZJhfM5OBkEIkk0HMxAnVCbVC9fli3R+
         6krt8KW+DgWqHChDTt98ScPjrhh+gIOf4M9G1cYUM7KKLk2l7Aoy77OZZGNsViAzv4
         HMWevrvtY1j/ibOpGBvMd8SrnxOU0XnDCDzP3re0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Scott Branden <scott.branden@broadcom.com>
Subject: [PATCH 5.9 215/391] fs/kernel_read_file: Remove FIRMWARE_PREALLOC_BUFFER enum
Date:   Tue,  3 Nov 2020 21:34:26 +0100
Message-Id: <20201103203401.441677789@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit c307459b9d1fcb8bbf3ea5a4162979532322ef77 upstream.

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
Link: https://lore.kernel.org/r/20201002173828.2099543-2-keescook@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/firmware_loader/main.c |    5 ++---
 fs/exec.c                           |    7 ++++---
 include/linux/fs.h                  |    1 -
 kernel/module.c                     |    2 +-
 security/integrity/digsig.c         |    2 +-
 security/integrity/ima/ima_fs.c     |    2 +-
 security/integrity/ima/ima_main.c   |    6 ++----
 7 files changed, 11 insertions(+), 14 deletions(-)

--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -470,14 +470,12 @@ fw_get_filesystem_firmware(struct device
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
 
@@ -501,7 +499,8 @@ fw_get_filesystem_firmware(struct device
 
 		/* load firmware files from the mount namespace of init */
 		rc = kernel_read_file_from_path_initns(path, &buffer,
-						       &size, msize, id);
+						       &size, msize,
+						       READING_FIRMWARE);
 		if (rc) {
 			if (rc != -ENOENT)
 				dev_warn(device, "loading %s failed with error %d\n",
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -955,6 +955,7 @@ int kernel_read_file(struct file *file,
 {
 	loff_t i_size, pos;
 	ssize_t bytes = 0;
+	void *allocated = NULL;
 	int ret;
 
 	if (!S_ISREG(file_inode(file)->i_mode) || max_size < 0)
@@ -978,8 +979,8 @@ int kernel_read_file(struct file *file,
 		goto out;
 	}
 
-	if (id != READING_FIRMWARE_PREALLOC_BUFFER)
-		*buf = vmalloc(i_size);
+	if (!*buf)
+		*buf = allocated = vmalloc(i_size);
 	if (!*buf) {
 		ret = -ENOMEM;
 		goto out;
@@ -1008,7 +1009,7 @@ int kernel_read_file(struct file *file,
 
 out_free:
 	if (ret < 0) {
-		if (id != READING_FIRMWARE_PREALLOC_BUFFER) {
+		if (allocated) {
 			vfree(*buf);
 			*buf = NULL;
 		}
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2861,7 +2861,6 @@ extern int do_pipe_flags(int *, int);
 #define __kernel_read_file_id(id) \
 	id(UNKNOWN, unknown)		\
 	id(FIRMWARE, firmware)		\
-	id(FIRMWARE_PREALLOC_BUFFER, firmware)	\
 	id(MODULE, kernel-module)		\
 	id(KEXEC_IMAGE, kexec-image)		\
 	id(KEXEC_INITRAMFS, kexec-initramfs)	\
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -4028,7 +4028,7 @@ SYSCALL_DEFINE3(finit_module, int, fd, c
 {
 	struct load_info info = { };
 	loff_t size;
-	void *hdr;
+	void *hdr = NULL;
 	int err;
 
 	err = may_init_module();
--- a/security/integrity/digsig.c
+++ b/security/integrity/digsig.c
@@ -169,7 +169,7 @@ int __init integrity_add_key(const unsig
 
 int __init integrity_load_x509(const unsigned int id, const char *path)
 {
-	void *data;
+	void *data = NULL;
 	loff_t size;
 	int rc;
 	key_perm_t perm;
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -272,7 +272,7 @@ static const struct file_operations ima_
 
 static ssize_t ima_read_policy(char *path)
 {
-	void *data;
+	void *data = NULL;
 	char *datap;
 	loff_t size;
 	int rc, pathlen = strlen(path);
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -621,19 +621,17 @@ void ima_post_path_mknod(struct dentry *
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


