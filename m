Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC6125AAFEE
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237404AbiIBMqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237414AbiIBMol (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:44:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A114E1AB0;
        Fri,  2 Sep 2022 05:33:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 789586212E;
        Fri,  2 Sep 2022 12:31:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8027DC433D6;
        Fri,  2 Sep 2022 12:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121885;
        bh=RlgmLsc1QgR4aQk2lM5b0iqGogmpdMQV8MKniSME4yQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Utm8PHSPtEFtTPj10hirOLj80NeepQPy/PpAHhFMcaGCYX0m1IUgfC8ypD/4VGECB
         RiSEoco1HimpzvcEMh2ZygYafinR9i7t6CeZq0HY+qJiOF+eTg4WLHtZHv6tsTfOmu
         /wvfUtM29fid/vzgxezccbKb57H0cm3yQiXFYjl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dylan Yudaken <dylany@fb.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.15 19/73] io_uring: remove poll entry from list when canceling all
Date:   Fri,  2 Sep 2022 14:18:43 +0200
Message-Id: <20220902121405.091863140@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ upstream commmit 61bc84c4008812d784c398cfb54118c1ba396dfc ]

When the ring is exiting, as part of the shutdown, poll requests are
removed. But io_poll_remove_all() does not remove entries when finding
them, and since completions are done out-of-band, we can find and remove
the same entry multiple times.

We do guard the poll execution by poll ownership, but that does not
exclude us from reissuing a new one once the previous removal ownership
goes away.

This can race with poll execution as well, where we then end up seeing
req->apoll be NULL because a previous task_work requeue finished the
request.

Remove the poll entry when we find it and get ownership of it. This
prevents multiple invocations from finding it.

Fixes: aa43477b0402 ("io_uring: poll rework")
Reported-by: Dylan Yudaken <dylany@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[pavel: backport]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5720,6 +5720,7 @@ static bool io_poll_remove_all(struct io
 		list = &ctx->cancel_hash[i];
 		hlist_for_each_entry_safe(req, tmp, list, hash_node) {
 			if (io_match_task_safe(req, tsk, cancel_all)) {
+				hlist_del_init(&req->hash_node);
 				io_poll_cancel_req(req);
 				found = true;
 			}


