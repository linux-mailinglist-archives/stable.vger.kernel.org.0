Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28D2360D82
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234393AbhDOPDO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:03:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:46112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235176AbhDOPA1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:00:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92F5961152;
        Thu, 15 Apr 2021 14:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498595;
        bh=8dX0nKeBPMPFDBL15Iezv+br/Y1ueaIaFrJnbJY55H4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t8FdTdxt2soWilI8K0MDWRpZdHzG09ZCq+2X1ISCABzExZ1guGPzI8N/3+Az43j+k
         erT+3B9bm2j8XPWE0W4p1lpV6Ey+H1x7lw22RwpmvTdx70epqR0cFpqYpod53IMsJr
         4bil05uuB+90E9Ja83383sKw2Sg7kdcYx4zYUJNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Yufen Yu <yuyufen@huawei.com>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 07/18] block: only update parent bi_status when bio fail
Date:   Thu, 15 Apr 2021 16:48:00 +0200
Message-Id: <20210415144413.285069290@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.055232956@linuxfoundation.org>
References: <20210415144413.055232956@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufen Yu <yuyufen@huawei.com>

[ Upstream commit 3edf5346e4f2ce2fa0c94651a90a8dda169565ee ]

For multiple split bios, if one of the bio is fail, the whole
should return error to application. But we found there is a race
between bio_integrity_verify_fn and bio complete, which return
io success to application after one of the bio fail. The race as
following:

split bio(READ)          kworker

nvme_complete_rq
blk_update_request //split error=0
  bio_endio
    bio_integrity_endio
      queue_work(kintegrityd_wq, &bip->bip_work);

                         bio_integrity_verify_fn
                         bio_endio //split bio
                          __bio_chain_endio
                             if (!parent->bi_status)

                               <interrupt entry>
                               nvme_irq
                                 blk_update_request //parent error=7
                                 req_bio_endio
                                    bio->bi_status = 7 //parent bio
                               <interrupt exit>

                               parent->bi_status = 0
                        parent->bi_end_io() // return bi_status=0

The bio has been split as two: split and parent. When split
bio completed, it depends on kworker to do endio, while
bio_integrity_verify_fn have been interrupted by parent bio
complete irq handler. Then, parent bio->bi_status which have
been set in irq handler will overwrite by kworker.

In fact, even without the above race, we also need to conside
the concurrency beteen mulitple split bio complete and update
the same parent bi_status. Normally, multiple split bios will
be issued to the same hctx and complete from the same irq
vector. But if we have updated queue map between multiple split
bios, these bios may complete on different hw queue and different
irq vector. Then the concurrency update parent bi_status may
cause the final status error.

Suggested-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Yufen Yu <yuyufen@huawei.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20210331115359.1125679-1-yuyufen@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index 24704bc2ad6f..cb38d6f3acce 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -305,7 +305,7 @@ static struct bio *__bio_chain_endio(struct bio *bio)
 {
 	struct bio *parent = bio->bi_private;
 
-	if (!parent->bi_status)
+	if (bio->bi_status && !parent->bi_status)
 		parent->bi_status = bio->bi_status;
 	bio_put(bio);
 	return parent;
-- 
2.30.2



