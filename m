Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B0D68301A
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 16:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbjAaPAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 10:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232590AbjAaO76 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 09:59:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E31522A24;
        Tue, 31 Jan 2023 06:59:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 248E86153C;
        Tue, 31 Jan 2023 14:59:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA06BC433A0;
        Tue, 31 Jan 2023 14:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675177195;
        bh=DWj+O7moT18+ZTe+Ogcv2iDKxrxaudaFhD+wXevmfXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rvVZV4CsZfK42/WiFpPcX+FwJHGtAXdFc+qlbd7phnWOZuxPPdlKXAFvNa5PRtcf5
         j2pAtxrLJ2HTdy/IqjNnnF6FBh6myKkPROucc1fyeG0ZIOneWhdtvt9d262zXUGf4r
         lv3flXp+LbV1hteiPE86uU9B3AhQTUb7UilI5FEq8kZIr6MoUy4YNq2e15HCY2emn7
         klbXO8S5UYIkuHHFhEB4Z+pPTHf4x2+Fk8MKyU/Md3NL0u6iXEMSaYQrVKabGB+wha
         iW3YyaSj296ABon56VU1s/AxRbhRsI/0YWfWqZ5+Bt2Q87TZvkgtzrjZ4XQjUJmrYV
         dZgDAakSmx2GQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maurizio Lombardi <mlombard@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 03/20] scsi: target: core: Fix warning on RT kernels
Date:   Tue, 31 Jan 2023 09:59:29 -0500
Message-Id: <20230131145946.1249850-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230131145946.1249850-1-sashal@kernel.org>
References: <20230131145946.1249850-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 84ed64b1a7a7fcd507598dee7708c1f225123711 ]

Calling spin_lock_irqsave() does not disable the interrupts on realtime
kernels, remove the warning and replace assert_spin_locked() with
lockdep_assert_held().

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20230110125310.55884-1-mlombard@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_tmr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index bac111456fa1..2b95b4550a63 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -73,8 +73,8 @@ static bool __target_check_io_state(struct se_cmd *se_cmd,
 {
 	struct se_session *sess = se_cmd->se_sess;
 
-	assert_spin_locked(&sess->sess_cmd_lock);
-	WARN_ON_ONCE(!irqs_disabled());
+	lockdep_assert_held(&sess->sess_cmd_lock);
+
 	/*
 	 * If command already reached CMD_T_COMPLETE state within
 	 * target_complete_cmd() or CMD_T_FABRIC_STOP due to shutdown,
-- 
2.39.0

