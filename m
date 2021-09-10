Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EAD240626E
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbhIJApu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:45:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233670AbhIJAVr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:21:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CA8561167;
        Fri, 10 Sep 2021 00:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233236;
        bh=0wd6VW1FHoDQCTCP7Ipnexg/Q5HQrr0fWXzdXUc42DE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BysapOG9lBIthLFuMDQBsO759uZnrnxHwwxLdQ0gYPcxBrT771VxzDztlT251jTyo
         5ayR3qlrflDpx9iW0IibZ7f2nq0vmrCI6JuYZHTbDT5dEGYL5XjZRLV9X1F2g00E6m
         LAKg7WjsZ45xYJABjVVVLAcYupgIxS5wMLw0ZKkJz/eSfEYHNB/LKsiwlACGdS07t7
         k22zVc3LamKjpMqYqLlsfvLVo/0jy5WP4BNo1X9m0wBOqz3XPcxWJ355tAKySFiYnn
         Cv0sTLy4MlSEvOWrAiiN3sFd1seEoEaOhOnYPnwHNbExDSg9SfnFMBu2wBH3/dUdXG
         cy5y7Q0Ha8xFw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike McGowen <mike.mcgowen@microchip.com>,
        Kevin Barnett <kevin.barnett@microchip.com>,
        Scott Benesh <scott.benesh@microchip.com>,
        Scott Teel <scott.teel@microchip.com>,
        Don Brace <don.brace@microchip.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, storagedev@microchip.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 05/53] scsi: smartpqi: Fix ISR accessing uninitialized data
Date:   Thu,  9 Sep 2021 20:19:40 -0400
Message-Id: <20210910002028.175174-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002028.175174-1-sashal@kernel.org>
References: <20210910002028.175174-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike McGowen <mike.mcgowen@microchip.com>

[ Upstream commit 0777a3fb98f0ea546561d04db4fd325248c39961 ]

Correct driver's ISR accessing a data structure member that has not been
fully initialized during driver initialization.

The pqi queue groups can have uninitialized members when an interrupt
fires. This has not resulted in any driver crashes. This was found during
our own internal testing. No bugs were ever filed.

Link: https://lore.kernel.org/r/20210714182847.50360-9-don.brace@microchip.com
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 5083e5d2b467..8d6c26e6251b 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -7284,11 +7284,11 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 
 	pqi_init_operational_queues(ctrl_info);
 
-	rc = pqi_request_irqs(ctrl_info);
+	rc = pqi_create_queues(ctrl_info);
 	if (rc)
 		return rc;
 
-	rc = pqi_create_queues(ctrl_info);
+	rc = pqi_request_irqs(ctrl_info);
 	if (rc)
 		return rc;
 
-- 
2.30.2

