Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2584C5052C0
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbiDRMuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239681AbiDRMqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:46:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5022929C96;
        Mon, 18 Apr 2022 05:33:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9A3A60FDF;
        Mon, 18 Apr 2022 12:33:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA22C385A1;
        Mon, 18 Apr 2022 12:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285185;
        bh=bs4wak5tOlOoHf4lGS50VhwN10Kt87nFI36ASnPYkPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pQ0Au9vkGzbvJRo2iYZ4JXP8kLhgJJAkkoLTohzvXucbxVY9SSyinY/XB760pAuxk
         ZiDEM7PkZD8ZMLELz5oRp3Ly7GhXX1q12/h2QXkinNfcqj+Y+j/LYneXVbb7O+snF5
         hx6nEbohAG+jtsXS8i7qRZo64AIePJOpNUAhWDks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dylan Yudaken <dylany@fb.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/189] io_uring: verify that resv2 is 0 in io_uring_rsrc_update2
Date:   Mon, 18 Apr 2022 14:11:51 +0200
Message-Id: <20220418121203.088735896@linuxfoundation.org>
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
index 0568304a597a..66671c0bd864 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6403,6 +6403,7 @@ static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 	up.nr = 0;
 	up.tags = 0;
 	up.resv = 0;
+	up.resv2 = 0;
 
 	io_ring_submit_lock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
 	ret = __io_register_rsrc_update(ctx, IORING_RSRC_FILE,
@@ -10620,7 +10621,7 @@ static int io_register_files_update(struct io_ring_ctx *ctx, void __user *arg,
 	memset(&up, 0, sizeof(up));
 	if (copy_from_user(&up, arg, sizeof(struct io_uring_rsrc_update)))
 		return -EFAULT;
-	if (up.resv)
+	if (up.resv || up.resv2)
 		return -EINVAL;
 	return __io_register_rsrc_update(ctx, IORING_RSRC_FILE, &up, nr_args);
 }
@@ -10634,7 +10635,7 @@ static int io_register_rsrc_update(struct io_ring_ctx *ctx, void __user *arg,
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



