Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 058A03D5F1A
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235954AbhGZPQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:16:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236586AbhGZPLl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:11:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C977260F9C;
        Mon, 26 Jul 2021 15:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314730;
        bh=EkoMMuTipOoCFQC/h6KPdyVXRRRFIht8QMMkIgK9hmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I0G60GPIzxRcOJj0qobBI1w8sICPoaN/QZJRzTX8p8B/zR9COsy5fpljY6IpNcR9t
         WLnrz6qyRXHk2EfZ4jxjs6T1f65Zm0WytH3/kZASvvyYchjCSHlAPKy+HrFCXfGm3J
         2tNM83qjoLkOvaNsOHjkpApU04NZJQHdwP0ebVJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.19 035/120] dm writecache: return the exact table values that were set
Date:   Mon, 26 Jul 2021 17:38:07 +0200
Message-Id: <20210726153833.516482781@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
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
 drivers/md/dm-writecache.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -153,6 +153,7 @@ struct dm_writecache {
 	bool overwrote_committed:1;
 	bool memory_vmapped:1;
 
+	bool start_sector_set:1;
 	bool high_wm_percent_set:1;
 	bool low_wm_percent_set:1;
 	bool max_writeback_jobs_set:1;
@@ -161,6 +162,10 @@ struct dm_writecache {
 	bool writeback_fua_set:1;
 	bool flush_on_suspend:1;
 
+	unsigned high_wm_percent_value;
+	unsigned low_wm_percent_value;
+	unsigned autocommit_time_value;
+
 	unsigned writeback_all;
 	struct workqueue_struct *writeback_wq;
 	struct work_struct writeback_work;
@@ -2045,6 +2050,7 @@ static int writecache_ctr(struct dm_targ
 			if (sscanf(string, "%llu%c", &start_sector, &dummy) != 1)
 				goto invalid_optional;
 			wc->start_sector = start_sector;
+			wc->start_sector_set = true;
 			if (wc->start_sector != start_sector ||
 			    wc->start_sector >= wc->memory_map_size >> SECTOR_SHIFT)
 				goto invalid_optional;
@@ -2054,6 +2060,7 @@ static int writecache_ctr(struct dm_targ
 				goto invalid_optional;
 			if (high_wm_percent < 0 || high_wm_percent > 100)
 				goto invalid_optional;
+			wc->high_wm_percent_value = high_wm_percent;
 			wc->high_wm_percent_set = true;
 		} else if (!strcasecmp(string, "low_watermark") && opt_params >= 1) {
 			string = dm_shift_arg(&as), opt_params--;
@@ -2061,6 +2068,7 @@ static int writecache_ctr(struct dm_targ
 				goto invalid_optional;
 			if (low_wm_percent < 0 || low_wm_percent > 100)
 				goto invalid_optional;
+			wc->low_wm_percent_value = low_wm_percent;
 			wc->low_wm_percent_set = true;
 		} else if (!strcasecmp(string, "writeback_jobs") && opt_params >= 1) {
 			string = dm_shift_arg(&as), opt_params--;
@@ -2080,6 +2088,7 @@ static int writecache_ctr(struct dm_targ
 			if (autocommit_msecs > 3600000)
 				goto invalid_optional;
 			wc->autocommit_jiffies = msecs_to_jiffies(autocommit_msecs);
+			wc->autocommit_time_value = autocommit_msecs;
 			wc->autocommit_time_set = true;
 		} else if (!strcasecmp(string, "fua")) {
 			if (WC_MODE_PMEM(wc)) {
@@ -2275,7 +2284,6 @@ static void writecache_status(struct dm_
 	struct dm_writecache *wc = ti->private;
 	unsigned extra_args;
 	unsigned sz = 0;
-	uint64_t x;
 
 	switch (type) {
 	case STATUSTYPE_INFO:
@@ -2287,7 +2295,7 @@ static void writecache_status(struct dm_
 		DMEMIT("%c %s %s %u ", WC_MODE_PMEM(wc) ? 'p' : 's',
 				wc->dev->name, wc->ssd_dev->name, wc->block_size);
 		extra_args = 0;
-		if (wc->start_sector)
+		if (wc->start_sector_set)
 			extra_args += 2;
 		if (wc->high_wm_percent_set)
 			extra_args += 2;
@@ -2303,26 +2311,18 @@ static void writecache_status(struct dm_
 			extra_args++;
 
 		DMEMIT("%u", extra_args);
-		if (wc->start_sector)
+		if (wc->start_sector_set)
 			DMEMIT(" start_sector %llu", (unsigned long long)wc->start_sector);
-		if (wc->high_wm_percent_set) {
-			x = (uint64_t)wc->freelist_high_watermark * 100;
-			x += wc->n_blocks / 2;
-			do_div(x, (size_t)wc->n_blocks);
-			DMEMIT(" high_watermark %u", 100 - (unsigned)x);
-		}
-		if (wc->low_wm_percent_set) {
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
+			DMEMIT(" autocommit_time %u", wc->autocommit_time_value);
 		if (wc->writeback_fua_set)
 			DMEMIT(" %sfua", wc->writeback_fua ? "" : "no");
 		break;


