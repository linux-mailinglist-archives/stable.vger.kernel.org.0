Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F35F412B6E8
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728768AbfL0RpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:45:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:44016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728139AbfL0RpY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:45:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 363C521D7E;
        Fri, 27 Dec 2019 17:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468723;
        bh=voZJ6+sHQ+7u32dzQueGKsDn3hu12ZM7e5NFUxeERmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XmX5C18QsZKkEpgY16u5EAVOLmNdDeTO8zXSL/AmrKWcoA22b4p/DKaTgcZ7DAask
         hOoZsSiliuO00wrg52QykXeexAaNkUe5c7LI36bdLD5Kw0i2KcTJ09rt3/Wo340Q8R
         YpNZBKi5v1GxHv5Jj9d7NPo2fplOz+WSu9xvTSNE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 76/84] s390/dasd/cio: Interpret ccw_device_get_mdc return value correctly
Date:   Fri, 27 Dec 2019 12:43:44 -0500
Message-Id: <20191227174352.6264-76-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174352.6264-1-sashal@kernel.org>
References: <20191227174352.6264-1-sashal@kernel.org>
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
index f89f9d02e788..108fb1c77e1d 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -1135,7 +1135,8 @@ static u32 get_fcx_max_data(struct dasd_device *device)
 {
 	struct dasd_eckd_private *private = device->private;
 	int fcx_in_css, fcx_in_gneq, fcx_in_features;
-	int tpm, mdc;
+	unsigned int mdc;
+	int tpm;
 
 	if (dasd_nofcx)
 		return 0;
@@ -1149,7 +1150,7 @@ static u32 get_fcx_max_data(struct dasd_device *device)
 		return 0;
 
 	mdc = ccw_device_get_mdc(device->cdev, 0);
-	if (mdc < 0) {
+	if (mdc == 0) {
 		dev_warn(&device->cdev->dev, "Detecting the maximum supported data size for zHPF requests failed\n");
 		return 0;
 	} else {
@@ -1160,12 +1161,12 @@ static u32 get_fcx_max_data(struct dasd_device *device)
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
index 4435ae0b3027..f0cae1973f78 100644
--- a/drivers/s390/cio/device_ops.c
+++ b/drivers/s390/cio/device_ops.c
@@ -624,7 +624,7 @@ EXPORT_SYMBOL(ccw_device_tm_start_timeout);
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

