Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9483326F148
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbgIRCIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:08:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728121AbgIRCIp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:08:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E132238E3;
        Fri, 18 Sep 2020 02:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394925;
        bh=d442ZhHPDdPHlZqNpFJfccLZZ5YF1Nb4w9dAD8eMODc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fdW1NSw77DCnh+iK74TXT0zBF3wNEAlGSOGFha5jJxggHZ5kQwEDG2RomCotRQPoV
         O3+umpS/SiXVeUZ0BLdRz6L+BkB+2xx77dmlviqL0zyufxzlbCPVXiwaakE2IOJVrC
         TWudFwz3h0F1Yq0SM++hsZMjo2fz+FJzxI2WfDP0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     peter chang <dpf@google.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Deepak Ukey <deepak.ukey@microchip.com>,
        Viswas G <Viswas.G@microchip.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, pmchba@pmcs.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 036/206] scsi: pm80xx: Cleanup command when a reset times out
Date:   Thu, 17 Sep 2020 22:05:12 -0400
Message-Id: <20200918020802.2065198-36-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: peter chang <dpf@google.com>

[ Upstream commit 51c1c5f6ed64c2b65a8cf89dac136273d25ca540 ]

Added the fix so the if driver properly sent the abort it tries to remove
it from the firmware's list of outstanding commands regardless of the abort
status. This means that the task gets freed 'now' rather than possibly
getting freed later when the scsi layer thinks it's leaked but still valid.

Link: https://lore.kernel.org/r/20191114100910.6153-10-deepak.ukey@microchip.com
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: peter chang <dpf@google.com>
Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_sas.c | 50 +++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 5be4212312cb0..49cf2b65de223 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -1184,8 +1184,8 @@ int pm8001_abort_task(struct sas_task *task)
 	pm8001_ha = pm8001_find_ha_by_dev(dev);
 	device_id = pm8001_dev->device_id;
 	phy_id = pm8001_dev->attached_phy;
-	rc = pm8001_find_tag(task, &tag);
-	if (rc == 0) {
+	ret = pm8001_find_tag(task, &tag);
+	if (ret == 0) {
 		pm8001_printk("no tag for task:%p\n", task);
 		return TMF_RESP_FUNC_FAILED;
 	}
@@ -1223,26 +1223,50 @@ int pm8001_abort_task(struct sas_task *task)
 
 			/* 2. Send Phy Control Hard Reset */
 			reinit_completion(&completion);
+			phy->port_reset_status = PORT_RESET_TMO;
 			phy->reset_success = false;
 			phy->enable_completion = &completion;
 			phy->reset_completion = &completion_reset;
 			ret = PM8001_CHIP_DISP->phy_ctl_req(pm8001_ha, phy_id,
 				PHY_HARD_RESET);
-			if (ret)
-				goto out;
-			PM8001_MSG_DBG(pm8001_ha,
-				pm8001_printk("Waiting for local phy ctl\n"));
-			wait_for_completion(&completion);
-			if (!phy->reset_success)
+			if (ret) {
+				phy->enable_completion = NULL;
+				phy->reset_completion = NULL;
 				goto out;
+			}
 
-			/* 3. Wait for Port Reset complete / Port reset TMO */
+			/* In the case of the reset timeout/fail we still
+			 * abort the command at the firmware. The assumption
+			 * here is that the drive is off doing something so
+			 * that it's not processing requests, and we want to
+			 * avoid getting a completion for this and either
+			 * leaking the task in libsas or losing the race and
+			 * getting a double free.
+			 */
 			PM8001_MSG_DBG(pm8001_ha,
+				pm8001_printk("Waiting for local phy ctl\n"));
+			ret = wait_for_completion_timeout(&completion,
+					PM8001_TASK_TIMEOUT * HZ);
+			if (!ret || !phy->reset_success) {
+				phy->enable_completion = NULL;
+				phy->reset_completion = NULL;
+			} else {
+				/* 3. Wait for Port Reset complete or
+				 * Port reset TMO
+				 */
+				PM8001_MSG_DBG(pm8001_ha,
 				pm8001_printk("Waiting for Port reset\n"));
-			wait_for_completion(&completion_reset);
-			if (phy->port_reset_status) {
-				pm8001_dev_gone_notify(dev);
-				goto out;
+				ret = wait_for_completion_timeout(
+					&completion_reset,
+					PM8001_TASK_TIMEOUT * HZ);
+				if (!ret)
+					phy->reset_completion = NULL;
+				WARN_ON(phy->port_reset_status ==
+						PORT_RESET_TMO);
+				if (phy->port_reset_status == PORT_RESET_TMO) {
+					pm8001_dev_gone_notify(dev);
+					goto out;
+				}
 			}
 
 			/*
-- 
2.25.1

