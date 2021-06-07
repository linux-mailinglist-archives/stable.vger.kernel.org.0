Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2454A39E3AC
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbhFGQ1W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:27:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233761AbhFGQY2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:24:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E25561950;
        Mon,  7 Jun 2021 16:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082556;
        bh=5Sl8I8Ml7VwpxWr4N193h06mLtdoczZ+qYc6AYXhh+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gYeqloSwZLz+LRkColJtJ9z1bUl5R1VIe2zX96VxPQYN/Ww/ZGepBmyl/gLrktafd
         VeKu7ZxV8QY2rlzqAK2SeUBr929/YlQGGXDiz9bravL8ih/z1P7vad+WBbeJ+37I4G
         4aBj0qgV2WyLSgN9PKSxUl9S5mpWY51JMDAtaeDKy52DtwUKAkt+T5ozKyH3zOqc8O
         2hFo0TIed6+zpZqqZvSx1ZSwnaX75nmg9AF8aJ1ezE7naDuKTuTVIJ2IXzvGNvnqg5
         04V232UKwMMTOXofYiwS/HXXy4WraiQqbZ39gJHvpkyDP4yd47BeeTj8KzFnQ6P3rc
         oOdtFy5u5Hr1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maurizio Lombardi <mlombard@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 09/15] scsi: target: core: Fix warning on realtime kernels
Date:   Mon,  7 Jun 2021 12:15:37 -0400
Message-Id: <20210607161543.3584778-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161543.3584778-1-sashal@kernel.org>
References: <20210607161543.3584778-1-sashal@kernel.org>
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
index ecd707f74ddc..6afb65387be6 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2779,9 +2779,7 @@ __transport_wait_for_tasks(struct se_cmd *cmd, bool fabric_stop,
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

