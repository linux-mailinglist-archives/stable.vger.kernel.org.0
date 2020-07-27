Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077C922EFD7
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730854AbgG0OTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:19:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731406AbgG0OTh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:19:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 216F320825;
        Mon, 27 Jul 2020 14:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859576;
        bh=TRh+4gzYuKIy2BqkB2gH3yL1Ae8c0trDVyJ/lwGZ8aM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZpvEY1l3SL2nFx626BL9ZTpgv/PjCwtmWWpYD4/qQXwmbdo6BHyGjdyqBMBjqLz/
         9DgaG/bTov0zI02f12yK4bcxGxeaWtNURW5fVTfPjXsaspYMc7jtCwRUzEcPhtSKrJ
         Ks81UwekFIL5/a3O/FTlTlcHmwa8fhgib0GKT/ro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 017/179] dm: use bio_uninit instead of bio_disassociate_blkg
Date:   Mon, 27 Jul 2020 16:03:12 +0200
Message-Id: <20200727134933.511961229@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 382761dc6312965a11f82f2217e16ec421bf17ae ]

bio_uninit is the proper API to clean up a BIO that has been allocated
on stack or inside a structure that doesn't come from the BIO allocator.
Switch dm to use that instead of bio_disassociate_blkg, which really is
an implementation detail.  Note that the bio_uninit calls are also moved
to the two callers of __send_empty_flush, so that they better pair with
the bio_init calls used to initialize them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 05333fc2f8d2b..9793b04e9ff3b 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1446,9 +1446,6 @@ static int __send_empty_flush(struct clone_info *ci)
 	BUG_ON(bio_has_data(ci->bio));
 	while ((ti = dm_table_get_target(ci->map, target_nr++)))
 		__send_duplicate_bios(ci, ti, ti->num_flush_bios, NULL);
-
-	bio_disassociate_blkg(ci->bio);
-
 	return 0;
 }
 
@@ -1636,6 +1633,7 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
 		ci.bio = &flush_bio;
 		ci.sector_count = 0;
 		error = __send_empty_flush(&ci);
+		bio_uninit(ci.bio);
 		/* dec_pending submits any data associated with flush */
 	} else if (op_is_zone_mgmt(bio_op(bio))) {
 		ci.bio = bio;
@@ -1710,6 +1708,7 @@ static blk_qc_t __process_bio(struct mapped_device *md, struct dm_table *map,
 		ci.bio = &flush_bio;
 		ci.sector_count = 0;
 		error = __send_empty_flush(&ci);
+		bio_uninit(ci.bio);
 		/* dec_pending submits any data associated with flush */
 	} else {
 		struct dm_target_io *tio;
-- 
2.25.1



