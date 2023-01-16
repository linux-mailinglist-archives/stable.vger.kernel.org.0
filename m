Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94BA166C59A
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbjAPQHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:07:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbjAPQHU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:07:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B87265B1
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:05:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF8E8B81065
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A82FC433EF;
        Mon, 16 Jan 2023 16:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885123;
        bh=pzyQHGEYss7NSj63f8HO/yDtGBGN67sxZjCJb3zZFx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FnfG+aalhvV2sIFHOrPu0z3VuNpjt/j0Lqr2+nWfB8QiLETCJoVeh3nIIW9bKwH+i
         gCSRkFLkOvWx5GkyTJtpb9r3wnf3InUrUIlHbkSpx14Tmt/pMr4bfvLeerotdxOGJU
         QIKPpPy5qddeLq8XKQ7FtXePGfio/qD7VJcDiJ/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+d56ec896af3637bdb7e4@syzkaller.appspotmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 83/86] io_uring/io-wq: only free worker if it was allocated for creation
Date:   Mon, 16 Jan 2023 16:51:57 +0100
Message-Id: <20230116154750.480675740@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit e6db6f9398dadcbc06318a133d4c44a2d3844e61 upstream.

We have two types of task_work based creation, one is using an existing
worker to setup a new one (eg when going to sleep and we have no free
workers), and the other is allocating a new worker. Only the latter
should be freed when we cancel task_work creation for a new worker.

Fixes: af82425c6a2d ("io_uring/io-wq: free worker if task_work creation is canceled")
Reported-by: syzbot+d56ec896af3637bdb7e4@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1217,7 +1217,12 @@ static void io_wq_cancel_tw_create(struc
 
 		worker = container_of(cb, struct io_worker, create_work);
 		io_worker_cancel_cb(worker);
-		kfree(worker);
+		/*
+		 * Only the worker continuation helper has worker allocated and
+		 * hence needs freeing.
+		 */
+		if (cb->func == create_worker_cont)
+			kfree(worker);
 	}
 }
 


