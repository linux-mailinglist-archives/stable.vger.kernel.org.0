Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16DF12F9F92
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 13:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391520AbhARM1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 07:27:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:39118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390879AbhARLqP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:46:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3BB9222B3;
        Mon, 18 Jan 2021 11:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970340;
        bh=0G3mvyihlNYVY0qink1d/lmxEzbO5HZb4AV5AQgkc/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R5ce1MocAt+mJmMzzOMsdtFofEI0aN5ekYkcUzsWQ16hS1DxGLniL3/3rAAK0QTL5
         cd7A64oypjFZ/EelNsgguyFFfKPLEfdqzooQ3eQGZ5jeBall0fq9EaYdNmhi9CKK8M
         8lrl1D7qpEzbYy9xAS18acm1+PSijHw8wec+85pE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/152] blk-mq-debugfs: Add decode for BLK_MQ_F_TAG_HCTX_SHARED
Date:   Mon, 18 Jan 2021 12:34:43 +0100
Message-Id: <20210118113357.907022810@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

[ Upstream commit 02f938e9fed1681791605ca8b96c2d9da9355f6a ]

Showing the hctx flags for when BLK_MQ_F_TAG_HCTX_SHARED is set gives
something like:

root@debian:/home/john# more /sys/kernel/debug/block/sda/hctx0/flags
alloc_policy=FIFO SHOULD_MERGE|TAG_QUEUE_SHARED|3

Add the decoding for that flag.

Fixes: 32bc15afed04b ("blk-mq: Facilitate a shared sbitmap per tagset")
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 4d6e83e5b4429..4de03da9a624b 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -246,6 +246,7 @@ static const char *const hctx_flag_name[] = {
 	HCTX_FLAG_NAME(BLOCKING),
 	HCTX_FLAG_NAME(NO_SCHED),
 	HCTX_FLAG_NAME(STACKING),
+	HCTX_FLAG_NAME(TAG_HCTX_SHARED),
 };
 #undef HCTX_FLAG_NAME
 
-- 
2.27.0



