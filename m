Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20CB92E122A
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbgLWCTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:19:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:46368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728709AbgLWCTj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24A8F221E5;
        Wed, 23 Dec 2020 02:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689947;
        bh=oN6i6DkJk0tmVHeJHuoWla/0hXVtAXfsO5gKAAjyamY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XO+0Cq8QgMz62DVJTy4BzXwkqeV/8lYWRna7S6I4W8DiJBqmkJt1TGf8mnbee0NXi
         XEiJF+jRc4IPPBUmzkdQyV5JwPtkZZC2cjcsZA4ErBl4J+DqBzLPHdR/vDT2NwGmo2
         hnHP7mocfLKaPP8pExkNUigRZ67HzzIxl/ntha4TffgGYBg/GUvw2zFSnvfK9+wOM0
         4AnUcpn15Qis7IoZIZRcgNfDIvjBAiyaGR12kfVO/NbX5tAni8JXkxuYxao1SYB/cC
         PEiMZ9n1oBiZNW883hzYZk1A55oQVM7Im9gm8QwmGATPxR0nDla66G5JFtc8dMOapX
         mMyZm6V3wt4pg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Don Brace <don.brace@microchip.com>,
        Scott Benesh <scott.benesh@microchip.com>,
        Scott Teel <scott.teel@microchip.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, storagedev@microchip.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 041/130] scsi: smartpqi: Correct driver removal with HBA disks
Date:   Tue, 22 Dec 2020 21:16:44 -0500
Message-Id: <20201223021813.2791612-41-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Don Brace <don.brace@microchip.com>

[ Upstream commit 1bdf6e9343877030640336d93da08321719bca43 ]

Correct rmmod hangs when using HBA disks with write cache enabled.

Do not set controller flag "in_shutdown" during rmmod. SCSI SYNCHRONIZE
CACHE(10) and SCSI SYNCHRONIZE CACHE(16) requests were blocked with
SCSI_MLQUEUE_HOST_BUSY.

Link: https://lore.kernel.org/r/160512627928.2359.10698615071827614781.stgit@brunhilda
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 093ed5d1eef20..d80cb2a6e11a2 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -330,10 +330,9 @@ static inline void pqi_device_remove_start(struct pqi_scsi_dev *device)
 	device->in_remove = true;
 }
 
-static inline bool pqi_device_in_remove(struct pqi_ctrl_info *ctrl_info,
-					struct pqi_scsi_dev *device)
+static inline bool pqi_device_in_remove(struct pqi_scsi_dev *device)
 {
-	return device->in_remove && !ctrl_info->in_shutdown;
+	return device->in_remove;
 }
 
 static inline void pqi_ctrl_shutdown_start(struct pqi_ctrl_info *ctrl_info)
@@ -5368,8 +5367,7 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost,
 
 	atomic_inc(&device->scsi_cmds_outstanding);
 
-	if (pqi_ctrl_offline(ctrl_info) || pqi_device_in_remove(ctrl_info,
-								device)) {
+	if (pqi_ctrl_offline(ctrl_info) || pqi_device_in_remove(device)) {
 		set_host_byte(scmd, DID_NO_CONNECT);
 		pqi_scsi_done(scmd);
 		return 0;
@@ -7951,8 +7949,6 @@ static void pqi_pci_remove(struct pci_dev *pci_dev)
 	if (!ctrl_info)
 		return;
 
-	ctrl_info->in_shutdown = true;
-
 	pqi_remove_ctrl(ctrl_info);
 }
 
-- 
2.27.0

