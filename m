Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 726406810B1
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237067AbjA3OFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237075AbjA3OFq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:05:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96BA20056
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:05:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6778CB81145
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83BCCC4339C;
        Mon, 30 Jan 2023 14:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087543;
        bh=PKpDEyB/Gg75JO9WN04qmkYMSwEnxBPl3ql+1/TDB50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GJeCrGrfU1pNQm+AeMHtg16sXBNmhE4flVPXKBCjKZ3Gk9NYbcekM0Qvr53UOn7HQ
         lvWxVwtqu6+inT11Tm9hQF8DPSRNUCIfjYgnDAefXJhWzgB7cfUN/j1To5MHCdQVoQ
         YXnlvNMchXIoA0Yo+uizOyiEXM9l1NBwlzU3qH4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 243/313] io_uring: use io_req_task_complete() in timeout
Date:   Mon, 30 Jan 2023 14:51:18 +0100
Message-Id: <20230130134348.005000064@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 624fd779fd869bdcb2c0ccca0f09456eed71ed52 ]

Use a more generic io_req_task_complete() in timeout completion
task_work instead of io_req_complete_post().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/bda1710b58c07bf06107421c2a65c529ea9cdcac.1669203009.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: ef5c600adb1d ("io_uring: always prep_async for drain requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/timeout.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 06200fe73a04..16b006bbbb11 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -284,11 +284,11 @@ static void io_req_task_link_timeout(struct io_kiocb *req, bool *locked)
 			ret = io_try_cancel(req->task->io_uring, &cd, issue_flags);
 		}
 		io_req_set_res(req, ret ?: -ETIME, 0);
-		io_req_complete_post(req);
+		io_req_task_complete(req, locked);
 		io_put_req(prev);
 	} else {
 		io_req_set_res(req, -ETIME, 0);
-		io_req_complete_post(req);
+		io_req_task_complete(req, locked);
 	}
 }
 
-- 
2.39.0



