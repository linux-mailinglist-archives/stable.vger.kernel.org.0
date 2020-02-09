Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76F5A156BB4
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 18:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbgBIRLV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 12:11:21 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34083 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727435AbgBIRLV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 12:11:21 -0500
Received: by mail-pf1-f196.google.com with SMTP id i6so2477329pfc.1
        for <stable@vger.kernel.org>; Sun, 09 Feb 2020 09:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oKyfB+glS4WzFsqb68AepooNt2SW8jy/RMnvEWj7GjY=;
        b=gehBv0gIERho4QhJU3viuxJWwHRHkg1yfza1Fu12TajLw9R4WWA8e247CtFajlj3D1
         x3pM0Nbnyg7w2pltYKBO/DpsShnfTu/jP6mvj0/lkEI25Q4q3db8xD7Hsvn6QvVAHg9Z
         bfFDdj1yFZ1M7UAFXFY2zYxxu3D9yfMTowGKGt75sXxT/3+mmjNoKnk6A7CRs1PdiUiv
         1ZCK8k/kBW4t7F9sQKjVcJ0uMr5yOavUsvZpHS0Oxe2eTtPhuH1UkAin3DjxoeGk6PUo
         +jHxbB7omqtXP6Aoe11KC2ur2u+5gnlHQwdjMwiPp2kSgM49SgW/awliU83OjkSiAXx9
         fK/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oKyfB+glS4WzFsqb68AepooNt2SW8jy/RMnvEWj7GjY=;
        b=Vn2Dg8M9O2aFrrRjs8MA9Ujd187JPuXrAW3juPAkTQzcBIxZ62lURtJF4RI5ZHZ7fh
         Z3CdTWIMYZfbIa2VwBIi3rHN2/eyt70ZUYBt5aHAa7fWBx5wQE6o5EiOhljsmUICaLKm
         wCrikh4HePWs2F9z2vnVoeXUsmHToJCbo0JOsJRDNUrq+AH3GuIgEHp0GUlWpR2vcL1z
         fezGhcGCXMB9hesDol+p8oqSYOnTP+mvzRlNL+ttUA5RC6W52FscxN6k/sDCdRL4HqNu
         sgXkiX4Ig2O10YeDXUcbSkIEHW8613+1ifDcXWGkMsX5k2MQih+O8LagcmLwKrKmQExk
         oyFw==
X-Gm-Message-State: APjAAAURj/XR0KhAC2+CF8bkFp+S6e6M0gv0b2XeDhNJG9fni+r2Mk7e
        UR0ecAyd9dZ5Jvcq2MEp96mO+w==
X-Google-Smtp-Source: APXvYqyVkIYC4IpSMr7JIFKgZ1MdxPHi8K3e/hetlMx1WYvA02GW+jtOhfIOY6qjdITy4uVIMvf5KA==
X-Received: by 2002:a63:60a:: with SMTP id 10mr8954357pgg.302.1581268279692;
        Sun, 09 Feb 2020 09:11:19 -0800 (PST)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id o9sm9703271pfg.130.2020.02.09.09.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2020 09:11:19 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: [PATCH 2/3] io_uring: grab ->fs as part of async preparation
Date:   Sun,  9 Feb 2020 10:11:12 -0700
Message-Id: <20200209171113.14270-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200209171113.14270-1-axboe@kernel.dk>
References: <20200209171113.14270-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This passes it in to io-wq, so it assumes the right fs_struct when
executing async work that may need to do lookups.

Cc: stable@vger.kernel.org # 5.3+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1a3ca6577a10..2a7bb178986e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -75,6 +75,7 @@
 #include <linux/fsnotify.h>
 #include <linux/fadvise.h>
 #include <linux/eventpoll.h>
+#include <linux/fs_struct.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -611,6 +612,8 @@ struct io_op_def {
 	unsigned		not_supported : 1;
 	/* needs file table */
 	unsigned		file_table : 1;
+	/* needs ->fs */
+	unsigned		needs_fs : 1;
 };
 
 static const struct io_op_def io_op_defs[] = {
@@ -653,12 +656,14 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.needs_fs		= 1,
 	},
 	[IORING_OP_RECVMSG] = {
 		.async_ctx		= 1,
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.needs_fs		= 1,
 	},
 	[IORING_OP_TIMEOUT] = {
 		.async_ctx		= 1,
@@ -689,6 +694,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.fd_non_neg		= 1,
 		.file_table		= 1,
+		.needs_fs		= 1,
 	},
 	[IORING_OP_CLOSE] = {
 		.needs_file		= 1,
@@ -702,6 +708,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.fd_non_neg		= 1,
+		.needs_fs		= 1,
 	},
 	[IORING_OP_READ] = {
 		.needs_mm		= 1,
@@ -733,6 +740,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.fd_non_neg		= 1,
 		.file_table		= 1,
+		.needs_fs		= 1,
 	},
 	[IORING_OP_EPOLL_CTL] = {
 		.unbound_nonreg_file	= 1,
@@ -907,6 +915,16 @@ static inline void io_req_work_grab_env(struct io_kiocb *req,
 	}
 	if (!req->work.creds)
 		req->work.creds = get_current_cred();
+	if (!req->work.fs && def->needs_fs) {
+		spin_lock(&current->fs->lock);
+		if (!current->fs->in_exec) {
+			req->work.fs = current->fs;
+			req->work.fs->users++;
+		} else {
+			req->work.flags |= IO_WQ_WORK_CANCEL;
+		}
+		spin_unlock(&current->fs->lock);
+	}
 }
 
 static inline void io_req_work_drop_env(struct io_kiocb *req)
@@ -919,6 +937,16 @@ static inline void io_req_work_drop_env(struct io_kiocb *req)
 		put_cred(req->work.creds);
 		req->work.creds = NULL;
 	}
+	if (req->work.fs) {
+		struct fs_struct *fs = req->work.fs;
+
+		spin_lock(&req->work.fs->lock);
+		if (--fs->users)
+			fs = NULL;
+		spin_unlock(&req->work.fs->lock);
+		if (fs)
+			free_fs_struct(fs);
+	}
 }
 
 static inline bool io_prep_async_work(struct io_kiocb *req,
-- 
2.25.0

