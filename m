Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9C0B333B89
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 12:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbhCJLf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 06:35:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231952AbhCJLfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 06:35:15 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB3EC061765
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 03:34:56 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id b18so22922913wrn.6
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 03:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jC2PbzBDap1eAGJrSMeju0k3/uX22JDyOTK/JWYWE0o=;
        b=fed5pFDYZW403uJCTIg39LDekLYaOleCNmHKszdjcVdnjsRVsgi0pWQYMIgjCzewuV
         Puq9bMtBpqU5CjaexE9FSikdsoj9W4qakCG/4GeSnIp+pDBBpQ7MLJNjLA7+rYZfUwTd
         DqwzPmMZBuvvwAJOOiTj914IIRt9gWp/208Zi/o+ny/ZYeXZFN4LgThuHcwi7MS/6G5p
         0wuy1jht5AwVvuu4g88Fc3X71NUXXKnGJj5EEdta2tON1YiXrsXOOKUKwRf9/kOeceeb
         3jpJpIU5OXgNXIC/ERlNSbrCP+bXJtbtbyiMWOpcIJRn6SwnJ+Jv89qcZOHxNrmRxV95
         WJEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jC2PbzBDap1eAGJrSMeju0k3/uX22JDyOTK/JWYWE0o=;
        b=RismiI/+MsdbdOPXJ853H2XWvuYz7HVOpoqBdQXEjqERNMl/c+SYQmvf+gdbhZoVfz
         59UfRj8SiVXLpOW6fw/SyjSOLb6oSrG7iLv8LznJaE2pqrO5kxbbpPTI3W/7fTtGjQYh
         b4nuqVQf8RA3jXGlsNgr18ZbsCCHO/Y4aMaAKsoOL18MXmITAS4CyCMDtMkZ+ucM+PaC
         MA77HT4cCDKwYH/YzhRHQsn6wP7UcfU7NogPsfNWJKrXQJXWw7E8kLoSyNKj9h+S11sm
         OB4QQm9qlnGsfFOeWPhwQIHoL2dtRNcl7MfVf2fTJtilZhHUaBS44lPSafekgDWb/l+L
         Uw8Q==
X-Gm-Message-State: AOAM533o8Ws1uukIVaZOwJsMOny5NTFqDHp/uQ+ppqBpomp9PF2VMrvZ
        Dcxvb4TC3FzsGVcf6LOD7vMoJBGyB8XZVA==
X-Google-Smtp-Source: ABdhPJwW55XlG+7ToVq1VAO/dI/kXlnAg49rUN1GfZ/dYthIfQ9QxeDPhrK+BxtugaVZqw8OoLMLqQ==
X-Received: by 2002:adf:ea0e:: with SMTP id q14mr3108382wrm.389.1615376095439;
        Wed, 10 Mar 2021 03:34:55 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.55])
        by smtp.gmail.com with ESMTPSA id s18sm25179078wrr.27.2021.03.10.03.34.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 03:34:55 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/9] fs: provide locked helper variant of close_fd_get_file()
Date:   Wed, 10 Mar 2021 11:30:41 +0000
Message-Id: <ad604cc69f01343b6d8300d83e3a97f56f878e0d.1615375332.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615375332.git.asml.silence@gmail.com>
References: <cover.1615375332.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 53dec2ea74f2ef360e8455439be96a780baa6097 upstream

Assumes current->files->file_lock is already held on invocation. Helps
the caller check the file before removing the fd, if it needs to.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/file.c     | 36 +++++++++++++++++++++++++-----------
 fs/internal.h |  1 +
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index dab120b71e44..f3a4bac2cbe9 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -22,6 +22,8 @@
 #include <linux/close_range.h>
 #include <net/sock.h>
 
+#include "internal.h"
+
 unsigned int sysctl_nr_open __read_mostly = 1024*1024;
 unsigned int sysctl_nr_open_min = BITS_PER_LONG;
 /* our min() is unusable in constant expressions ;-/ */
@@ -732,36 +734,48 @@ int __close_range(unsigned fd, unsigned max_fd, unsigned int flags)
 }
 
 /*
- * variant of close_fd that gets a ref on the file for later fput.
- * The caller must ensure that filp_close() called on the file, and then
- * an fput().
+ * See close_fd_get_file() below, this variant assumes current->files->file_lock
+ * is held.
  */
-int close_fd_get_file(unsigned int fd, struct file **res)
+int __close_fd_get_file(unsigned int fd, struct file **res)
 {
 	struct files_struct *files = current->files;
 	struct file *file;
 	struct fdtable *fdt;
 
-	spin_lock(&files->file_lock);
 	fdt = files_fdtable(files);
 	if (fd >= fdt->max_fds)
-		goto out_unlock;
+		goto out_err;
 	file = fdt->fd[fd];
 	if (!file)
-		goto out_unlock;
+		goto out_err;
 	rcu_assign_pointer(fdt->fd[fd], NULL);
 	__put_unused_fd(files, fd);
-	spin_unlock(&files->file_lock);
 	get_file(file);
 	*res = file;
 	return 0;
-
-out_unlock:
-	spin_unlock(&files->file_lock);
+out_err:
 	*res = NULL;
 	return -ENOENT;
 }
 
+/*
+ * variant of close_fd that gets a ref on the file for later fput.
+ * The caller must ensure that filp_close() called on the file, and then
+ * an fput().
+ */
+int close_fd_get_file(unsigned int fd, struct file **res)
+{
+	struct files_struct *files = current->files;
+	int ret;
+
+	spin_lock(&files->file_lock);
+	ret = __close_fd_get_file(fd, res);
+	spin_unlock(&files->file_lock);
+
+	return ret;
+}
+
 void do_close_on_exec(struct files_struct *files)
 {
 	unsigned i;
diff --git a/fs/internal.h b/fs/internal.h
index 77c50befbfbe..c6c85f6ad598 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -132,6 +132,7 @@ extern struct file *do_file_open_root(struct dentry *, struct vfsmount *,
 		const char *, const struct open_flags *);
 extern struct open_how build_open_how(int flags, umode_t mode);
 extern int build_open_flags(const struct open_how *how, struct open_flags *op);
+extern int __close_fd_get_file(unsigned int fd, struct file **res);
 
 long do_sys_ftruncate(unsigned int fd, loff_t length, int small);
 int chmod_common(const struct path *path, umode_t mode);
-- 
2.24.0

