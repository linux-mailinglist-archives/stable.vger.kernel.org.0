Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D149752ACD9
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 22:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353012AbiEQUiD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 16:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352991AbiEQUfy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 16:35:54 -0400
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BCF63D4
        for <stable@vger.kernel.org>; Tue, 17 May 2022 13:35:48 -0700 (PDT)
Received: by mail-wr1-f44.google.com with SMTP id d21so10311807wra.10
        for <stable@vger.kernel.org>; Tue, 17 May 2022 13:35:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1CY4w85yduXFEgIaqxjuEE4C+vumx45wHWXgObwK/Tw=;
        b=y5CPTOqph+HJVv7ISe0LOBYl5h5UlAw1bRb1WIP7lPwC4I+NbsdE+brRJQUVKA7DiD
         2H6YWygT/a63T9VnBb1tKiTEmphJieJ102XiuGlf2V3HafYgrDXBbgTZCcubOEfbNfv3
         RCbsk2dHXT7d19BaeAzJBC5k0HDVwzWDAhU4/Hrn4dX8v56Q/EbeI89dDUrMBXJc8E9B
         bQxmkIw+mZjVmt89X023jR3keuqWLPKCyHxG0TH1v2geU4WQuNTpTEGknAbJ75knzW3Z
         SM6mzWU6pIXeC9/ZAnKNlC4u8P6XM11K3f0fkL1taFDwyVmyQL+CRohd/dYHkPPVYnBu
         F1QA==
X-Gm-Message-State: AOAM5310rWhJnAMOfn7raNpq+RzZjJa6oUYeCeKONpPg8rnBiYFgofcR
        gKHoF1K/QyYGkXPO1kkBJNs=
X-Google-Smtp-Source: ABdhPJyMhSTi+17ewpDTIUISwwcfumSM9LZctAigJbsZouxyAJC/TQrnVBQWR2L8T3UybZ/m1Zzd0A==
X-Received: by 2002:a05:6000:1378:b0:20d:78e:abb5 with SMTP id q24-20020a056000137800b0020d078eabb5mr10720557wrz.239.1652819746853;
        Tue, 17 May 2022 13:35:46 -0700 (PDT)
Received: from localhost.localdomain ([94.205.35.240])
        by smtp.googlemail.com with ESMTPSA id n4-20020a1c2704000000b003942a244f3asm2714641wmn.19.2022.05.17.13.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 13:35:46 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     gregkh@linuxfoundation.org
Cc:     Willy Tarreau <w@1wt.eu>, stable@vger.kernel.org,
        Minh Yuan <yuanmingbuaa@gmail.com>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Denis Efremov <efremov@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19] floppy: use a statically allocated error counter
Date:   Wed, 18 May 2022 00:35:16 +0400
Message-Id: <20220517203516.60030-1-efremov@linux.com>
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
 drivers/block/floppy.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 97c8fc4d6e7b..0e66314415c5 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -520,8 +520,8 @@ static unsigned long fdc_busy;
 static DECLARE_WAIT_QUEUE_HEAD(fdc_wait);
 static DECLARE_WAIT_QUEUE_HEAD(command_done);
 
-/* Errors during formatting are counted here. */
-static int format_errors;
+/* errors encountered on the current (or last) request */
+static int floppy_errors;
 
 /* Format request descriptor. */
 static struct format_descr format_req;
@@ -541,7 +541,6 @@ static struct format_descr format_req;
 static char *floppy_track_buffer;
 static int max_buffer_sectors;
 
-static int *errors;
 typedef void (*done_f)(int);
 static const struct cont_t {
 	void (*interrupt)(void);
@@ -1434,7 +1433,7 @@ static int interpret_errors(void)
 			if (DP->flags & FTD_MSG)
 				DPRINT("Over/Underrun - retrying\n");
 			bad = 0;
-		} else if (*errors >= DP->max_errors.reporting) {
+		} else if (floppy_errors >= DP->max_errors.reporting) {
 			print_errors();
 		}
 		if (ST2 & ST2_WC || ST2 & ST2_BC)
@@ -2054,7 +2053,7 @@ static void bad_flp_intr(void)
 		if (!next_valid_format())
 			return;
 	}
-	err_count = ++(*errors);
+	err_count = ++floppy_errors;
 	INFBOUND(DRWE->badness, err_count);
 	if (err_count > DP->max_errors.abort)
 		cont->done(0);
@@ -2199,9 +2198,8 @@ static int do_format(int drive, struct format_descr *tmp_format_req)
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
@@ -2684,7 +2682,7 @@ static int make_raw_rw_request(void)
 		 */
 		if (!direct ||
 		    (indirect * 2 > direct * 3 &&
-		     *errors < DP->max_errors.read_track &&
+		     floppy_errors < DP->max_errors.read_track &&
 		     ((!probing ||
 		       (DP->read_track & (1 << DRS->probed_format)))))) {
 			max_size = blk_rq_sectors(current_req);
@@ -2818,7 +2816,7 @@ static int set_next_request(void)
 		if (q) {
 			current_req = blk_fetch_request(q);
 			if (current_req) {
-				current_req->error_count = 0;
+				floppy_errors = 0;
 				break;
 			}
 		}
@@ -2880,7 +2878,6 @@ static void redo_fd_request(void)
 		_floppy = floppy_type + DP->autodetect[DRS->probed_format];
 	} else
 		probing = 0;
-	errors = &(current_req->error_count);
 	tmp = make_raw_rw_request();
 	if (tmp < 2) {
 		request_done(tmp);
-- 
2.35.3

