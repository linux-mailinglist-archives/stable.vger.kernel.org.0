Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 179785050A4
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235699AbiDRM0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238741AbiDRM0W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:26:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123B81261C;
        Mon, 18 Apr 2022 05:20:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A22AA60F0A;
        Mon, 18 Apr 2022 12:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C591C385A9;
        Mon, 18 Apr 2022 12:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284429;
        bh=X/2BiOYQf0Z+0ANkLJl9DPyLmi79vzg8bV9C5ksUvPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rggj/U84T8lDs2trufusEq9lcdtJV1uJiTRHGUOHZs8unlzVAU1DgV2hIvXxGhKWZ
         h31Cr6mDdFD5xqPhFVn2UOmF1WTsydQBZCv4B4xgyXLOtCFoUhEi9WeVwUfEYZvCJW
         OB4Q0j3RdOQFRr4KHb2J+wVWLrg6YRHeSaiw7MNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dylan Yudaken <dylany@fb.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 112/219] io_uring: verify pad field is 0 in io_get_ext_arg
Date:   Mon, 18 Apr 2022 14:11:21 +0200
Message-Id: <20220418121210.034580519@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Dylan Yudaken <dylany@fb.com>

[ Upstream commit d2347b9695dafe5c388a5f9aeb70e27a7a4d29cf ]

Ensure that only 0 is passed for pad here.

Fixes: c73ebb685fb6 ("io_uring: add timeout support for io_uring_enter()")
Signed-off-by: Dylan Yudaken <dylany@fb.com>
Link: https://lore.kernel.org/r/20220412163042.2788062-5-dylany@fb.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2838bc6cdbc8..7a652c8eeed2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10109,6 +10109,8 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp, size_t *argsz
 		return -EINVAL;
 	if (copy_from_user(&arg, argp, sizeof(arg)))
 		return -EFAULT;
+	if (arg.pad)
+		return -EINVAL;
 	*sig = u64_to_user_ptr(arg.sigmask);
 	*argsz = arg.sigmask_sz;
 	*ts = u64_to_user_ptr(arg.ts);
-- 
2.35.1



