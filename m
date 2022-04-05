Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94FFF4F35B5
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233368AbiDEKyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345636AbiDEJnl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:43:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A447C4E1B;
        Tue,  5 Apr 2022 02:29:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58455616D2;
        Tue,  5 Apr 2022 09:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68486C385A0;
        Tue,  5 Apr 2022 09:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150962;
        bh=C89ZJw/w30s5nJwuI+SqP0Mv4XWo5ly++QaLGXUhdg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BcgIdu5qUXNH+AsFdw/QlP31raoyyh/D9+bw6SGV9YiJdHBNPwu00jcbP1ySPHBzp
         kGTDWiswpAYKZ343mdHXEx8Ahyc2gu/7VPZ5u0b9ahrf58B4xqSsPzJakf6mwQDhTn
         QlxQhmATDEdL26v4d3IDCxcfie7T0PEWPDv1kPNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Jaeschke <joel.jaeschke@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 243/913] io_uring: terminate manual loop iterator loop correctly for non-vecs
Date:   Tue,  5 Apr 2022 09:21:45 +0200
Message-Id: <20220405070347.141374452@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 5e929367468c8f97cd1ffb0417316cecfebef94b ]

The fix for not advancing the iterator if we're using fixed buffers is
broken in that it can hit a condition where we don't terminate the loop.
This results in io-wq looping forever, asking to read (or write) 0 bytes
for every subsequent loop.

Reported-by: Joel Jaeschke <joel.jaeschke@gmail.com>
Link: https://github.com/axboe/liburing/issues/549
Fixes: 16c8d2df7ec0 ("io_uring: ensure symmetry in handling iter types in loop_rw_iter()")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 70e85f64dc38..ec0b50940405 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3319,13 +3319,15 @@ static ssize_t loop_rw_iter(int rw, struct io_kiocb *req, struct iov_iter *iter)
 				ret = nr;
 			break;
 		}
+		ret += nr;
 		if (!iov_iter_is_bvec(iter)) {
 			iov_iter_advance(iter, nr);
 		} else {
-			req->rw.len -= nr;
 			req->rw.addr += nr;
+			req->rw.len -= nr;
+			if (!req->rw.len)
+				break;
 		}
-		ret += nr;
 		if (nr != iovec.iov_len)
 			break;
 	}
-- 
2.34.1



