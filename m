Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249C75946B9
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346663AbiHOXAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351871AbiHOW7O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:59:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2536E76452;
        Mon, 15 Aug 2022 12:57:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 885CA60FD8;
        Mon, 15 Aug 2022 19:57:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E01C433D6;
        Mon, 15 Aug 2022 19:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593440;
        bh=sgYSD0j/s9y/c4VoEzXbjidbj5aLl52XfgJNB+JormI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FcgfNt1D2iF1kCKY5wfvU2PTJ9TTOtfbwAX1xuty8NsDOf04CViQ5G2Wxx2vZrDx3
         3JUzhfUqUOr7fvndBdG6mDFJYq0isj3FLCxrYYIvdSfFvojCOEF2QFK8BvHmiMIMTK
         7F8cIYzI/wuE0eOUIZINmcYXZUDn2u/sBarO4reU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Zhang <yi.zhang@redhat.com>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0268/1157] blk-mq: dont create hctx debugfs dir until q->debugfs_dir is created
Date:   Mon, 15 Aug 2022 19:53:44 +0200
Message-Id: <20220815180450.328660119@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit f3ec5d11554778c24ac8915e847223ed71d104fc ]

blk_mq_debugfs_register_hctx() can be called by blk_mq_update_nr_hw_queues
when gendisk isn't added yet, such as nvme tcp.

Fixes the warning of 'debugfs: Directory 'hctx0' with parent '/' already present!'
which can be observed reliably when running blktests nvme/005.

Fixes: 6cfc0081b046 ("blk-mq: no need to check return value of debugfs_create functions")
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Tested-by: Yi Zhang <yi.zhang@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220711090808.259682-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-debugfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 4d1ce9ef4318..61f179e5f151 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -730,6 +730,9 @@ void blk_mq_debugfs_register_hctx(struct request_queue *q,
 	char name[20];
 	int i;
 
+	if (!q->debugfs_dir)
+		return;
+
 	snprintf(name, sizeof(name), "hctx%u", hctx->queue_num);
 	hctx->debugfs_dir = debugfs_create_dir(name, q->debugfs_dir);
 
-- 
2.35.1



