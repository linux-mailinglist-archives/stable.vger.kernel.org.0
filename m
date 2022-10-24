Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F22F660B8C5
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbiJXTyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233427AbiJXTxP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:53:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39E12DE1;
        Mon, 24 Oct 2022 11:17:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B2DDB8171F;
        Mon, 24 Oct 2022 12:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3999C433D7;
        Mon, 24 Oct 2022 12:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614749;
        bh=lRex0KZaajbNq/rIhcn4HcwjpNYtfESEz/jQaZV8qrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ixUI3Vuo07ySv1W6cY1htQuTA8EYybuFF7HBDmPUAml68lxW/0BGIWcWs4gvhJQ8W
         2iqh7Bizgsnqg3w5i659nFAFbBF5RH14iPOnkDTmK3f+Y9OoDfF5ewQ+XZIS0alZOk
         zcTnK2YfPqGyx4DbhWwpBfUBE44QR93oUYWWYdu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 378/390] io_uring: correct pinned_vm accounting
Date:   Mon, 24 Oct 2022 13:32:55 +0200
Message-Id: <20221024113039.072215330@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ upstream commit 42b6419d0aba47c5d8644cdc0b68502254671de5 ]

->mm_account should be released only after we free all registered
buffers, otherwise __io_sqe_buffers_unregister() will see a NULL
->mm_account and skip locked_vm accounting.

Cc: <Stable@vger.kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/6d798f65ed4ab8db3664c4d3397d4af16ca98846.1664849932.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8436,8 +8436,6 @@ static void io_ring_ctx_free(struct io_r
 	if (ctx->sqo_task) {
 		put_task_struct(ctx->sqo_task);
 		ctx->sqo_task = NULL;
-		mmdrop(ctx->mm_account);
-		ctx->mm_account = NULL;
 	}
 
 #ifdef CONFIG_BLK_CGROUP
@@ -8456,6 +8454,11 @@ static void io_ring_ctx_free(struct io_r
 	}
 #endif
 
+	if (ctx->mm_account) {
+		mmdrop(ctx->mm_account);
+		ctx->mm_account = NULL;
+	}
+
 	io_mem_free(ctx->rings);
 	io_mem_free(ctx->sq_sqes);
 


