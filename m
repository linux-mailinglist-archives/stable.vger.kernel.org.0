Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E174261C5A
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732018AbgIHTSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:18:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731139AbgIHQCv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:02:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D7EF246E3;
        Tue,  8 Sep 2020 15:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579618;
        bh=IW5uSBcmOPPSkVi4qJhYfoEVWEe0kYakDz5/+FPWbEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GqPHP/JxVfMST3bSXczU4rOuDyQqEeMnTrvWjzsfmLmk5SmJxvnwgV6/dcNd6falK
         +yPi4IGWsWkFJrN88pyBUAkQZPPxQ+O2rAc+C3s2PMl+EfNjJ7AVqjwKt1KoC3N0SH
         ZSVM4GvJR616JpoLXL7yv7vHM9WBSKMFsg6t9C1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.8 153/186] block: ensure bdi->io_pages is always initialized
Date:   Tue,  8 Sep 2020 17:24:55 +0200
Message-Id: <20200908152249.075194644@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit de1b0ee490eafdf65fac9eef9925391a8369f2dc upstream.

If a driver leaves the limit settings as the defaults, then we don't
initialize bdi->io_pages. This means that file systems may need to
work around bdi->io_pages == 0, which is somewhat messy.

Initialize the default value just like we do for ->ra_pages.

Cc: stable@vger.kernel.org
Fixes: 9491ae4aade6 ("mm: don't cap request size based on read-ahead setting")
Reported-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -526,6 +526,7 @@ struct request_queue *__blk_alloc_queue(
 		goto fail_stats;
 
 	q->backing_dev_info->ra_pages = VM_READAHEAD_PAGES;
+	q->backing_dev_info->io_pages = VM_READAHEAD_PAGES;
 	q->backing_dev_info->capabilities = BDI_CAP_CGROUP_WRITEBACK;
 	q->node = node_id;
 


