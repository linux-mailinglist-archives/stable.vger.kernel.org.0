Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83C3E55C14F
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238409AbiF0LvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237500AbiF0Lsu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C76C9D4E;
        Mon, 27 Jun 2022 04:42:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B0D4B80DFB;
        Mon, 27 Jun 2022 11:42:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1909C3411D;
        Mon, 27 Jun 2022 11:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330171;
        bh=4w7b4pWpD7UXDkoehSBUHN1bW7Sn6vafUsjWmz8QO+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BRx5mUQye6VweSPC/NUlCCr77aIPmhof8mK8MWvpYrc2vh5W9GFPwpbJ4CieNABMt
         XQw8alR5y2MTHl8YtyI6A6FgrkwdIHiNsz82Hyf/2VkkBCEYeI8Szx9jhpb2T0+JmR
         m/xy5v5o93CaG6WKmhHzO/vSeQ+twGJ9jGAy94dw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 108/181] io_uring: make apoll_events a __poll_t
Date:   Mon, 27 Jun 2022 13:21:21 +0200
Message-Id: <20220627111947.829741373@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 58f5c8d39e0ea07fdaaea6a85c49000da83dc0cc ]

apoll_events is fed to vfs_poll and the poll tables, so it should be
a __poll_t.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220518084005.3255380-5-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ca9ed3d899e6..1070d22a1c2b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -926,7 +926,7 @@ struct io_kiocb {
 		/* used by request caches, completion batching and iopoll */
 		struct io_wq_work_node	comp_list;
 		/* cache ->apoll->events */
-		int apoll_events;
+		__poll_t apoll_events;
 	};
 	atomic_t			refs;
 	atomic_t			poll_refs;
@@ -5984,7 +5984,7 @@ static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
 		io_req_complete_failed(req, ret);
 }
 
-static void __io_poll_execute(struct io_kiocb *req, int mask, int events)
+static void __io_poll_execute(struct io_kiocb *req, int mask, __poll_t events)
 {
 	req->result = mask;
 	/*
@@ -6003,7 +6003,8 @@ static void __io_poll_execute(struct io_kiocb *req, int mask, int events)
 	io_req_task_work_add(req, false);
 }
 
-static inline void io_poll_execute(struct io_kiocb *req, int res, int events)
+static inline void io_poll_execute(struct io_kiocb *req, int res,
+		__poll_t events)
 {
 	if (io_poll_get_ownership(req))
 		__io_poll_execute(req, res, events);
-- 
2.35.1



