Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD90A307E5C
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 19:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhA1SqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 13:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbhA1Sn4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 13:43:56 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC77C0613D6;
        Thu, 28 Jan 2021 10:43:16 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id q7so6416717wre.13;
        Thu, 28 Jan 2021 10:43:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yP0udIqQ5N4s/ns7Vr5zMHUty7fjICCtXowNGmke6wI=;
        b=CBcHSFFkDRsULzX1kuYr9rG2UQ5CS30IXB92gl9WMzYgKJKr3hs7teNApQAVLRtXyc
         e+JnA5HVT9ZUrJa9qzrKsOD6vomNmg5fWbGokNeOp0svaZutdzAUBnp3FRxnrZXbQoXm
         tyIlo1DbJ4r9nAk7l0KZvl6VBaBUshVSIeQf/bnNQoFJ/Qm1vnGbGbvQtciW1vHmr5t5
         331SKw3UsPv5TtBWtbM7eYZ9WKoqhY9mMlwinFJ6Et9XkEN8ft7ZI3IO/vxIFDvHlnEW
         GP6r+WMfuQLI0ovISLlg8xpPIa7xQXcH3xfYGkM/8TqQEZLi2gwtHRndZn0NBLnfQUyA
         T/NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yP0udIqQ5N4s/ns7Vr5zMHUty7fjICCtXowNGmke6wI=;
        b=pEr2nrwqIDT45G3mvQ6iI635weAcOS7e318NpeWXXWvKrNFFEypS/dmU1hog2jmLxp
         gLPHC66rdNVhVtORa//RC/dlbssU95cHD0dyCOQyJilC5VCDAi99TOR+A81ibVHzKMn2
         CYYTxsYa6YyGSX8jTdd4ItKQNtCRQjO01IOPPdBKpCNf4a4toRfWzsgYT88yxWclrp+X
         7GqeTu1PgRjH2OkbtQxm0FTmFVIOQM5hE02LyDAdVEf2QNfZjKFnz6P61qcyF6OblZNK
         AvnJwAHV+4EuFqeCWxDjCpFL88C7v/xM24zvQH94kUcJPR6v7SUNv10HHvoMSLMUCS/X
         cphA==
X-Gm-Message-State: AOAM531TA2LDYHWRZd2HgLwUzZJYIc073d6rB8pfYjAR+RqjitoY/uAu
        BRue8HBjfFv3mXPk3MlFZ0I=
X-Google-Smtp-Source: ABdhPJxXxlr9TCNrRr80JXY/UhTCoiNZZrk2BxI1aBdoR3FRiOSkWYl6pz/I+N5JStBIMa0fPegyhQ==
X-Received: by 2002:a05:6000:104f:: with SMTP id c15mr441512wrx.239.1611859395083;
        Thu, 28 Jan 2021 10:43:15 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.131])
        by smtp.gmail.com with ESMTPSA id y18sm7916386wrt.19.2021.01.28.10.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 10:43:14 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org,
        syzbot+6879187cf57845801267@syzkaller.appspotmail.com
Subject: [PATCH 1/2] io_uring: fix list corruption for splice file_get
Date:   Thu, 28 Jan 2021 18:39:24 +0000
Message-Id: <8cf8339c34948e837fc5236d75cd816e0931fe9b.1611859042.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611859042.git.asml.silence@gmail.com>
References: <cover.1611859042.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ae388cc52843..39ae1f821cef 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6460,7 +6460,8 @@ static struct file *io_file_get(struct io_submit_state *state,
 		file = __io_file_get(state, fd);
 	}
 
-	if (file && file->f_op == &io_uring_fops) {
+	if (file && file->f_op == &io_uring_fops &&
+	    !(req->flags & REQ_F_INFLIGHT)) {
 		io_req_init_async(req);
 		req->flags |= REQ_F_INFLIGHT;
 
-- 
2.24.0

