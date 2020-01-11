Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5A87137EA0
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729709AbgAKKMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:12:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:49738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729420AbgAKKME (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:12:04 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44D9620848;
        Sat, 11 Jan 2020 10:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737524;
        bh=520u/bTYtujL/2/hNBt3ud192gd9V95qNeRCkgJ5klA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bhs8aNcd/bGEsekOszLk+rSsC8VRfSx7LcIhtWY9jj8HHfmM6ULcwgrOrB9jr944W
         06qqwuc4vvWPCJJ3MiF0gk8jTwEcUCDmCOVWvtawytJyrQSL27QS1kPkUpoRd4j4ou
         pRe+5LpEwPW7T2wPqUN0s92TcsxBwFE99vPlR5FU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 35/62] s390/dasd: fix memleak in path handling error case
Date:   Sat, 11 Jan 2020 10:50:17 +0100
Message-Id: <20200111094846.373087715@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094837.425430968@linuxfoundation.org>
References: <20200111094837.425430968@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



