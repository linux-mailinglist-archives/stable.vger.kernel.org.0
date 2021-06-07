Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17B239E30D
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbhFGQUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:20:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232433AbhFGQSp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:18:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8043161601;
        Mon,  7 Jun 2021 16:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082471;
        bh=MfSr33OQR/3F0MHvDf2x2DbxuNCQgTef2ELFZ8C5Lg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iDSF1w4F7OXl+AoulCMtQKuBzWc3YdRGCPd58dLb2RMYwSoh7/hihxC8I38zOuSRj
         U9woEoukcSwkJ+JLxbF3UEGpj8VjF4QgMINE+strz+ZJOHU4eU96EpQx3RGrbyQ8ja
         nMpkw+h6eoYOea4aNuVWYsROPJYFEDfrHYrZ9cqBXD8EjkMw9lAF891tacBTyHtwCS
         ij3t5ghYWmdQHC2I2hqaDeI911M6S9za34sd5QeURzACyt37eKSs6Ltpq78V5HU6eF
         EIOIMMaDr0MrUdwAW/D5+qlT7WvjNbkO+TSeE7yGdLZDAxKvPKhJA+u46rci6hZZjg
         PWouFdmvIATJw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maurizio Lombardi <mlombard@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 16/29] scsi: target: core: Fix warning on realtime kernels
Date:   Mon,  7 Jun 2021 12:13:57 -0400
Message-Id: <20210607161410.3584036-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161410.3584036-1-sashal@kernel.org>
References: <20210607161410.3584036-1-sashal@kernel.org>
MIME-Version: 1.0
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
index a16835c0bb1d..5cf9e7677926 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2993,9 +2993,7 @@ __transport_wait_for_tasks(struct se_cmd *cmd, bool fabric_stop,
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

