Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0E2419C6A
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236420AbhI0R3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:29:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235622AbhI0R0s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:26:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1A676138E;
        Mon, 27 Sep 2021 17:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632763006;
        bh=Z+h5UCQ1pHGq30LcDVJRyF4/ArN7q2q2X4cNJCzUbT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DQ/yQmKCsyTW4ExtzdGF09/ahvP9ZPNDo7ieproMTD7m8jjhCwRVxaQ/lFrerMELc
         SsGmUIPnpluIIWjV8IfjxrOOC1laEqUu1D5n+DLfv19LNEms/ZeHSO6pe/hCGoUFjG
         hqs2nivqtsoNW1x6RahA5BsqBSkMI0N9CC7f3KDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lihong Kou <koulihong@huawei.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 133/162] block: flush the integrity workqueue in blk_integrity_unregister
Date:   Mon, 27 Sep 2021 19:02:59 +0200
Message-Id: <20210927170238.033503340@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lihong Kou <koulihong@huawei.com>

[ Upstream commit 3df49967f6f1d2121b0c27c381ca1c8386b1dab9 ]

When the integrity profile is unregistered there can still be integrity
reads queued up which could see a NULL verify_fn as shown by the race
window below:

CPU0                                    CPU1
  process_one_work                      nvme_validate_ns
    bio_integrity_verify_fn                nvme_update_ns_info
	                                     nvme_update_disk_info
	                                       blk_integrity_unregister
                                               ---set queue->integrity as 0
	bio_integrity_process
	--access bi->profile->verify_fn(bi is a pointer of queue->integity)

Before calling blk_integrity_unregister in nvme_update_disk_info, we must
make sure that there is no work item in the kintegrityd_wq. Just call
blk_flush_integrity to flush the work queue so the bug can be resolved.

Signed-off-by: Lihong Kou <koulihong@huawei.com>
[hch: split up and shortened the changelog]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Link: https://lore.kernel.org/r/20210914070657.87677-3-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-integrity.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index e9f943de377a..9e83159f5a52 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -430,6 +430,9 @@ void blk_integrity_unregister(struct gendisk *disk)
 
 	if (!bi->profile)
 		return;
+
+	/* ensure all bios are off the integrity workqueue */
+	blk_flush_integrity();
 	blk_queue_flag_clear(QUEUE_FLAG_STABLE_WRITES, disk->queue);
 	memset(bi, 0, sizeof(*bi));
 }
-- 
2.33.0



