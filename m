Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA665E9172
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 09:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiIYHck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Sep 2022 03:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiIYHcj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Sep 2022 03:32:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B053D3B94B
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 00:32:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E49761000
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 07:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2A7C433D6;
        Sun, 25 Sep 2022 07:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664091157;
        bh=ZPz+gM+6mF16t1+D7wLZ6VDVnHqpFUJRGAjq/ars9FA=;
        h=Subject:To:Cc:From:Date:From;
        b=awfRVPPzxEgBJv2TawlrmHtizL7Dv7wD/Z89Mr7GXK/zG6sfAd/YlDgtO5GkORdEd
         jvsmtRKOQ7vWpkZYeuI2fY+ro5cH0YSEEpySvSiD8pm+vtdl82bGaLc6HHLRV6e+CL
         PH3RzOcgo62Xbqpr/Ikzg+ug8czQYffX535En7o8=
Subject: FAILED: patch "[PATCH] io_uring: ensure that cached task references are always put" failed to apply to 5.15-stable tree
To:     axboe@kernel.dk, hominlab@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 25 Sep 2022 09:32:34 +0200
Message-ID: <166409115474111@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

e775f93f2ab9 ("io_uring: ensure that cached task references are always put on exit")
ed29b0b4fd83 ("io_uring: move to separate directory")
60053be859b3 ("io_uring: remove extra ifs around io_commit_cqring")
33ce2aff7d34 ("io_uring: code clean for some ctx usage")
3d4aeb9f9805 ("io_uring: don't spinlock when not posting CQEs")
04c76b41ca97 ("io_uring: add option to skip CQE posting")
913a571affed ("io_uring: clean cqe filling functions")
5ca7a8b3f698 ("io_uring: inform block layer of how many requests we are submitting")
5a158c6b0d03 ("io_uring: reshuffle io_submit_state bits")
6d63416dc57e ("io_uring: optimise plugging")
54daa9b2d80a ("io_uring: correct fill events helpers types")
867f8fa5aeb7 ("io_uring: inline io_req_needs_clean()")
d17e56eb4907 ("io_uring: remove struct io_completion")
d886e185a128 ("io_uring: control ->async_data with a REQ_F flag")
fff4e40e3094 ("io_uring: delay req queueing into compl-batch list")
51d48dab62ed ("io_uring: add more likely/unlikely() annotations")
7e3709d57651 ("io_uring: optimise kiocb layout")
30d51dd4ad20 ("io_uring: clean up buffer select")
fc0ae0244bbb ("io_uring: init opcode in io_init_req()")
22b2ca310afc ("io_uring: extra a helper for drain init")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e775f93f2ab976a2cdb4a7b53063cbe890904f73 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Fri, 23 Sep 2022 13:44:56 -0600
Subject: [PATCH] io_uring: ensure that cached task references are always put
 on exit

io_uring caches task references to avoid doing atomics for each of them
per request. If a request is put from the same task that allocated it,
then we can maintain a per-ctx cache of them. This obviously relies
on io_uring always pruning caches in a reliable way, and there's
currently a case off io_uring fd release where we can miss that.

One example is a ring setup with IOPOLL, which relies on the task
polling for completions, which will free them. However, if such a task
submits a request and then exits or closes the ring without reaping
the completion, then ring release will reap and put. If release happens
from that very same task, the completed request task refs will get
put back into the cache pool. This is problematic, as we're now beyond
the point of pruning caches.

Manually drop these caches after doing an IOPOLL reap. This releases
references from the current task, which is enough. If another task
happens to be doing the release, then the caching will not be
triggered and there's no issue.

Cc: stable@vger.kernel.org
Fixes: e98e49b2bbf7 ("io_uring: extend task put optimisations")
Reported-by: Homin Rhee <hominlab@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b9640ad5069f..2965b354efc8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2648,6 +2648,9 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 		io_kill_timeouts(ctx, NULL, true);
 		/* if we failed setting up the ctx, we might not have any rings */
 		io_iopoll_try_reap_events(ctx);
+		/* drop cached put refs after potentially doing completions */
+		if (current->io_uring)
+			io_uring_drop_tctx_refs(current);
 	}
 
 	INIT_WORK(&ctx->exit_work, io_ring_exit_work);

