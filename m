Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA9415AF6
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbfEGFuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:50:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729042AbfEGFkN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:40:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D38E214AE;
        Tue,  7 May 2019 05:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207612;
        bh=0lXt05TCRZdQkuVRMf8JxGKjSOx8H7tZZ4rq+/yUapg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M15DwTnazETUyojdPwDWNKfgfFiSJStb1YFGtXqCjehpDYxEEGfQXmwQcZLX/oAg2
         8mUmyUiuWxZb9xCpYGA3p6rfTqlszRxcONeRDYCMAiaWrOHVsQntJpWpmyfgyUK6XF
         mUD1k0QBa3MyuW7peoSALDhUOMUSWvbUl12XCj2s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <alexander.levin@microsoft.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 56/95] scsi: raid_attrs: fix unused variable warning
Date:   Tue,  7 May 2019 01:37:45 -0400
Message-Id: <20190507053826.31622-56-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 0eeec01488da9b1403c8c29e73eacac8af9e4bf2 ]

I ran into a new warning on randconfig kernels:

drivers/scsi/raid_class.c: In function 'raid_match':
drivers/scsi/raid_class.c:64:24: error: unused variable 'i' [-Werror=unused-variable]

This looks like a very old problem that for some reason was very hard to
run into, but it is very easy to fix, by replacing the incorrect #ifdef
with a simpler IS_ENABLED() check.

Fixes: fac829fdcaf4 ("[SCSI] raid_attrs: fix dependency problems")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/scsi/raid_class.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/raid_class.c b/drivers/scsi/raid_class.c
index 2c146b44d95f..cddd78893b46 100644
--- a/drivers/scsi/raid_class.c
+++ b/drivers/scsi/raid_class.c
@@ -63,8 +63,7 @@ static int raid_match(struct attribute_container *cont, struct device *dev)
 	 * emulated RAID devices, so start with SCSI */
 	struct raid_internal *i = ac_to_raid_internal(cont);
 
-#if defined(CONFIG_SCSI) || defined(CONFIG_SCSI_MODULE)
-	if (scsi_is_sdev_device(dev)) {
+	if (IS_ENABLED(CONFIG_SCSI) && scsi_is_sdev_device(dev)) {
 		struct scsi_device *sdev = to_scsi_device(dev);
 
 		if (i->f->cookie != sdev->host->hostt)
@@ -72,7 +71,6 @@ static int raid_match(struct attribute_container *cont, struct device *dev)
 
 		return i->f->is_raid(dev);
 	}
-#endif
 	/* FIXME: look at other subsystems too */
 	return 0;
 }
-- 
2.20.1

