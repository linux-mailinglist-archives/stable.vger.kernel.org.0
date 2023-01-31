Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D25C68306D
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 16:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbjAaPCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 10:02:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232705AbjAaPBd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 10:01:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CCD8A72;
        Tue, 31 Jan 2023 07:00:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F8CB61562;
        Tue, 31 Jan 2023 15:00:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DF8C433A0;
        Tue, 31 Jan 2023 15:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675177237;
        bh=DWj+O7moT18+ZTe+Ogcv2iDKxrxaudaFhD+wXevmfXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cEEMwZApbIqhlUvB3D6XKChGhwBFgW5uduXWukUh5Q3oVxNGrrR8Ckie++ROUDhR4
         qh4pTterhgXlnQQCZuzDmvFuvqLK2Q+Ije4A6K1636q+STgiRpD5XaAzZ1r0CShPiV
         iiLd7G4AjSqNQfpATeI0n0YGAD62G3rhfW9FUUzCDq+qCuapRyCAPN7Wkpdpj7agk4
         zhLJdUNvZJhDisMJRH9G23mdwdCvEif+LA4qWjeSTt3GtuTPIxMwldei+ffWXxynAH
         ssXRuvUGlbqAymSnxDfoBYR7Xu3q4TRrDTiloiofzkZrFumwgRCneIw9Y93oARD2Z0
         4HcfnqOQotu5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maurizio Lombardi <mlombard@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 03/12] scsi: target: core: Fix warning on RT kernels
Date:   Tue, 31 Jan 2023 10:00:21 -0500
Message-Id: <20230131150030.1250104-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230131150030.1250104-1-sashal@kernel.org>
References: <20230131150030.1250104-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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

