Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF9210BA0C
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731419AbfK0U7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:59:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:51080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731430AbfK0U7b (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:59:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D68821556;
        Wed, 27 Nov 2019 20:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888370;
        bh=F9nfwylI2cbFlI3Gy+RWwoya7DKdqH9GaXiRvmRpGlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PkhyTMIclWHUE5J72uEdp1OGnAXxUvL5jvGH9hRKKAGXMfgPzmY7MqT03Js5Bvq6D
         JoS/Gz3iHjIYinNg5fTNCTkb+HiWGI1e6iq2zCpnHrtzaCmCk0oW0J7TOL8x0CXaoS
         Ifejq6spqS+IROqrdBI4BMiRPM4n6tNO8KmuoNAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 109/306] scsi: hisi_sas: Fix NULL pointer dereference
Date:   Wed, 27 Nov 2019 21:29:19 +0100
Message-Id: <20191127203123.221883725@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavo@embeddedor.com>

[ Upstream commit f4445bb93d82a984657b469e63118c2794a4c3d3 ]

There is a NULL pointer dereference in case *slot* happens to be NULL at
lines 1053 and 1878:

struct hisi_sas_cq *cq =
	&hisi_hba->cq[slot->dlvry_queue];

Notice that *slot* is being NULL checked at lines 1057 and 1881:
if (slot), which implies it may be NULL.

Fix this by placing the declaration and definition of variable cq, which
contains the pointer dereference slot->dlvry_queue, after slot has been
properly NULL checked.

Addresses-Coverity-ID: 1474515 ("Dereference before null check")
Addresses-Coverity-ID: 1474520 ("Dereference before null check")
Fixes: 584f53fe5f52 ("scsi: hisi_sas: Fix the race between IO completion and timeout for SMP/internal IO")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Reviewed-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index d4a2625a44232..f478d1f50dfc0 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1025,11 +1025,11 @@ static int hisi_sas_exec_internal_tmf_task(struct domain_device *device,
 		if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
 			if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
 				struct hisi_sas_slot *slot = task->lldd_task;
-				struct hisi_sas_cq *cq =
-					&hisi_hba->cq[slot->dlvry_queue];
 
 				dev_err(dev, "abort tmf: TMF task timeout and not done\n");
 				if (slot) {
+					struct hisi_sas_cq *cq =
+					       &hisi_hba->cq[slot->dlvry_queue];
 					/*
 					 * flush tasklet to avoid free'ing task
 					 * before using task in IO completion
@@ -1856,10 +1856,10 @@ hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
 	if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
 		if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
 			struct hisi_sas_slot *slot = task->lldd_task;
-			struct hisi_sas_cq *cq =
-				&hisi_hba->cq[slot->dlvry_queue];
 
 			if (slot) {
+				struct hisi_sas_cq *cq =
+					&hisi_hba->cq[slot->dlvry_queue];
 				/*
 				 * flush tasklet to avoid free'ing task
 				 * before using task in IO completion
-- 
2.20.1



