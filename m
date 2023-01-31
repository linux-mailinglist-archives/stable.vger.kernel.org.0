Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5C5683092
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 16:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbjAaPEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 10:04:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232411AbjAaPDr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 10:03:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B6853542;
        Tue, 31 Jan 2023 07:01:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC446B81D3E;
        Tue, 31 Jan 2023 15:01:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7BFC433EF;
        Tue, 31 Jan 2023 15:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675177264;
        bh=Ci/QZduyeliRSt1wbxFWmu6TxU7AxC2Pkb9qwEmrpR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t9dY5m906zkru7hO065ufcQKkaI9ZX0/mDpYs89Uoy0+komlkqojvzwiejgrKWbbt
         gU4iRfjRq8YdGeTKC/7ZD4DzEo1t0HGiJtV8uPOpgg639Sfv592m4FNQpAqDp4Z29o
         x2+ZyF2mqF9hLcrs3oXFaQzm9BNqubkBOjwFUR+pznJKf/7Wo+OdKRjAsFSvBKRlzM
         In/wwtVlaze6/Lh+ZzXciPWXNiR3GhHU8UNOvVxJXaOVFAycN4WOqey67voVzbrjxX
         LqxjBdxalk2O8pwWYft1JKXRaPYfFKVUJpCfSZVWCjzvIufJ//GF6amWFsTBUlk8yC
         NC8wtDFe2U4XA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maurizio Lombardi <mlombard@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 2/6] scsi: target: core: Fix warning on RT kernels
Date:   Tue, 31 Jan 2023 10:00:54 -0500
Message-Id: <20230131150100.1250267-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230131150100.1250267-1-sashal@kernel.org>
References: <20230131150100.1250267-1-sashal@kernel.org>
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
index e4513ef09159..3efd5a3bd69d 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -82,8 +82,8 @@ static bool __target_check_io_state(struct se_cmd *se_cmd,
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

