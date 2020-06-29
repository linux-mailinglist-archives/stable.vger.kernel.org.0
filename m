Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBEDD20D0BF
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 20:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgF2Sfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:35:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726640AbgF2Sfj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3766D2472E;
        Mon, 29 Jun 2020 15:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444050;
        bh=oIYrLKBcbE1yGStjETpm0NAs49UI9Y8xkZBOAIb8+T4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WQ9kz0T7yv5z00QXACz86disFifERmadzjt9SvYDwsngKV0hpcJMVr9Xsn/Nqt0cY
         ICB8LlTjjPCRJd3HiLbN5vnTMceP+emLlLEz+FyVVSgXJ9Be1ZGp88SmVADDUqpgil
         bounURSy4uLN9DwU3iuN4edcxZvn1K3LQSSGP4dQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     SeongJae Park <sjpark@amazon.de>,
        James Smart <james.smart@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 158/265] scsi: lpfc: Avoid another null dereference in lpfc_sli4_hba_unset()
Date:   Mon, 29 Jun 2020 11:16:31 -0400
Message-Id: <20200629151818.2493727-159-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
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
index 4104bdcdbb6fd..70be1f5de8730 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11895,7 +11895,8 @@ lpfc_sli4_hba_unset(struct lpfc_hba *phba)
 	lpfc_sli4_xri_exchange_busy_wait(phba);
 
 	/* per-phba callback de-registration for hotplug event */
-	lpfc_cpuhp_remove(phba);
+	if (phba->pport)
+		lpfc_cpuhp_remove(phba);
 
 	/* Disable PCI subsystem interrupt */
 	lpfc_sli4_disable_intr(phba);
-- 
2.25.1

