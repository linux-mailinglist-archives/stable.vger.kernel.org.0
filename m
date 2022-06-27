Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6CC55C5F3
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238415AbiF0LvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237711AbiF0Ls7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C48FD7B;
        Mon, 27 Jun 2022 04:43:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BCCFB80D37;
        Mon, 27 Jun 2022 11:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904A6C3411D;
        Mon, 27 Jun 2022 11:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330179;
        bh=wbR3MEKdW6BKJKVYfURMA437j2DqDri/6fTczRaIwwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PXLLadvB20Uyv6YobbX+qQ/a6kw85rwpOpzHIrYwM2/+QXEWbhdhTkj4APndmP3QO
         +HMCotfiLio7lhvh1a232kkDBwygSHtBYswf+wvPxk0p5U/Fvu/bIqNTk7Afqhee0u
         eRTXfTY2/xW8CMlVVqvrhfFoELBhFm6rjlr1C3Cg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 111/181] io_uring: fix wrong arm_poll error handling
Date:   Mon, 27 Jun 2022 13:21:24 +0200
Message-Id: <20220627111947.917086865@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 9d2ad2947a53abf5e5e6527a9eeed50a3a4cbc72 ]

Leaving ip.error set when a request was punted to task_work execution is
problematic, don't forget to clear it.

Fixes: aa43477b04025 ("io_uring: poll rework")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/a6c84ef4182c6962380aebe11b35bdcb25b0ccfb.1655852245.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 38ecea726254..e4186635aaa8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6178,6 +6178,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 		if (unlikely(ipt->error || !ipt->nr_entries)) {
 			poll->events |= EPOLLONESHOT;
 			req->apoll_events |= EPOLLONESHOT;
+			ipt->error = 0;
 		}
 		__io_poll_execute(req, mask, poll->events);
 		return 0;
-- 
2.35.1



