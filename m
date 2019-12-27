Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F22C312B945
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 19:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbfL0SDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 13:03:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:60618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728659AbfL0SDY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 13:03:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93AC221582;
        Fri, 27 Dec 2019 18:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577469803;
        bh=15uCv88DqOg4sbjIuVZMtUhC1JnMrYLSD4Kpcggr87k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HpggWsSgIFLD5W865PYYaDwNfcF8dzY7VDmOmj8S5M6jeUX3zYirGoJ6r0QwiGYdn
         DDgeN0m8M/hGxF5oYIO1xYG0P4R5DCr8G50hYvN+ANrFr3TpjXzvN+KAW/OXcOcizp
         ETYnFq9tokA0NBxcg66eSa2SKQ2+pa/A1aOLCDg0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 50/57] s390/dasd/cio: Interpret ccw_device_get_mdc return value correctly
Date:   Fri, 27 Dec 2019 13:02:15 -0500
Message-Id: <20191227180222.7076-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227180222.7076-1-sashal@kernel.org>
References: <20191227180222.7076-1-sashal@kernel.org>
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

[ Upstream commit dd4b3c83b9efac10d48a94c61372119fc555a077 ]

The max data count (mdc) is an unsigned 16-bit integer value as per AR
documentation and is received via ccw_device_get_mdc() for a specific
path mask from the CIO layer. The function itself also always returns a
positive mdc value or 0 in case mdc isn't supported or couldn't be
determined.

Though, the comment for this function describes a negative return value
to indicate failures.

As a result, the DASD device driver interprets the return value of
ccw_device_get_mdc() incorrectly. The error case is essentially a dead
code path.

To fix this behaviour, check explicitly for a return value of 0 and
change the comment for ccw_device_get_mdc() accordingly.

This fix merely enables the error code path in the DASD functions
get_fcx_max_data() and verify_fcx_max_data(). The actual functionality
stays the same and is still correct.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Jan Höppner <hoeppner@linux.ibm.com>
Acked-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reviewed-by: Stefan Haberland <sth@linux.ibm.com>
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/block/dasd_eckd.c | 9 +++++----
 drivers/s390/cio/device_ops.c  | 2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 0d5e2d92e05b..81359312a987 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -1133,7 +1133,8 @@ static u32 get_fcx_max_data(struct dasd_device *device)
 {
 	struct dasd_eckd_private *private = device->private;
 	int fcx_in_css, fcx_in_gneq, fcx_in_features;
-	int tpm, mdc;
+	unsigned int mdc;
+	int tpm;
 
 	if (dasd_nofcx)
 		return 0;
@@ -1147,7 +1148,7 @@ static u32 get_fcx_max_data(struct dasd_device *device)
 		return 0;
 
 	mdc = ccw_device_get_mdc(device->cdev, 0);
-	if (mdc < 0) {
+	if (mdc == 0) {
 		dev_warn(&device->cdev->dev, "Detecting the maximum supported data size for zHPF requests failed\n");
 		return 0;
 	} else {
@@ -1158,12 +1159,12 @@ static u32 get_fcx_max_data(struct dasd_device *device)
 static int verify_fcx_max_data(struct dasd_device *device, __u8 lpm)
 {
 	struct dasd_eckd_private *private = device->private;
-	int mdc;
+	unsigned int mdc;
 	u32 fcx_max_data;
 
 	if (private->fcx_max_data) {
 		mdc = ccw_device_get_mdc(device->cdev, lpm);
-		if ((mdc < 0)) {
+		if (mdc == 0) {
 			dev_warn(&device->cdev->dev,
 				 "Detecting the maximum data size for zHPF "
 				 "requests failed (rc=%d) for a new path %x\n",
diff --git a/drivers/s390/cio/device_ops.c b/drivers/s390/cio/device_ops.c
index b22922ec32d1..474afec9ab87 100644
--- a/drivers/s390/cio/device_ops.c
+++ b/drivers/s390/cio/device_ops.c
@@ -595,7 +595,7 @@ EXPORT_SYMBOL(ccw_device_tm_start_timeout);
  * @mask: mask of paths to use
  *
  * Return the number of 64K-bytes blocks all paths at least support
- * for a transport command. Return values <= 0 indicate failures.
+ * for a transport command. Return value 0 indicates failure.
  */
 int ccw_device_get_mdc(struct ccw_device *cdev, u8 mask)
 {
-- 
2.20.1

