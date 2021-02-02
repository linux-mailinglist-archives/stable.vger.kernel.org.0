Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3588830C02F
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbhBBNvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:51:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:37906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232879AbhBBNst (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:48:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D4B064FA2;
        Tue,  2 Feb 2021 13:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273341;
        bh=ActQgV3OQ5VJ/hCb9T67xDjl9gG3cIAZxibIxThTSpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i5n5NS6KpjsHZ9uqXYBw035QAPrCgVlxmPtY6DYKeW/thViRmzneOuusQQ5QDI+wx
         2OEubBdgm7FJ4JrjvPgQq4zeZe6tXaL600cneracNSHbfWuwWmK7VD/3unFGJFNQTv
         U9IfzDG9ZiLJOgAWwPwAv2xbu2aFVJTwk5FKDS8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 069/142] blk-mq: test QUEUE_FLAG_HCTX_ACTIVE for sbitmap_shared in hctx_may_queue
Date:   Tue,  2 Feb 2021 14:37:12 +0100
Message-Id: <20210202133000.570728868@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit 2569063c7140c65a0d0ad075e95ddfbcda9ba3c0 upstream.

In case of blk_mq_is_sbitmap_shared(), we should test QUEUE_FLAG_HCTX_ACTIVE against
q->queue_flags instead of BLK_MQ_S_TAG_ACTIVE.

So fix it.

Cc: John Garry <john.garry@huawei.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Fixes: f1b49fdc1c64 ("blk-mq: Record active_queues_shared_sbitmap per tag_set for when using shared sbitmap")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-mq.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -303,7 +303,7 @@ static inline bool hctx_may_queue(struct
 		struct request_queue *q = hctx->queue;
 		struct blk_mq_tag_set *set = q->tag_set;
 
-		if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &q->queue_flags))
+		if (!test_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags))
 			return true;
 		users = atomic_read(&set->active_queues_shared_sbitmap);
 	} else {


