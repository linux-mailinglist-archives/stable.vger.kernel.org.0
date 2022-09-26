Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B685EA40D
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238078AbiIZLjS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238161AbiIZLhv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:37:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC8ABC81;
        Mon, 26 Sep 2022 03:44:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17A57609FE;
        Mon, 26 Sep 2022 10:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D548C433C1;
        Mon, 26 Sep 2022 10:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188927;
        bh=Y280b8Km9VNvziI6QZoOm5NrPSX5eP3b/H2SGoYxOeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m/io/nSPoFJ4fziQSefJvpw8ExWwpKTNxMowKdVAkU/p7m0f2pej5kR+xznvr7MdB
         EWnvmZYgz6IgONGjpVFxDXQ/Cr+oWiFCs5Dq1tkJUBb5B4uq86Hn4lBuNx2qKyKwjV
         I4zA3i0+ajgqJ/L2X83ly1UJ6sklWz7EFKcdNo2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 018/207] block: stop setting the nomerges flags in blk_cleanup_queue
Date:   Mon, 26 Sep 2022 12:10:07 +0200
Message-Id: <20220926100807.284103780@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 0e3534022f26ae51f7cf28347a253230604b6f4e ]

These flags only apply to file system I/O, and all file system I/O is
already drained by del_gendisk and thus can't be in progress when
blk_cleanup_queue is called.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Link: https://lore.kernel.org/r/20220619060552.1850436-5-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 8fe4ce5836e9 ("scsi: core: Fix a use-after-free")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 76f070c3a3b0..b8083decc07f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -304,9 +304,6 @@ void blk_cleanup_queue(struct request_queue *q)
 	blk_queue_flag_set(QUEUE_FLAG_DYING, q);
 	blk_queue_start_drain(q);
 
-	blk_queue_flag_set(QUEUE_FLAG_NOMERGES, q);
-	blk_queue_flag_set(QUEUE_FLAG_NOXMERGES, q);
-
 	/*
 	 * Drain all requests queued before DYING marking. Set DEAD flag to
 	 * prevent that blk_mq_run_hw_queues() accesses the hardware queues
-- 
2.35.1



