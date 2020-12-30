Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 763282E7CBC
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 22:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgL3Vih (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 16:38:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbgL3Vih (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Dec 2020 16:38:37 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889A5C06179C;
        Wed, 30 Dec 2020 13:37:56 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id d26so18589816wrb.12;
        Wed, 30 Dec 2020 13:37:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i0JNeSkZ2Mn9i0Rgzs4ebXYJyDNhaT1q8nmzEolEWEU=;
        b=Iqy4iCQm5P+22C8q20TX0sOYFKKmJlhZ7rnwF1NW+qI5z0WSA+U6Q7ySgH7KQL7Ahn
         Yghzqil01IhM2jAnmzmQ8LSDms55btkPtUBPe8P+Lh3BqbSCyRDvLRl1NJmC4UaGt3id
         j6bwG+dcIGK+XuTO5tp/P8rRPzSv5HtehalbLgLJx6yjr+6V8YmYYDZpz8cwVzQibuBV
         XlLvvKrtxraJXQP75XlYSl19aeEEEqr45focTfgpa5aaCxMKXpfdSiY0tY23pmWQ92Qv
         hJeLbNFyYAiMoT9ubTSXJc/HwiFH6uJ7ro7CC8zIRT2jW7ZH7fR7OofDxNUjXS6G4CDj
         Eehg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i0JNeSkZ2Mn9i0Rgzs4ebXYJyDNhaT1q8nmzEolEWEU=;
        b=sNclSvc1Z2trDW4H5xGeN5z950Um8zPNxMPtiZ6vvv43/dtrPx64VbXmUwBSeyRAhC
         3hNkBk2HLDP47d2W/Bu9TmUhxMQkpYEB/7O/kUfp8gSI2Tzd0n9rZFDjvR5hBbvh68b7
         gCjXYjB/Ow9h7G0kmTK0UZdrXJXY7+CDVBaS1fx5POJZvXIr2MGRjBtQ7EpKXGzeQCD3
         9ANAv7s4RjMCitmdIaBR82oxsCSbswZHAtAUhIDG3JUGUkPznTWIjeRdtgw6LGURm7yT
         5rox9lq/Mpcxwgm+Ybh49cpOkZziNfYPzNrbYxjhF7Tp6xFngFOM9apCxYunSq1GM9wv
         tRpQ==
X-Gm-Message-State: AOAM531SVCYJceasna8CSXMI3V9B9Lpz7JGdh2M63DMj9TrfSqaA0j65
        p7dVRazkyaT4lFkABOZU6UdG76PvQfw=
X-Google-Smtp-Source: ABdhPJwS4yFFQo+1+d3EDkTD6TwqL2FwKqpW6u8O8yXqK6jd7R/hmdKGZ1lF8NN8Xzv3V3//l1sw7w==
X-Received: by 2002:adf:eac7:: with SMTP id o7mr62514974wrn.23.1609364275312;
        Wed, 30 Dec 2020 13:37:55 -0800 (PST)
Received: from localhost.localdomain ([148.252.128.61])
        by smtp.gmail.com with ESMTPSA id 125sm8823626wmc.27.2020.12.30.13.37.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Dec 2020 13:37:54 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 4/4] io_uring: cancel requests enqueued as task_work's
Date:   Wed, 30 Dec 2020 21:34:17 +0000
Message-Id: <9d7a1c5ce3fe2a6054382760b9ef68f03c6e11ba.1609361865.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1609361865.git.asml.silence@gmail.com>
References: <cover.1609361865.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently request cancellations are happening before PF_EXITING is set,
so it's allowed to call task_work_run(). Even though it should work as
it's not it's safer to remove PF_EXITING checks.

Cc: stable@vger.kernel.org # 5.5+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ca46f314640b..8d4fa0031e0a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2361,12 +2361,8 @@ static inline unsigned int io_put_rw_kbuf(struct io_kiocb *req)
 
 static inline bool io_run_task_work(void)
 {
-	/*
-	 * Not safe to run on exiting task, and the task_work handling will
-	 * not add work to such a task.
-	 */
-	if (unlikely(current->flags & PF_EXITING))
-		return false;
+	WARN_ON_ONCE(current->flags & PF_EXITING);
+
 	if (current->task_works) {
 		__set_current_state(TASK_RUNNING);
 		task_work_run();
-- 
2.24.0

