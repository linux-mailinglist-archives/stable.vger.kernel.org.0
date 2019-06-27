Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A15BC57787
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728994AbfF0AjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:39:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728992AbfF0Ai7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:38:59 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C59C5217F9;
        Thu, 27 Jun 2019 00:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595938;
        bh=PUaeXSgtWZvmx8CAp+lBU9kRZAMQL1MOJ0W+0PuGnm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rNsxru7T8dgjBDyYlQaaDOZtvIj6h4G/insK5jycB5e0l1ep5UwptZWytsWy4TxyQ
         NLs1Mik4PAyLzMPw2x95E97DRqVCKPgN4ckiPKTyhdScXeOT5fonEQ6q5+5wqHBlec
         y5ekJGUWzttsK+6e779TK39eulhPiPXvTv7h4hyA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>, linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 51/60] md: fix for divide error in status_resync
Date:   Wed, 26 Jun 2019 20:36:06 -0400
Message-Id: <20190627003616.20767-51-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003616.20767-1-sashal@kernel.org>
References: <20190627003616.20767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>

[ Upstream commit 9642fa73d073527b0cbc337cc17a47d545d82cd2 ]

Stopping external metadata arrays during resync/recovery causes
retries, loop of interrupting and starting reconstruction, until it
hit at good moment to stop completely. While these retries
curr_mark_cnt can be small- especially on HDD drives, so subtraction
result can be smaller than 0. However it is casted to uint without
checking. As a result of it the status bar in /proc/mdstat while stopping
is strange (it jumps between 0% and 99%).

The real problem occurs here after commit 72deb455b5ec ("block: remove
CONFIG_LBDAF"). Sector_div() macro has been changed, now the
divisor is casted to uint32. For db = -8 the divisior(db/32-1) becomes 0.

Check if db value can be really counted and replace these macro by
div64_u64() inline.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b924f62e2cd5..fb5d702e43b5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7625,9 +7625,9 @@ static void status_unused(struct seq_file *seq)
 static int status_resync(struct seq_file *seq, struct mddev *mddev)
 {
 	sector_t max_sectors, resync, res;
-	unsigned long dt, db;
-	sector_t rt;
-	int scale;
+	unsigned long dt, db = 0;
+	sector_t rt, curr_mark_cnt, resync_mark_cnt;
+	int scale, recovery_active;
 	unsigned int per_milli;
 
 	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) ||
@@ -7716,22 +7716,30 @@ static int status_resync(struct seq_file *seq, struct mddev *mddev)
 	 * db: blocks written from mark until now
 	 * rt: remaining time
 	 *
-	 * rt is a sector_t, so could be 32bit or 64bit.
-	 * So we divide before multiply in case it is 32bit and close
-	 * to the limit.
-	 * We scale the divisor (db) by 32 to avoid losing precision
-	 * near the end of resync when the number of remaining sectors
-	 * is close to 'db'.
-	 * We then divide rt by 32 after multiplying by db to compensate.
-	 * The '+1' avoids division by zero if db is very small.
+	 * rt is a sector_t, which is always 64bit now. We are keeping
+	 * the original algorithm, but it is not really necessary.
+	 *
+	 * Original algorithm:
+	 *   So we divide before multiply in case it is 32bit and close
+	 *   to the limit.
+	 *   We scale the divisor (db) by 32 to avoid losing precision
+	 *   near the end of resync when the number of remaining sectors
+	 *   is close to 'db'.
+	 *   We then divide rt by 32 after multiplying by db to compensate.
+	 *   The '+1' avoids division by zero if db is very small.
 	 */
 	dt = ((jiffies - mddev->resync_mark) / HZ);
 	if (!dt) dt++;
-	db = (mddev->curr_mark_cnt - atomic_read(&mddev->recovery_active))
-		- mddev->resync_mark_cnt;
+
+	curr_mark_cnt = mddev->curr_mark_cnt;
+	recovery_active = atomic_read(&mddev->recovery_active);
+	resync_mark_cnt = mddev->resync_mark_cnt;
+
+	if (curr_mark_cnt >= (recovery_active + resync_mark_cnt))
+		db = curr_mark_cnt - (recovery_active + resync_mark_cnt);
 
 	rt = max_sectors - resync;    /* number of remaining sectors */
-	sector_div(rt, db/32+1);
+	rt = div64_u64(rt, db/32+1);
 	rt *= dt;
 	rt >>= 5;
 
-- 
2.20.1

