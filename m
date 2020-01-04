Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19199130143
	for <lists+stable@lfdr.de>; Sat,  4 Jan 2020 07:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbgADG6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jan 2020 01:58:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:48930 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbgADG6J (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 Jan 2020 01:58:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F1808AD5F;
        Sat,  4 Jan 2020 06:58:07 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, stable@vger.kernel.org,
        Eric Wheeler <bcache@linux.ewheeler.net>
Subject: [PATCH] bcache: back to cache all readahead I/Os
Date:   Sat,  4 Jan 2020 14:58:02 +0800
Message-Id: <20200104065802.113137-1-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In year 2007 high performance SSD was still expensive, in order to
save more space for real workload or meta data, the readahead I/Os
for non-meta data was bypassed and not cached on SSD.

In now days, SSD price drops a lot and people can find larger size
SSD with more comfortable price. It is unncessary to bypass normal
readahead I/Os to save SSD space for now.

This patch removes the code which checks REQ_RAHEAD tag of bio in
check_should_bypass(), then all readahead I/Os will be cached on SSD.

NOTE: this patch still keeps the checking of "REQ_META|REQ_PRIO" in
should_writeback(), because we still want to cache meta data I/Os
even they are asynchronized.

Cc: stable@vger.kernel.org
Signed-off-by: Coly Li <colyli@suse.de>
Cc: Eric Wheeler <bcache@linux.ewheeler.net>
---
 drivers/md/bcache/request.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 73478a91a342..acc07c4f27ae 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -378,15 +378,6 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
 	     op_is_write(bio_op(bio))))
 		goto skip;
 
-	/*
-	 * Flag for bypass if the IO is for read-ahead or background,
-	 * unless the read-ahead request is for metadata
-	 * (eg, for gfs2 or xfs).
-	 */
-	if (bio->bi_opf & (REQ_RAHEAD|REQ_BACKGROUND) &&
-	    !(bio->bi_opf & (REQ_META|REQ_PRIO)))
-		goto skip;
-
 	if (bio->bi_iter.bi_sector & (c->sb.block_size - 1) ||
 	    bio_sectors(bio) & (c->sb.block_size - 1)) {
 		pr_debug("skipping unaligned io");
-- 
2.16.4

