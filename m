Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88CB52F0BB0
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 05:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbhAKEEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 23:04:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbhAKEEz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jan 2021 23:04:55 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90BDC061795;
        Sun, 10 Jan 2021 20:04:14 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id 3so13717056wmg.4;
        Sun, 10 Jan 2021 20:04:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YtyEgNKIS4L+pfBHOPculvaKhcVREy7GPu2xVWuzm2s=;
        b=SlTOULy9tk/yRruDhD3atnfZ4NTdIjSxK07DuV3EJzl0OL51vx9GhcfuSDSYVXWG/R
         Xo/DrS/UZdNN+UaWLtnUsg4d311u4hKZJsvpfE1klRD5kmnbHS+24dREoGYaO69dntCi
         FLePfPC9wGQ7gfp1OeDxVmnWFbNUOprZrH/ip1/xnVHvAGBJecfV4UIxRXtMmvVl0vrq
         sqoKvgev2dihJktZYmX6B4kO7FVX4cLlKawMqdWjV0jDlsK6tTjb8Q4MyPdtA+JLCvd6
         dAFgnnhw0cKZJ6QlZbtG6aslbpvrQftG/nNPtEg7Zh1rH1C1bKrpSFbiLVDbYZOlyKPD
         yIOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YtyEgNKIS4L+pfBHOPculvaKhcVREy7GPu2xVWuzm2s=;
        b=LUm4CzK3J4pjUuB/X3BzKRgPh4LXoz/jLqbYkvHToPD4o/d7cpQZhmUTQZ0tU8XE7q
         SE/xIP0OjCCB7Gylqe9Xv+ZXFUj7Xsh73NVw9/hQpIA3Fmr5jIcSSMUYdO8gQ/GD0Q/O
         VgmNilpWXCSsL4x7DqrONfY/j1uArPukIecs3F6z9aYL7e7IjPPcnB4NvyG+giZX5iOr
         I8sNeyFMhooC277rs9t2G5V49qSkk6H6bSKJV3EgWP/l1lVWKm/tGHGamDoLBGLLNGN5
         +2A4XSsKfEDA9G6BWyKNsAQElbwTD2PG7pVn3ymIp6h31ewqf8aDqeJ/pV4TloVgux0g
         MDIA==
X-Gm-Message-State: AOAM530ZAbT1mcZBAUCixcD0X6w/aSb4AuMH52nJ33q7/COfQSJa0pww
        AMJMe+TjQbo3RpXgzooZOqZVrmErMKA=
X-Google-Smtp-Source: ABdhPJyNKp2gKaFsj9crBQZm5oikCOqkgdz8zVZsKpL1xjuUpw0IL62aOrV4J9WpbmfsKCfhn5rTHg==
X-Received: by 2002:a1c:2003:: with SMTP id g3mr13011338wmg.136.1610337853507;
        Sun, 10 Jan 2021 20:04:13 -0800 (PST)
Received: from localhost.localdomain ([85.255.237.6])
        by smtp.gmail.com with ESMTPSA id o8sm22658061wrm.17.2021.01.10.20.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jan 2021 20:04:13 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 2/2] io_uring: don't take files/mm for a dead task
Date:   Mon, 11 Jan 2021 04:00:31 +0000
Message-Id: <0c0af65180413ebfdd0ba376d185906573fe6396.1610337318.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1610337318.git.asml.silence@gmail.com>
References: <cover.1610337318.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In rare cases a task may be exiting while io_ring_exit_work() trying to
cancel/wait its requests. It's ok for __io_sq_thread_acquire_mm()
because of SQPOLL check, but is not for __io_sq_thread_acquire_files().
Play safe and fail for both of them.

Cc: stable@vger.kernel.org # 5.5+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7af74c1ec909..b0e6d8e607a3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1106,6 +1106,9 @@ static void io_sq_thread_drop_mm_files(void)
 
 static int __io_sq_thread_acquire_files(struct io_ring_ctx *ctx)
 {
+	if (current->flags & PF_EXITING)
+		return -EFAULT;
+
 	if (!current->files) {
 		struct files_struct *files;
 		struct nsproxy *nsproxy;
@@ -1133,6 +1136,8 @@ static int __io_sq_thread_acquire_mm(struct io_ring_ctx *ctx)
 {
 	struct mm_struct *mm;
 
+	if (current->flags & PF_EXITING)
+		return -EFAULT;
 	if (current->mm)
 		return 0;
 
-- 
2.24.0

