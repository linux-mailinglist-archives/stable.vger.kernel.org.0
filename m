Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA3352ACF6
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 22:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351536AbiEQUrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 16:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353029AbiEQUre (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 16:47:34 -0400
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5BE4A925
        for <stable@vger.kernel.org>; Tue, 17 May 2022 13:47:33 -0700 (PDT)
Received: by mail-wm1-f42.google.com with SMTP id i20-20020a05600c355400b0039456976dcaso1585520wmq.1
        for <stable@vger.kernel.org>; Tue, 17 May 2022 13:47:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t1VrVjYTW2VAAVeymD4hpXwuR/R1xi6xB5F0a9OxATk=;
        b=en8mIKBqUMLL4MIpKAl4jrP8EYTHkJ1K1G4L2UJ8FX3cJXLlIndMYerl8jjDhc9XL9
         Ha4svtuUQRvLMevJ3CiWeUzinOuZY0FrOoqiwC61SVUvjZCsbCIX1yssSWgwqzOmaSSK
         dRF+cL2/vaQ6MgG0/MEtQSy6TxBS1Tp66vO7fa+QmPolKT6w1t6lHyLMUpktUx+xuSnq
         S2TZ8FuArouGadWrCk/wL7B6NXkTKJY3xLOhvmrVU9HS+CiB07R+mxSDX18JkkFezVSZ
         TAumyH0FUXgaWCXr5RV/3pslBEy0TY7+PwiCUoPuTeSYYrolmvBiFbchtsM29yn/VtgB
         aL2A==
X-Gm-Message-State: AOAM531Ssy8++8TMc7rLCr9PRNmaVvrPZ9t+EyoLVGQqfA2dlkFS5MEn
        kK+X61B/8VBunJu+mj2tMao=
X-Google-Smtp-Source: ABdhPJwW45xC6N9yY+MRVje3IArXTz9J+asp8eXqmoITw0k9vZjGK21AwTzqRHSTNFDtcSpM/U+LjQ==
X-Received: by 2002:a05:600c:1986:b0:394:77a3:bfa9 with SMTP id t6-20020a05600c198600b0039477a3bfa9mr22717795wmq.142.1652820451659;
        Tue, 17 May 2022 13:47:31 -0700 (PDT)
Received: from localhost.localdomain ([94.205.35.240])
        by smtp.googlemail.com with ESMTPSA id j17-20020a05600c489100b003942a244ed0sm104816wmp.21.2022.05.17.13.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 13:47:30 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     gregkh@linuxfoundation.org
Cc:     Willy Tarreau <w@1wt.eu>, stable@vger.kernel.org,
        Minh Yuan <yuanmingbuaa@gmail.com>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Denis Efremov <efremov@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9] floppy: use a statically allocated error counter
Date:   Wed, 18 May 2022 00:46:39 +0400
Message-Id: <20220517204639.76678-1-efremov@linux.com>
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
 drivers/block/floppy.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index cfe1bfb3c20e..216ee1057b12 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -516,8 +516,8 @@ static unsigned long fdc_busy;
 static DECLARE_WAIT_QUEUE_HEAD(fdc_wait);
 static DECLARE_WAIT_QUEUE_HEAD(command_done);
 
-/* Errors during formatting are counted here. */
-static int format_errors;
+/* errors encountered on the current (or last) request */
+static int floppy_errors;
 
 /* Format request descriptor. */
 static struct format_descr format_req;
@@ -537,7 +537,6 @@ static struct format_descr format_req;
 static char *floppy_track_buffer;
 static int max_buffer_sectors;
 
-static int *errors;
 typedef void (*done_f)(int);
 static const struct cont_t {
 	void (*interrupt)(void);
@@ -1426,7 +1425,7 @@ static int interpret_errors(void)
 			if (DP->flags & FTD_MSG)
 				DPRINT("Over/Underrun - retrying\n");
 			bad = 0;
-		} else if (*errors >= DP->max_errors.reporting) {
+		} else if (floppy_errors >= DP->max_errors.reporting) {
 			print_errors();
 		}
 		if (ST2 & ST2_WC || ST2 & ST2_BC)
@@ -2049,7 +2048,7 @@ static void bad_flp_intr(void)
 		if (!next_valid_format())
 			return;
 	}
-	err_count = ++(*errors);
+	err_count = ++floppy_errors;
 	INFBOUND(DRWE->badness, err_count);
 	if (err_count > DP->max_errors.abort)
 		cont->done(0);
@@ -2194,9 +2193,8 @@ static int do_format(int drive, struct format_descr *tmp_format_req)
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
@@ -2679,7 +2677,7 @@ static int make_raw_rw_request(void)
 		 */
 		if (!direct ||
 		    (indirect * 2 > direct * 3 &&
-		     *errors < DP->max_errors.read_track &&
+		     floppy_errors < DP->max_errors.read_track &&
 		     ((!probing ||
 		       (DP->read_track & (1 << DRS->probed_format)))))) {
 			max_size = blk_rq_sectors(current_req);
@@ -2812,8 +2810,10 @@ static int set_next_request(void)
 			fdc_queue = 0;
 		if (q) {
 			current_req = blk_fetch_request(q);
-			if (current_req)
+			if (current_req) {
+				floppy_errors = 0;
 				break;
+			}
 		}
 	} while (fdc_queue != old_pos);
 
@@ -2873,7 +2873,6 @@ static void redo_fd_request(void)
 		_floppy = floppy_type + DP->autodetect[DRS->probed_format];
 	} else
 		probing = 0;
-	errors = &(current_req->errors);
 	tmp = make_raw_rw_request();
 	if (tmp < 2) {
 		request_done(tmp);
-- 
2.35.3

