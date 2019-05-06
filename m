Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6863114F2E
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfEFOgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:36:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727140AbfEFOgT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:36:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14C9A204EC;
        Mon,  6 May 2019 14:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153378;
        bh=WZwAqtlxuEjg6/iE/ynfWMbAoNHOuqF/5Ogj6QmJDno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tDBs7IxGZSI3pO1PgzuRb6BFVIoApt7tfUC8dh7bAOiP5CNOJ8zzGuGna5aRKWLEb
         69bxiq95z8xvmweXccaW1wPsonSH5Ok0cMBxU0NFA3E2pqaUgK+ERKk2/8EMnJwZtZ
         5IoUlYmD0FIrweSnQWmqguffeCvVCHNtF/n9RCg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Dongli Zhang <dongli.zhang@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 066/122] blk-mq: do not reset plug->rq_count before the list is sorted
Date:   Mon,  6 May 2019 16:32:04 +0200
Message-Id: <20190506143100.884894875@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit bcc816dfe51ab86ca94663c7b225f2d6eb0fddb9 ]

We would never be able to sort the list if we first reset plug->rq_count
which is used in conditional check later.

Fixes: ce5b009cff19 ("block: improve logic around when to sort a plug list")
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 block/blk-mq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 97eba6d23425..5a2585d69c81 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1716,11 +1716,12 @@ void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 	unsigned int depth;
 
 	list_splice_init(&plug->mq_list, &list);
-	plug->rq_count = 0;
 
 	if (plug->rq_count > 2 && plug->multiple_queues)
 		list_sort(NULL, &list, plug_rq_cmp);
 
+	plug->rq_count = 0;
+
 	this_q = NULL;
 	this_hctx = NULL;
 	this_ctx = NULL;
-- 
2.20.1



