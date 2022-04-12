Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29F1E4FD7B4
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377446AbiDLHuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359073AbiDLHm3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:42:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA35A5521E;
        Tue, 12 Apr 2022 00:20:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4420361045;
        Tue, 12 Apr 2022 07:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58DADC385A1;
        Tue, 12 Apr 2022 07:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649748008;
        bh=q7WSODLypYIykGAg6QQO4egcUuD69gEgMfjespz19u8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HUbyBLQY0LuB+NqoDQmxGHuWoIFX9e1pmknJNclGZi00x9VP1jrq9WwGSYEolB6Qw
         zbDy+K1nADMeD/YPKVZcZnN7VP6oXU4Mof2rfBVHxpreIb03VZ3be2+IBppWrN2Bp/
         pMFGGPUjVlBLMzKvsHjYdsw61g2E7b9ZXbMCtc/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.17 279/343] io_uring: fix race between timeout flush and removal
Date:   Tue, 12 Apr 2022 08:31:37 +0200
Message-Id: <20220412062959.376033708@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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
@@ -1644,12 +1644,11 @@ static __cold void io_flush_timeouts(str
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
@@ -1666,7 +1665,6 @@ static __cold void io_flush_timeouts(str
 		if (events_got < events_needed)
 			break;
 
-		list_del_init(&req->timeout.list);
 		io_kill_timeout(req, 0);
 	}
 	ctx->cq_last_tm_flush = seq;
@@ -6276,6 +6274,7 @@ static int io_timeout_prep(struct io_kio
 	if (data->ts.tv_sec < 0 || data->ts.tv_nsec < 0)
 		return -EINVAL;
 
+	INIT_LIST_HEAD(&req->timeout.list);
 	data->mode = io_translate_timeout_mode(flags);
 	hrtimer_init(&data->timer, io_timeout_get_clock(data), data->mode);
 


