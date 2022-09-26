Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16C255EA531
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238224AbiIZL7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238972AbiIZL5F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:57:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA9B7A74B;
        Mon, 26 Sep 2022 03:51:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 079C1B80782;
        Mon, 26 Sep 2022 10:51:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E64FC433C1;
        Mon, 26 Sep 2022 10:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189459;
        bh=NR2nGKHCqMCbiIzfzdxCOwBE57OSql4xqN0iC9Rp7Uo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qD9beS6T7VcqO26fPylTqA+psdAV6w0gKAzYpbxdamuYdr6NwedXUXSpQvlwRBPPz
         DXDnVbhlLmg7l7zmcMPLI4zZsqXvZVnlQobz+Q6CtNbejRWMCqNhy9eTea930B8RCt
         /uQ8uYejDPd9MWUs53gnT63Lc7N3AJsX8K00QeOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.19 168/207] blk-mq: fix error handling in __blk_mq_alloc_disk
Date:   Mon, 26 Sep 2022 12:12:37 +0200
Message-Id: <20220926100814.177713877@linuxfoundation.org>
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

commit 0a3e5cc7bbfcd571a2e53779ef7d7aa3c57d5432 upstream.

To fully clean up the queue if the disk allocation fails we need to
call blk_mq_destroy_queue and not just blk_put_queue.

Fixes: 6f8191fdf41d ("block: simplify disk shutdown")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20220720130541.1323531-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3949,7 +3949,7 @@ struct gendisk *__blk_mq_alloc_disk(stru
 
 	disk = __alloc_disk_node(q, set->numa_node, lkclass);
 	if (!disk) {
-		blk_put_queue(q);
+		blk_mq_destroy_queue(q);
 		return ERR_PTR(-ENOMEM);
 	}
 	set_bit(GD_OWNS_QUEUE, &disk->state);


