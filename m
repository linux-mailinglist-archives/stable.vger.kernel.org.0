Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31BA850529B
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240664AbiDRMts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239529AbiDRMqr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:46:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6954F2983D;
        Mon, 18 Apr 2022 05:33:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8B3C60F04;
        Mon, 18 Apr 2022 12:33:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA28C385A1;
        Mon, 18 Apr 2022 12:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285182;
        bh=4VgAjfKSnI6qCbQ36M+LpNuBGABeOeuS7Sf5Kx1qs8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IDvaGIfx3zVzitT7B6GMq0gIIU3p2eYmiTz6TAUXZAQvTrFV/NX9ibfvXPXAw0HOQ
         QnZtt2FG+Ar9AQakYCMT9ODwbPVfZfT9m5kXsUzwuwtIK9mOQhnapoGhIdMgRlCD6U
         01sLmcJwPwhRkjj6hJ4GRO/nEacYmAtoI53ZMaAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dylan Yudaken <dylany@fb.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/189] io_uring: move io_uring_rsrc_update2 validation
Date:   Mon, 18 Apr 2022 14:11:50 +0200
Message-Id: <20220418121203.061156741@linuxfoundation.org>
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

[ Upstream commit 565c5e616e8061b40a2e1d786c418a7ac3503a8d ]

Move validation to be more consistently straight after
copy_from_user. This is already done in io_register_rsrc_update and so
this removes that redundant check.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
Link: https://lore.kernel.org/r/20220412163042.2788062-2-dylany@fb.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3d44d48b35ea..0568304a597a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10595,8 +10595,6 @@ static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
 	__u32 tmp;
 	int err;
 
-	if (up->resv)
-		return -EINVAL;
 	if (check_add_overflow(up->offset, nr_args, &tmp))
 		return -EOVERFLOW;
 	err = io_rsrc_node_switch_start(ctx);
@@ -10622,6 +10620,8 @@ static int io_register_files_update(struct io_ring_ctx *ctx, void __user *arg,
 	memset(&up, 0, sizeof(up));
 	if (copy_from_user(&up, arg, sizeof(struct io_uring_rsrc_update)))
 		return -EFAULT;
+	if (up.resv)
+		return -EINVAL;
 	return __io_register_rsrc_update(ctx, IORING_RSRC_FILE, &up, nr_args);
 }
 
-- 
2.35.1



