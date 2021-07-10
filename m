Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2403F3C2F27
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233733AbhGJC3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:29:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232691AbhGJC2J (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:28:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A1C661422;
        Sat, 10 Jul 2021 02:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883900;
        bh=+teWcXtYWVyK9YNcvQTLZzb1MYx+hhqYzIPdj2ggBek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NH+WbJmG+Jsxx9HWgLG2wNYy9DFI7biMr0RV3az2TKLhbIaWGgC97QFeKlL4JY6eU
         UQ/LXtnMfBlLhpIosrxU1gaLe4c7/AgrsGB3dD8KYE9BkS+qON5Fkq5iXElhMsnS6a
         TGAnlP3SytFDKuUajeiFblAX3PeRrouVVxfEO7vg0wF40P0ceZfqqtmAdoDtNKYAlt
         NS2vI5AUcrjwF1Rae5kD9zuuJS67q/WcA7O51StEyw7gq7VyyRH9T/hlxfz1uL0thP
         zrGXBGlB6m7kv2yLNjjKhH9lL8upAK0Z/9GsB5jSNKZCoKfR//AaGi5vpCDYHCCN9A
         xPM0i1GQwONaQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 24/93] scsi: hisi_sas: Propagate errors in interrupt_init_v1_hw()
Date:   Fri,  9 Jul 2021 22:23:18 -0400
Message-Id: <20210710022428.3169839-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022428.3169839-1-sashal@kernel.org>
References: <20210710022428.3169839-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit ab17122e758ef68fb21033e25c041144067975f5 ]

After commit 6c11dc060427 ("scsi: hisi_sas: Fix IRQ checks") we have the
error codes returned by platform_get_irq() ready for the propagation
upsream in interrupt_init_v1_hw() -- that will fix still broken deferred
probing. Let's propagate the error codes from devm_request_irq() as well
since I don't see the reason to override them with -ENOENT...

Link: https://lore.kernel.org/r/49ba93a3-d427-7542-d85a-b74fe1a33a73@omp.ru
Acked-by: John Garry <john.garry@huawei.com>
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 6c2a97f80b12..2e529d67de73 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1647,7 +1647,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 			if (irq < 0) {
 				dev_err(dev, "irq init: fail map phy interrupt %d\n",
 					idx);
-				return -ENOENT;
+				return irq;
 			}
 
 			rc = devm_request_irq(dev, irq, phy_interrupts[j], 0,
@@ -1655,7 +1655,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 			if (rc) {
 				dev_err(dev, "irq init: could not request phy interrupt %d, rc=%d\n",
 					irq, rc);
-				return -ENOENT;
+				return rc;
 			}
 		}
 	}
@@ -1666,7 +1666,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 		if (irq < 0) {
 			dev_err(dev, "irq init: could not map cq interrupt %d\n",
 				idx);
-			return -ENOENT;
+			return irq;
 		}
 
 		rc = devm_request_irq(dev, irq, cq_interrupt_v1_hw, 0,
@@ -1674,7 +1674,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 		if (rc) {
 			dev_err(dev, "irq init: could not request cq interrupt %d, rc=%d\n",
 				irq, rc);
-			return -ENOENT;
+			return rc;
 		}
 	}
 
@@ -1684,7 +1684,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 		if (irq < 0) {
 			dev_err(dev, "irq init: could not map fatal interrupt %d\n",
 				idx);
-			return -ENOENT;
+			return irq;
 		}
 
 		rc = devm_request_irq(dev, irq, fatal_interrupts[i], 0,
@@ -1692,7 +1692,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 		if (rc) {
 			dev_err(dev, "irq init: could not request fatal interrupt %d, rc=%d\n",
 				irq, rc);
-			return -ENOENT;
+			return rc;
 		}
 	}
 
-- 
2.30.2

