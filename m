Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0CA4CF758
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233764AbiCGJpm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:45:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241014AbiCGJlp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C2C6D3A0;
        Mon,  7 Mar 2022 01:39:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5EE46116E;
        Mon,  7 Mar 2022 09:39:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63707C340E9;
        Mon,  7 Mar 2022 09:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645948;
        bh=jelnZl3ZRX+l4OmSRmakzD+X6v4N54ckjAV75aGfZgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g1/kOnKLvjsq13SrCsmcX0rCXteKxIB01PGC4xHC4O/UvT0iRSw6q5Wv+V6Wx740Y
         GJuNdtSWx+880Cj6UYf1H3EY23qvPQGS4UjiN626SVpm7QXgP1wb1WPAjyIqx7zq29
         pylDWorkLiUoSxTXZdmlTbqhdSAw+J4M9mImOZLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Xu <haoxu@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 045/262] io_uring: fix no lock protection for ctx->cq_extra
Date:   Mon,  7 Mar 2022 10:16:29 +0100
Message-Id: <20220307091703.794659099@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hao Xu <haoxu@linux.alibaba.com>

[ Upstream commit e302f1046f4c209291b07ff7bc4d15ca26891f16 ]

ctx->cq_extra should be protected by completion lock so that the
req_need_defer() does the right check.

Cc: stable@vger.kernel.org
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
Link: https://lore.kernel.org/r/20211125092103.224502-2-haoxu@linux.alibaba.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d7e49e87b49b9..156c54ebb62b7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6573,11 +6573,14 @@ static bool io_drain_req(struct io_kiocb *req)
 	}
 
 	/* Still need defer if there is pending req in defer list. */
+	spin_lock(&ctx->completion_lock);
 	if (likely(list_empty_careful(&ctx->defer_list) &&
 		!(req->flags & REQ_F_IO_DRAIN))) {
+		spin_unlock(&ctx->completion_lock);
 		ctx->drain_active = false;
 		return false;
 	}
+	spin_unlock(&ctx->completion_lock);
 
 	seq = io_get_sequence(req);
 	/* Still a chance to pass the sequence check */
-- 
2.34.1



