Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 272173C2F9A
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234527AbhGJCbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:31:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233973AbhGJCaN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:30:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F175D613FC;
        Sat, 10 Jul 2021 02:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884044;
        bh=771xVZXqIipQtpSSLwGn+z8A4FMZJy3lU2l55actlcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nq34to8FT+FIEYmRsjemOV+P2O7k43yTLdk6LGr5zg+hyCybpQ80ci1Bnh0m3qX5c
         zEAcllRH6naWpw4uXmRb/xZl7OV/oRi9eaURYyKaMt8C/jUQLwj4WNJMUc6BPGWAw+
         8AyRSy/QX2CxlfpcVFj4ijUy1I8aCACqlZAurQ2XHBjGJ6Ou1V/CMYh12JZY4lCpLE
         0Ozi6Esw+c3ZSKm+PVFd/ii87A1W9+qgno8/8bwm+a3lJ/blEijo8Mq+VZ4YjycMJ3
         V+qb/qUvsZ01PiVXil7XM2xYGYXPMWxln2TkOaaZKd9RyE+raNCH1JoCu4p35+PRHT
         j8FjTn2z1G2ew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 12/63] scsi: hisi_sas: Propagate errors in interrupt_init_v1_hw()
Date:   Fri,  9 Jul 2021 22:26:18 -0400
Message-Id: <20210710022709.3170675-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022709.3170675-1-sashal@kernel.org>
References: <20210710022709.3170675-1-sashal@kernel.org>
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
index 3364ae0b9bfe..9f6534bd354b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1648,7 +1648,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 			if (irq < 0) {
 				dev_err(dev, "irq init: fail map phy interrupt %d\n",
 					idx);
-				return -ENOENT;
+				return irq;
 			}
 
 			rc = devm_request_irq(dev, irq, phy_interrupts[j], 0,
@@ -1656,7 +1656,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 			if (rc) {
 				dev_err(dev, "irq init: could not request phy interrupt %d, rc=%d\n",
 					irq, rc);
-				return -ENOENT;
+				return rc;
 			}
 		}
 	}
@@ -1667,7 +1667,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 		if (irq < 0) {
 			dev_err(dev, "irq init: could not map cq interrupt %d\n",
 				idx);
-			return -ENOENT;
+			return irq;
 		}
 
 		rc = devm_request_irq(dev, irq, cq_interrupt_v1_hw, 0,
@@ -1675,7 +1675,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 		if (rc) {
 			dev_err(dev, "irq init: could not request cq interrupt %d, rc=%d\n",
 				irq, rc);
-			return -ENOENT;
+			return rc;
 		}
 	}
 
@@ -1685,7 +1685,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 		if (irq < 0) {
 			dev_err(dev, "irq init: could not map fatal interrupt %d\n",
 				idx);
-			return -ENOENT;
+			return irq;
 		}
 
 		rc = devm_request_irq(dev, irq, fatal_interrupts[i], 0,
@@ -1693,7 +1693,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 		if (rc) {
 			dev_err(dev, "irq init: could not request fatal interrupt %d, rc=%d\n",
 				irq, rc);
-			return -ENOENT;
+			return rc;
 		}
 	}
 
-- 
2.30.2

