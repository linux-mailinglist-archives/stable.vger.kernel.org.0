Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 426D952917E
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238104AbiEPUJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350830AbiEPUBm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:01:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8184B1F2;
        Mon, 16 May 2022 12:55:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCAD960A1C;
        Mon, 16 May 2022 19:55:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44F3C385AA;
        Mon, 16 May 2022 19:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730952;
        bh=yH5M1c0ldN5R+FkK/zu3biDlTtfEvvdoiBULCRmiLhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cs//EgUGpWkkZEFkKJ4D2LZGqfsQTRAqSmv+HD1/TNjZfHK06RxagdL2r52CLgXiD
         F94N3FqMXGbYhfP5hBryILFfEYhShqwiTSIO55b0izEzYAgdrI8M9xa3LzOp1Gqctg
         diLF9TOQN5MXR1T0sAFFPTgwsoQO1JdAQUvyGg8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 058/114] io_uring: assign non-fixed early for async work
Date:   Mon, 16 May 2022 21:36:32 +0200
Message-Id: <20220516193627.160256625@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 87df37912055..a0680046ff3c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6572,7 +6572,12 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
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
 	if (WARN_ON_ONCE(req_has_async_data(req)))
 		return -EFAULT;
-- 
2.35.1



