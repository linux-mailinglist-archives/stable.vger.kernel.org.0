Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE42E52ACAA
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 22:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbiEQUYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 16:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbiEQUYJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 16:24:09 -0400
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7325D5252F
        for <stable@vger.kernel.org>; Tue, 17 May 2022 13:24:08 -0700 (PDT)
Received: by mail-wr1-f50.google.com with SMTP id j24so10947237wrb.1
        for <stable@vger.kernel.org>; Tue, 17 May 2022 13:24:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0gp2QrZ+Xf5e4vypYACGu38rxTWx4SE2OTF0mjVsKlY=;
        b=h8vshPjuRH8WhF7Uo7iWc+Vb/PmausOPLD9RtPhX+Wz27dF5ArIAvawOxoOGn6H7MQ
         Vbsep9NyYhEJGDadPvav1iX9+mKX24IryRDxydHex0kQtBKcbd/2vNcFo30OHEFzXVHN
         /xcFpZPybYnZ9OOKKjtdEKF99rI1SjOP3zTFZBmQmJvQbH0Z5F0Jyu8QWdrrKjyd6XFA
         staMWPYEV7MYx0u9fbVAl5oQcMA7h6L+2S5a8s+q/f/2t8IQrHtcFY6xmxwk7cf35WrO
         VBKZeLJ+coJgtLEIkyDAVi9OH1H+Cnjtb/UPIBENE4YRnsNGrr/TDgyCzv2pIEhi0If/
         oVVA==
X-Gm-Message-State: AOAM532NWVa6ojSyOrcOCsA57rmVx9+MoI/D5qk43r5M8f0p94Kc1b83
        7JXKMapWzes8BgfJ6RrJswo=
X-Google-Smtp-Source: ABdhPJzXKmlLpzTnpIhb0SDZJkqmx+93Yf7s2upxuiEi1YBVDya+K+0SSVXwrW1gUIHI/tCXkNsAiQ==
X-Received: by 2002:adf:ee11:0:b0:20d:430:6b42 with SMTP id y17-20020adfee11000000b0020d04306b42mr12327679wrn.31.1652819046975;
        Tue, 17 May 2022 13:24:06 -0700 (PDT)
Received: from localhost.localdomain ([94.205.35.240])
        by smtp.googlemail.com with ESMTPSA id w10-20020a7bc10a000000b003971176b011sm134034wmi.0.2022.05.17.13.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 13:24:06 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     gregkh@linuxfoundation.org
Cc:     Willy Tarreau <w@1wt.eu>, stable@vger.kernel.org,
        Minh Yuan <yuanmingbuaa@gmail.com>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Denis Efremov <efremov@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4] floppy: use a statically allocated error counter
Date:   Wed, 18 May 2022 00:23:40 +0400
Message-Id: <20220517202340.51711-1-efremov@linux.com>
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
 drivers/block/floppy.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index f24e3791e840..e133ff5fa596 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -521,8 +521,8 @@ static unsigned long fdc_busy;
 static DECLARE_WAIT_QUEUE_HEAD(fdc_wait);
 static DECLARE_WAIT_QUEUE_HEAD(command_done);
 
-/* Errors during formatting are counted here. */
-static int format_errors;
+/* errors encountered on the current (or last) request */
+static int floppy_errors;
 
 /* Format request descriptor. */
 static struct format_descr format_req;
@@ -542,7 +542,6 @@ static struct format_descr format_req;
 static char *floppy_track_buffer;
 static int max_buffer_sectors;
 
-static int *errors;
 typedef void (*done_f)(int);
 static const struct cont_t {
 	void (*interrupt)(void);
@@ -1435,7 +1434,7 @@ static int interpret_errors(void)
 			if (DP->flags & FTD_MSG)
 				DPRINT("Over/Underrun - retrying\n");
 			bad = 0;
-		} else if (*errors >= DP->max_errors.reporting) {
+		} else if (floppy_errors >= DP->max_errors.reporting) {
 			print_errors();
 		}
 		if (ST2 & ST2_WC || ST2 & ST2_BC)
@@ -2055,7 +2054,7 @@ static void bad_flp_intr(void)
 		if (!next_valid_format())
 			return;
 	}
-	err_count = ++(*errors);
+	err_count = ++floppy_errors;
 	INFBOUND(DRWE->badness, err_count);
 	if (err_count > DP->max_errors.abort)
 		cont->done(0);
@@ -2200,9 +2199,8 @@ static int do_format(int drive, struct format_descr *tmp_format_req)
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
@@ -2677,7 +2675,7 @@ static int make_raw_rw_request(void)
 		 */
 		if (!direct ||
 		    (indirect * 2 > direct * 3 &&
-		     *errors < DP->max_errors.read_track &&
+		     floppy_errors < DP->max_errors.read_track &&
 		     ((!probing ||
 		       (DP->read_track & (1 << DRS->probed_format)))))) {
 			max_size = blk_rq_sectors(current_req);
@@ -2801,10 +2799,11 @@ static int set_next_request(void)
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
 
 static void redo_fd_request(void)
@@ -2860,7 +2859,6 @@ static void redo_fd_request(void)
 		_floppy = floppy_type + DP->autodetect[DRS->probed_format];
 	} else
 		probing = 0;
-	errors = &(current_req->error_count);
 	tmp = make_raw_rw_request();
 	if (tmp < 2) {
 		request_done(tmp);
-- 
2.35.3

