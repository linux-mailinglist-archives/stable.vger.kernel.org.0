Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D99B37CDF5
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343763AbhELQ7Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:59:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:36542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243924AbhELQmO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39D8861C44;
        Wed, 12 May 2021 16:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835703;
        bh=qo5X3bvPHRaDyQ+A7wmJAJJO2KAhPLn2mnm/HJqmc/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZwTXp3baxXsYv8yTm8Y3YqGV1c3zR20kbnmfvXqM5BlCk0gp8JkYT27a7hGx/3mC3
         fGIdbTggpnoZPfueNSUJrF1WgH8NG2SkzOOHuouZnxAoEOLkiox3ORyQWHmjwG6JE2
         sPDkO4UH1U+cngQZ+v+ot+c47jbTvR39ZNSic3WA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 416/677] scsi: hisi_sas: Fix IRQ checks
Date:   Wed, 12 May 2021 16:47:42 +0200
Message-Id: <20210512144851.161610524@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
index 7451377c4cb6..3e359ac752fd 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1646,7 +1646,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 		idx = i * HISI_SAS_PHY_INT_NR;
 		for (j = 0; j < HISI_SAS_PHY_INT_NR; j++, idx++) {
 			irq = platform_get_irq(pdev, idx);
-			if (!irq) {
+			if (irq < 0) {
 				dev_err(dev, "irq init: fail map phy interrupt %d\n",
 					idx);
 				return -ENOENT;
@@ -1665,7 +1665,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 	idx = hisi_hba->n_phy * HISI_SAS_PHY_INT_NR;
 	for (i = 0; i < hisi_hba->queue_count; i++, idx++) {
 		irq = platform_get_irq(pdev, idx);
-		if (!irq) {
+		if (irq < 0) {
 			dev_err(dev, "irq init: could not map cq interrupt %d\n",
 				idx);
 			return -ENOENT;
@@ -1683,7 +1683,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
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



