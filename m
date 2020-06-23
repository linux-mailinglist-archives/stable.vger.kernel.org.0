Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C1120653E
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388935AbgFWUMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:12:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388932AbgFWUMG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:12:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2476E206C3;
        Tue, 23 Jun 2020 20:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943125;
        bh=ccud9H4/hh8E4BIatBOOi8yCoOoEyZ/g0FYQlkRG0p8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JTQfIUAPGG8anpPLFxUy3txsC3b9UPoHY7S0sD0d+5l7BiiQdBs3thDOChVuxMNcx
         OtlXxe5wJ09Scm3meJvnXPj0Cl3HYFPR/lhN26OFnqoR9Dhxr3sgpuhyCkIRYWldKH
         xUQBy80knGlr9xG800OBXcKYPCf7qaJ3HFI6Jwsc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Ye Bin <yebin10@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 239/477] scsi: core: Fix incorrect usage of shost_for_each_device
Date:   Tue, 23 Jun 2020 21:53:56 +0200
Message-Id: <20200623195418.873715887@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 978be1602f718..927b1e6418423 100644
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
index 3ecdae18597d1..b8b4366f12001 100644
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



