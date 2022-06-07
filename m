Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7065408D4
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349454AbiFGSDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350380AbiFGSAz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:00:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D8B6EC40;
        Tue,  7 Jun 2022 10:43:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FF13B822A7;
        Tue,  7 Jun 2022 17:42:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A45AC385A5;
        Tue,  7 Jun 2022 17:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623767;
        bh=8fyaHLfs66JSD8DWARG4Vmw9VaXoP4pQwZnrSrmzxME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ULvttbcbLaLpsTj31HA1mUd8vaIDvbL4AYDsULMAGEt7HL/0LorBRWBsmNv019EQ7
         LtInzwCQLPWRR4IdZeHnQPWsHPlvQqO3u8A56X7PXpVeZzr7nePwsvvADEw5uYRKhm
         JeVrsrqbzadM4yxMowTQV47H1D6eeYJnqn22BP9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 082/667] scsi: ufs: Use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
Date:   Tue,  7 Jun 2022 18:55:47 +0200
Message-Id: <20220607164937.281483247@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



