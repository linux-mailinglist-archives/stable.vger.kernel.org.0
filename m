Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB2255CD3F
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243566AbiF1CVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243565AbiF1CUb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:20:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598A124BD5;
        Mon, 27 Jun 2022 19:20:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBF95B81C10;
        Tue, 28 Jun 2022 02:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED05C341CB;
        Tue, 28 Jun 2022 02:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382809;
        bh=bJ+kyBGY+pp+g7vxp3IKmOoxPx19as83TpTlQBNOuvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E0jSC+ZFElcwz7pohQnjsbsEJ4gffe7fAWrgi+8QeCDYcYyJ2YuN1/rcGT+tZ5IU8
         HmDSikSD2TMf7kPeDXRle0e9V6jw3agTa7e8eZmfviK6ZiSsDGiMPzr2kONsGJ/Fkm
         pPhSQrB9GhNTSONZqN0qECVfcmuQpGqtCooxcPb1NysmQ+5eqq0f+woPvnVlKzZpCK
         eV5iIzL3K5EzdDkk8YIiGBPhQ2iDqDaiH6ChlB4vnHf9bGiACRTU4cQzn3u5gczIZB
         W+HK64M92t18LUr4ZapaUQZPDEYALlnZnJ7HyDuIpAl3dA5mevbBefAC6axE8135S8
         hsLo9TskAOmpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 32/53] io_uring: mark reissue requests with REQ_F_PARTIAL_IO
Date:   Mon, 27 Jun 2022 22:18:18 -0400
Message-Id: <20220628021839.594423-32-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628021839.594423-1-sashal@kernel.org>
References: <20220628021839.594423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 1bacd264d3c3a05de4afdd1712c9dd6ccebb9490 ]

If we mark for reissue, we assume that the buffer will remain stable.
Hence if are using a provided buffer, we need to ensure that we stick
with it for the duration of that request.

This only affects block devices that use provided buffers, as those are
the only ones that get marked with REQ_F_REISSUE.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 68aab48838e4..725c59c734f1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3009,7 +3009,7 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 	if (unlikely(res != req->result)) {
 		if ((res == -EAGAIN || res == -EOPNOTSUPP) &&
 		    io_rw_should_reissue(req)) {
-			req->flags |= REQ_F_REISSUE;
+			req->flags |= REQ_F_REISSUE | REQ_F_PARTIAL_IO;
 			return true;
 		}
 		req_set_fail(req);
@@ -3059,7 +3059,7 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
 		kiocb_end_write(req);
 	if (unlikely(res != req->result)) {
 		if (res == -EAGAIN && io_rw_should_reissue(req)) {
-			req->flags |= REQ_F_REISSUE;
+			req->flags |= REQ_F_REISSUE | REQ_F_PARTIAL_IO;
 			return;
 		}
 		req->result = res;
-- 
2.35.1

