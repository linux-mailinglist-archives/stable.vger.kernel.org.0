Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86F93CE10E
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347524AbhGSPTb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:19:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345675AbhGSPNr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:13:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88D2C606A5;
        Mon, 19 Jul 2021 15:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710024;
        bh=+teWcXtYWVyK9YNcvQTLZzb1MYx+hhqYzIPdj2ggBek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MkSZfdwzA0hhXDSXZUfXSBdiN/bNas9XrylXj/btBemgB8rRfKbtOmoDpi4EFMXuR
         5aKVZubkLYdZUHmag45FbelO3pwnr4Hbs6upaRykDQLn6DXJW7JJkHrgqNw1DAooAK
         sCHpzRpG+TVLIdTyA4TIQirOlFg3VGSt7QZrDweM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/243] scsi: hisi_sas: Propagate errors in interrupt_init_v1_hw()
Date:   Mon, 19 Jul 2021 16:51:13 +0200
Message-Id: <20210719144942.347083655@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



