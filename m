Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCC352AC86
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 22:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345821AbiEQUNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 16:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242648AbiEQUN3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 16:13:29 -0400
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32FE3ED27
        for <stable@vger.kernel.org>; Tue, 17 May 2022 13:13:28 -0700 (PDT)
Received: by mail-wm1-f50.google.com with SMTP id o12-20020a1c4d0c000000b00393fbe2973dso2039938wmh.2
        for <stable@vger.kernel.org>; Tue, 17 May 2022 13:13:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zL58PPAXBZxZ4TJTFbQYT/SZuK9MZpF31VyDwwiyZ48=;
        b=CIWbGmWXOPqRsvkg+Vq7euC08bBnoo0HDUWfwthDurXZc6ItVsRXNEjfR/8oSwJN+K
         TIlL5OVDjY3E8w54Z8nxNJfCwjjat5eeKNBj0jmML6GcgY/nKpbFlcbL8DXunxJAvn4B
         AI//JQ03MpfOY8F07Ui//c7q+i02e7wH1qB2/NmxMZPpK9Lr6VdnEC6FZVZolF88qnh0
         tTMIK3fX/Y7t2Bnnd90q7XxyD0fDbFiwdNgESnfxDqqB11ctFt59JuSCMNKYRqa0NwT4
         ZlaQffRmEApyrAGCS+2bodlWDrJ0t301LnJKRKo5aC4xcBmaoNwPQt/wSAkFMstOLWn6
         VtIA==
X-Gm-Message-State: AOAM531NYymKGUYftUgDNKkt3oDV7FJryi2LhFPEylt3TGv+sNCnM+iS
        S16biDJegf9lwE4WCmIj7o8blpict0c=
X-Google-Smtp-Source: ABdhPJxxjlRPs7ld6MpTWUZAwcCu2Z/nVv8bewMKEn4SJleFTn/rjMVOShJ2BbXsXmqj99ySzGOygw==
X-Received: by 2002:a05:600c:a45:b0:346:5e67:cd54 with SMTP id c5-20020a05600c0a4500b003465e67cd54mr34241230wmq.127.1652818406966;
        Tue, 17 May 2022 13:13:26 -0700 (PDT)
Received: from localhost.localdomain ([94.205.35.240])
        by smtp.googlemail.com with ESMTPSA id o23-20020a05600c511700b0039456c00ba7sm3609232wms.1.2022.05.17.13.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 13:13:25 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     gregkh@linuxfoundation.org
Cc:     Willy Tarreau <w@1wt.eu>, stable@vger.kernel.org,
        Minh Yuan <yuanmingbuaa@gmail.com>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Denis Efremov <efremov@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10] floppy: use a statically allocated error counter
Date:   Wed, 18 May 2022 00:12:15 +0400
Message-Id: <20220517201215.36166-1-efremov@linux.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220508093709.24548-1-w@1wt.eu>
References: <20220508093709.24548-1-w@1wt.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
Signed-off-by: Denis Efremov <efremov@linux.com>
---

Handled *errors in make_raw_rw_request().

 drivers/block/floppy.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index c9411fe2f0af..4ef407a33996 100644
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
@@ -2240,9 +2239,8 @@ static int do_format(int drive, struct format_descr *tmp_format_req)
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
@@ -2721,7 +2719,7 @@ static int make_raw_rw_request(void)
 		 */
 		if (!direct ||
 		    (indirect * 2 > direct * 3 &&
-		     *errors < drive_params[current_drive].max_errors.read_track &&
+		     floppy_errors < drive_params[current_drive].max_errors.read_track &&
 		     ((!probing ||
 		       (drive_params[current_drive].read_track & (1 << drive_state[current_drive].probed_format)))))) {
 			max_size = blk_rq_sectors(current_req);
@@ -2846,10 +2844,11 @@ static int set_next_request(void)
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
@@ -2908,7 +2907,6 @@ static void redo_fd_request(void)
 		_floppy = floppy_type + drive_params[current_drive].autodetect[drive_state[current_drive].probed_format];
 	} else
 		probing = 0;
-	errors = &(current_req->error_count);
 	tmp = make_raw_rw_request();
 	if (tmp < 2) {
 		request_done(tmp);
-- 
2.35.3

