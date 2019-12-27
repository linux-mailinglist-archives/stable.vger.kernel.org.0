Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A66412B946
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 19:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbfL0SDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 13:03:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:60648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728671AbfL0SDZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 13:03:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB41F20CC7;
        Fri, 27 Dec 2019 18:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577469804;
        bh=520u/bTYtujL/2/hNBt3ud192gd9V95qNeRCkgJ5klA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NTYacIVJzsn8fs0j9yqDm2oOElHJvAUVTrSLknImDdgPn2/VJ+kE1d8ieN87dpuYH
         scwrADaJxOYJY5INnGOTTAa+uDxUo2OZm47OpeYIaQdOMgrVg3yAP3G+YSWtVioCBO
         1eNmn1rpZjCO2woDRkFJlGYWgIC2ZVezhT36uUUc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Haberland <sth@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 51/57] s390/dasd: fix memleak in path handling error case
Date:   Fri, 27 Dec 2019 13:02:16 -0500
Message-Id: <20191227180222.7076-51-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227180222.7076-1-sashal@kernel.org>
References: <20191227180222.7076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Haberland <sth@linux.ibm.com>

[ Upstream commit 00b39f698a4f1ee897227cace2e3937fc4412270 ]

If for whatever reason the dasd_eckd_check_characteristics() function
exits after at least some paths have their configuration data
allocated those data is never freed again. In the error case the
device->private pointer is set to NULL and dasd_eckd_uncheck_device()
will exit without freeing the path data because of this NULL pointer.

Fix by calling dasd_eckd_clear_conf_data() for error cases.

Also use dasd_eckd_clear_conf_data() in dasd_eckd_uncheck_device()
to avoid code duplication.

Reported-by: Qian Cai <cai@lca.pw>
Reviewed-by: Jan Hoeppner <hoeppner@linux.ibm.com>
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/block/dasd_eckd.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 81359312a987..aa651403546f 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -1768,7 +1768,7 @@ dasd_eckd_check_characteristics(struct dasd_device *device)
 	dasd_free_block(device->block);
 	device->block = NULL;
 out_err1:
-	kfree(private->conf_data);
+	dasd_eckd_clear_conf_data(device);
 	kfree(device->private);
 	device->private = NULL;
 	return rc;
@@ -1777,7 +1777,6 @@ dasd_eckd_check_characteristics(struct dasd_device *device)
 static void dasd_eckd_uncheck_device(struct dasd_device *device)
 {
 	struct dasd_eckd_private *private = device->private;
-	int i;
 
 	if (!private)
 		return;
@@ -1787,21 +1786,7 @@ static void dasd_eckd_uncheck_device(struct dasd_device *device)
 	private->sneq = NULL;
 	private->vdsneq = NULL;
 	private->gneq = NULL;
-	private->conf_len = 0;
-	for (i = 0; i < 8; i++) {
-		kfree(device->path[i].conf_data);
-		if ((__u8 *)device->path[i].conf_data ==
-		    private->conf_data) {
-			private->conf_data = NULL;
-			private->conf_len = 0;
-		}
-		device->path[i].conf_data = NULL;
-		device->path[i].cssid = 0;
-		device->path[i].ssid = 0;
-		device->path[i].chpid = 0;
-	}
-	kfree(private->conf_data);
-	private->conf_data = NULL;
+	dasd_eckd_clear_conf_data(device);
 }
 
 static struct dasd_ccw_req *
-- 
2.20.1

