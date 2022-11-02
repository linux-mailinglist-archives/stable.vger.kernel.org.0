Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAA76159BD
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiKBDRe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiKBDQ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:16:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B8C248FD
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:16:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D146EB82062
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71EFC433B5;
        Wed,  2 Nov 2022 03:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359013;
        bh=hkmBHOnMKPue9dNprXXDUtFjn8LIHByL5/yPrjH19d4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bOIO3+PE4hEC6Y+4xCoQo/j6lOdnj1fcSm7ZshRzYqeckT/n7CbAfgw0LkSGpMKK9
         Vs1++T1vS63UyU6/HUpYrkTJCpDX6/r5SZls7cWNm50NkNVoSpgXmUZzZnJLXk6IB5
         tVAJB9ZKk+J+jw3e15VKTD4S8fKhklewsCNNU7c4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dongliang Mu <dzm91@hust.edu.cn>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 61/91] can: mscan: mpc5xxx: mpc5xxx_can_probe(): add missing put_clock() in error path
Date:   Wed,  2 Nov 2022 03:33:44 +0100
Message-Id: <20221102022056.761160942@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
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
index e254e04ae257..ef649764f9b4 100644
--- a/drivers/net/can/mscan/mpc5xxx_can.c
+++ b/drivers/net/can/mscan/mpc5xxx_can.c
@@ -325,14 +325,14 @@ static int mpc5xxx_can_probe(struct platform_device *ofdev)
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
@@ -340,7 +340,9 @@ static int mpc5xxx_can_probe(struct platform_device *ofdev)
 
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



