Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E533147B8
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 05:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhBIExZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 23:53:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbhBIExL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 23:53:11 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82CA9C06121C
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 20:51:59 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id s11so21912052edd.5
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 20:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3mk+54N0sp9sB5kMDzgz4t7dZbdpPAhaoei/vff2jSo=;
        b=PIPsbjKJzds0F8+/GXi2O04IbZX8payUiPAgR1wSuS9oCBwgtqigSW0+IXu+y4SGjd
         NDdIYItBu/j+FHKsuD4FmRhuAXSzeF6YLjij5r+g0EfyLXslLzeMSct4tEB4PI1kGHwi
         UPFPY7glsT0XlPjd4nvEOmSP/nHjXzDN7clFK2eaA4PIMX8kkuDeibtf0dle0cbvYAwU
         zHKxLmMBDcGzTXB8lfBwvQilJO36G2yF1eyrSznzGTPRtGQWx1h06cV9NQHG/zKjKET1
         O2ivVdB2rWsO65fec+CEBalcRZO8YAEpLyTxrUKFCURi9QmiRroUeMx2Le4xlZFJPYDw
         AQ/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3mk+54N0sp9sB5kMDzgz4t7dZbdpPAhaoei/vff2jSo=;
        b=flBWS7CvxqFqNqVsjtZ8+AThVy01pnON5xFuE7lqJ7BRDvjQ8D72g1E4K4VED5SXAe
         QBPoxEw1PaEHmqxkVYaddnn+5JMXWR1P42HBE7dXgxWsgYZgePPEg35ViPCZcObWQXeH
         zek04drfDxZmViiqNKofwaEhpUEAuYfC+tAzN9TIWgRkvyx15OXP4L+vegSJLs9Ie/xf
         Fo1gQGY/aLBxH21rFFwR+i/1J+kXx3IUPyDprHLuhbw/BXPZvVJ6xyjJLCq1IIYCokva
         gwwSWxGrPS+QzABMA+CebDY20hEuIF2cZcAXCfY7ymdwAzq+8FaQCM19qw5AcJA/SUOw
         kE8Q==
X-Gm-Message-State: AOAM533sqLeiqKqKYHv9KBMn8WbEKViIguJu2kiiPE7noOauq/q0eXA+
        ANTuqSI4rkEAH0Rh2Ze1ucIWT+iE7UQ=
X-Google-Smtp-Source: ABdhPJxtsmZkxhvjQa0OizH8ktK4ZiG0m5+D7D880NKJL62dbQt2rmR9QsqNHUTklCLlmHcB0kNxVw==
X-Received: by 2002:aa7:d5c1:: with SMTP id d1mr20502980eds.359.1612846318072;
        Mon, 08 Feb 2021 20:51:58 -0800 (PST)
Received: from localhost.localdomain ([148.252.128.244])
        by smtp.gmail.com with ESMTPSA id g9sm9973445ejp.55.2021.02.08.20.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 20:51:57 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot+6879187cf57845801267@syzkaller.appspotmail.com
Subject: [PATCH 13/16] io_uring: fix list corruption for splice file_get
Date:   Tue,  9 Feb 2021 04:47:47 +0000
Message-Id: <f3cb58e6def11ded052a0820b5f95dc9c8152ccb.1612845821.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612845821.git.asml.silence@gmail.com>
References: <cover.1612845821.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f609cbb8911e40e15f9055e8f945f926ac906924 ]

kernel BUG at lib/list_debug.c:29!
Call Trace:
 __list_add include/linux/list.h:67 [inline]
 list_add include/linux/list.h:86 [inline]
 io_file_get+0x8cc/0xdb0 fs/io_uring.c:6466
 __io_splice_prep+0x1bc/0x530 fs/io_uring.c:3866
 io_splice_prep fs/io_uring.c:3920 [inline]
 io_req_prep+0x3546/0x4e80 fs/io_uring.c:6081
 io_queue_sqe+0x609/0x10d0 fs/io_uring.c:6628
 io_submit_sqe fs/io_uring.c:6705 [inline]
 io_submit_sqes+0x1495/0x2720 fs/io_uring.c:6953
 __do_sys_io_uring_enter+0x107d/0x1f30 fs/io_uring.c:9353
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

io_file_get() may be called from splice, and so REQ_F_INFLIGHT may
already be set.

Fixes: 02a13674fa0e8 ("io_uring: account io_uring internal files as REQ_F_INFLIGHT")
Cc: stable@vger.kernel.org # 5.9+
Reported-by: syzbot+6879187cf57845801267@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b09a59edf6aa..296b4cb44c7d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6170,7 +6170,8 @@ static struct file *io_file_get(struct io_submit_state *state,
 		file = __io_file_get(state, fd);
 	}
 
-	if (file && file->f_op == &io_uring_fops) {
+	if (file && file->f_op == &io_uring_fops &&
+	    !(req->flags & REQ_F_INFLIGHT)) {
 		io_req_init_async(req);
 		req->flags |= REQ_F_INFLIGHT;
 
-- 
2.24.0

