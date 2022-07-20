Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F236157AD34
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241352AbiGTBZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242102AbiGTBYj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:24:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3BF73934;
        Tue, 19 Jul 2022 18:17:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AB34B81DEA;
        Wed, 20 Jul 2022 01:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFB5C341CA;
        Wed, 20 Jul 2022 01:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279847;
        bh=hFKG1bbEtQeJKNkTd5Ayfh8yCS0l9VAbsfYnJ46IJkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ogsVYQE1RZG2FiisSriCDkLId2EPII8skQSlBkL84WztApDcXwRmW3Z0vuMUZAKEj
         Xfok36FIy0oXIwR/ElTZ9abi7RAoByapueNbPMnrTtbZK+AZdDX/148kErLLz/B86C
         03o4viqohWgHAnH2xUoW15cS0Mwc0p7rhtiadnrsq/uqneFRv4A8p1z2NBWdV5xa2a
         j/9h+ClgydNvyfkZxEnBBrE/7eF0H/5QnFZIMfOjWhJPn4UAQOiJDevV8JufYOPmY2
         F00+3ZhrQC8pu9PiGPt2fmc4oJ0MeBZXsOuULqPmOPQZl42ieDd8XMcxZnaTPWLN4H
         vITdgx6LL511A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Po-Wen Kao <powen.kao@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        matthias.bgg@gmail.com, beanhuo@micron.com, avri.altman@wdc.com,
        adrian.hunter@intel.com, daejun7.park@samsung.com,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 23/25] scsi: ufs: core: Fix missing clk change notification on host reset
Date:   Tue, 19 Jul 2022 21:16:14 -0400
Message-Id: <20220720011616.1024753-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011616.1024753-1-sashal@kernel.org>
References: <20220720011616.1024753-1-sashal@kernel.org>
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
index ea6ceab1a1b2..ba14ac9b3914 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6824,7 +6824,7 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	/* scale up clocks to max frequency before full reinitialization */
-	ufshcd_set_clk_freq(hba, true);
+	ufshcd_scale_clks(hba, true);
 
 	err = ufshcd_hba_enable(hba);
 	if (err)
-- 
2.35.1

