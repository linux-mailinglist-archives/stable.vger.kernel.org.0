Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50C5537C5D
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237013AbiE3NbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237268AbiE3NaR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:30:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE7F85EF6;
        Mon, 30 May 2022 06:27:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6549B80B3A;
        Mon, 30 May 2022 13:27:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D4DC3411C;
        Mon, 30 May 2022 13:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917220;
        bh=8fyaHLfs66JSD8DWARG4Vmw9VaXoP4pQwZnrSrmzxME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ezBnmvEPfFbP4CdMD6WkG5RVb8IXGa5dtA+A/EL3LJzrDLgp7F4vRTP21CJ5UQmTG
         mHJpAifBxV9CK9SsNxKxnrpJoN+rW3qIf1q0Y1t+1H40FbI244/wOE53lI4k4v29lw
         vuNW5M6EIoAn3NdbNwtz1vMWsIBZMr5J2cX7fXciQUB0uKkACvOru4GDcZ2ejuCUXM
         ZHdRW7bmvkSfC3f8NZxtlhjLYqhyRONGGENs4aqOMm95UT0CWbDsCsKOEUZmkq3Pmr
         YlUr8Ko8n8Zndk9heVSQiTAcQY6Uw3C1VQYCbE9+89UsMEvkYMVPiUl8CzmhftQKmg
         XKNPSMCh7/1Gg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 060/159] scsi: ufs: Use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
Date:   Mon, 30 May 2022 09:22:45 -0400
Message-Id: <20220530132425.1929512-60-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

[ Upstream commit 75b8715e20a20bc7b4844835e4035543a2674200 ]

Using pm_runtime_resume_and_get() to replace pm_runtime_get_sync() and
pm_runtime_put_noidle(). This change is just to simplify the code, no
actual functional changes.

Link: https://lore.kernel.org/r/20220420090353.2588804-1-chi.minghao@zte.com.cn
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ti-j721e-ufs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ti-j721e-ufs.c b/drivers/scsi/ufs/ti-j721e-ufs.c
index eafe0db98d54..122d650d0810 100644
--- a/drivers/scsi/ufs/ti-j721e-ufs.c
+++ b/drivers/scsi/ufs/ti-j721e-ufs.c
@@ -29,11 +29,9 @@ static int ti_j721e_ufs_probe(struct platform_device *pdev)
 		return PTR_ERR(regbase);
 
 	pm_runtime_enable(dev);
-	ret = pm_runtime_get_sync(dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(dev);
+	ret = pm_runtime_resume_and_get(dev);
+	if (ret < 0)
 		goto disable_pm;
-	}
 
 	/* Select MPHY refclk frequency */
 	clk = devm_clk_get(dev, NULL);
-- 
2.35.1

