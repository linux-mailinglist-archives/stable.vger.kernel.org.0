Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82593FF30C
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728551AbfKPPnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:43:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:46892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728547AbfKPPnB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:43:01 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC3C92075B;
        Sat, 16 Nov 2019 15:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918981;
        bh=RhEQdIRWLTuBSUEAgYQ268wy45fY4RTZSKHNk1bT7B8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M0maQnGZUFuKgwgs3Tqt0qV1c8IPS6o9JPidNCtd1m5OZNhNnmPnou/2dWTjNFECh
         C4fhnkJsI9nXTQUNobuXf2UbB2nbuPLxJh1v7DGs9LslqY6GixitVP+ohhrrLvdgy6
         QaogoqDc5KvQUbqPb9PJy/H3gZrCf6duEITBEtP8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 090/237] scsi: hisi_sas: Fix NULL pointer dereference
Date:   Sat, 16 Nov 2019 10:38:45 -0500
Message-Id: <20191116154113.7417-90-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

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

