Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81B316358A2
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236807AbiKWKCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237000AbiKWKBI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:01:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39B7748C8
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:53:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E946B81EE5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:53:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9191BC433B5;
        Wed, 23 Nov 2022 09:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197200;
        bh=QUidASXV2Hx8XkfztRf8O5GMKzZDoGx9Zp/e2NlKmPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v450pTl0nWC3M5ijK68qZQARpc5OtRZTnUrc1LoLsK0Ot2/TMJCeXzMxAS2orTaEi
         yf9X6hVAZYK97027cEAELiCjdjcT3WG8bULZY7+AYAp2sK6PTncmWmAHBnUSZO/Yyx
         +WiD1dkpIlAlLHzFMN15DbSVQthWAPjeL88Zjbfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 226/314] io_uring: update res mask in io_poll_check_events
Date:   Wed, 23 Nov 2022 09:51:11 +0100
Message-Id: <20221123084635.768677526@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

commit b98186aee22fa593bc8c6b2c5d839c2ee518bc8c upstream.

When io_poll_check_events() collides with someone attempting to queue a
task work, it'll spin for one more time. However, it'll continue to use
the mask from the first iteration instead of updating it. For example,
if the first wake up was a EPOLLIN and the second EPOLLOUT, the
userspace will not get EPOLLOUT in time.

Clear the mask for all subsequent iterations to force vfs_poll().

Cc: stable@vger.kernel.org
Fixes: aa43477b04025 ("io_uring: poll rework")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/2dac97e8f691231049cb259c4ae57e79e40b537c.1668710222.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -256,6 +256,9 @@ static int io_poll_check_events(struct i
 				return ret;
 		}
 
+		/* force the next iteration to vfs_poll() */
+		req->cqe.res = 0;
+
 		/*
 		 * Release all references, retry if someone tried to restart
 		 * task_work while we were executing it.


