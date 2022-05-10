Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3090B521F8C
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 17:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346233AbiEJPui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 11:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346250AbiEJPuZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 11:50:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7686E285ECE;
        Tue, 10 May 2022 08:44:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDE9A61381;
        Tue, 10 May 2022 15:44:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D2DC385CA;
        Tue, 10 May 2022 15:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197486;
        bh=/1Y0d87/4tbN+DLBfRrfe0cvxhj9hPhwOquuR7yBFqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DRIEJzlkG7o8OywZeMLFaxwgkLrlZ9AAWc3TfdxeqgTMAfz7OgV6XurSCMlTEFD1o
         dbYMQrPqP1DHvz2foxj6ZPr0SooLBBnTsIf9cx37POAareKTFZ8lNaQcd6X3pK+4oZ
         aW7NuHj3bYJnKx5kHISliHtb1JjCtD0F/WeLMu6kPvU2RyLi+OXHkrG7DJZK/Pfu8I
         0y/Ye3hCudPpTgB4FAoJejDtUG6Kugmp5m4pu4M2j+4knEM71B0x85O1683KiULV/O
         C8/qWe4Ijm4X5e8ZPdT0YfM8aY/3O1t3Cuvs0Qg7vcrbbJEUyULrstLhT2TM7VTIR+
         SKOgcWCELjn6g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 09/19] io_uring: assign non-fixed early for async work
Date:   Tue, 10 May 2022 11:44:19 -0400
Message-Id: <20220510154429.153677-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510154429.153677-1-sashal@kernel.org>
References: <20220510154429.153677-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit a196c78b5443fc61af2c0490213b9d125482cbd1 ]

We defer file assignment to ensure that fixed files work with links
between a direct accept/open and the links that follow it. But this has
the side effect that normal file assignment is then not complete by the
time that request submission has been done.

For deferred execution, if the file is a regular file, assign it when
we do the async prep anyway.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7aad4bde92e9..2f7ac8df9a0c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6506,7 +6506,12 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 static int io_req_prep_async(struct io_kiocb *req)
 {
-	if (!io_op_defs[req->opcode].needs_async_setup)
+	const struct io_op_def *def = &io_op_defs[req->opcode];
+
+	/* assign early for deferred execution for non-fixed file */
+	if (def->needs_file && !(req->flags & REQ_F_FIXED_FILE))
+		req->file = io_file_get_normal(req, req->fd);
+	if (!def->needs_async_setup)
 		return 0;
 	if (WARN_ON_ONCE(req->async_data))
 		return -EFAULT;
-- 
2.35.1

