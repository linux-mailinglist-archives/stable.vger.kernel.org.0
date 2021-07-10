Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 761C63C30A3
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235168AbhGJCgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:36:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235756AbhGJCfD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:35:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82C8E613E6;
        Sat, 10 Jul 2021 02:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884338;
        bh=FouFDJmTwQE7solqH69bOIMe0yKX0MOK+I9G50PhMqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lYeYOLeKTdtAk0Cb8j9xSdl3PX4D+P/OEQHztIq1ajMlP5Q6sxojZMTGxQbVM9u6T
         S5EA0oTO3f0vwnHGMWkYUCyiXvNuxYk6/EiyHNmW0hGB+4prAwq7yOTx7iNYN1x5BP
         SGiv/UhGcNJMh90W8Gs3Uy9q5c3VhVzdPAyC4Qz9roZLV6OoSOQl2eKQDZCm5/7Y4a
         ohrMb/7QS+yzBljUQ9bdzko2CCLsSDMOVxBtIBgZCr4m69XpnmqDb8Xn4UvNzYMxZe
         LJw3nuRG5i+U4vjnUyy7ncsyRop1imBol+SOvTV8gixGaeNkfn+auD1vu2yg0l1CJw
         WQEyYeSYpoxLw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 11/39] scsi: scsi_dh_alua: Check for negative result value
Date:   Fri,  9 Jul 2021 22:31:36 -0400
Message-Id: <20210710023204.3171428-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023204.3171428-1-sashal@kernel.org>
References: <20210710023204.3171428-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 7e26e3ea028740f934477ec01ba586ab033c35aa ]

scsi_execute() will now return a negative error if there was an error prior
to command submission; evaluate that instead if checking for DRIVER_ERROR.

[mkp: build fix]

Link: https://lore.kernel.org/r/20210427083046.31620-6-hare@suse.de
Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index efd2b4312528..41e8c9e68878 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -562,12 +562,12 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 			kfree(buff);
 			return SCSI_DH_OK;
 		}
-		if (!scsi_sense_valid(&sense_hdr)) {
+		if (retval < 0 || !scsi_sense_valid(&sense_hdr)) {
 			sdev_printk(KERN_INFO, sdev,
 				    "%s: rtpg failed, result %d\n",
 				    ALUA_DH_NAME, retval);
 			kfree(buff);
-			if (driver_byte(retval) == DRIVER_ERROR)
+			if (retval < 0)
 				return SCSI_DH_DEV_TEMP_BUSY;
 			return SCSI_DH_IO;
 		}
@@ -789,11 +789,11 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	retval = submit_stpg(sdev, pg->group_id, &sense_hdr);
 
 	if (retval) {
-		if (!scsi_sense_valid(&sense_hdr)) {
+		if (retval < 0 || !scsi_sense_valid(&sense_hdr)) {
 			sdev_printk(KERN_INFO, sdev,
 				    "%s: stpg failed, result %d",
 				    ALUA_DH_NAME, retval);
-			if (driver_byte(retval) == DRIVER_ERROR)
+			if (retval < 0)
 				return SCSI_DH_DEV_TEMP_BUSY;
 		} else {
 			sdev_printk(KERN_INFO, sdev, "%s: stpg failed\n",
-- 
2.30.2

