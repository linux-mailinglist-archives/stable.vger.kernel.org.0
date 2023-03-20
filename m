Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8046C0718
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 01:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjCTAy2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 20:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbjCTAyI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 20:54:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F4E11E5C7;
        Sun, 19 Mar 2023 17:53:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F03A6611DF;
        Mon, 20 Mar 2023 00:53:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B42C4339B;
        Mon, 20 Mar 2023 00:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273609;
        bh=7EL9TvrvjginXKOzqR86t0df7hgPP3aHNpYPzaCP28E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LAwQe5K2wAAqF1nlrODMv5G6IYirx1fuW366q2nKG/w/wk/+3ZcN28oksUIRd53rT
         A6kDj9oL9oETuEpqfIobyEVWkbwsV59F1983hVsUhxqWc1yqENcKyYsAjO8MAe9Xnl
         PyBDCnvhSfUiJ9nw9SKycfiNwMk24bvrGZCmgbdAt/V4GFl/SnvsLHRkoXbq1hwcUi
         nSjimgwpNVPF5UubrzHhnAgIkpswbn+ozJWiruQkRKj370NUCjV6/kMGh6OMF0k5d2
         IadzJTyD+VZ9wb5iO5738SUDG67MxcWaAuw0KuFlREjss3u9+dYrfQ8Nzz3yatHugw
         nsKow1HtkASEA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kang Chen <void0red@gmail.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 12/30] scsi: hisi_sas: Check devm_add_action() return value
Date:   Sun, 19 Mar 2023 20:52:37 -0400
Message-Id: <20230320005258.1428043-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005258.1428043-1-sashal@kernel.org>
References: <20230320005258.1428043-1-sashal@kernel.org>
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

From: Kang Chen <void0red@gmail.com>

[ Upstream commit 06d1a90de60208054cca15ef200138cfdbb642a9 ]

In case devm_add_action() fails, check it in the caller of
interrupt_preinit_v3_hw().

Link: https://lore.kernel.org/r/20230227031030.893324-1-void0red@gmail.com
Signed-off-by: Kang Chen <void0red@gmail.com>
Acked-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 0c3fcb8078062..a63279f55d096 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2495,8 +2495,7 @@ static int interrupt_preinit_v3_hw(struct hisi_hba *hisi_hba)
 	hisi_hba->cq_nvecs = vectors - BASE_VECTORS_V3_HW;
 	shost->nr_hw_queues = hisi_hba->cq_nvecs;
 
-	devm_add_action(&pdev->dev, hisi_sas_v3_free_vectors, pdev);
-	return 0;
+	return devm_add_action(&pdev->dev, hisi_sas_v3_free_vectors, pdev);
 }
 
 static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
-- 
2.39.2

