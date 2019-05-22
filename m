Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7F7926CAD
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732750AbfEVTge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:36:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733295AbfEVTao (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:30:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64C7020675;
        Wed, 22 May 2019 19:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553444;
        bh=L1mzJk8zTZ9Pm4jx7SrthqP2CFq1+CxozFOR3G6nbUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=urtqbRIpNykZIxz2CB86MbtZRFkIqXWlVahyAgs8fSpunsE1kaQkYF322qgYvRi6Z
         ZoSiLk8xfmw4qPxZTrswV+K0TBQNLm6yaxYLJf1TZ22LzQ4s0WXuyvf9LDobDbaYm6
         t5cIhD75Y4llLug7WRSDPn49OEoCzpiPhexJ21AE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Giridhar Malavali <gmalavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 015/114] scsi: qla2xxx: Fix a qla24xx_enable_msix() error path
Date:   Wed, 22 May 2019 15:28:38 -0400
Message-Id: <20190522193017.26567-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522193017.26567-1-sashal@kernel.org>
References: <20190522193017.26567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 24afabdbd0b3553963a2bbf465895492b14d1107 ]

Make sure that the allocated interrupts are freed if allocating memory for
the msix_entries array fails.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Giridhar Malavali <gmalavali@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_isr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 73c99f237b10c..f0fcff032f8ac 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3089,7 +3089,7 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 		ql_log(ql_log_fatal, vha, 0x00c8,
 		    "Failed to allocate memory for ha->msix_entries.\n");
 		ret = -ENOMEM;
-		goto msix_out;
+		goto free_irqs;
 	}
 	ha->flags.msix_enabled = 1;
 
@@ -3177,6 +3177,10 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 msix_out:
 	kfree(entries);
 	return ret;
+
+free_irqs:
+	pci_free_irq_vectors(ha->pdev);
+	goto msix_out;
 }
 
 int
-- 
2.20.1

