Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6B4615A83
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbiKBDch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbiKBDcg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:32:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30D4264B6
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:32:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82A0B61729
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:32:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D014C433D7;
        Wed,  2 Nov 2022 03:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359954;
        bh=ulI99lG6pLWyzxAqvw4lwZcYfWEfRcpWIjb3LWVaKwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2sl/sQXIxSaff78J0uRxt6bWMCZ11Prtz2u34JRZue/6rzZww70mgj/xhKa9tmgWA
         dG45fr7xBmXAGVf6pLUUoxNLnQ5mcnfncdAW2Qdok5ghDPJKeBDMD286f/a2A6mGsM
         35Fvt43e06igKIgS+hcPegsJTHf3dsNQ7rJ5+CqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dongliang Mu <dzm91@hust.edu.cn>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 62/78] can: mscan: mpc5xxx: mpc5xxx_can_probe(): add missing put_clock() in error path
Date:   Wed,  2 Nov 2022 03:34:47 +0100
Message-Id: <20221102022054.776977847@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>
References: <20221102022052.895556444@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <dzm91@hust.edu.cn>

[ Upstream commit 3e5b3418827cefb5e1cc658806f02965791b8f07 ]

The commit 1149108e2fbf ("can: mscan: improve clock API use") only
adds put_clock() in mpc5xxx_can_remove() function, forgetting to add
put_clock() in the error handling code.

Fix this bug by adding put_clock() in the error handling code.

Fixes: 1149108e2fbf ("can: mscan: improve clock API use")
Signed-off-by: Dongliang Mu <dzm91@hust.edu.cn>
Link: https://lore.kernel.org/all/20221024133828.35881-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/mscan/mpc5xxx_can.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/mscan/mpc5xxx_can.c b/drivers/net/can/mscan/mpc5xxx_can.c
index 2949a381a94d..21993ba7ae2a 100644
--- a/drivers/net/can/mscan/mpc5xxx_can.c
+++ b/drivers/net/can/mscan/mpc5xxx_can.c
@@ -336,14 +336,14 @@ static int mpc5xxx_can_probe(struct platform_device *ofdev)
 					       &mscan_clksrc);
 	if (!priv->can.clock.freq) {
 		dev_err(&ofdev->dev, "couldn't get MSCAN clock properties\n");
-		goto exit_free_mscan;
+		goto exit_put_clock;
 	}
 
 	err = register_mscandev(dev, mscan_clksrc);
 	if (err) {
 		dev_err(&ofdev->dev, "registering %s failed (err=%d)\n",
 			DRV_NAME, err);
-		goto exit_free_mscan;
+		goto exit_put_clock;
 	}
 
 	dev_info(&ofdev->dev, "MSCAN at 0x%p, irq %d, clock %d Hz\n",
@@ -351,7 +351,9 @@ static int mpc5xxx_can_probe(struct platform_device *ofdev)
 
 	return 0;
 
-exit_free_mscan:
+exit_put_clock:
+	if (data->put_clock)
+		data->put_clock(ofdev);
 	free_candev(dev);
 exit_dispose_irq:
 	irq_dispose_mapping(irq);
-- 
2.35.1



