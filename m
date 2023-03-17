Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51BF86BE1E2
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 08:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbjCQH0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 03:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbjCQH0S (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 03:26:18 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5AF5CC0E;
        Fri, 17 Mar 2023 00:26:06 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id le6so4422931plb.12;
        Fri, 17 Mar 2023 00:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679037966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8wd3NuPx9Xrv4wZq4NfbNl6nVymad+l2rLb284yv9Ic=;
        b=HUjRru7K1q2V0+LjN+cklA8NqIRrkFoDlNfw/60TK6/mPZlsIuFSou0nVzrFhQuVcd
         zcI6aHbxSGO1i9BeWFHbqVzJvntGV9utE/pBioy90Z5zz30zngpM4lxHPJ2NN9MwH94f
         mgJdkwT34Z2oAldIfYkeBrSxtVoLscp9/nSjdfEBj8k+vYhVe8Gj4/PASgovy2hVgsdO
         ajyo6qU/2UDOEaLaDslVTL5ARDGT4Cnf+ioc0HmHok14Nf1MJ7nL4FyCDbEgmJp9AHCV
         tifpj0BVEAEs7rPiORXk/YE9BISrbu88xKqv2CR54pDuSu4Iu0DnYiPMe1lJSi9ASV5C
         6ejQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679037966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8wd3NuPx9Xrv4wZq4NfbNl6nVymad+l2rLb284yv9Ic=;
        b=NAEzm9jIio4cfdrVXAtCbSaLyGRAIXdTGWehIbqk1uxLMdv86lXSNNJD6ntRIZyzL3
         bm3h9eO76KE/7qmYGsIAJdgXnwjQtz0fMD6SY7kQMUDyexWjlJPLfv7WSxpTwSQfASc6
         bJJplYlqqVKYu/1kChHZwW8qfefPyMMApYJJHUr5SMaLU3dweHX8zcVy8aMi6+9yQv6g
         nB6BuTVi1veyxypotq4StzxqqqZhztqjLIa97DjQO/aYW1UgL2BtU5A4BMaB/+tR1s9Y
         F3k5QaCuF9+VnAPqWthaftpu8P056rWsi0gcBJEUIUiuatqgxsAdO+CFfDwf+kGeJO7d
         9kCA==
X-Gm-Message-State: AO0yUKUKDIGMDvWQV4moHmRzgC4vwMvCfCTTFp7WfiLUbghFhDX5cSxX
        vUA+QAROPsguDmi5XxXGJ1I=
X-Google-Smtp-Source: AK7set9EMjDY66tpoZFnVEj+GJ5EPoyN01MmGI08BZt6c2374pdBpeHlL+AHkx5hraoUMxGhMWTAEw==
X-Received: by 2002:a17:90a:1903:b0:23b:2963:ec94 with SMTP id 3-20020a17090a190300b0023b2963ec94mr7319033pjg.29.1679037966170;
        Fri, 17 Mar 2023 00:26:06 -0700 (PDT)
Received: from localhost.localdomain ([43.155.90.222])
        by smtp.googlemail.com with ESMTPSA id t10-20020a170902b20a00b001a0403f6a97sm848406plr.202.2023.03.17.00.26.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Mar 2023 00:26:05 -0700 (PDT)
From:   juanfengpy@gmail.com
X-Google-Original-From: caelli@tencent.com
To:     jirislaby@kernel.org, gregkh@linuxfoundation.org
Cc:     ilpo.jarvinen@linux.intel.com, benbjiang@tencent.com,
        robinlai@tencent.com, linux-serial@vger.kernel.org,
        juanfengpy@gmail.com, Hui Li <caelli@tencent.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v8] tty: fix hang on tty device with no_room set
Date:   Fri, 17 Mar 2023 15:25:46 +0800
Message-Id: <1679037946-18156-1-git-send-email-caelli@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <35358148-3d46-40e5-aa1e-84e7fb6dbb6f@kernel.org>
References: <35358148-3d46-40e5-aa1e-84e7fb6dbb6f@kernel.org>
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
Patch changelogs between v7 and v8:
	-Simplify the comments for barriers.

 drivers/tty/n_tty.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index c8f56c9b1a1c..4dff2f34e2d0 100644
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
 
@@ -1729,6 +1729,17 @@ n_tty_receive_buf_common(struct tty_struct *tty, const unsigned char *cp,
 	} else
 		n_tty_check_throttle(tty);
 
+	if (unlikely(ldata->no_room)) {
+		/*
+		 * Barrier here is to ensure to read the latest read_tail in
+		 * chars_in_buffer() and to make sure that read_tail is not loaded
+		 * before ldata->no_room is set.
+		 */
+		smp_mb();
+		if (!chars_in_buffer(tty))
+			n_tty_kick_worker(tty);
+	}
+
 	up_read(&tty->termios_rwsem);
 
 	return rcvd;
@@ -2282,8 +2293,14 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 		if (time)
 			timeout = time;
 	}
-	if (old_tail != ldata->read_tail)
+	if (old_tail != ldata->read_tail) {
+		/*
+		 * Make sure no_room is not read in n_tty_kick_worker()
+		 * before setting ldata->read_tail in copy_from_read_buf().
+		 */
+		smp_mb();
 		n_tty_kick_worker(tty);
+	}
 	up_read(&tty->termios_rwsem);
 
 	remove_wait_queue(&tty->read_wait, &wait);
-- 
2.27.0

