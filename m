Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8939DFD8
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 09:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730935AbfH0H6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:58:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:50612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730926AbfH0H6F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:58:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94B5320828;
        Tue, 27 Aug 2019 07:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892684;
        bh=IhLlVbaTQ/lDlnnPNW4ZBB3GouK8lSNNKaaDhXnG/mY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rK0cdy8Zj/yfpxcnkOXxq2F6NJm5oQiqQjkmP1vG2ylANUChQJMUEJYLpG5SozrJJ
         Kk+xu3yAeMpuYy57ViGGV9ICZYCvOM6u6Bc28tSTqwAY2qfe5GkAJWlpGPNJp+I+Tz
         FlSbt/S2h65Ve928IsTUYuy2s8GHXqYeC5gDCqQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.19 77/98] dm integrity: fix a crash due to BUG_ON in __journal_read_write()
Date:   Tue, 27 Aug 2019 09:50:56 +0200
Message-Id: <20190827072722.185737796@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
References: <20190827072718.142728620@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 5729b6e5a1bcb0bbc28abe82d749c7392f66d2c7 upstream.

Fix a crash that was introduced by the commit 724376a04d1a. The crash is
reported here: https://gitlab.com/cryptsetup/cryptsetup/issues/468

When reading from the integrity device, the function
dm_integrity_map_continue calls find_journal_node to find out if the
location to read is present in the journal. Then, it calculates how many
sectors are consecutively stored in the journal. Then, it locks the range
with add_new_range and wait_and_add_new_range.

The problem is that during wait_and_add_new_range, we hold no locks (we
don't hold ic->endio_wait.lock and we don't hold a range lock), so the
journal may change arbitrarily while wait_and_add_new_range sleeps.

The code then goes to __journal_read_write and hits
BUG_ON(journal_entry_get_sector(je) != logical_sector); because the
journal has changed.

In order to fix this bug, we need to re-check the journal location after
wait_and_add_new_range. We restrict the length to one block in order to
not complicate the code too much.

Fixes: 724376a04d1a ("dm integrity: implement fair range locks")
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-integrity.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1749,7 +1749,22 @@ offload_to_thread:
 			queue_work(ic->wait_wq, &dio->work);
 			return;
 		}
+		if (journal_read_pos != NOT_FOUND)
+			dio->range.n_sectors = ic->sectors_per_block;
 		wait_and_add_new_range(ic, &dio->range);
+		/*
+		 * wait_and_add_new_range drops the spinlock, so the journal
+		 * may have been changed arbitrarily. We need to recheck.
+		 * To simplify the code, we restrict I/O size to just one block.
+		 */
+		if (journal_read_pos != NOT_FOUND) {
+			sector_t next_sector;
+			unsigned new_pos = find_journal_node(ic, dio->range.logical_sector, &next_sector);
+			if (unlikely(new_pos != journal_read_pos)) {
+				remove_range_unlocked(ic, &dio->range);
+				goto retry;
+			}
+		}
 	}
 	spin_unlock_irq(&ic->endio_wait.lock);
 


