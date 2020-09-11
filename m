Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E48A26613D
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 16:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725839AbgIKObC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 10:31:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726146AbgIKNMA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 09:12:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA7BD22460;
        Fri, 11 Sep 2020 13:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829238;
        bh=WlNBCEI9KTfKCFK7pdkqnVaUt/mbl+s3RN+6DE4iLdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g5sr7gU0aGC8V/8M9yjmTEtD+0jQnC2RO6kVk3SNlSErxT/g/J/zODx+NnvdN/Hsp
         GcYQmrhoVosdYrnTTPeYkwWj+3F0O6RORtgoZPe4kboXOBzO+HLs+ygWmT6S36bfHp
         QEgRhf6bhvwDDb3D26fDTkFZSnwQ639OXtZzW8gQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 2/8] block: ensure bdi->io_pages is always initialized
Date:   Fri, 11 Sep 2020 14:54:49 +0200
Message-Id: <20200911125421.818030368@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911125421.695645838@linuxfoundation.org>
References: <20200911125421.695645838@linuxfoundation.org>
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
index ea33d6abdcfc9..ce3710404544c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1036,6 +1036,8 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id,
 
 	q->backing_dev_info->ra_pages =
 			(VM_MAX_READAHEAD * 1024) / PAGE_SIZE;
+	q->backing_dev_info->io_pages =
+			(VM_MAX_READAHEAD * 1024) / PAGE_SIZE;
 	q->backing_dev_info->capabilities = BDI_CAP_CGROUP_WRITEBACK;
 	q->backing_dev_info->name = "block";
 	q->node = node_id;
-- 
2.25.1



