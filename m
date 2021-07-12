Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A953C4D90
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241264AbhGLHNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:13:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242267AbhGLHLw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:11:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF17E610D1;
        Mon, 12 Jul 2021 07:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073742;
        bh=eeSRVt3FkCjt3WDQdxZ1x+xwWrJEEYE+1JUohQRvcN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q/Iv5oETgr9ibaKN1C6h7UbXv7hhFP2gdo1hooEFCvCABss81AeloLzotffFMSkEG
         VFYxxy07VihdyeRdr+PujHQOlk66tAaiga93TWC/NgHpORTB4iihcZCib+vwpqqXuA
         F1jbUW1+fqQgCYEeX82g29LRtQsURjZ04j4B0aPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 342/700] blk-mq: update hctx->dispatch_busy in case of real scheduler
Date:   Mon, 12 Jul 2021 08:07:05 +0200
Message-Id: <20210712061012.671834133@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index d06ff908f3d9..6a982a277176 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1223,9 +1223,6 @@ static void blk_mq_update_dispatch_busy(struct blk_mq_hw_ctx *hctx, bool busy)
 {
 	unsigned int ewma;
 
-	if (hctx->queue->elevator)
-		return;
-
 	ewma = hctx->dispatch_busy;
 
 	if (!ewma && !busy)
-- 
2.30.2



