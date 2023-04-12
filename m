Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD406DEF99
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbjDLIwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbjDLIwU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:52:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F565558B
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:52:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D3476319D
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:52:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52201C433D2;
        Wed, 12 Apr 2023 08:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289519;
        bh=/MKBGP3G17dM/AeUC/HknQ2So8TXdWesndPifUGHbjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QmEiSobQ5jNKxDYtbkZrrvaJbyXW9XPVK+4f1JoaJrI8jiFP2G6oBGh4z9zbr0OPH
         fGtxWkjK+1AxSp/DSGCgu2uOH4qe5oPJxNfF6PGN77x1S9qr7ze85LWTgmUS0sbLbD
         7Vnc1WkDU/jg4joa5rPH825c7h3fz2ulEu1JUzYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wojciech Lukowicz <wlukowicz01@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 131/173] io_uring: fix return value when removing provided buffers
Date:   Wed, 12 Apr 2023 10:34:17 +0200
Message-Id: <20230412082843.446732254@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wojciech Lukowicz <wlukowicz01@gmail.com>

[ Upstream commit c0921e51dab767ef5adf6175c4a0ba3c6e1074a3 ]

When a request to remove buffers is submitted, and the given number to be
removed is larger than available in the specified buffer group, the
resulting CQE result will be the number of removed buffers + 1, which is
1 more than it should be.

Previously, the head was part of the list and it got removed after the
loop, so the increment was needed. Now, the head is not an element of
the list, so the increment shouldn't be there anymore.

Fixes: dbc7d452e7cf ("io_uring: manage provided buffers strictly ordered")
Signed-off-by: Wojciech Lukowicz <wlukowicz01@gmail.com>
Link: https://lore.kernel.org/r/20230401195039.404909-2-wlukowicz01@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/kbuf.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 3002dc8271959..0fdcc0adbdbcc 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -228,7 +228,6 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 		return i;
 	}
 
-	/* the head kbuf is the list itself */
 	while (!list_empty(&bl->buf_list)) {
 		struct io_buffer *nxt;
 
@@ -238,7 +237,6 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 			return i;
 		cond_resched();
 	}
-	i++;
 
 	return i;
 }
-- 
2.39.2



