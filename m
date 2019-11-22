Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 376E6107013
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729595AbfKVKqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:46:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:52940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729545AbfKVKqC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:46:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3060020748;
        Fri, 22 Nov 2019 10:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419561;
        bh=DLqtyD3FkQpL4d6hSuqWxbmsfSbHPKfvIDSHACFVQUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CMikqmNJ69Z2h5ffuKYtmu61LgraIdDEvszalaFTG8fAUww1L9nK4R48IZa9lUXB6
         Ow+hJoO6TGHrer6EAx5Nfn6XU/9t9fokvC+MOLw6fAmQ0yQacWCoDOlYqwZrrO2EqG
         UoRDjWBtFdMS0lpl5xh4krjjHTJsAwMctCJSWjNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@fb.com>
Subject: [PATCH 4.9 153/222] block: introduce blk_rq_is_passthrough
Date:   Fri, 22 Nov 2019 11:28:13 +0100
Message-Id: <20191122100913.777795515@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 57292b58ddb58689e8c3b4c6eadbef10d9ca44dd upstream.

This can be used to check for fs vs non-fs requests and basically
removes all knowledge of BLOCK_PC specific from the block layer,
as well as preparing for removing the cmd_type field in struct request.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@fb.com>
[only take the blkdev.h changes as we only want the function for backported
patches - gregkh]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/blkdev.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -212,6 +212,11 @@ struct request {
 	(req)->cmd_flags |= flags;		\
 } while (0)
 
+static inline bool blk_rq_is_passthrough(struct request *rq)
+{
+	return rq->cmd_type != REQ_TYPE_FS;
+}
+
 static inline unsigned short req_get_ioprio(struct request *req)
 {
 	return req->ioprio;
@@ -663,7 +668,7 @@ static inline void blk_clear_rl_full(str
 
 static inline bool rq_mergeable(struct request *rq)
 {
-	if (rq->cmd_type != REQ_TYPE_FS)
+	if (blk_rq_is_passthrough(rq))
 		return false;
 
 	if (req_op(rq) == REQ_OP_FLUSH)
@@ -910,7 +915,7 @@ static inline unsigned int blk_rq_get_ma
 {
 	struct request_queue *q = rq->q;
 
-	if (unlikely(rq->cmd_type != REQ_TYPE_FS))
+	if (blk_rq_is_passthrough(rq))
 		return q->limits.max_hw_sectors;
 
 	if (!q->limits.chunk_sectors ||


