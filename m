Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF4F6BB208
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbjCOMcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232566AbjCOMb6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:31:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652EB2201A
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:31:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EE7261D58
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F9EC433EF;
        Wed, 15 Mar 2023 12:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883475;
        bh=5vgBSIJR9Vs+qAxCbN2bmTQwr2NAFxHisIh3cE0xgLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VFUfZQmH5AtimIypz7ywDPh3oP/YAteZalkZkweaC2s6rmqI7rJiDjKef5F8CM1YX
         m80dYFyjJl4ZXD/5+mECTM+QBUBhnME863vnCnsGB4TBLzvG4XxhCMG56ZIVxLrBPS
         Ln1LIdZGhLntVsSclUhGXIentCibp258mMUmT2Os=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kanchan Joshi <joshi.k@samsung.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 004/143] io_uring/uring_cmd: ensure that device supports IOPOLL
Date:   Wed, 15 Mar 2023 13:11:30 +0100
Message-Id: <20230315115740.583785917@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit 03b3d6be73e81ddb7c2930d942cdd17f4cfd5ba5 upstream.

It's possible for a file type to support uring commands, but not
pollable ones. Hence before issuing one of those, we should check
that it is supported and error out upfront if it isn't.

Cc: stable@vger.kernel.org
Fixes: 5756a3a7e713 ("io_uring: add iopoll infrastructure for io_uring_cmd")
Link: https://github.com/axboe/liburing/issues/816
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/uring_cmd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 446a189b78b0..2e4c483075d3 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -108,7 +108,7 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 	struct file *file = req->file;
 	int ret;
 
-	if (!req->file->f_op->uring_cmd)
+	if (!file->f_op->uring_cmd)
 		return -EOPNOTSUPP;
 
 	ret = security_uring_cmd(ioucmd);
@@ -120,6 +120,8 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 	if (ctx->flags & IORING_SETUP_CQE32)
 		issue_flags |= IO_URING_F_CQE32;
 	if (ctx->flags & IORING_SETUP_IOPOLL) {
+		if (!file->f_op->uring_cmd_iopoll)
+			return -EOPNOTSUPP;
 		issue_flags |= IO_URING_F_IOPOLL;
 		req->iopoll_completed = 0;
 		WRITE_ONCE(ioucmd->cookie, NULL);
-- 
2.39.2



