Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E790357ABED
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240720AbiGTBQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241075AbiGTBPp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:15:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A528469F2D;
        Tue, 19 Jul 2022 18:13:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94FAAB81DEA;
        Wed, 20 Jul 2022 01:13:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C782CC341C6;
        Wed, 20 Jul 2022 01:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279621;
        bh=hfXrYoJbZy3WFQVhswLlOQu9fJJYWOb3Bffj/Ux6OhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=npSDVP3/yIbq1ATdwxzSiyU7ay90Vg8/YnGMiQPl7Z6n7Bty25iw+9ic91ymcDFxG
         Rabylkt9NoDcU2uqZ+S4RzuR0HYS9fGHuJwoiR0zLSN6hcve9B/TzWauO9SjUu0oK7
         BOBiM//UGaIV1s0v5Lrv74dip208pcRqg/O4cftNWFovRnWVjzZ5tyDxyhioVB0xGR
         cUNg4ZcVRwTHqyrIYw3/KDemND7t10pbOMPdFYFJiD/An86PnIzlCspFnhUag2s5uE
         xalx5+pea9aGE8MEXBD5a+lgAWlvV6Q1xAvrt0oJ5aybwHGWhVOCc/3XHMSOTj6qn4
         zTo4oyuD+1ADQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Po-Wen Kao <powen.kao@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        matthias.bgg@gmail.com, beanhuo@micron.com, avri.altman@wdc.com,
        daejun7.park@samsung.com, adrian.hunter@intel.com,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.18 50/54] scsi: ufs: core: Fix missing clk change notification on host reset
Date:   Tue, 19 Jul 2022 21:10:27 -0400
Message-Id: <20220720011031.1023305-50-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011031.1023305-1-sashal@kernel.org>
References: <20220720011031.1023305-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Po-Wen Kao <powen.kao@mediatek.com>

[ Upstream commit 52a518019ca187227b786f8b8ee20869a97f3af4 ]

In ufshcd_host_reset_and_restore(), ufshcd_set_clk_freq() is called to
scale clock rate. However, this did not call vops->clk_scale_notify() to
inform platform driver of clock change.

Call ufshcd_scale_clks() instead so that clock change can be properly
handled.

Link: https://lore.kernel.org/r/20220711144224.17916-2-powen.kao@mediatek.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Po-Wen Kao <powen.kao@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 4c9eb4be449c..be7b03a90cb3 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7235,7 +7235,7 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 	hba->silence_err_logs = false;
 
 	/* scale up clocks to max frequency before full reinitialization */
-	ufshcd_set_clk_freq(hba, true);
+	ufshcd_scale_clks(hba, true);
 
 	err = ufshcd_hba_enable(hba);
 
-- 
2.35.1

