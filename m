Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0028D6BDE9E
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 03:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjCQCc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 22:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjCQCc2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 22:32:28 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88213344A
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 19:32:26 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id h12-20020a17090aea8c00b0023d1311fab3so3565004pjz.1
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 19:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679020346;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IhCWHyMCWkCDTxDG3Tk5hH+ucDJE122QjsB041WgAUE=;
        b=PgzjUCrljzc2WMAxuesf3YWnfzcTU2MWNCY7xOTB6DNC+uq7gGUxaKptHEhSrAGDF3
         eu9iqYQ/gCWbu7NBdz8pcluvpN2Qx0D+Get71rrSbgpLt6xzi8y6KSa9KU/jj/a8mBPj
         OTJ+Ymh5/bHTEmDIJg/yCjE951ytl12YNANvIy6EZI+aTNoIkOV5qf+L1kZuhFJ+mTTR
         AdgwDzBCnbQVq29zjeynYH7SNh3cosgkfAVnoLE548jezWSpjwieirZzXewbJQWQZR6x
         RR+C3iGaA8xb4cCLNwt66+8Gbwoh6Tm2WdlS2Bgcl6tmWx0G3+/+BXk297En9MSCWTxV
         uysg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679020346;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IhCWHyMCWkCDTxDG3Tk5hH+ucDJE122QjsB041WgAUE=;
        b=J+38s3Bg052fnWhavobBCCE80hp5x7a1ogkemE+KpAy685SAcz/aCEb9vT+GwUMfrs
         TlNCdhETRgHYSPUbBE6OHZ+ENdheNERILabJWiQ1vihB/ZZyre9HjGGWHrnXMQ90sPyQ
         JgyrS5qX2kAjO3Vd/oGlCt85W8/0Kp27n0VKPVQWVdLClL2yPBeuflRp3rD1N54Qvycz
         HZL+gkQ2N/7NqVi37SZLz5TT3WqkzT94YdXgWSepeWw9i7XKZYGfQ2mdhvNSOxbt4kRQ
         O5I0gUynGv4haBH9Aeom0ezc+Ool9wZzFK41X3VsMO12AhSwusT5gAUqWKKJcya4p/S2
         wxeQ==
X-Gm-Message-State: AO0yUKV3k0Tnl7noG/3ORmvUcnKTXLZjOVRz/HNsVrUTNwpVzEZ7FzEN
        X7+mHIQ/XAR6w4wFC0sofGs=
X-Google-Smtp-Source: AK7set+dnFleIX+jHssLdQHL974uOdn7DnrLLWRuErSIUTy+94+ROvILjNBgcv3gFlbvFLnZvOyLlg==
X-Received: by 2002:a17:902:ec87:b0:1a1:a06c:48a5 with SMTP id x7-20020a170902ec8700b001a1a06c48a5mr3189406plg.33.1679020346217;
        Thu, 16 Mar 2023 19:32:26 -0700 (PDT)
Received: from localhost.localdomain ([43.155.90.222])
        by smtp.googlemail.com with ESMTPSA id jx21-20020a17090b46d500b0020b21019086sm7928402pjb.3.2023.03.16.19.32.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Mar 2023 19:32:25 -0700 (PDT)
From:   juanfengpy@gmail.com
X-Google-Original-From: caelli@tencent.com
To:     juanfengpy@gmail.com
Cc:     Hui Li <caelli@tencent.com>, <stable@vger.kernel.org>
Subject: [PATCH v7] tty: fix hang on tty device with no_room set
Date:   Fri, 17 Mar 2023 10:24:07 +0800
Message-Id: <1679019847-1401-1-git-send-email-caelli@tencent.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Li <caelli@tencent.com>

We have met a hang on pty device, the reader was blocking
at epoll on master side, the writer was sleeping at wait_woken
inside n_tty_write on slave side, and the write buffer on
tty_port was full, we found that the reader and writer would
never be woken again and blocked forever.

The problem was caused by a race between reader and kworker:
n_tty_read(reader):  n_tty_receive_buf_common(kworker):
copy_from_read_buf()|
                    |room = N_TTY_BUF_SIZE - (ldata->read_head - tail)
                    |room <= 0
n_tty_kick_worker() |
                    |ldata->no_room = true

After writing to slave device, writer wakes up kworker to flush
data on tty_port to reader, and the kworker finds that reader
has no room to store data so room <= 0 is met. At this moment,
reader consumes all the data on reader buffer and calls
n_tty_kick_worker to check ldata->no_room which is false and
reader quits reading. Then kworker sets ldata->no_room=true
and quits too.

If write buffer is not full, writer will wake kworker to flush data
again after following writes, but if write buffer is full and writer
goes to sleep, kworker will never be woken again and tty device is
blocked.

This problem can be solved with a check for read buffer size inside
n_tty_receive_buf_common, if read buffer is empty and ldata->no_room
is true, a call to n_tty_kick_worker is necessary to keep flushing
data to reader.

