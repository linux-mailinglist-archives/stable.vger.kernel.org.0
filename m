Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0827027C9AF
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732129AbgI2MMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:12:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730132AbgI2Lha (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FC9223B86;
        Tue, 29 Sep 2020 11:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379282;
        bh=PzlK0HBiFlBK/3Hr007gMmGV63GgteLeTbEInXiXkok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1hbr0XeR+kGW2VvAWgmFSNZ9LmwIMNqY06K+78S/4xkUBdaz5mnkB/yQ43r418QYv
         EVpT2ADok1KsQo78m9c8DLmOfJXP4C+Z2Y9bE7YBgw5u57RUlTbLLusNd0dWj53cYf
         Qf4WPyzCt263Z+df3JxSFHr7MLd9EJyh+CVqFZ0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        peter chang <dpf@google.com>,
        Deepak Ukey <deepak.ukey@microchip.com>,
        Viswas G <Viswas.G@microchip.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 054/388] scsi: pm80xx: Cleanup command when a reset times out
Date:   Tue, 29 Sep 2020 12:56:25 +0200
Message-Id: <20200929110013.109323596@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 027bf5b2981b9..36f5bab09f73e 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -1202,8 +1202,8 @@ int pm8001_abort_task(struct sas_task *task)
 	pm8001_dev = dev->lldd_dev;
 	pm8001_ha = pm8001_find_ha_by_dev(dev);
 	phy_id = pm8001_dev->attached_phy;
-	rc = pm8001_find_tag(task, &tag);
-	if (rc == 0) {
+	ret = pm8001_find_tag(task, &tag);
+	if (ret == 0) {
 		pm8001_printk("no tag for task:%p\n", task);
 		return TMF_RESP_FUNC_FAILED;
 	}
@@ -1241,26 +1241,50 @@ int pm8001_abort_task(struct sas_task *task)
 
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



