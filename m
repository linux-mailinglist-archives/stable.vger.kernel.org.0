Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6DF92EB82
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729533AbfE3DNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:13:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728623AbfE3DNh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:13:37 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C592B2455A;
        Thu, 30 May 2019 03:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186016;
        bh=u09o6bZ/R6++CAfLokmjezebCjIIfB4HAQkdEO2Orbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4wne45v4sM0S5+ZXi1IS6/UiBur6Iy6qq6CpXzAKv47hRo9a7o7GXOy8eFrMPXeD
         zeJlcZ1Elw7fClFKFTIeFlSzkVe9sIw/DQgnovfUUlD0tZ6RskB+VjRDK+6dHslQs6
         hysjQONv6dDsu/yU/yPAptUrU5xJlY+I5P3xI/Ds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Himanshu Madhani <hmadhani@marvell.com>,
        Giridhar Malavali <gmalavali@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 082/346] scsi: qla2xxx: Fix a qla24xx_enable_msix() error path
Date:   Wed, 29 May 2019 20:02:35 -0700
Message-Id: <20190530030545.301521695@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 1a20e5d8f0575..51df171b32ed3 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3454,7 +3454,7 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 		ql_log(ql_log_fatal, vha, 0x00c8,
 		    "Failed to allocate memory for ha->msix_entries.\n");
 		ret = -ENOMEM;
-		goto msix_out;
+		goto free_irqs;
 	}
 	ha->flags.msix_enabled = 1;
 
@@ -3537,6 +3537,10 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 
 msix_out:
 	return ret;
+
+free_irqs:
+	pci_free_irq_vectors(ha->pdev);
+	goto msix_out;
 }
 
 int
-- 
2.20.1



