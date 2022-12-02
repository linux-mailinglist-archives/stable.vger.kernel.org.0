Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C43F364086A
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 15:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbiLBO3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 09:29:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233257AbiLBO3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 09:29:48 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E095DC847
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 06:29:47 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id r9-20020a1c4409000000b003d08febff59so9498wma.3
        for <stable@vger.kernel.org>; Fri, 02 Dec 2022 06:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LcW12Iogavs9pEyVxO0yQqQrzKlm0yZtxCctvTzxuxI=;
        b=UKGzEhCdT6aUrL6TzxBUNJQu1HC0mjEwpeWZ0fjUNRRodYj6yZAGaiS/uKjZu38qyI
         CfS3pZKGlBpwdzev37L0y69uyP7SsPSaQAQpoxAo+s13Zcp50z4oHeMh6A37Doh6qXeS
         v6xgZoJZCexWPGmIl8nHX8FQxu8vxlvHpajBvziSWihhjgDoM40O8qxB7JqCP6mOwHMz
         WP+rr1lePZFPoAFaBi54z1Aglaand/bD0bR36xg77GwQ2u5jPt5Mq8ugT4xZtj+55Cv8
         jdsLAAhwCw4RMTlaOxnMKmsZsjGN+SFY1Xgabn0T1TqH03rE/SNMSGnfVKvAV/xajlrG
         avsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LcW12Iogavs9pEyVxO0yQqQrzKlm0yZtxCctvTzxuxI=;
        b=uP61DymNOeAocYYWhd6Yve7ePQJj4a/3dAbCDdqujwsjCneUZyuAleQikVEXWFbaXb
         jRVW+EbuOa6OzlNjLTFVmbXxxXBvQ37LfbWPHh9hVsu4D/8XVFYtSWdKZw74aDNjn4eE
         3+fyKNSsHuAnS2am++f/Iw3hzh4TeD4m6HJIStxGIpHFuTWhHG9uK15dwcBtaerzeRPZ
         hbyY/dAltyPIc2OWqL37VPnaI+qieezKvcgK3XhnDetYYyU9Zfe/6gx1bLVhUkQiktoY
         kGZt5nUiYS8xwIyZnQa4CRbgED9yxa9pZ4BZK8pHbP7UQUJEB5lQyBJv37i/QRqBPstn
         fGqg==
X-Gm-Message-State: ANoB5pkn4QTcJDv01H5HZM1xzD6Ncl4EqwAlTYwOziKqYymnkMg8vpJO
        IFDdzOM+hititf5yOzlXv1Lp3kSRb7k=
X-Google-Smtp-Source: AA0mqf69XHR1feOgXkqv3hvITbNbeho/0+hdt9qqISVR6fyfl359MCbpwvKuc0RzE7rx2WtcXLPxjg==
X-Received: by 2002:a05:600c:43d6:b0:3d0:387d:8eb6 with SMTP id f22-20020a05600c43d600b003d0387d8eb6mr32467676wmn.137.1669991385715;
        Fri, 02 Dec 2022 06:29:45 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:2dd3])
        by smtp.gmail.com with ESMTPSA id n187-20020a1ca4c4000000b003d005aab31asm8956946wme.40.2022.12.02.06.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 06:29:45 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Lin Ma <linma@zju.edu.cn>
Subject: [PATCH stable-5.15 4/5] io_uring: make poll refs more robust
Date:   Fri,  2 Dec 2022 14:27:14 +0000
Message-Id: <f305c479060d33d5653a253898ac42f4bb11d329.1669990799.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1669990799.git.asml.silence@gmail.com>
References: <cover.1669990799.git.asml.silence@gmail.com>
MIME-Version: 1.0
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

[ upstream commit a26a35e9019fd70bf3cf647dcfdae87abc7bacea ]

poll_refs carry two functions, the first is ownership over the request.
The second is notifying the io_poll_check_events() that there was an
event but wake up couldn't grab the ownership, so io_poll_check_events()
should retry.

We want to make poll_refs more robust against overflows. Instead of
always incrementing it, which covers two purposes with one atomic, check
if poll_refs is elevated enough and if so set a retry flag without
attempts to grab ownership. The gap between the bias check and following
atomics may seem racy, but we don't need it to be strict. Moreover there
might only be maximum 4 parallel updates: by the first and the second
poll entries, __io_arm_poll_handler() and cancellation. From those four,
only poll wake ups may be executed multiple times, but they're protected
by a spin.

Cc: stable@vger.kernel.org
Reported-by: Lin Ma <linma@zju.edu.cn>
Fixes: aa43477b04025 ("io_uring: poll rework")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/c762bc31f8683b3270f3587691348a7119ef9c9d.1668963050.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0e3fc80fee05..11dcad170594 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5322,7 +5322,29 @@ struct io_poll_table {
 };
 
 #define IO_POLL_CANCEL_FLAG	BIT(31)
-#define IO_POLL_REF_MASK	GENMASK(30, 0)
+#define IO_POLL_RETRY_FLAG	BIT(30)
+#define IO_POLL_REF_MASK	GENMASK(29, 0)
+
+/*
+ * We usually have 1-2 refs taken, 128 is more than enough and we want to
+ * maximise the margin between this amount and the moment when it overflows.
+ */
+#define IO_POLL_REF_BIAS       128
+
+static bool io_poll_get_ownership_slowpath(struct io_kiocb *req)
+{
+	int v;
+
+	/*
+	 * poll_refs are already elevated and we don't have much hope for
+	 * grabbing the ownership. Instead of incrementing set a retry flag
+	 * to notify the loop that there might have been some change.
+	 */
+	v = atomic_fetch_or(IO_POLL_RETRY_FLAG, &req->poll_refs);
+	if (v & IO_POLL_REF_MASK)
+		return false;
+	return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
+}
 
 /*
  * If refs part of ->poll_refs (see IO_POLL_REF_MASK) is 0, it's free. We can
@@ -5332,6 +5354,8 @@ struct io_poll_table {
  */
 static inline bool io_poll_get_ownership(struct io_kiocb *req)
 {
+	if (unlikely(atomic_read(&req->poll_refs) >= IO_POLL_REF_BIAS))
+		return io_poll_get_ownership_slowpath(req);
 	return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
 }
 
@@ -5447,6 +5471,16 @@ static int io_poll_check_events(struct io_kiocb *req)
 		 */
 		if ((v & IO_POLL_REF_MASK) != 1)
 			req->result = 0;
+		if (v & IO_POLL_RETRY_FLAG) {
+			req->result = 0;
+			/*
+			 * We won't find new events that came in between
+			 * vfs_poll and the ref put unless we clear the
+			 * flag in advance.
+			 */
+			atomic_andnot(IO_POLL_RETRY_FLAG, &req->poll_refs);
+			v &= ~IO_POLL_RETRY_FLAG;
+		}
 
 		if (!req->result) {
 			struct poll_table_struct pt = { ._key = poll->events };
-- 
2.38.1

