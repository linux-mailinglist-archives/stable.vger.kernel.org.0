Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED857504E90
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 11:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237565AbiDRJ5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 05:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237556AbiDRJ5f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 05:57:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5810ABC1
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 02:54:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0CC94B80E5E
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 09:54:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A50C385A7;
        Mon, 18 Apr 2022 09:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650275694;
        bh=7urFRbHIWHXPjV0fcF4y8mQ2wFPUtvMDdY8pbKcybDo=;
        h=Subject:To:Cc:From:Date:From;
        b=m2sJXIbDxJN2ZGHqbA2B7YDcB9sidEIMAN6QqMsocxuCUA4xTiucGhsK72yCUyGxk
         Hb/nE43MfK70pm0SlAROfaHdUQ9BJlkMIiJ7/0ur3KAGhqDuORuZAzGt0F07j6IcZj
         qPqKug4Uf+RrbZBuzQ2lT74POBccB+dz9Eyf8qxs=
Subject: FAILED: patch "[PATCH] io_uring: fix poll file assign deadlock" failed to apply to 5.17-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Apr 2022 11:54:51 +0200
Message-ID: <1650275691196214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.17-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cce64ef01308b677a687d90927fc2b2e0e1cba67 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Wed, 13 Apr 2022 16:10:34 +0100
Subject: [PATCH] io_uring: fix poll file assign deadlock

We pass "unlocked" into io_assign_file() in io_poll_check_events(),
which can lead to double locking.

Fixes: 6bf9c47a3989 ("io_uring: defer file assignment")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/2476d4ae46554324b599ee4055447b105f20a75a.1649862516.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3d6cbf77c89d..d06f1952fdfa 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5858,8 +5858,9 @@ static int io_poll_check_events(struct io_kiocb *req, bool locked)
 
 		if (!req->result) {
 			struct poll_table_struct pt = { ._key = req->apoll_events };
+			unsigned flags = locked ? 0 : IO_URING_F_UNLOCKED;
 
-			if (unlikely(!io_assign_file(req, IO_URING_F_UNLOCKED)))
+			if (unlikely(!io_assign_file(req, flags)))
 				req->result = -EBADF;
 			else
 				req->result = vfs_poll(req->file, &pt) & req->apoll_events;

