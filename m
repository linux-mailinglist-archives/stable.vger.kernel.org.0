Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8722664D2
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 18:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbgIKQq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 12:46:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:49580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726370AbgIKPIE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 11:08:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E462223FB;
        Fri, 11 Sep 2020 12:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829145;
        bh=+GANnE8x2AjIJ0n2g8xz0D6nOtdB9ZiU2pb8fbn4/8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JtrIUVBq2ENAJHFb9J2EwbhirDMcATTn/K49jwUsjF/BchIPFnTPrwHWF0FEUvyCx
         yFv9Y23uFs0LQeJVtqQhAAkv4UMuwc7s8jRtB7bdsay5AwsLDdDthxuRlhY7h+tl5k
         RAN0tQKITBNE2jxRPXCl94/AtPoxKxPnqvhuOpGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 02/12] block: ensure bdi->io_pages is always initialized
Date:   Fri, 11 Sep 2020 14:46:56 +0200
Message-Id: <20200911122458.540739890@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122458.413137406@linuxfoundation.org>
References: <20200911122458.413137406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit de1b0ee490eafdf65fac9eef9925391a8369f2dc ]

If a driver leaves the limit settings as the defaults, then we don't
initialize bdi->io_pages. This means that file systems may need to
work around bdi->io_pages == 0, which is somewhat messy.

Initialize the default value just like we do for ->ra_pages.

Cc: stable@vger.kernel.org
Fixes: 9491ae4aade6 ("mm: don't cap request size based on read-ahead setting")
Reported-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4e04c79aa2c27..2407c898ba7d8 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -852,6 +852,8 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 
 	q->backing_dev_info->ra_pages =
 			(VM_MAX_READAHEAD * 1024) / PAGE_SIZE;
+	q->backing_dev_info->io_pages =
+			(VM_MAX_READAHEAD * 1024) / PAGE_SIZE;
 	q->backing_dev_info->capabilities = BDI_CAP_CGROUP_WRITEBACK;
 	q->backing_dev_info->name = "block";
 	q->node = node_id;
-- 
2.25.1



