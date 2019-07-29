Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71530796ED
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404229AbfG2Tz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:55:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404209AbfG2Tzx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:55:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F5F521655;
        Mon, 29 Jul 2019 19:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430152;
        bh=CE4tJhHZBKHyEGCRqLRINiu4ABLaoH6P3gMjy31Nk0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xY5aNFEs7ocjv5PVYaX89K/e3w/Gn7PUPkKFEX7aOBWdWldgrsHqvkurvQiHkZ6pj
         kvWUO+RS4UNyRW2RS36qzaOuwyHBjh/RiaLL6eBuio4FKUCCezuj32lqgkM8LUK2fs
         Y1Lpmbh+apeNbKX1KN1K4CRRhubExN++F8QXuBc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhengyuan Liu <liuzhengyuan@kylinos.cn>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.2 214/215] io_uring: fix counter inc/dec mismatch in async_list
Date:   Mon, 29 Jul 2019 21:23:30 +0200
Message-Id: <20190729190816.978581666@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengyuan Liu <liuzhengyuan@kylinos.cn>

commit f7b76ac9d17e16e44feebb6d2749fec92bfd6dd4 upstream.

We could queue a work for each req in defer and link list without
increasing async_list->cnt, so we shouldn't decrease it while exiting
from workqueue as well if we didn't process the req in async list.

Thanks to Jens Axboe <axboe@kernel.dk> for his guidance.

Fixes: 31b515106428 ("io_uring: allow workqueue item to handle multiple buffered requests")
Signed-off-by: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 fs/io_uring.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -331,6 +331,9 @@ struct io_kiocb {
 #define REQ_F_SEQ_PREV		8	/* sequential with previous */
 #define REQ_F_IO_DRAIN		16	/* drain existing IO first */
 #define REQ_F_IO_DRAINED	32	/* drain done */
+#define REQ_F_LINK		64	/* linked sqes */
+#define REQ_F_LINK_DONE		128	/* linked sqes done */
+#define REQ_F_FAIL_LINK		256	/* fail rest of links */
 	u64			user_data;
 	u32			error;	/* iopoll result from callback */
 	u32			sequence;
@@ -1698,6 +1701,10 @@ restart:
 		/* async context always use a copy of the sqe */
 		kfree(sqe);
 
+		/* req from defer and link list needn't decrease async cnt */
+		if (req->flags & (REQ_F_IO_DRAINED | REQ_F_LINK_DONE))
+			goto out;
+
 		if (!async_list)
 			break;
 		if (!list_empty(&req_list)) {
@@ -1745,6 +1752,7 @@ restart:
 		}
 	}
 
+out:
 	if (cur_mm) {
 		set_fs(old_fs);
 		unuse_mm(cur_mm);


