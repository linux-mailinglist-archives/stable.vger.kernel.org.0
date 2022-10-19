Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9DB60401F
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234146AbiJSJmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234530AbiJSJkj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:40:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62677F018B;
        Wed, 19 Oct 2022 02:17:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6024361834;
        Wed, 19 Oct 2022 09:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C0EC433B5;
        Wed, 19 Oct 2022 09:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666171005;
        bh=N5Fk36xhWE9Z2gJD+Mj+1ntG8BLl5wzMznG0J3oGd0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hkwJ06WKwzCUgZIE3YUyZinW4i3eaIPo+U3avds+596YylDvKGna8c1p4JetkyCb9
         SLI5cTA/i/hiLKBQsEjsLm1yNgadMzgK/fmbiogvMOSqPQJ6dhdxEroo9/+kP329sZ
         yJ2lWQZLcUInl5pO/cADjJ0mdOiLmi2ngCXm56no=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        syzbot+e5198737e8a2d23d958c@syzkaller.appspotmail.com
Subject: [PATCH 6.0 858/862] io_uring: fix fdinfo sqe offsets calculation
Date:   Wed, 19 Oct 2022 10:35:45 +0200
Message-Id: <20221019083327.799672854@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 00927931cb630bbf8edb6d7f4dadb25139fc5e16 upstream.

Only with the big sqe feature they take 128 bytes per entry, but we
unconditionally advance by 128B. Fix it by using sq_shift.

Fixes: 3b8fdd1dc35e3 ("io_uring/fdinfo: fix sqe dumping for IORING_SETUP_SQE128")
Reported-and-tested-by: syzbot+e5198737e8a2d23d958c@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/8b41287cb75d5efb8fcb5cccde845ddbbadd8372.1665449983.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/fdinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -95,7 +95,7 @@ static __cold void __io_uring_show_fdinf
 		sq_idx = READ_ONCE(ctx->sq_array[entry & sq_mask]);
 		if (sq_idx > sq_mask)
 			continue;
-		sqe = &ctx->sq_sqes[sq_idx << 1];
+		sqe = &ctx->sq_sqes[sq_idx << sq_shift];
 		seq_printf(m, "%5u: opcode:%s, fd:%d, flags:%x, off:%llu, "
 			      "addr:0x%llx, rw_flags:0x%x, buf_index:%d "
 			      "user_data:%llu",


