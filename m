Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAB06DD02
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389305AbfGSEUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:20:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388967AbfGSEMs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:12:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 331BB218C3;
        Fri, 19 Jul 2019 04:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509567;
        bh=h6vyEgOAt91ilNFETqHclV73kLzKMq/VD9cGUMby9Ec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hxEeK61/y4/gBvi0J1D1FM3wHoQF637xyLa3PWW0JV9sOaevBxughrV0VXp7elIzx
         OXvIzxk9ARHuVXT2cBWfhzGTZ3UQJHxelO8YXMM0zXl3nQzi2Ws95kT17H1ME+b/Yp
         awYx1LzUwYDubZLo19J6caDsSkCSX/OTCfUyhuFE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 52/60] s390/dasd: Make layout analysis ESE compatible
Date:   Fri, 19 Jul 2019 00:11:01 -0400
Message-Id: <20190719041109.18262-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719041109.18262-1-sashal@kernel.org>
References: <20190719041109.18262-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Höppner <hoeppner@linux.ibm.com>

[ Upstream commit ce6915f5343f5f2a2a937b683d8ffbf12dab3ad4 ]

The disk layout and volume information of a DASD reside in the first two
tracks of cylinder 0. When a DASD is set online, currently the first
three tracks are read and analysed to confirm an expected layout.

For CDL (Compatible Disk Layout) only count area data of the first track
is evaluated and checked against expected key and data lengths. For LDL
(Linux Disk Layout) the first and third track is evaluated. However,
an LDL formatted volume is expected to be in the same format across all
tracks. Checking the third track therefore doesn't have any more value
than checking any other track at random.

Now, an Extent Space Efficient (ESE) DASD is initialised by only
formatting the first two tracks, as those tracks always contain all
information necessarry.

Checking the third track on an ESE volume will therefore most likely
fail with a record not found error, as the third track will be empty.
This in turn leads to the device being recognised with a volume size of
0. Attempts to write volume information on the first two tracks then
fail with "no space left on device" errors.

Initialising the first three tracks for an ESE volume is not a viable
solution, because the third track is already a regular track and could
contain user data. With that there is potential for data corruption.

Instead, always only analyse the first two tracks, as it is sufficiant
for both CDL and LDL, and allow ESE volumes to be recognised as well.

Signed-off-by: Jan Höppner <hoeppner@linux.ibm.com>
Reviewed-by: Stefan Haberland <sth@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/block/dasd_eckd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 0d5e2d92e05b..090c312eae32 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -156,7 +156,7 @@ static const int sizes_trk0[] = { 28, 148, 84 };
 #define LABEL_SIZE 140
 
 /* head and record addresses of count_area read in analysis ccw */
-static const int count_area_head[] = { 0, 0, 0, 0, 2 };
+static const int count_area_head[] = { 0, 0, 0, 0, 1 };
 static const int count_area_rec[] = { 1, 2, 3, 4, 1 };
 
 static inline unsigned int
@@ -1820,8 +1820,8 @@ dasd_eckd_analysis_ccw(struct dasd_device *device)
 	if (IS_ERR(cqr))
 		return cqr;
 	ccw = cqr->cpaddr;
-	/* Define extent for the first 3 tracks. */
-	define_extent(ccw++, cqr->data, 0, 2,
+	/* Define extent for the first 2 tracks. */
+	define_extent(ccw++, cqr->data, 0, 1,
 		      DASD_ECKD_CCW_READ_COUNT, device, 0);
 	LO_data = cqr->data + sizeof(struct DE_eckd_data);
 	/* Locate record for the first 4 records on track 0. */
@@ -1840,9 +1840,9 @@ dasd_eckd_analysis_ccw(struct dasd_device *device)
 		count_data++;
 	}
 
-	/* Locate record for the first record on track 2. */
+	/* Locate record for the first record on track 1. */
 	ccw[-1].flags |= CCW_FLAG_CC;
-	locate_record(ccw++, LO_data++, 2, 0, 1,
+	locate_record(ccw++, LO_data++, 1, 0, 1,
 		      DASD_ECKD_CCW_READ_COUNT, device, 0);
 	/* Read count ccw. */
 	ccw[-1].flags |= CCW_FLAG_CC;
@@ -1964,7 +1964,7 @@ static int dasd_eckd_end_analysis(struct dasd_block *block)
 		}
 	}
 	if (i == 3)
-		count_area = &private->count_area[4];
+		count_area = &private->count_area[3];
 
 	if (private->uses_cdl == 0) {
 		for (i = 0; i < 5; i++) {
-- 
2.20.1

