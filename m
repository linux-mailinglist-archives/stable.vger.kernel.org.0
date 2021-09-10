Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26BFC406394
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbhIJAsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:48:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234799AbhIJAYY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:24:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 364F8604DC;
        Fri, 10 Sep 2021 00:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233393;
        bh=CDjcuYBsv/7WluQ8K/Q+t8LWlfPmHZKeC6pERcY8H3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=silQ4MXD7K57SJeJwxGrHQfireD4TpOtSIS083NyHq+yt4QUkrZQJuW8b72jbawBw
         iiSYfA+l56duu41rF9aiOuxSetKDrxmMdSPAd4YI7M0m3LdqAmffaqkWnOtSskVFNp
         Yso7D/yYhO5Fy7s8WDSYpnL7qJuDBv+WLXIPMUuPa+I+OjaHOFNWKxkjb8z0jtyVtf
         izPFex3ATgLLUTJvfez19kEW0K0qnHxE0SatvlYH/ecAhd8fIEdpTvvF19qfu4vl/5
         fLEorMpdJwTxeYumODpSH0i3rYlho3n5ygHwfRSNEBm0MWROeaLsYuxV/6YVbdAL6H
         6wjIBo029wRSQ==
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
Subject: [PATCH AUTOSEL 4.14 02/19] scsi: smartpqi: Fix ISR accessing uninitialized data
Date:   Thu,  9 Sep 2021 20:22:52 -0400
Message-Id: <20210910002309.176412-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002309.176412-1-sashal@kernel.org>
References: <20210910002309.176412-1-sashal@kernel.org>
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
index 4055753b495a..cf76f389943d 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6218,11 +6218,11 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 
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

