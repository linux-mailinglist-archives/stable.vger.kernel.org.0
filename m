Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53917303B76
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 12:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392213AbhAZLW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 06:22:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392300AbhAZLVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 06:21:42 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2717C061756
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 03:21:01 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id hs11so22442687ejc.1
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 03:21:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Bo2KvLyJ3CoRAV90XXAzC6MvE67j5C0xtYYmI4wQQFc=;
        b=J924yGnWRNUC6Q++owCw2rGPr8JWM0Zn+bH/ktGEjr0VOPu4707+29prxhGar/haJE
         A7MaAJPpyhD/2UvA73DTA7WL7VOwnScMQ0zDuRzYghYJ2XC5e/stGDA30Y7/6V1INmsK
         RM8gaDaRLDMph+cvZPxXVaMxk+E0PCEcX8DG4t0qjOrw+pJWzVNvatvlRVyuCE0jGBIZ
         6Gz69UgLBJlD01Dca3X2NbZLv3djD7kXNrK1ZJrWsVUJIpTvECpvjD5NsVY5vdGZTwsr
         Scw5QA6iN0N3/rsrgP8tSSVSONKeKVn3Jid/KVqJW6D+z54fI/etV9CyoxoIScldHPje
         eQ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bo2KvLyJ3CoRAV90XXAzC6MvE67j5C0xtYYmI4wQQFc=;
        b=Hx32hsg2tMD7+SLi4GzbVrv4biN6Ny9PMP5+VFjrux4KjiTz5nKv5HwaMQUtCefPbg
         IXnYuEMhC8vxs0wiR0hZX+LPJCW9ZywN5Ubp9hzcC9dVw9Y7wm5nOA2Z+GbC9HxpyIY5
         ynIQZjB+/pVwc4yNpvfo5sJBVBshKAk7SGsw35ZVm8cbQ+0DrigTzkUM5pV8PDbv5/Fq
         b4n2yKOdL4CHtLscjAaUFd14oaLWuW6fJuCN/46ikbZWHFIxdwbkeFOK9o2YxE1CpL7T
         5o0A0Iya593AxcybSXVtVvmG+emNecOjsLa74pAOq0drYggS9t9ha5Z+zPLbkdBs/f8+
         d72A==
X-Gm-Message-State: AOAM5339TNnTdTMKaqJdraXFodeetdpLqnisgvtdVXsQcVlF22S2HKbg
        TUBaijS3oU4MumpXWO+XmhpHisJmdms/5w==
X-Google-Smtp-Source: ABdhPJwS8KrazKTQ7mhoeL+GjbnPsuXuz4xXmgVhRzCTJuh9Pl/zWLNy2FbfdcPUoAKbbXYT5ozdOg==
X-Received: by 2002:a17:906:2a42:: with SMTP id k2mr3101669eje.118.1611660060415;
        Tue, 26 Jan 2021 03:21:00 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.161])
        by smtp.gmail.com with ESMTPSA id o17sm12167128edr.17.2021.01.26.03.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 03:21:00 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH stable 02/11] io_uring: inline io_uring_attempt_task_drop()
Date:   Tue, 26 Jan 2021 11:17:01 +0000
Message-Id: <706c41d54e42eff8de3f2d1741cead614c9b454b.1611659564.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611659564.git.asml.silence@gmail.com>
References: <cover.1611659564.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4f793dc40bc605b97624fd36baf085b3c35e8bfd ]

A simple preparation change inlining io_uring_attempt_task_drop() into
io_uring_flush().

Cc: stable@vger.kernel.org # 5.5+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 265aea2cd7bc..6c89d38076d0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8804,23 +8804,6 @@ static void io_uring_del_task_file(struct file *file)
 		fput(file);
 }
 
-/*
- * Drop task note for this file if we're the only ones that hold it after
- * pending fput()
- */
-static void io_uring_attempt_task_drop(struct file *file)
-{
-	if (!current->io_uring)
-		return;
-	/*
-	 * fput() is pending, will be 2 if the only other ref is our potential
-	 * task file note. If the task is exiting, drop regardless of count.
-	 */
-	if (fatal_signal_pending(current) || (current->flags & PF_EXITING) ||
-	    atomic_long_read(&file->f_count) == 2)
-		io_uring_del_task_file(file);
-}
-
 static void io_uring_remove_task_files(struct io_uring_task *tctx)
 {
 	struct file *file;
@@ -8912,7 +8895,17 @@ void __io_uring_task_cancel(void)
 
 static int io_uring_flush(struct file *file, void *data)
 {
-	io_uring_attempt_task_drop(file);
+	if (!current->io_uring)
+		return 0;
+
+	/*
+	 * fput() is pending, will be 2 if the only other ref is our potential
+	 * task file note. If the task is exiting, drop regardless of count.
+	 */
+	if (fatal_signal_pending(current) || (current->flags & PF_EXITING) ||
+	    atomic_long_read(&file->f_count) == 2)
+		io_uring_del_task_file(file);
+
 	return 0;
 }
 
-- 
2.24.0

