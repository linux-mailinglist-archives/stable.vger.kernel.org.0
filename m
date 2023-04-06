Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5A0F6D8DA0
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 04:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234778AbjDFCqK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 22:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234768AbjDFCpK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 22:45:10 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A169034;
        Wed,  5 Apr 2023 19:45:09 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id j13so35999618pjd.1;
        Wed, 05 Apr 2023 19:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680749108;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sKxOWbr7rDn/qnvB6FljLF8vj/aIxvx/70FeQshH1rE=;
        b=PggzUDOpVU+7UjjH7jcpIcnIkrXHNAPPpkqDPITfJESnV+tSnMfKo6ZDROKEB2bMDC
         vh5CI8iNy/2VbDAZcheeq6DhUaImFn7l5/HC323FAak6EEtBg/UFsB7MGwAfYpsd0oLd
         PWzxXWTakUmUVOkFIoxpgnQs0QlIToYpY8SiCLoIoZIqpTdQc37Hzb7Pb6X/N6SzdXId
         m1MsiNk2cK99oPSvXzngEb0aCx7ymqV0KsX6Gradsv7rYGKxVrY379ddEAkGD/bBLuiX
         iKKgE8HzVv/0bCpZx2ZTjXP7SPHBBKc0T2ytUNbPY96ltPfRLxvAD2MIuWpDGV6dmKat
         4sjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680749108;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sKxOWbr7rDn/qnvB6FljLF8vj/aIxvx/70FeQshH1rE=;
        b=1pnNbWW2ZexTTKD4zD8LDjc/pksRDsHFVn6d6hG004/lWdxtQuA+33O+UKt7q8ce41
         TjJoYUzCN2RfLWZKGk+PQnZpoiD1e0JTcQx9plXCMrESqBLMZZVrs1hHmw6STgSPY2Rt
         aVnjp575Wb/H9wOdfEZf7ApCPAxIJmEDtAOB++zeo0FCKe1FVLsFUe/25RR3gxAR61/A
         GonfqlN4BnTA2JNEGvXFI/9jU7v0VNe66yfLl0Rl03d52ivMvkGpLB90csppi3jKfOp8
         3h/Myb5oFlegcPN0XamE+WRlEQF9d8592WKxP+FFg8KvMiVyhEq4/ujX+L5sy5gyUv/K
         VbQA==
X-Gm-Message-State: AAQBX9epVo1eLQ93ihH930Y7lKQz2It6NhDP9/bzb20UlBx2F0lfBAH9
        yC6fla7EZk61DwbcniUKSRI=
X-Google-Smtp-Source: AKy350al49pn09cKU9mnQ5KGBI7hgLFHlH//fL84AGw/2LD0tpEz2STzpoTTsgOtQdFN/hoMzcqu+Q==
X-Received: by 2002:a05:6a20:6690:b0:d9:e45d:95da with SMTP id o16-20020a056a20669000b000d9e45d95damr1425321pzh.20.1680749108397;
        Wed, 05 Apr 2023 19:45:08 -0700 (PDT)
Received: from localhost.localdomain ([43.155.90.222])
        by smtp.googlemail.com with ESMTPSA id 3-20020aa79243000000b0062e12f945adsm86374pfp.135.2023.04.05.19.45.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Apr 2023 19:45:07 -0700 (PDT)
From:   juanfengpy@gmail.com
X-Google-Original-From: caelli@tencent.com
To:     jirislaby@kernel.org, gregkh@linuxfoundation.org
Cc:     ilpo.jarvinen@linux.intel.com, bagasdotme@gmail.com,
        benbjiang@tencent.com, robinlai@tencent.com,
        linux-serial@vger.kernel.org, juanfengpy@gmail.com,
        Hui Li <caelli@tencent.com>, <stable@vger.kernel.org>
Subject: [PATCH v9] tty: fix hang on tty device with no_room set
Date:   Thu,  6 Apr 2023 10:44:50 +0800
Message-Id: <1680749090-14106-1-git-send-email-caelli@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1679037946-18156-1-git-send-email-caelli@tencent.com>
References: <1679037946-18156-1-git-send-email-caelli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Li <caelli@tencent.com>

It is possible to hang pty devices in this case, the reader was
blocking at epoll on master side, the writer was sleeping at
wait_woken inside n_tty_write on slave side, and the write buffer
on tty_port was full, we found that the reader and writer would
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
Patch changelogs between v8 and v9:
	-change the commit messages as suggested by Bagas Sanjaya.

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

