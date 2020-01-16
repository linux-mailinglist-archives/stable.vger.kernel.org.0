Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F149B13EF05
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391503AbgAPSMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:12:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:52038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405273AbgAPRhC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:37:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30828246B1;
        Thu, 16 Jan 2020 17:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196221;
        bh=i1qTzur8YcUSERvtHXzpybCkUfKo3U7F9mpu+IiXhf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=No93k2sx3Uq8TOTYGxIaCFpTWtYK6Ih5nyIrfviHMgoAxDiAfS5EYBpTlzUSyUyqR
         Ah+3HqCWauc5ODGPYh5H7IqriSYOTgh5bxAh1sCUiplQS1IqV/mbPB19c0Yb2sM1BR
         PdMRRFly/pWL9/tg0mGHTYU2tYmDjilnA4N9Oxj4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.9 056/251] staging: most: cdev: add missing check for cdev_add failure
Date:   Thu, 16 Jan 2020 12:33:25 -0500
Message-Id: <20200116173641.22137-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 5ae890780e1b4d08f2c0c5d4ea96fc3928fc0ee9 ]

Currently the call to cdev_add is missing a check for failure. Fix this by
checking for failure and exiting via a new error path that ensures the
allocated comp_channel struct is kfree'd.

Detected by CoverityScan, CID#1462359 ("Unchecked return value")

Fixes: 9bc79bbcd0c5 ("Staging: most: add MOST driver's aim-cdev module")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/most/aim-cdev/cdev.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/most/aim-cdev/cdev.c b/drivers/staging/most/aim-cdev/cdev.c
index 7f51024dc5eb..e87b9ed4f37d 100644
--- a/drivers/staging/most/aim-cdev/cdev.c
+++ b/drivers/staging/most/aim-cdev/cdev.c
@@ -451,7 +451,9 @@ static int aim_probe(struct most_interface *iface, int channel_id,
 	c->devno = MKDEV(major, current_minor);
 	cdev_init(&c->cdev, &channel_fops);
 	c->cdev.owner = THIS_MODULE;
-	cdev_add(&c->cdev, c->devno, 1);
+	retval = cdev_add(&c->cdev, c->devno, 1);
+	if (retval < 0)
+		goto err_free_c;
 	c->iface = iface;
 	c->cfg = cfg;
 	c->channel_id = channel_id;
@@ -487,6 +489,7 @@ static int aim_probe(struct most_interface *iface, int channel_id,
 	list_del(&c->list);
 error_alloc_kfifo:
 	cdev_del(&c->cdev);
+err_free_c:
 	kfree(c);
 error_alloc_channel:
 	ida_simple_remove(&minor_id, current_minor);
-- 
2.20.1

