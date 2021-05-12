Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBFE37C21C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbhELPGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:06:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233413AbhELPFT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:05:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D86761943;
        Wed, 12 May 2021 15:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831621;
        bh=bH4rxIyTt8CUSlqp9N2Z7xTxp7tpOIClk0r2NOyL8X4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y1Gsl4tRLT1McQp5n/rDckK2/JTMQhgapwHoyM3KvreIPOfn5NEGMvC2Ov67ulsEQ
         dCJ0D+bEZ8k8Kc3nnLYEs70j6dPYBFsnaoXxf/JNIfnwbPTWlF2OcPIRaB9Z+1QUeX
         3GtfSfMxqo8nyQiIKDuJMwu8x6SMjE081/CxFbgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 159/244] scsi: hisi_sas: Fix IRQ checks
Date:   Wed, 12 May 2021 16:48:50 +0200
Message-Id: <20210512144748.088936296@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omprussia.ru>

[ Upstream commit 6c11dc060427e07ca144eacaccd696106b361b06 ]

Commit df2d8213d9e3 ("hisi_sas: use platform_get_irq()") failed to take
into account that irq_of_parse_and_map() and platform_get_irq() have a
different way of indicating an error: the former returns 0 and the latter
returns a negative error code. Fix up the IRQ checks!

Link: https://lore.kernel.org/r/810f26d3-908b-1d6b-dc5c-40019726baca@omprussia.ru
Fixes: df2d8213d9e3 ("hisi_sas: use platform_get_irq()")
Acked-by: John Garry <john.garry@huawei.com>
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index b861a0f14c9d..3364ae0b9bfe 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1645,7 +1645,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 		idx = i * HISI_SAS_PHY_INT_NR;
 		for (j = 0; j < HISI_SAS_PHY_INT_NR; j++, idx++) {
 			irq = platform_get_irq(pdev, idx);
-			if (!irq) {
+			if (irq < 0) {
 				dev_err(dev, "irq init: fail map phy interrupt %d\n",
 					idx);
 				return -ENOENT;
@@ -1664,7 +1664,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 	idx = hisi_hba->n_phy * HISI_SAS_PHY_INT_NR;
 	for (i = 0; i < hisi_hba->queue_count; i++, idx++) {
 		irq = platform_get_irq(pdev, idx);
-		if (!irq) {
+		if (irq < 0) {
 			dev_err(dev, "irq init: could not map cq interrupt %d\n",
 				idx);
 			return -ENOENT;
@@ -1682,7 +1682,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 	idx = (hisi_hba->n_phy * HISI_SAS_PHY_INT_NR) + hisi_hba->queue_count;
 	for (i = 0; i < HISI_SAS_FATAL_INT_NR; i++, idx++) {
 		irq = platform_get_irq(pdev, idx);
-		if (!irq) {
+		if (irq < 0) {
 			dev_err(dev, "irq init: could not map fatal interrupt %d\n",
 				idx);
 			return -ENOENT;
-- 
2.30.2



