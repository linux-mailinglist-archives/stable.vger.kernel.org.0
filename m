Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91FF420DA66
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730296AbgF2T4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:56:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387630AbgF2TkY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA665248CC;
        Mon, 29 Jun 2020 15:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444423;
        bh=8CWrnoZjvbvp1XGWiHnOivYZmItC6ki18O8fBSx/xcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zNDgylcG3KCTnpj6qww2m6LTXx1pWKs7B7eEeDrccl9td5EZ/xOXgoEysgxXf/6Jn
         pvqaiGs9FR6AaY9ZLXZJA1kvWJH+/+0iGzCIhwj6v4WKbf8GKaFujZtkKXqVjurp/+
         jeXRHOFhr5KhbTbeSSmGwT75PvpZJQucEDU14+Ws=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     SeongJae Park <sjpark@amazon.de>,
        James Smart <james.smart@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 101/178] scsi: lpfc: Avoid another null dereference in lpfc_sli4_hba_unset()
Date:   Mon, 29 Jun 2020 11:24:06 -0400
Message-Id: <20200629152523.2494198-102-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

[ Upstream commit 46da547e21d6cefceec3fb3dba5ebbca056627fc ]

Commit cdb42becdd40 ("scsi: lpfc: Replace io_channels for nvme and fcp with
general hdw_queues per cpu") has introduced static checker warnings for
potential null dereferences in 'lpfc_sli4_hba_unset()' and commit 1ffdd2c0440d
("scsi: lpfc: resolve static checker warning in lpfc_sli4_hba_unset") has
tried to fix it.  However, yet another potential null dereference is
remaining.  This commit fixes it.

This bug was discovered and resolved using Coverity Static Analysis
Security Testing (SAST) by Synopsys, Inc.

Link: https://lore.kernel.org/r/20200623084122.30633-1-sjpark@amazon.com
Fixes: 1ffdd2c0440d ("scsi: lpfc: resolve static checker warning inlpfc_sli4_hba_unset")
Fixes: cdb42becdd40 ("scsi: lpfc: Replace io_channels for nvme and fcp with general hdw_queues per cpu")
Reviewed-by: James Smart <james.smart@broadcom.com>
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 14d9f41977f1c..95abffd9ad100 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11542,7 +11542,8 @@ lpfc_sli4_hba_unset(struct lpfc_hba *phba)
 	lpfc_sli4_xri_exchange_busy_wait(phba);
 
 	/* per-phba callback de-registration for hotplug event */
-	lpfc_cpuhp_remove(phba);
+	if (phba->pport)
+		lpfc_cpuhp_remove(phba);
 
 	/* Disable PCI subsystem interrupt */
 	lpfc_sli4_disable_intr(phba);
-- 
2.25.1

