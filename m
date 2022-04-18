Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B006505297
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234348AbiDRMuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239696AbiDRMqy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:46:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BD529CA4;
        Mon, 18 Apr 2022 05:33:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E926060F04;
        Mon, 18 Apr 2022 12:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34D6C385A8;
        Mon, 18 Apr 2022 12:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285188;
        bh=NKi4soFhU5x/UQqscEyGPgWLirV8S6dbvfcLMOp+MZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y6a6Klzu3kya6my1r2EcFRfhhEMYdSAdC8xoPRpJsN7EJKlqRK23mqKWIvGvyZbrQ
         UC3zPAtGQDjU4VeLygfWdyE8C0mDwhpOuI9dcGfOjIiUYz7S+zswB3uRJ9SKfouerm
         MBjvdQQo10YGWxEKHe/rTmubTpsQgEcQ3K3B7Yo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dylan Yudaken <dylany@fb.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 092/189] io_uring: verify pad field is 0 in io_get_ext_arg
Date:   Mon, 18 Apr 2022 14:11:52 +0200
Message-Id: <20220418121203.117534223@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
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
index 66671c0bd864..cc0a07a9fe9c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9981,6 +9981,8 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp, size_t *argsz
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



