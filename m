Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673F7406319
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242344AbhIJAqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:46:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234190AbhIJAXA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:23:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 848EA60F24;
        Fri, 10 Sep 2021 00:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233310;
        bh=zE/zs8pjurMpZbAT0rpUZiaXHYIwRvJkegYn8d7RSJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PfEC84bDNihD2EuYDZThl7bY5QzrIRvK++N5DiXsrNymql+Kj/eBmlJccnin5Zer3
         REK1dpuId5x47wqwez/gTdLNe7Zxw7M2nixVbdtxY+q3zw20H/5iwjjmg1CrAurAAL
         0xj9PLUWG/x+BczNRw1gPj4SZXtoIQcOhow8/6YKNTdrYnIDViKCTwwk2gq4EVJ+CE
         ORA6KgcyGbAI6hIaxZ0Raw9eDroOQmYsv4IqbwVhiEdwNJ2DtdcpINqkqwIZgXBGgo
         /Mzjfuf25UtNl3uSGS5cdnl4wkUA4kSQIv8jrqMwce9pLweS+Ya8mRsOYyhR4z64DM
         aU63THRLR9LXQ==
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
Subject: [PATCH AUTOSEL 5.4 05/37] scsi: smartpqi: Fix ISR accessing uninitialized data
Date:   Thu,  9 Sep 2021 20:21:10 -0400
Message-Id: <20210910002143.175731-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002143.175731-1-sashal@kernel.org>
References: <20210910002143.175731-1-sashal@kernel.org>
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
index 9bc451004184..824f19475b27 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -7208,11 +7208,11 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 
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

