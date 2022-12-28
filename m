Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1651658485
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235378AbiL1Q5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235198AbiL1Q5A (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:57:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A631DDCE
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:53:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E4F661568
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:53:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AABEC433EF;
        Wed, 28 Dec 2022 16:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246408;
        bh=TqCvaUzX+8QhxVRnLVW99Tobk4bYdhv8ZJMVTg0nk1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=llpvfFUNI633bnpoguonf8wI7ZXuXslcDCn/DHA+/U6uAEi7VGG81q8V1FrJFpJsc
         l14u47ySu09ozvi0FBsSIYZ6N5ULXmL2VwiFuYRGA8W+dGx/kV3Q+ziPcMXyWKfivd
         ZSxRUhhvBfn1dMji/CltVdNkcvhcm5d2SUHB1AKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 1062/1073] io_uring: protect cq_timeouts with timeout_lock
Date:   Wed, 28 Dec 2022 15:44:10 +0100
Message-Id: <20221228144357.081068808@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit ea011ee10231f5fa6cbb415007048ca0bb948baf upstream.

Read cq_timeouts in io_flush_timeouts() only after taking the
timeout_lock, as it's protected by it. There are many places where we
also grab ->completion_lock, but for instance io_timeout_fn() doesn't
and still modifies cq_timeouts.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/9c79544dd6cf5c4018cb1bab99cf481a93ea46ef.1670002973.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/timeout.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -72,10 +72,12 @@ static bool io_kill_timeout(struct io_ki
 __cold void io_flush_timeouts(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->completion_lock)
 {
-	u32 seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
+	u32 seq;
 	struct io_timeout *timeout, *tmp;
 
 	spin_lock_irq(&ctx->timeout_lock);
+	seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
+
 	list_for_each_entry_safe(timeout, tmp, &ctx->timeout_list, list) {
 		struct io_kiocb *req = cmd_to_io_kiocb(timeout);
 		u32 events_needed, events_got;


