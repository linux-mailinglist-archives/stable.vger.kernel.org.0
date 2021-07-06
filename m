Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877A03BCFF6
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbhGFLb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:31:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233908AbhGFL0c (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:26:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B07A61D4B;
        Tue,  6 Jul 2021 11:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570391;
        bh=WHEJ/5JxED6vPS2TrQq+1VbRsCAJrlhyTw5epqGEJ6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Agbm/1HzypCGAnJg9gKuhx/QpY7DTJSgMXEBBXkFvcBX8waTTr4XEmvB5dqpIBpXF
         76AYsuKkgwwLHO6tsaaOpNJLsynMhPGjFeOvufgni2llxNk1M/W+D50DMGhiG7BzCH
         XYp0Uon+LeulEwdtOUsRctayXv+4sxwZRSCQ7wxLtmhhWtocr2CL6wCCCvIqx1fAdK
         7CRR97lhMEdZ70h8sWtu9B6mb7mLc9Oh0cx8ra3IAR8dbkrNUwcQeJDdwkZlCW3CA3
         PbYYTgkTAo9BG5zg77WZW8XhUbUqe3vt1BuhTJmtuFFmGGXUTIMx6gcuc1lrCKPjM5
         mLJeRdGFnAu5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Damien Le Moal <damien.lemoal@wdc.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 5.12 063/160] dm: Fix dm_accept_partial_bio() relative to zone management commands
Date:   Tue,  6 Jul 2021 07:16:49 -0400
Message-Id: <20210706111827.2060499-63-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

[ Upstream commit 6842d264aa5205da338b6dcc6acfa2a6732558f1 ]

Fix dm_accept_partial_bio() to actually check that zone management
commands are not passed as explained in the function documentation
comment. Also, since a zone append operation cannot be split, add
REQ_OP_ZONE_APPEND as a forbidden command.

White lines are added around the group of BUG_ON() calls to make the
code more legible.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3f3be9408afa..05747d2736a7 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1239,8 +1239,8 @@ static int dm_dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
 
 /*
  * A target may call dm_accept_partial_bio only from the map routine.  It is
- * allowed for all bio types except REQ_PREFLUSH, REQ_OP_ZONE_RESET,
- * REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE and REQ_OP_ZONE_FINISH.
+ * allowed for all bio types except REQ_PREFLUSH, REQ_OP_ZONE_* zone management
+ * operations and REQ_OP_ZONE_APPEND (zone append writes).
  *
  * dm_accept_partial_bio informs the dm that the target only wants to process
  * additional n_sectors sectors of the bio and the rest of the data should be
@@ -1270,9 +1270,13 @@ void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors)
 {
 	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
 	unsigned bi_size = bio->bi_iter.bi_size >> SECTOR_SHIFT;
+
 	BUG_ON(bio->bi_opf & REQ_PREFLUSH);
+	BUG_ON(op_is_zone_mgmt(bio_op(bio)));
+	BUG_ON(bio_op(bio) == REQ_OP_ZONE_APPEND);
 	BUG_ON(bi_size > *tio->len_ptr);
 	BUG_ON(n_sectors > bi_size);
+
 	*tio->len_ptr -= bi_size - n_sectors;
 	bio->bi_iter.bi_size = n_sectors << SECTOR_SHIFT;
 }
-- 
2.30.2

