Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD2F6531676
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236095AbiEWRXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241695AbiEWRWd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:22:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259F17C15B;
        Mon, 23 May 2022 10:19:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB663B811FF;
        Mon, 23 May 2022 17:18:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B39C385AA;
        Mon, 23 May 2022 17:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326281;
        bh=qWn9ZKbQrzQkwnnfeCk8yx1PqGXI3vpJJRoBj0bQd+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y0mALqeZRgObc+e1x2vbpeMx6r8EsoX/EM6uJ6rb88N9SPAEaGT5wAFoe1APEoS/T
         JarLZ9I9ck1HDny9Ub6BLkn61WBqmdckQjznghgjPsX/d6XmPPwwe9cMBO4ZEM6J2k
         LBOPT49lmAvLWdVK4Oz91XfzMOLvW9ccGvRjABE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minh Yuan <yuanmingbuaa@gmail.com>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Denis Efremov <efremov@linux.com>, Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 003/132] floppy: use a statically allocated error counter
Date:   Mon, 23 May 2022 19:03:32 +0200
Message-Id: <20220523165824.064053072@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>

commit f71f01394f742fc4558b3f9f4c7ef4c4cf3b07c8 upstream.

Interrupt handler bad_flp_intr() may cause a UAF on the recently freed
request just to increment the error count.  There's no point keeping
that one in the request anyway, and since the interrupt handler uses a
static pointer to the error which cannot be kept in sync with the
pending request, better make it use a static error counter that's reset
for each new request.  This reset now happens when entering
redo_fd_request() for a new request via set_next_request().

One initial concern about a single error counter was that errors on one
floppy drive could be reported on another one, but this problem is not
real given that the driver uses a single drive at a time, as that
PC-compatible controllers also have this limitation by using shared
signals.  As such the error count is always for the "current" drive.

Reported-by: Minh Yuan <yuanmingbuaa@gmail.com>
Suggested-by: Linus Torvalds <torvalds@linuxfoundation.org>
Tested-by: Denis Efremov <efremov@linux.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/floppy.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -509,8 +509,8 @@ static unsigned long fdc_busy;
 static DECLARE_WAIT_QUEUE_HEAD(fdc_wait);
 static DECLARE_WAIT_QUEUE_HEAD(command_done);
 
-/* Errors during formatting are counted here. */
-static int format_errors;
+/* errors encountered on the current (or last) request */
+static int floppy_errors;
 
 /* Format request descriptor. */
 static struct format_descr format_req;
@@ -530,7 +530,6 @@ static struct format_descr format_req;
 static char *floppy_track_buffer;
 static int max_buffer_sectors;
 
-static int *errors;
 typedef void (*done_f)(int);
 static const struct cont_t {
 	void (*interrupt)(void);
@@ -1455,7 +1454,7 @@ static int interpret_errors(void)
 			if (drive_params[current_drive].flags & FTD_MSG)
 				DPRINT("Over/Underrun - retrying\n");
 			bad = 0;
-		} else if (*errors >= drive_params[current_drive].max_errors.reporting) {
+		} else if (floppy_errors >= drive_params[current_drive].max_errors.reporting) {
 			print_errors();
 		}
 		if (reply_buffer[ST2] & ST2_WC || reply_buffer[ST2] & ST2_BC)
@@ -2095,7 +2094,7 @@ static void bad_flp_intr(void)
 		if (!next_valid_format(current_drive))
 			return;
 	}
-	err_count = ++(*errors);
+	err_count = ++floppy_errors;
 	INFBOUND(write_errors[current_drive].badness, err_count);
 	if (err_count > drive_params[current_drive].max_errors.abort)
 		cont->done(0);
@@ -2241,9 +2240,8 @@ static int do_format(int drive, struct f
 		return -EINVAL;
 	}
 	format_req = *tmp_format_req;
-	format_errors = 0;
 	cont = &format_cont;
-	errors = &format_errors;
+	floppy_errors = 0;
 	ret = wait_til_done(redo_format, true);
 	if (ret == -EINTR)
 		return -EINTR;
@@ -2761,10 +2759,11 @@ static int set_next_request(void)
 	current_req = list_first_entry_or_null(&floppy_reqs, struct request,
 					       queuelist);
 	if (current_req) {
-		current_req->error_count = 0;
+		floppy_errors = 0;
 		list_del_init(&current_req->queuelist);
+		return 1;
 	}
-	return current_req != NULL;
+	return 0;
 }
 
 /* Starts or continues processing request. Will automatically unlock the
@@ -2823,7 +2822,6 @@ do_request:
 		_floppy = floppy_type + drive_params[current_drive].autodetect[drive_state[current_drive].probed_format];
 	} else
 		probing = 0;
-	errors = &(current_req->error_count);
 	tmp = make_raw_rw_request();
 	if (tmp < 2) {
 		request_done(tmp);


