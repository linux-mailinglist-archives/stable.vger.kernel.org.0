Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF647459C
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404937AbfGYFo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:44:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404929AbfGYFo2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:44:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DABC922CB9;
        Thu, 25 Jul 2019 05:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033468;
        bh=jCXGdMDV83SSi0RMcl/cTH0AX2saeysAkpPWqNnn6r8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k3WrnGiGtvaUAwOC3KUpR21xWv9ej4enjhCXxd2f+OyOr6/J9dT8HUcRwPFEYSRg/
         Q/+yIb5m0b68cJTPBzBw3IAs76/qNA6nMXLQrjnljzv/tF5W03eHgfnNU0y1XN4zqr
         qAItYelQZ4EyqcPZlDkWdc3vYU9VlAdUz0BKIrzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masato Suzuki <masato.suzuki@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.19 219/271] dm zoned: fix zone state management race
Date:   Wed, 24 Jul 2019 21:21:28 +0200
Message-Id: <20190724191713.875553013@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

commit 3b8cafdd5436f9298b3bf6eb831df5eef5ee82b6 upstream.

dm-zoned uses the zone flag DMZ_ACTIVE to indicate that a zone of the
backend device is being actively read or written and so cannot be
reclaimed. This flag is set as long as the zone atomic reference
counter is not 0. When this atomic is decremented and reaches 0 (e.g.
on BIO completion), the active flag is cleared and set again whenever
the zone is reused and BIO issued with the atomic counter incremented.
These 2 operations (atomic inc/dec and flag set/clear) are however not
always executed atomically under the target metadata mutex lock and
this causes the warning:

WARN_ON(!test_bit(DMZ_ACTIVE, &zone->flags));

in dmz_deactivate_zone() to be displayed. This problem is regularly
triggered with xfstests generic/209, generic/300, generic/451 and
xfs/077 with XFS being used as the file system on the dm-zoned target
device. Similarly, xfstests ext4/303, ext4/304, generic/209 and
generic/300 trigger the warning with ext4 use.

This problem can be easily fixed by simply removing the DMZ_ACTIVE flag
and managing the "ACTIVE" state by directly looking at the reference
counter value. To do so, the functions dmz_activate_zone() and
dmz_deactivate_zone() are changed to inline functions respectively
calling atomic_inc() and atomic_dec(), while the dmz_is_active() macro
is changed to an inline function calling atomic_read().

Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
Cc: stable@vger.kernel.org
Reported-by: Masato Suzuki <masato.suzuki@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-zoned-metadata.c |   24 ------------------------
 drivers/md/dm-zoned.h          |   28 ++++++++++++++++++++++++----
 2 files changed, 24 insertions(+), 28 deletions(-)

--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1594,30 +1594,6 @@ struct dm_zone *dmz_get_zone_for_reclaim
 }
 
 /*
- * Activate a zone (increment its reference count).
- */
-void dmz_activate_zone(struct dm_zone *zone)
-{
-	set_bit(DMZ_ACTIVE, &zone->flags);
-	atomic_inc(&zone->refcount);
-}
-
-/*
- * Deactivate a zone. This decrement the zone reference counter
- * and clears the active state of the zone once the count reaches 0,
- * indicating that all BIOs to the zone have completed. Returns
- * true if the zone was deactivated.
- */
-void dmz_deactivate_zone(struct dm_zone *zone)
-{
-	if (atomic_dec_and_test(&zone->refcount)) {
-		WARN_ON(!test_bit(DMZ_ACTIVE, &zone->flags));
-		clear_bit_unlock(DMZ_ACTIVE, &zone->flags);
-		smp_mb__after_atomic();
-	}
-}
-
-/*
  * Get the zone mapping a chunk, if the chunk is mapped already.
  * If no mapping exist and the operation is WRITE, a zone is
  * allocated and used to map the chunk.
--- a/drivers/md/dm-zoned.h
+++ b/drivers/md/dm-zoned.h
@@ -115,7 +115,6 @@ enum {
 	DMZ_BUF,
 
 	/* Zone internal state */
-	DMZ_ACTIVE,
 	DMZ_RECLAIM,
 	DMZ_SEQ_WRITE_ERR,
 };
@@ -128,7 +127,6 @@ enum {
 #define dmz_is_empty(z)		((z)->wp_block == 0)
 #define dmz_is_offline(z)	test_bit(DMZ_OFFLINE, &(z)->flags)
 #define dmz_is_readonly(z)	test_bit(DMZ_READ_ONLY, &(z)->flags)
-#define dmz_is_active(z)	test_bit(DMZ_ACTIVE, &(z)->flags)
 #define dmz_in_reclaim(z)	test_bit(DMZ_RECLAIM, &(z)->flags)
 #define dmz_seq_write_err(z)	test_bit(DMZ_SEQ_WRITE_ERR, &(z)->flags)
 
@@ -188,8 +186,30 @@ void dmz_unmap_zone(struct dmz_metadata
 unsigned int dmz_nr_rnd_zones(struct dmz_metadata *zmd);
 unsigned int dmz_nr_unmap_rnd_zones(struct dmz_metadata *zmd);
 
-void dmz_activate_zone(struct dm_zone *zone);
-void dmz_deactivate_zone(struct dm_zone *zone);
+/*
+ * Activate a zone (increment its reference count).
+ */
+static inline void dmz_activate_zone(struct dm_zone *zone)
+{
+	atomic_inc(&zone->refcount);
+}
+
+/*
+ * Deactivate a zone. This decrement the zone reference counter
+ * indicating that all BIOs to the zone have completed when the count is 0.
+ */
+static inline void dmz_deactivate_zone(struct dm_zone *zone)
+{
+	atomic_dec(&zone->refcount);
+}
+
+/*
+ * Test if a zone is active, that is, has a refcount > 0.
+ */
+static inline bool dmz_is_active(struct dm_zone *zone)
+{
+	return atomic_read(&zone->refcount);
+}
 
 int dmz_lock_zone_reclaim(struct dm_zone *zone);
 void dmz_unlock_zone_reclaim(struct dm_zone *zone);


