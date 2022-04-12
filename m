Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF994FD910
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353012AbiDLH2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351671AbiDLHMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:12:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A3215FFD;
        Mon, 11 Apr 2022 23:51:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C6F1B81B43;
        Tue, 12 Apr 2022 06:51:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C23EC385A1;
        Tue, 12 Apr 2022 06:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746274;
        bh=Px1Q6z1mnEqmDqVuhc0sZDElCkVdJB05UJ67MCkETW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=octhU8z6j/uxtY4Xjc+kzXVJNXaCGZRFXLkj701CUDez7io+v3Vt0IFjQ1HJRzkrW
         EDe9PzyNgxGseN7spFx1LJUfQZCDLQ/mLLbdI/2WRju0+AqfH1ftXkkhTb1Z8j/DoZ
         waKlBg4asLdwz0wjk+2ziItKAFhCBvuY3JCvxZ8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 221/277] io_uring: fix race between timeout flush and removal
Date:   Tue, 12 Apr 2022 08:30:24 +0200
Message-Id: <20220412062948.440027567@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit e677edbcabee849bfdd43f1602bccbecf736a646 upstream.

io_flush_timeouts() assumes the timeout isn't in progress of triggering
or being removed/canceled, so it unconditionally removes it from the
timeout list and attempts to cancel it.

Leave it on the list and let the normal timeout cancelation take care
of it.

Cc: stable@vger.kernel.org # 5.5+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1538,12 +1538,11 @@ static void io_flush_timeouts(struct io_
 	__must_hold(&ctx->completion_lock)
 {
 	u32 seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
+	struct io_kiocb *req, *tmp;
 
 	spin_lock_irq(&ctx->timeout_lock);
-	while (!list_empty(&ctx->timeout_list)) {
+	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, timeout.list) {
 		u32 events_needed, events_got;
-		struct io_kiocb *req = list_first_entry(&ctx->timeout_list,
-						struct io_kiocb, timeout.list);
 
 		if (io_is_timeout_noseq(req))
 			break;
@@ -1560,7 +1559,6 @@ static void io_flush_timeouts(struct io_
 		if (events_got < events_needed)
 			break;
 
-		list_del_init(&req->timeout.list);
 		io_kill_timeout(req, 0);
 	}
 	ctx->cq_last_tm_flush = seq;
@@ -6205,6 +6203,7 @@ static int io_timeout_prep(struct io_kio
 	if (get_timespec64(&data->ts, u64_to_user_ptr(sqe->addr)))
 		return -EFAULT;
 
+	INIT_LIST_HEAD(&req->timeout.list);
 	data->mode = io_translate_timeout_mode(flags);
 	hrtimer_init(&data->timer, io_timeout_get_clock(data), data->mode);
 


