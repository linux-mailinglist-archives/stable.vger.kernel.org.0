Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50E644FAF0B
	for <lists+stable@lfdr.de>; Sun, 10 Apr 2022 18:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238520AbiDJQsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Apr 2022 12:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238445AbiDJQsm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Apr 2022 12:48:42 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9C44B840
        for <stable@vger.kernel.org>; Sun, 10 Apr 2022 09:46:30 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id n8so11957624plh.1
        for <stable@vger.kernel.org>; Sun, 10 Apr 2022 09:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=53cOIAYGyOS23kshrm4Uc4aZhp2HA2Cg63sIOKkCVEg=;
        b=QTV9BYajmaEkrHmAAaUU4NJ6whm2RY2fe6AKFmDedi2civssBRmd437fSbE/55Kl+m
         rDASWwweA6KAPw8XM/5DRDDCj3mIqSU0v/BnQplYs/QviFBgibmb7iOrCi2YpWZnwNa5
         KQFRbzFt7M2gl4EvATNhoarV6ZA+6r30hzHzJltGKvDhT20UxTCHGovYVufl9W+/OPya
         030YGL5BJwHSGmOvdWqk9w20KvX8lljhLCn7/Ua7znCVO9rdZhroxGz4nAmRkQJ4JC9n
         1LvzuqWGNC2EhLiOzY5YVgnny9TFc8Y1l4aYh1RjZNm6SYd0l18ywQ7p0JnE0Fy7sHmR
         vuTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=53cOIAYGyOS23kshrm4Uc4aZhp2HA2Cg63sIOKkCVEg=;
        b=GjCnyPEP2+qIbn1gVcGiLxQGnRXh1pq99ggkUSxoI7zsKhgnevCcfWKWKyl3pzVBEH
         nILLs4TpNkvG3H5U+QfEcHSmaSkZLvtIZAdYAMt/ypIFyJdtw6rfGuOp/yKtqAcChl+A
         VxVUfHqp9sd/wQE0Lf78D4uOHiH66wYx4XRAJgQEpqy3/P1tv1d/Q4RX2tFjjSu0xca0
         liHjADCWPo8SgirpbSBX3zzSB8QG3HBkwhIWN2r4/aaDliaquZY4DN6fRas1jh3eoprJ
         Y3wlzcZX7pg0CembRrKPBLqdV8KyxqpbgiNAls0TG3Z5WJ+rlGGMDFv9xJgiuuzL2Goc
         eSJQ==
X-Gm-Message-State: AOAM533k2DoA+sX2Q+Oy1o8SXOud/yJUKl1efHxiMYtexboBgnz3ieYZ
        yow/IJ35fuqnDNP59jzdC29Z+uMRxSzqVw==
X-Google-Smtp-Source: ABdhPJwqcKg8+z3kWCYIEPmmZRSm6pRujHL+2AzhuZlREiMiRZ8ufjKw10imoYp3sXDu+GjBhdT+0Q==
X-Received: by 2002:a17:902:bf09:b0:153:99a6:55b8 with SMTP id bi9-20020a170902bf0900b0015399a655b8mr28098704plb.142.1649609189602;
        Sun, 10 Apr 2022 09:46:29 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d59-20020a17090a6f4100b001cb4b786e64sm8164675pjk.28.2022.04.10.09.46.28
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Apr 2022 09:46:28 -0700 (PDT)
Message-ID: <5baa6fdd-4f5e-338b-7c38-28e5a88bfe65@kernel.dk>
Date:   Sun, 10 Apr 2022 10:46:27 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     stable@vger.kernel.org
From:   Jens Axboe <axboe@kernel.dk>
Subject: Queue up 5.10 io_uring backport
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Can you queue up this one for 5.10 stable? It has an extra hunk
that's needed for 5.10. 5.15/16/17 will be a direct port of
the 5.18-rc patch.


commit e677edbcabee849bfdd43f1602bccbecf736a646
Author: Jens Axboe <axboe@kernel.dk>
Date:   Fri Apr 8 11:08:58 2022 -0600

    io_uring: fix race between timeout flush and removal
    
    commit e677edbcabee849bfdd43f1602bccbecf736a646 upstream.

    io_flush_timeouts() assumes the timeout isn't in progress of triggering
    or being removed/canceled, so it unconditionally removes it from the
    timeout list and attempts to cancel it.
    
    Leave it on the list and let the normal timeout cancelation take care
    of it.
    
    Cc: stable@vger.kernel.org # 5.5+
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5959b0359524..bc6bf17566f8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1556,6 +1556,7 @@ static void __io_queue_deferred(struct io_ring_ctx *ctx)
 
 static void io_flush_timeouts(struct io_ring_ctx *ctx)
 {
+	struct io_kiocb *req, *tmp;
 	u32 seq;
 
 	if (list_empty(&ctx->timeout_list))
@@ -1563,10 +1564,8 @@ static void io_flush_timeouts(struct io_ring_ctx *ctx)
 
 	seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
 
-	do {
+	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, timeout.list) {
 		u32 events_needed, events_got;
-		struct io_kiocb *req = list_first_entry(&ctx->timeout_list,
-						struct io_kiocb, timeout.list);
 
 		if (io_is_timeout_noseq(req))
 			break;
@@ -1583,9 +1582,8 @@ static void io_flush_timeouts(struct io_ring_ctx *ctx)
 		if (events_got < events_needed)
 			break;
 
-		list_del_init(&req->timeout.list);
 		io_kill_timeout(req, 0);
-	} while (!list_empty(&ctx->timeout_list));
+	}
 
 	ctx->cq_last_tm_flush = seq;
 }
@@ -5639,6 +5637,7 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	else
 		data->mode = HRTIMER_MODE_REL;
 
+	INIT_LIST_HEAD(&req->timeout.list);
 	hrtimer_init(&data->timer, CLOCK_MONOTONIC, data->mode);
 	return 0;
 }
@@ -6282,12 +6281,12 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	if (!list_empty(&req->link_list)) {
 		prev = list_entry(req->link_list.prev, struct io_kiocb,
 				  link_list);
-		if (refcount_inc_not_zero(&prev->refs))
-			list_del_init(&req->link_list);
-		else
+		list_del_init(&req->link_list);
+		if (!refcount_inc_not_zero(&prev->refs))
 			prev = NULL;
 	}
 
+	list_del(&req->timeout.list);
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
 	if (prev) {


-- 
Jens Axboe

