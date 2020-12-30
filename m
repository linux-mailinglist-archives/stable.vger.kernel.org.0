Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09EA62E7CBB
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 22:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgL3Vig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 16:38:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbgL3Vig (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Dec 2020 16:38:36 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39B1C06179B;
        Wed, 30 Dec 2020 13:37:55 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id q18so18679980wrn.1;
        Wed, 30 Dec 2020 13:37:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bcMAp6tVywjSvwwt6sm+3F0M10rsmbInlCvk86yuFG4=;
        b=BfY/hxclbsS/QJDWGx7INU0FiWM6XcDywWWV2MWs3rOZEUb4+PwPL5tfjonaZ4PRIr
         FGvn5lcX9H1n2c7WpPWI/PNB9whivR2kxT1pizDp39nzUznkZN+VlAerOrf7kLSqk84+
         VO4dzE8JG753HHeVHitx49CbKdNzAaRIisgtO8DWVTzJ6L9nZVavQvsg3Y1YJjIvPYHd
         JSacP1wvPHn3uJ0wdf+xjF1eXb1j98SVJQ5mrNTCFoLWF0l3+AtLqifPIt3fBJcskNXM
         r/xnv4HmhkYbd8wITVvSFbSL66BYj8COtkABcB8vR/oXi2o8Z1h/V+VqDh85ZUfJaIAY
         /O1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bcMAp6tVywjSvwwt6sm+3F0M10rsmbInlCvk86yuFG4=;
        b=aF219iVdboP/rHyM4bNEGuPsrBHTS/Q6pEn5WGXajZMGKjhIrNCLzlXURqvzftelom
         7ZjXB3k91LIbAtMNx3K86m62TsHqKNhisioIjxZRUoEge5mP1RAqFMCVjka3xw4Dveki
         PoaYVpjO2rqlzdz7bz1LWDX7v9FdXZUhHTg9ZvvFs5WK2BbdbRuYpJFT94ksHOUpeAU+
         z3Qho3TTGEiuPcws0CGvqhDiBvWQCzyQ3eb26TDdtq9sQxncqxpIEssUw9Ng+7/HYWYx
         TlKKQ9ujLkKPt3ekbwshDN+pCFHIiIhb/Bz8XdAF90zU3j7jpl5FdP0NbsDCtgernpt0
         6ycg==
X-Gm-Message-State: AOAM531Q6s5GuKXKsjVOhtJYkUkyrPn/tAyfqsrn/ZtVaa5T4T6dVrZI
        sksz+rOmJDgDD0HMAx8fyBw=
X-Google-Smtp-Source: ABdhPJyxuOgGIOHOikCdsz8oWx4I/QAZaKnS9rLyE34F7zX3to9nyovgqTE4+/+mEB7eTWkl6FYP5g==
X-Received: by 2002:adf:90e3:: with SMTP id i90mr36804489wri.248.1609364274465;
        Wed, 30 Dec 2020 13:37:54 -0800 (PST)
Received: from localhost.localdomain ([148.252.128.61])
        by smtp.gmail.com with ESMTPSA id 125sm8823626wmc.27.2020.12.30.13.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Dec 2020 13:37:54 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 3/4] kernel/io_uring: cancel io_uring before task works
Date:   Wed, 30 Dec 2020 21:34:16 +0000
Message-Id: <12a143ea8f841801b36ccd1cca3558543eab7683.1609361865.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1609361865.git.asml.silence@gmail.com>
References: <cover.1609361865.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For cancelling io_uring requests it needs either to be able to run
currently enqueued task_wokrs or having it shut down by that moment.
Otherwise io_uring_cancel_files() may be waiting for requests that won't
ever complete.

Go with the first way and do cancellations before setting PF_EXITING and
so before putting the task_work infrastructure into a transition state
where task_work_run() would better not be called.

Cc: stable@vger.kernel.org # 5.5+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/file.c     | 2 --
 kernel/exit.c | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index c0b60961c672..dab120b71e44 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -21,7 +21,6 @@
 #include <linux/rcupdate.h>
 #include <linux/close_range.h>
 #include <net/sock.h>
-#include <linux/io_uring.h>
 
 unsigned int sysctl_nr_open __read_mostly = 1024*1024;
 unsigned int sysctl_nr_open_min = BITS_PER_LONG;
@@ -428,7 +427,6 @@ void exit_files(struct task_struct *tsk)
 	struct files_struct * files = tsk->files;
 
 	if (files) {
-		io_uring_files_cancel(files);
 		task_lock(tsk);
 		tsk->files = NULL;
 		task_unlock(tsk);
diff --git a/kernel/exit.c b/kernel/exit.c
index 3594291a8542..04029e35e69a 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -63,6 +63,7 @@
 #include <linux/random.h>
 #include <linux/rcuwait.h>
 #include <linux/compat.h>
+#include <linux/io_uring.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -776,6 +777,7 @@ void __noreturn do_exit(long code)
 		schedule();
 	}
 
+	io_uring_files_cancel(tsk->files);
 	exit_signals(tsk);  /* sets PF_EXITING */
 
 	/* sync mm's RSS info before statistics gathering */
-- 
2.24.0

