Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F97B17FD51
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728603AbgCJMwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:52:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729072AbgCJMwc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:52:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3022320674;
        Tue, 10 Mar 2020 12:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844751;
        bh=9FSYDkae8qu7VN6CuUOGfJEylPiP87lYdX0dWiEBBUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ab9PnF3jlunNHJl24iaHyQ7viZ0o5Cwd9WI6Z19dlMeAMXGxBNQRozIc7rNzwc8UR
         +cnV19MQLILLZrJqhbUTzEfdfrZRc0gMHGgrk9a7VktzSfR90aou7u/FnKJGH6NM2s
         bdyVz6KSr5czZyuP4T/PGQvxtu8TdyVUr3kpngjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.4 104/168] dm integrity: fix recalculation when moving from journal mode to bitmap mode
Date:   Tue, 10 Mar 2020 13:39:10 +0100
Message-Id: <20200310123645.911225481@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit d5bdf66108419cdb39da361b58ded661c29ff66e upstream.

If we resume a device in bitmap mode and the on-disk format is in journal
mode, we must recalculate anything above ic->sb->recalc_sector. Otherwise,
there would be non-recalculated blocks which would cause I/O errors.

Fixes: 468dfca38b1a ("dm integrity: add a bitmap mode")
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-integrity.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2883,17 +2883,24 @@ static void dm_integrity_resume(struct d
 	} else {
 		replay_journal(ic);
 		if (ic->mode == 'B') {
-			int mode;
 			ic->sb->flags |= cpu_to_le32(SB_FLAG_DIRTY_BITMAP);
 			ic->sb->log2_blocks_per_bitmap_bit = ic->log2_blocks_per_bitmap_bit;
 			r = sync_rw_sb(ic, REQ_OP_WRITE, REQ_FUA);
 			if (unlikely(r))
 				dm_integrity_io_error(ic, "writing superblock", r);
 
-			mode = ic->recalculate_flag ? BITMAP_OP_SET : BITMAP_OP_CLEAR;
-			block_bitmap_op(ic, ic->journal, 0, ic->provided_data_sectors, mode);
-			block_bitmap_op(ic, ic->recalc_bitmap, 0, ic->provided_data_sectors, mode);
-			block_bitmap_op(ic, ic->may_write_bitmap, 0, ic->provided_data_sectors, mode);
+			block_bitmap_op(ic, ic->journal, 0, ic->provided_data_sectors, BITMAP_OP_CLEAR);
+			block_bitmap_op(ic, ic->recalc_bitmap, 0, ic->provided_data_sectors, BITMAP_OP_CLEAR);
+			block_bitmap_op(ic, ic->may_write_bitmap, 0, ic->provided_data_sectors, BITMAP_OP_CLEAR);
+			if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING) &&
+			    le64_to_cpu(ic->sb->recalc_sector) < ic->provided_data_sectors) {
+				block_bitmap_op(ic, ic->journal, le64_to_cpu(ic->sb->recalc_sector),
+						ic->provided_data_sectors - le64_to_cpu(ic->sb->recalc_sector), BITMAP_OP_SET);
+				block_bitmap_op(ic, ic->recalc_bitmap, le64_to_cpu(ic->sb->recalc_sector),
+						ic->provided_data_sectors - le64_to_cpu(ic->sb->recalc_sector), BITMAP_OP_SET);
+				block_bitmap_op(ic, ic->may_write_bitmap, le64_to_cpu(ic->sb->recalc_sector),
+						ic->provided_data_sectors - le64_to_cpu(ic->sb->recalc_sector), BITMAP_OP_SET);
+			}
 			rw_journal_sectors(ic, REQ_OP_WRITE, REQ_FUA | REQ_SYNC, 0,
 					   ic->n_bitmap_blocks * (BITMAP_BLOCK_SIZE >> SECTOR_SHIFT), NULL);
 		}


