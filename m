Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82B8D676F1F
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbjAVPSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:18:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbjAVPR6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:17:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947F4359D
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:17:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1343AB80B1B
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:17:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E51AC433EF;
        Sun, 22 Jan 2023 15:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400673;
        bh=3cRGBHDByLnAZeCjvn7v97G2SNm9CO8kgin0q7ZsY00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Nw0StOBVEkXdXtl326g4niHVJ6xIfVUdnyTVGz76Q3p3DyE/Sj/riuEB/Wzq8Zrr
         S7kwoiIGfxvYi8bwVmxkcXpn2/8d9ALyOw8scP8dcgYym4uhjXW1klBDOfs8mFPNMq
         vSEIUYR+K7MquNyhPKAL/mf0GXvJXg2LWNzv2NNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dylan Yudaken <dylany@fb.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/117] io_uring: fix async accept on O_NONBLOCK sockets
Date:   Sun, 22 Jan 2023 16:03:46 +0100
Message-Id: <20230122150234.230902259@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dylan Yudaken <dylany@meta.com>

commit a73825ba70c93e1eb39a845bb3d9885a787f8ffe upstream.

Do not set REQ_F_NOWAIT if the socket is non blocking. When enabled this
causes the accept to immediately post a CQE with EAGAIN, which means you
cannot perform an accept SQE on a NONBLOCK socket asynchronously.

By removing the flag if there is no pending accept then poll is armed as
usual and when a connection comes in the CQE is posted.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
Link: https://lore.kernel.org/r/20220324143435.2875844-1-dylany@fb.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 997a7264e1d4..e1e15d40d758 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -5272,9 +5272,6 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 	struct file *file;
 	int ret, fd;
 
-	if (req->file->f_flags & O_NONBLOCK)
-		req->flags |= REQ_F_NOWAIT;
-
 	if (!fixed) {
 		fd = __get_unused_fd_flags(accept->flags, accept->nofile);
 		if (unlikely(fd < 0))
@@ -5286,6 +5283,8 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 		if (!fixed)
 			put_unused_fd(fd);
 		ret = PTR_ERR(file);
+		/* safe to retry */
+		req->flags |= REQ_F_PARTIAL_IO;
 		if (ret == -EAGAIN && force_nonblock)
 			return -EAGAIN;
 		if (ret == -ERESTARTSYS)
-- 
2.39.0



