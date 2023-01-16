Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6CC66C525
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbjAPQCE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:02:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbjAPQBk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:01:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E5E227B8
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:01:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54147B8105F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC0AC433F0;
        Mon, 16 Jan 2023 16:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884893;
        bh=EAj5/06oEFDmmIEA1jaaaod16OnjAifokg9IgmuQtZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ni0WLOj18HieXVcbJs+14JNBBapl47YaDKETGjE5bQ/zEkjweeAYlatoRNxywytZG
         dEmCH7HuC4ci/LyuxdAktk/L3H6AWtCBB1homqVxBRKh/+Z6wUTvDXb/pga5E7B3jq
         /l/AoCugsfh1ZsPOXhbCGIWlMO/usdKl0J4DSpqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+d56ec896af3637bdb7e4@syzkaller.appspotmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 180/183] io_uring/io-wq: only free worker if it was allocated for creation
Date:   Mon, 16 Jan 2023 16:51:43 +0100
Message-Id: <20230116154810.900952472@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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
@@ -1230,7 +1230,12 @@ static void io_wq_cancel_tw_create(struc
 
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
 


