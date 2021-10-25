Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74A1243A12F
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235725AbhJYThg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:37:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236490AbhJYTeu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:34:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86FC8610A0;
        Mon, 25 Oct 2021 19:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190264;
        bh=1rXrvtHjJ+u+9yzUUuiHLMJgH9Xy7NFvXkfLnU9sx3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=da4tlJ3YYJYdwjqhFT8Jhqnbl0h8pWWcaMY3ZNKJwCFyEYQW9pLYpUwWCwsCnvKTW
         oY9yN9eFyLRtp+41CcEK72enoDqNWtUjI9bGcDSiTfI2sqe10Z8lXB/32QJLDn2rd7
         gX/gK7ivONKKLWjCJYAIJFA9EVTvYcR6d1/zdLNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 06/95] block: decode QUEUE_FLAG_HCTX_ACTIVE in debugfs output
Date:   Mon, 25 Oct 2021 21:14:03 +0200
Message-Id: <20211025190957.309744185@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit 1dbdd99b511c966be9147ad72991a2856ac76f22 ]

While debugging an issue we've found that $DEBUGFS/block/$disk/state
doesn't decode QUEUE_FLAG_HCTX_ACTIVE but only displays its numerical
value.

Add QUEUE_FLAG(HCTX_ACTIVE) to the blk_queue_flag_name array so it'll get
decoded properly.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/4351076388918075bd80ef07756f9d2ce63be12c.1633332053.git.johannes.thumshirn@wdc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 4de03da9a624..b5f26082b959 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -129,6 +129,7 @@ static const char *const blk_queue_flag_name[] = {
 	QUEUE_FLAG_NAME(PCI_P2PDMA),
 	QUEUE_FLAG_NAME(ZONE_RESETALL),
 	QUEUE_FLAG_NAME(RQ_ALLOC_TIME),
+	QUEUE_FLAG_NAME(HCTX_ACTIVE),
 	QUEUE_FLAG_NAME(NOWAIT),
 };
 #undef QUEUE_FLAG_NAME
-- 
2.33.0



