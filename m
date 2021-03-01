Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E99BE328C0D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238005AbhCASoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:44:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:51244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240492AbhCASjO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:39:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FACF65295;
        Mon,  1 Mar 2021 17:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619968;
        bh=AO06Y7O9kQn59AlIfUY0zVisbUSIrI5FkQk4jxrnmiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pdXmmcAIb+upISyaDp7H6akYe+y05k0oREgE8ZNcS6gwtAe6pOMtpZ/GaWBTQ/6Ub
         n1H6QmXI1cd9v1eVR4VhWyN77x9PUdevMquENzRZj5Ch7y0Joxt43Aqor7EJwTzSUU
         S5oG2QQb71QALExqA/DAmidstx2AZ2zccgvobgbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.10 646/663] dm writecache: return the exact table values that were set
Date:   Mon,  1 Mar 2021 17:14:54 +0100
Message-Id: <20210301161213.815627233@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 054bee16163df023e2589db09fd27d81f7ad9e72 upstream.

LVM doesn't like it when the target returns different values from what
was set in the constructor. Fix dm-writecache so that the returned
table values are exactly the same as requested values.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org # v4.18+
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-writecache.c |   54 +++++++++++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 24 deletions(-)

--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -159,14 +159,22 @@ struct dm_writecache {
 	bool overwrote_committed:1;
 	bool memory_vmapped:1;
 
+	bool start_sector_set:1;
 	bool high_wm_percent_set:1;
 	bool low_wm_percent_set:1;
 	bool max_writeback_jobs_set:1;
 	bool autocommit_blocks_set:1;
 	bool autocommit_time_set:1;
+	bool max_age_set:1;
 	bool writeback_fua_set:1;
 	bool flush_on_suspend:1;
 	bool cleaner:1;
+	bool cleaner_set:1;
+
+	unsigned high_wm_percent_value;
+	unsigned low_wm_percent_value;
+	unsigned autocommit_time_value;
+	unsigned max_age_value;
 
 	unsigned writeback_all;
 	struct workqueue_struct *writeback_wq;
@@ -2205,6 +2213,7 @@ static int writecache_ctr(struct dm_targ
 			if (sscanf(string, "%llu%c", &start_sector, &dummy) != 1)
 				goto invalid_optional;
 			wc->start_sector = start_sector;
+			wc->start_sector_set = true;
 			if (wc->start_sector != start_sector ||
 			    wc->start_sector >= wc->memory_map_size >> SECTOR_SHIFT)
 				goto invalid_optional;
@@ -2214,6 +2223,7 @@ static int writecache_ctr(struct dm_targ
 				goto invalid_optional;
 			if (high_wm_percent < 0 || high_wm_percent > 100)
 				goto invalid_optional;
+			wc->high_wm_percent_value = high_wm_percent;
 			wc->high_wm_percent_set = true;
 		} else if (!strcasecmp(string, "low_watermark") && opt_params >= 1) {
 			string = dm_shift_arg(&as), opt_params--;
@@ -2221,6 +2231,7 @@ static int writecache_ctr(struct dm_targ
 				goto invalid_optional;
 			if (low_wm_percent < 0 || low_wm_percent > 100)
 				goto invalid_optional;
+			wc->low_wm_percent_value = low_wm_percent;
 			wc->low_wm_percent_set = true;
 		} else if (!strcasecmp(string, "writeback_jobs") && opt_params >= 1) {
 			string = dm_shift_arg(&as), opt_params--;
@@ -2240,6 +2251,7 @@ static int writecache_ctr(struct dm_targ
 			if (autocommit_msecs > 3600000)
 				goto invalid_optional;
 			wc->autocommit_jiffies = msecs_to_jiffies(autocommit_msecs);
+			wc->autocommit_time_value = autocommit_msecs;
 			wc->autocommit_time_set = true;
 		} else if (!strcasecmp(string, "max_age") && opt_params >= 1) {
 			unsigned max_age_msecs;
@@ -2249,7 +2261,10 @@ static int writecache_ctr(struct dm_targ
 			if (max_age_msecs > 86400000)
 				goto invalid_optional;
 			wc->max_age = msecs_to_jiffies(max_age_msecs);
+			wc->max_age_set = true;
+			wc->max_age_value = max_age_msecs;
 		} else if (!strcasecmp(string, "cleaner")) {
+			wc->cleaner_set = true;
 			wc->cleaner = true;
 		} else if (!strcasecmp(string, "fua")) {
 			if (WC_MODE_PMEM(wc)) {
@@ -2455,7 +2470,6 @@ static void writecache_status(struct dm_
 	struct dm_writecache *wc = ti->private;
 	unsigned extra_args;
 	unsigned sz = 0;
-	uint64_t x;
 
 	switch (type) {
 	case STATUSTYPE_INFO:
@@ -2467,11 +2481,11 @@ static void writecache_status(struct dm_
 		DMEMIT("%c %s %s %u ", WC_MODE_PMEM(wc) ? 'p' : 's',
 				wc->dev->name, wc->ssd_dev->name, wc->block_size);
 		extra_args = 0;
-		if (wc->start_sector)
+		if (wc->start_sector_set)
 			extra_args += 2;
-		if (wc->high_wm_percent_set && !wc->cleaner)
+		if (wc->high_wm_percent_set)
 			extra_args += 2;
-		if (wc->low_wm_percent_set && !wc->cleaner)
+		if (wc->low_wm_percent_set)
 			extra_args += 2;
 		if (wc->max_writeback_jobs_set)
 			extra_args += 2;
@@ -2479,37 +2493,29 @@ static void writecache_status(struct dm_
 			extra_args += 2;
 		if (wc->autocommit_time_set)
 			extra_args += 2;
-		if (wc->max_age != MAX_AGE_UNSPECIFIED)
+		if (wc->max_age_set)
 			extra_args += 2;
-		if (wc->cleaner)
+		if (wc->cleaner_set)
 			extra_args++;
 		if (wc->writeback_fua_set)
 			extra_args++;
 
 		DMEMIT("%u", extra_args);
-		if (wc->start_sector)
+		if (wc->start_sector_set)
 			DMEMIT(" start_sector %llu", (unsigned long long)wc->start_sector);
-		if (wc->high_wm_percent_set && !wc->cleaner) {
-			x = (uint64_t)wc->freelist_high_watermark * 100;
-			x += wc->n_blocks / 2;
-			do_div(x, (size_t)wc->n_blocks);
-			DMEMIT(" high_watermark %u", 100 - (unsigned)x);
-		}
-		if (wc->low_wm_percent_set && !wc->cleaner) {
-			x = (uint64_t)wc->freelist_low_watermark * 100;
-			x += wc->n_blocks / 2;
-			do_div(x, (size_t)wc->n_blocks);
-			DMEMIT(" low_watermark %u", 100 - (unsigned)x);
-		}
+		if (wc->high_wm_percent_set)
+			DMEMIT(" high_watermark %u", wc->high_wm_percent_value);
+		if (wc->low_wm_percent_set)
+			DMEMIT(" low_watermark %u", wc->low_wm_percent_value);
 		if (wc->max_writeback_jobs_set)
 			DMEMIT(" writeback_jobs %u", wc->max_writeback_jobs);
 		if (wc->autocommit_blocks_set)
 			DMEMIT(" autocommit_blocks %u", wc->autocommit_blocks);
 		if (wc->autocommit_time_set)
-			DMEMIT(" autocommit_time %u", jiffies_to_msecs(wc->autocommit_jiffies));
-		if (wc->max_age != MAX_AGE_UNSPECIFIED)
-			DMEMIT(" max_age %u", jiffies_to_msecs(wc->max_age));
-		if (wc->cleaner)
+			DMEMIT(" autocommit_time %u", wc->autocommit_time_value);
+		if (wc->max_age_set)
+			DMEMIT(" max_age %u", wc->max_age_value);
+		if (wc->cleaner_set)
 			DMEMIT(" cleaner");
 		if (wc->writeback_fua_set)
 			DMEMIT(" %sfua", wc->writeback_fua ? "" : "no");
@@ -2519,7 +2525,7 @@ static void writecache_status(struct dm_
 
 static struct target_type writecache_target = {
 	.name			= "writecache",
-	.version		= {1, 3, 0},
+	.version		= {1, 4, 0},
 	.module			= THIS_MODULE,
 	.ctr			= writecache_ctr,
 	.dtr			= writecache_dtr,


