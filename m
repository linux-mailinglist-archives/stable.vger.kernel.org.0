Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D15837C97C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235365AbhELQTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:19:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235572AbhELQLQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:11:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6ECDA61D47;
        Wed, 12 May 2021 15:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834039;
        bh=crKN/7yfo80lWtaZ+YDCa6FqTTqNAX6wJ+BANczlvUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=05+jUBbTNxlCzbBkFMcXX8x1sbSgofBzCEgLPiBaIiMpCz+Z6Ma4fSdyzpeMhhlPx
         weYODuBGJyFTFAJ+f8vzevj6znO8nJnF/8jNL305hpSF1aDo+V82eBql4xH6zYuO6K
         W3d5l3+y5NoO2wHlRVacVPtlklWK4fdgcfZDvSk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 368/601] scsi: hisi_sas: Fix IRQ checks
Date:   Wed, 12 May 2021 16:47:25 +0200
Message-Id: <20210512144839.918918721@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
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
index 22eecc89d41b..6c2a97f80b12 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1644,7 +1644,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 		idx = i * HISI_SAS_PHY_INT_NR;
 		for (j = 0; j < HISI_SAS_PHY_INT_NR; j++, idx++) {
 			irq = platform_get_irq(pdev, idx);
-			if (!irq) {
+			if (irq < 0) {
 				dev_err(dev, "irq init: fail map phy interrupt %d\n",
 					idx);
 				return -ENOENT;
@@ -1663,7 +1663,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 	idx = hisi_hba->n_phy * HISI_SAS_PHY_INT_NR;
 	for (i = 0; i < hisi_hba->queue_count; i++, idx++) {
 		irq = platform_get_irq(pdev, idx);
-		if (!irq) {
+		if (irq < 0) {
 			dev_err(dev, "irq init: could not map cq interrupt %d\n",
 				idx);
 			return -ENOENT;
@@ -1681,7 +1681,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
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



