Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC1881FE719
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387748AbgFRCi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:38:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729108AbgFRBNX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:13:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EDE821974;
        Thu, 18 Jun 2020 01:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442803;
        bh=o7HWOg7d4ZD/pc/7wRN0L2pGlvAuNr+3UrYtOB7V8MI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PD3a/+gMo6zM2CdoV4Wyl3bBxBJkYbtTsK/44iSxn09pOYu+hYRM5JnBUbUoSdreF
         GMXSlLEwdzwfrzornzEsDU48CcKTaeiuZuu1yHxE6WBqGHhw2qm6FXzPHxX2xqEW9u
         Z4UYfKxKI9E9WOaFd8845FKgeRyZDRAS1L51vID8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ye Bin <yebin10@huawei.com>, Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 243/388] scsi: core: Fix incorrect usage of shost_for_each_device
Date:   Wed, 17 Jun 2020 21:05:40 -0400
Message-Id: <20200618010805.600873-243-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit 4dea170f4fb225984b4f2f1cf0a41d485177b905 ]

shost_for_each_device(sdev, shost) \
	for ((sdev) = __scsi_iterate_devices((shost), NULL); \
	     (sdev); \
	     (sdev) = __scsi_iterate_devices((shost), (sdev)))

When terminating shost_for_each_device() iteration with break or return,
scsi_device_put() should be used to prevent stale scsi device references
from being left behind.

Link: https://lore.kernel.org/r/20200518074420.39275-1-yebin10@huawei.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Ye Bin <yebin10@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_error.c | 2 ++
 drivers/scsi/scsi_lib.c   | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 978be1602f71..927b1e641842 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1412,6 +1412,7 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 				sdev_printk(KERN_INFO, sdev,
 					    "%s: skip START_UNIT, past eh deadline\n",
 					    current->comm));
+			scsi_device_put(sdev);
 			break;
 		}
 		stu_scmd = NULL;
@@ -1478,6 +1479,7 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 				sdev_printk(KERN_INFO, sdev,
 					    "%s: skip BDR, past eh deadline\n",
 					     current->comm));
+			scsi_device_put(sdev);
 			break;
 		}
 		bdr_scmd = NULL;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 3ecdae18597d..b8b4366f1200 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2865,8 +2865,10 @@ scsi_host_unblock(struct Scsi_Host *shost, int new_state)
 
 	shost_for_each_device(sdev, shost) {
 		ret = scsi_internal_device_unblock(sdev, new_state);
-		if (ret)
+		if (ret) {
+			scsi_device_put(sdev);
 			break;
+		}
 	}
 	return ret;
 }
-- 
2.25.1

