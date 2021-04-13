Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C641135DCB6
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 12:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343846AbhDMKrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 06:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343834AbhDMKrh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 06:47:37 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A37C061574;
        Tue, 13 Apr 2021 03:47:17 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 12so8454481wmf.5;
        Tue, 13 Apr 2021 03:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4lMXsJO9v5huIB4nN6VmdX8CnLsm8ybpqVlxJ2R7FVs=;
        b=ELmLOhG/JzTuPw+abAxVSGpQo9tp2HacHyCaObvq6UlYYbUl+DqeSqXuMkoOvcCGDw
         DhJvRQizNiW3xw3sJQ65BsMh++L530eghGKewiFQeB5xuS4IwDUi/9F+T0R/e6T8Sb3+
         wtzN1FqVwHSGn29hP94okdBTPKGef/jd0YQhtXxaMVVWBA230BTu5n1KNigcc93+pyIk
         wzKwYv1ZuvUkr7c9XvCUHFIiDoTMW7XKsBl1FXR2NuVSWlSQnI2KpNTQGbl3N6dhG1wC
         q1PTta+YQWBrzqEOxnuSQlketwFJvGhffXM/P9XFV4Of4l8Q0niAr65AU0fno+86HsEF
         juFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4lMXsJO9v5huIB4nN6VmdX8CnLsm8ybpqVlxJ2R7FVs=;
        b=pEDnP/KvDyVy7umft0QG6O19qErfraiVRTekww4dIieaQoZH3crwVgguJBDJiTlNic
         PljPTmzDjCSwnV8jil9l7zRr3nt0TYZZBRRnOjjnj1SOHJ457oLmDNL66MrshVS54MNX
         CVI9hnhsKo1DV2a3uRg276qF1gB0APHkVn49ARVANq5C9JVt19U/kwo3dBF0CizTNW1L
         FuMncmWZbKs989155/3+v02EzKReEk9n4RBaS+34nBfgmHL/6mAkmBRrQpFHQ6OtLOj9
         Why+7fFls/lfeyvcwBM0CRzX0cmKFCGfqOKiB+Za88MBBObwgST/5tqzENwJyxei48co
         mqtg==
X-Gm-Message-State: AOAM5309SjaRB+6YTmzXVGZ18sPJArJjGVEBXJ905EWt4ECUnGvW//IF
        USYL2VfUYyTSokGRPSrXKy5Dy9GPR68=
X-Google-Smtp-Source: ABdhPJz4J8Jjbmwm6dq3O8ZWcfcakv3BJzPUQF4u6SLru8tOhXO7PHs5miqfh2mg9rbX78a2p0R3sg==
X-Received: by 2002:a1c:750d:: with SMTP id o13mr3475157wmc.76.1618310836535;
        Tue, 13 Apr 2021 03:47:16 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.208])
        by smtp.gmail.com with ESMTPSA id m14sm19858640wrh.28.2021.04.13.03.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 03:47:15 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org, Joakim Hassila <joj@mac.com>
Subject: [PATCH] io_uring: fix early sqd_list removal sqpoll hangs
Date:   Tue, 13 Apr 2021 11:43:00 +0100
Message-Id: <1592cc2b0418a0512c83898dbef0b1c9722e8645.1618310545.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[  245.463317] INFO: task iou-sqp-1374:1377 blocked for more than 122 seconds.
[  245.463334] task:iou-sqp-1374    state:D flags:0x00004000
[  245.463345] Call Trace:
[  245.463352]  __schedule+0x36b/0x950
[  245.463376]  schedule+0x68/0xe0
[  245.463385]  __io_uring_cancel+0xfb/0x1a0
[  245.463407]  do_exit+0xc0/0xb40
[  245.463423]  io_sq_thread+0x49b/0x710
[  245.463445]  ret_from_fork+0x22/0x30

It happens when sqpoll forgot to run park_task_work and goes to exit,
then exiting user may remove ctx from sqd_list, and so corresponding
io_sq_thread() -> io_uring_cancel_sqpoll() won't be executed. Hopefully
it just stucks in do_exit() in this case.

Cc: stable@vger.kernel.org
Reported-by: Joakim Hassila <joj@mac.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cadd7a65a7f4..f390914666b1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6817,6 +6817,9 @@ static int io_sq_thread(void *data)
 	current->flags |= PF_NO_SETAFFINITY;
 
 	mutex_lock(&sqd->lock);
+	/* a user may had exited before the thread wstarted */
+	io_run_task_work_head(&sqd->park_task_work);
+
 	while (!test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state)) {
 		int ret;
 		bool cap_entries, sqt_spin, needs_sched;
@@ -6833,10 +6836,10 @@ static int io_sq_thread(void *data)
 			}
 			cond_resched();
 			mutex_lock(&sqd->lock);
-			if (did_sig)
-				break;
 			io_run_task_work();
 			io_run_task_work_head(&sqd->park_task_work);
+			if (did_sig)
+				break;
 			timeout = jiffies + sqd->sq_thread_idle;
 			continue;
 		}
-- 
2.24.0

