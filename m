Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55DF03C309D
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235137AbhGJCf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:35:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235691AbhGJCe7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:34:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3199461407;
        Sat, 10 Jul 2021 02:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884331;
        bh=mxqQrdLG/E9N+IMHQqsVt7/SN+k6aipg4GiStHlgieg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VYPx3+bHhpffrrBU9Uw7CeIcGMHy1alJ3gdugXV8JZwrFmZrbpo2oIXqGTeOwtUfR
         5RR0Fdzjbbh8lC+6bjMT9wHEvkNGobW54Jjv+2vubO+7ci9VI5NIsKkC+Go2CCDcVh
         LNHax8DlXvRA/MKpgNW1jHlAmYMxlPqwt1DCETdkshZKUhBLaoa6eMx8Gj52RsOXHE
         nqZUwj/99FO4dfn2qmRgOBAZ4VOOsjvYNhN/Eecd5WATbNVmPq9DMsF2S7J0XI62om
         W8I+9nZXb4FLjVysHBgImkn0RA7k5sWMHn4vz652wTuKOyjW5/8rVuYemkrB8S/+2q
         9GEKodATRkQyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 05/39] scsi: hisi_sas: Propagate errors in interrupt_init_v1_hw()
Date:   Fri,  9 Jul 2021 22:31:30 -0400
Message-Id: <20210710023204.3171428-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023204.3171428-1-sashal@kernel.org>
References: <20210710023204.3171428-1-sashal@kernel.org>
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
index 8aa3222fe486..5a777e48963b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1697,7 +1697,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 				dev_err(dev,
 					"irq init: fail map phy interrupt %d\n",
 					idx);
-				return -ENOENT;
+				return irq;
 			}
 
 			rc = devm_request_irq(dev, irq, phy_interrupts[j], 0,
@@ -1706,7 +1706,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 				dev_err(dev, "irq init: could not request "
 					"phy interrupt %d, rc=%d\n",
 					irq, rc);
-				return -ENOENT;
+				return rc;
 			}
 		}
 	}
@@ -1717,7 +1717,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 		if (!irq) {
 			dev_err(dev, "irq init: could not map cq interrupt %d\n",
 				idx);
-			return -ENOENT;
+			return irq;
 		}
 
 		rc = devm_request_irq(dev, irq, cq_interrupt_v1_hw, 0,
@@ -1725,7 +1725,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 		if (rc) {
 			dev_err(dev, "irq init: could not request cq interrupt %d, rc=%d\n",
 				irq, rc);
-			return -ENOENT;
+			return rc;
 		}
 	}
 
@@ -1735,7 +1735,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 		if (!irq) {
 			dev_err(dev, "irq init: could not map fatal interrupt %d\n",
 				idx);
-			return -ENOENT;
+			return irq;
 		}
 
 		rc = devm_request_irq(dev, irq, fatal_interrupts[i], 0,
@@ -1744,7 +1744,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 			dev_err(dev,
 				"irq init: could not request fatal interrupt %d, rc=%d\n",
 				irq, rc);
-			return -ENOENT;
+			return rc;
 		}
 	}
 
-- 
2.30.2

