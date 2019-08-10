Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA3488D5F
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfHJUp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:45:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55464 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726920AbfHJUoJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:09 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDe-00053i-Vp; Sat, 10 Aug 2019 21:44:07 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDK-0003cB-GO; Sat, 10 Aug 2019 21:43:46 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Ilya Dryomov" <idryomov@gmail.com>,
        "Mike Snitzer" <snitzer@redhat.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.124084088@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 059/157] dm table: propagate BDI_CAP_STABLE_WRITES to
 fix sporadic checksum errors
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <idryomov@gmail.com>

commit eb40c0acdc342b815d4d03ae6abb09e80c0f2988 upstream.

Some devices don't use blk_integrity but still want stable pages
because they do their own checksumming.  Examples include rbd and iSCSI
when data digests are negotiated.  Stacking DM (and thus LVM) on top of
these devices results in sporadic checksum errors.

Set BDI_CAP_STABLE_WRITES if any underlying device has it set.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
[bwh: Backported to 3.16: request_queue::backing_dev_info is a struct
 not a pointer]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/dm-table.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1432,6 +1432,36 @@ static bool dm_table_supports_write_same
 	return true;
 }
 
+static int device_requires_stable_pages(struct dm_target *ti,
+					struct dm_dev *dev, sector_t start,
+					sector_t len, void *data)
+{
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+
+	return q && bdi_cap_stable_pages_required(&q->backing_dev_info);
+}
+
+/*
+ * If any underlying device requires stable pages, a table must require
+ * them as well.  Only targets that support iterate_devices are considered:
+ * don't want error, zero, etc to require stable pages.
+ */
+static bool dm_table_requires_stable_pages(struct dm_table *t)
+{
+	struct dm_target *ti;
+	unsigned i;
+
+	for (i = 0; i < dm_table_get_num_targets(t); i++) {
+		ti = dm_table_get_target(t, i);
+
+		if (ti->type->iterate_devices &&
+		    ti->type->iterate_devices(ti, device_requires_stable_pages, NULL))
+			return true;
+	}
+
+	return false;
+}
+
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 			       struct queue_limits *limits)
 {
@@ -1474,6 +1504,15 @@ void dm_table_set_restrictions(struct dm
 	dm_table_set_integrity(t);
 
 	/*
+	 * Some devices don't use blk_integrity but still want stable pages
+	 * because they do their own checksumming.
+	 */
+	if (dm_table_requires_stable_pages(t))
+		q->backing_dev_info.capabilities |= BDI_CAP_STABLE_WRITES;
+	else
+		q->backing_dev_info.capabilities &= ~BDI_CAP_STABLE_WRITES;
+
+	/*
 	 * Determine whether or not this queue's I/O timings contribute
 	 * to the entropy pool, Only request-based targets use this.
 	 * Clear QUEUE_FLAG_ADD_RANDOM if any underlying device does not

