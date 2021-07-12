Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABAC43C4993
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236563AbhGLGp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:45:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:36944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237917AbhGLGmm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:42:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A058610D1;
        Mon, 12 Jul 2021 06:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071951;
        bh=rnQyENnhsq0GDNUYyoGfHFRhAaTYTl6xO5i0XIqk6Ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3PVO+RJlUG2ofKj9vEQ79T/4qp0GAc8Zf+h7AQZxkIO4YBMXAN8XWt2enIvu1uEJ
         o9j1okjEbIyktzVI4wHdAmnlb7DZcUsSLQqYRsAYzhcVjeOllTitp+i1LPQVV1TuH9
         7UQXmexdXOk4lgBmmLs6KmjtH5n/w3rcM+FdAZdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 288/593] blk-mq: update hctx->dispatch_busy in case of real scheduler
Date:   Mon, 12 Jul 2021 08:07:28 +0200
Message-Id: <20210712060916.019280751@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit cb9516be7708a2a18ec0a19fe3a225b5b3bc92c7 ]

Commit 6e6fcbc27e77 ("blk-mq: support batching dispatch in case of io")
starts to support io batching submission by using hctx->dispatch_busy.

However, blk_mq_update_dispatch_busy() isn't changed to update hctx->dispatch_busy
in that commit, so fix the issue by updating hctx->dispatch_busy in case
of real scheduler.

Reported-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Fixes: 6e6fcbc27e77 ("blk-mq: support batching dispatch in case of io")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20210625020248.1630497-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 00d6ed2fe812..a368eb6dc647 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1242,9 +1242,6 @@ static void blk_mq_update_dispatch_busy(struct blk_mq_hw_ctx *hctx, bool busy)
 {
 	unsigned int ewma;
 
-	if (hctx->queue->elevator)
-		return;
-
 	ewma = hctx->dispatch_busy;
 
 	if (!ewma && !busy)
-- 
2.30.2