Cc: <stable@vger.kernel.org>
Fixes: 42458f41d08f ("n_tty: Ensure reader restarts worker for next reader")
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Hui Li <caelli@tencent.com>
---
Patch changelogs between v1 and v2:
	-add barrier inside n_tty_read and n_tty_receive_buf_common;
	-comment why barrier is needed;
	-access to ldata->no_room is changed with READ_ONCE and WRITE_ONCE;
Patch changelogs between v2 and v3:
	-in function n_tty_receive_buf_common, add unlikely to check
	 ldata->no_room, eg: if (unlikely(ldata->no_room)), and READ_ONCE
	 is removed here to get locality;
	-change comment for barrier to show the race condition to make
	 comment easier to understand;
Patch changelogs between v3 and v4:
	-change subject from 'tty: fix a possible hang on tty device' to
	 'tty: fix hang on tty device with no_room set' to make subject 
	 more obvious;
Patch changelogs between v4 and v5:
	-name is changed from cael to caelli, li is added as the family
	 name and caelli is the fullname.
Patch changelogs between v5 and v6:
	-change from and Signed-off-by, from 'caelli <juanfengpy@gmail.com>'
	 to 'caelli <caelli@tencent.com>', later one is my corporate address.
Patch changelogs between v6 and v7:
	-change name from caelli to 'Hui Li', which is my name in chinese.
	-the comment for barrier is improved, and a Fixes and Reviewed-by
	 tags is added.

 drivers/tty/n_tty.c | 41 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index c8f56c9b1a1c..8c17304fffcf 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -204,8 +204,8 @@ static void n_tty_kick_worker(struct tty_struct *tty)
 	struct n_tty_data *ldata = tty->disc_data;
 
 	/* Did the input worker stop? Restart it */
-	if (unlikely(ldata->no_room)) {
-		ldata->no_room = 0;
+	if (unlikely(READ_ONCE(ldata->no_room))) {
+		WRITE_ONCE(ldata->no_room, 0);
 
 		WARN_RATELIMIT(tty->port->itty == NULL,
 				"scheduling with invalid itty\n");
@@ -1698,7 +1698,7 @@ n_tty_receive_buf_common(struct tty_struct *tty, const unsigned char *cp,
 			if (overflow && room < 0)
 				ldata->read_head--;
 			room = overflow;
-			ldata->no_room = flow && !room;
+			WRITE_ONCE(ldata->no_room, flow && !room);
 		} else
 			overflow = 0;
 
@@ -1729,6 +1729,27 @@ n_tty_receive_buf_common(struct tty_struct *tty, const unsigned char *cp,
 	} else
 		n_tty_check_throttle(tty);
 
+	if (unlikely(ldata->no_room)) {
+		/*
+		 * Barrier here is to ensure to read the latest read_tail in
+		 * chars_in_buffer() and to make sure that read_tail is not loaded
+		 * before ldata->no_room is set, otherwise, following race may occur:
+		 * n_tty_receive_buf_common()
+		 *				n_tty_read()
+		 *   if (!chars_in_buffer(tty))->false
+		 *				  copy_from_read_buf()
+		 *				    read_tail=commit_head
+		 *				  n_tty_kick_worker()
+		 *				    if (ldata->no_room)->false
+		 *   ldata->no_room = 1
+		 * Then both kworker and reader will fail to kick n_tty_kick_worker(),
+		 * smp_mb is paired with smp_mb() in n_tty_read().
+		 */
+		smp_mb();
+		if (!chars_in_buffer(tty))
+			n_tty_kick_worker(tty);
+	}
+
 	up_read(&tty->termios_rwsem);
 
 	return rcvd;
@@ -2282,8 +2303,25 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 		if (time)
 			timeout = time;
 	}
-	if (old_tail != ldata->read_tail)
+	if (old_tail != ldata->read_tail) {
+		/*
+		 * Make sure no_room is not read in n_tty_kick_worker()
+		 * before setting ldata->read_tail in copy_from_read_buf(),
+		 * otherwise, following race may occur:
+		 * n_tty_read()
+		 *			n_tty_receive_buf_common()
+		 *   n_tty_kick_worker()
+		 *     if(ldata->no_room)->false
+		 *			  ldata->no_room = 1
+		 *			  if (!chars_in_buffer(tty))->false
+		 *   copy_from_read_buf()
+		 *     read_tail=commit_head
+		 * Both reader and kworker will fail to kick tty_buffer_restart_work(),
+		 * smp_mb is paired with smp_mb() in n_tty_receive_buf_common().
+		 */
+		smp_mb();
 		n_tty_kick_worker(tty);
+	}
 	up_read(&tty->termios_rwsem);
 
 	remove_wait_queue(&tty->read_wait, &wait);
-- 
2.27.0

