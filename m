Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21AF65B7013
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbiIMOUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233718AbiIMOTu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:19:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14AB642D3;
        Tue, 13 Sep 2022 07:14:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37179B80EFE;
        Tue, 13 Sep 2022 14:14:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B46BC433D6;
        Tue, 13 Sep 2022 14:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078464;
        bh=6aA7CnVTcpXodXHxy4KVbkMf2SFC+nIXweQBADRBJnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uK6x42GTfP7aov+9Dqo8PBmJw7Oxx9he2c3koBUFCq9g83EeHAtZIBwbIrTLuPo5A
         Tu8+DUAPT6uP/65Aa9aejaBclE1pDjYZkG6OAwHQHqhHbmP6/wnaJIuL/INB+wrf4O
         kPtL0XdC9PkDHyg2VcTinDRtUpb8iHDVyY9aD/uo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 149/192] io_uring: recycle kbuf recycle on tw requeue
Date:   Tue, 13 Sep 2022 16:04:15 +0200
Message-Id: <20220913140417.446810476@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 336d28a8f38013a069f2d46e73aaa1880ef17a47 ]

When we queue a request via tw for execution it's not going to be
executed immediately, so when io_queue_async() hits IO_APOLL_READY
and queues a tw but doesn't try to recycle/consume the buffer some other
request may try to use the the buffer.

Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/a19bc9e211e3184215a58e129b62f440180e9212.1662480490.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cd155b7e1346d..effe3570a051f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -8260,6 +8260,7 @@ static void io_queue_async(struct io_kiocb *req, int ret)
 
 	switch (io_arm_poll_handler(req, 0)) {
 	case IO_APOLL_READY:
+		io_kbuf_recycle(req, 0);
 		io_req_task_queue(req);
 		break;
 	case IO_APOLL_ABORTED:
-- 
2.35.1



