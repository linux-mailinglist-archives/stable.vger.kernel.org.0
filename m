Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2A523E3AF
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 23:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgHFV6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 17:58:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:40718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgHFV6k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Aug 2020 17:58:40 -0400
Received: from dhcp-10-100-145-180.wdl.wdc.com (unknown [199.255.45.60])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4ABF82173E;
        Thu,  6 Aug 2020 21:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596751119;
        bh=JMySq8t6HuT94iYiIEB6oem9k8KlefLRtW1Qkq2EZTU=;
        h=From:To:Cc:Subject:Date:From;
        b=NIbpktFJgjuKL/2rsU1jQR9rOWt9tKL6D64GNtDUJoQhWM7Kz9uiSqKo3q4qQqdls
         VGwt3YuT2/5SqiD5MoilZUg0PjSeiMO/rusQSFTfVrB9pj79mapGvi7e+Ul8P26id5
         Xd8MJt0230vx4EHyPkyiHz3BUJH4UsuE1qnQmLVU=
From:   Keith Busch <kbusch@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Keith Busch <kbusch@kernel.org>, Eric Deal <eric.deal@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, stable@vger.kernel.org
Subject: [PATCH] block: fix get_max_io_size()
Date:   Thu,  6 Aug 2020 14:58:37 -0700
Message-Id: <20200806215837.3968445-1-kbusch@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A previous commit aligning splits to physical block sizes inadvertently
modified one return case such that that it now returns 0 length splits
when the number of sectors doesn't exceed the physical offset. This
later hits a BUG in bio_split(). Restore the previous working behavior.

Reported-by: Eric Deal <eric.deal@wdc.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: stable@vger.kernel.org
Fixes: 9cc5169cd478b ("block: Improve physical block alignment of split bios")
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/blk-merge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 5196dc145270..d7fef954d42f 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -154,7 +154,7 @@ static inline unsigned get_max_io_size(struct request_queue *q,
 	if (max_sectors > start_offset)
 		return max_sectors - start_offset;
 
-	return sectors & (lbs - 1);
+	return sectors & ~(lbs - 1);
 }
 
 static inline unsigned get_max_segment_size(const struct request_queue *q,
-- 
2.24.1

