Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0466D6433CF
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234774AbiLETjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:39:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234716AbiLETjY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:39:24 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B242C6352
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:36:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 21F5ACE131B
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC3AC433D6;
        Mon,  5 Dec 2022 19:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268995;
        bh=lGYaA8pTkJWT3xjk0ADvEhsPe2+yJneXaLkpIUtu54U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FMQZgTsZawPAdgijcTXZSv8NzCy1Xfv8AJunI3aAOt80VaJMXFliImh0rt16jlwRI
         zhsCb3/mPkML7krTgUo8tiI+3hzepCurCK4vQ1pu28TQetrgBRtD2hRgzBtUTUEGEd
         dJ2s5PHJWemMvHVb295KzaXTCT95YJyCW/PnbUFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 088/120] io_uring: update res mask in io_poll_check_events
Date:   Mon,  5 Dec 2022 20:10:28 +0100
Message-Id: <20221205190809.226809644@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
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

[ upstream commit b98186aee22fa593bc8c6b2c5d839c2ee518bc8c ]

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
 fs/io_uring.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5464,6 +5464,9 @@ static int io_poll_check_events(struct i
 			return 0;
 		}
 
+		/* force the next iteration to vfs_poll() */
+		req->result = 0;
+
 		/*
 		 * Release all references, retry if someone tried to restart
 		 * task_work while we were executing it.


