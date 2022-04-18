Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 985AD5050DE
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbiDRM3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239369AbiDRM2W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:28:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D09A21241;
        Mon, 18 Apr 2022 05:21:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE623B80ED6;
        Mon, 18 Apr 2022 12:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256C9C385A7;
        Mon, 18 Apr 2022 12:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284499;
        bh=zDfn1lGmLBtYBMqJBS6fF6HQOhZA5RF7ZoQrvNcctxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MUfTNBUxlh2d8by2COw+0wCeRuiPr9MExJGO52CJmYLLR1/i44llYqcsWQkpTXjGg
         6dc7qkZi/0euOIok7A7Wmi5o0mb5+RKQSxY886BOEkaIH4IIuX5CXQz8vwKi7ZVLqr
         g8wzT618LMawV5gTX2iYjwC4QQcUWVO5EKHHGYug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dylan Yudaken <dylany@fb.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 111/219] io_uring: verify that resv2 is 0 in io_uring_rsrc_update2
Date:   Mon, 18 Apr 2022 14:11:20 +0200
Message-Id: <20220418121210.006355712@linuxfoundation.org>
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

[ Upstream commit d8a3ba9c143bf89c032deced8a686ffa53b46098 ]

Verify that the user does not pass in anything but 0 for this field.

Fixes: 992da01aa932 ("io_uring: change registration/upd/rsrc tagging ABI")
Signed-off-by: Dylan Yudaken <dylany@fb.com>
Link: https://lore.kernel.org/r/20220412163042.2788062-3-dylany@fb.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7da6fddaef4d..2838bc6cdbc8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6466,6 +6466,7 @@ static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 	up.nr = 0;
 	up.tags = 0;
 	up.resv = 0;
+	up.resv2 = 0;
 
 	io_ring_submit_lock(ctx, needs_lock);
 	ret = __io_register_rsrc_update(ctx, IORING_RSRC_FILE,
@@ -10809,7 +10810,7 @@ static int io_register_files_update(struct io_ring_ctx *ctx, void __user *arg,
 	memset(&up, 0, sizeof(up));
 	if (copy_from_user(&up, arg, sizeof(struct io_uring_rsrc_update)))
 		return -EFAULT;
-	if (up.resv)
+	if (up.resv || up.resv2)
 		return -EINVAL;
 	return __io_register_rsrc_update(ctx, IORING_RSRC_FILE, &up, nr_args);
 }
@@ -10823,7 +10824,7 @@ static int io_register_rsrc_update(struct io_ring_ctx *ctx, void __user *arg,
 		return -EINVAL;
 	if (copy_from_user(&up, arg, sizeof(up)))
 		return -EFAULT;
-	if (!up.nr || up.resv)
+	if (!up.nr || up.resv || up.resv2)
 		return -EINVAL;
 	return __io_register_rsrc_update(ctx, type, &up, up.nr);
 }
-- 
2.35.1



