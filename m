Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5A273B6433
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235292AbhF1PGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:06:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236773AbhF1PCi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:02:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AF8261CD9;
        Mon, 28 Jun 2021 14:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891384;
        bh=7Ws0jZ1/9jfL3AFF6798BOs1ZRGa0ZAja/D4PdjEYrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UvakiiTr/g8muG9NynVp89ZkkBp+v7+gaSpph1HdnnhUanUaQvfRHdXLDHoc2CSrE
         2H1yQIrpna1N7Qsyrk8iTabQchhYCg1usEanxYNU7M5RR+UaP7XNAeGBYiIPY6ZooR
         xkdZNIDZNKkIAMUci4SJzorgRCW+Bm8xuFysQSca+CGWyr8fsP6hyO6+m8FG1Vtrt7
         WlTrXi4MJauVthDubdWgpgN9q26Lf26+OyutaYQQgMg1p1QKVAdku934KUnFz+F1i4
         CYj6BJWRp4uRkffOOorxbOj/MTFj4AOaa9CdcpQeyL2Y1HLc4ZSRAUWrBQLU+LAfn1
         EWgTAT44ol3IA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maurizio Lombardi <mlombard@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 07/57] scsi: target: core: Fix warning on realtime kernels
Date:   Mon, 28 Jun 2021 10:42:06 -0400
Message-Id: <20210628144256.34524-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144256.34524-1-sashal@kernel.org>
References: <20210628144256.34524-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:42+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 515da6f4295c2c42b8c54572cce3d2dd1167c41e ]

On realtime kernels, spin_lock_irq*(spinlock_t) do not disable the
interrupts, a call to irqs_disabled() will return false thus firing a
warning in __transport_wait_for_tasks().

Remove the warning and also replace assert_spin_locked() with
lockdep_assert_held()

Link: https://lore.kernel.org/r/20210531121326.3649-1-mlombard@redhat.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_transport.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 96cf2448a1f4..6c6aa23ced45 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2757,9 +2757,7 @@ __transport_wait_for_tasks(struct se_cmd *cmd, bool fabric_stop,
 	__releases(&cmd->t_state_lock)
 	__acquires(&cmd->t_state_lock)
 {
-
-	assert_spin_locked(&cmd->t_state_lock);
-	WARN_ON_ONCE(!irqs_disabled());
+	lockdep_assert_held(&cmd->t_state_lock);
 
 	if (fabric_stop)
 		cmd->transport_state |= CMD_T_FABRIC_STOP;
-- 
2.30.2

