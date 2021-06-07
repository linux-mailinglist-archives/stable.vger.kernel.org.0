Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6667439E355
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233348AbhFGQXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:23:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:32772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232345AbhFGQVG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:21:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AB2761864;
        Mon,  7 Jun 2021 16:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082503;
        bh=1zf+BQx7t+SeimfFA/onkUY3pcops3a+BVK9iv4zMWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Le+cFJurCBPC2vOpCf8hX/KaafsL7P2Dyv4PemWq+Z0x7TSL13xDZnYFxvg6ZkTHM
         W21u5hQ9niCqXDlXfMmo3F2aG3TrdiwBnsMTxpX98EQAGxkevOK+lCNdzJzIA0qi76
         AMM7FAvqS5xGc6filuhFFK6VH3eRMWvGyOOK01rqL6G/Cn1CJ8LFaL1I66SgRwWqPX
         hBVNFMJyYgPD+pNUinue4A/Ue6TPtUlGGGPAbNWRze4dSKh28B5UlorZP/8i6oAzEU
         XwotH992OfEQ+qBBysIiRoTFEa9hzqR9/aGWZYgxb/aDO9jTjQAFmTy/UvLB0PSMOM
         EzJYIEOxQeQIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maurizio Lombardi <mlombard@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 11/21] scsi: target: core: Fix warning on realtime kernels
Date:   Mon,  7 Jun 2021 12:14:38 -0400
Message-Id: <20210607161448.3584332-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161448.3584332-1-sashal@kernel.org>
References: <20210607161448.3584332-1-sashal@kernel.org>
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
index bdada97cd4fe..9c60a090cfd1 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2982,9 +2982,7 @@ __transport_wait_for_tasks(struct se_cmd *cmd, bool fabric_stop,
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

