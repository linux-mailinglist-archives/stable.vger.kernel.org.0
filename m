Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5801D6B41C9
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbjCJN4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbjCJN4h (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:56:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A2C112DD8
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:56:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4C26B822BA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:56:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF7BC433EF;
        Fri, 10 Mar 2023 13:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456567;
        bh=6EYrF6M0qUJmbvXb+T/4fpb0RDE97dt16mHUJG9yEEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qniAAyZIc3evdZARxF5mcN3mtGqmYLPsz76dVrOZRTSMdVuzrHI3e1b2jf2Z9go47
         9/rCDdR4oqpH+fKLKnJHl2YttqCfL0HZHR793iDmhcJrmOK6fSTTwDAki/WGoTX4Wm
         34k/FLxDyAS2eUvo5EVityvKmCd7mqQcvYgdZuzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Roger Lu <roger.lu@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 017/211] soc: mediatek: mtk-svs: restore default voltages when svs_init02() fail
Date:   Fri, 10 Mar 2023 14:36:37 +0100
Message-Id: <20230310133719.260851372@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Lu <roger.lu@mediatek.com>

[ Upstream commit a0674cd237fc24b08c7dcb4f8e48df3ee769293a ]

If svs init02 fail, it means we cannot rely on svs bank voltages anymore.
We need to disable svs function and restore DVFS opp voltages back to the
default voltages for making sure we have enough DVFS voltages.

Fixes: 681a02e95000 ("soc: mediatek: SVS: introduce MTK SVS engine")
Fixes: 0bbb09b2af9d ("soc: mediatek: SVS: add mt8192 SVS GPU driver")
Signed-off-by: Roger Lu <roger.lu@mediatek.com>
Link: https://lore.kernel.org/r/20230111074528.29354-2-roger.lu@mediatek.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mtk-svs.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/mediatek/mtk-svs.c b/drivers/soc/mediatek/mtk-svs.c
index 75b2f534aa9d0..9859e6cf6b8f9 100644
--- a/drivers/soc/mediatek/mtk-svs.c
+++ b/drivers/soc/mediatek/mtk-svs.c
@@ -1461,6 +1461,7 @@ static int svs_init02(struct svs_platform *svsp)
 {
 	struct svs_bank *svsb;
 	unsigned long flags, time_left;
+	int ret;
 	u32 idx;
 
 	for (idx = 0; idx < svsp->bank_max; idx++) {
@@ -1479,7 +1480,8 @@ static int svs_init02(struct svs_platform *svsp)
 							msecs_to_jiffies(5000));
 		if (!time_left) {
 			dev_err(svsb->dev, "init02 completion timeout\n");
-			return -EBUSY;
+			ret = -EBUSY;
+			goto out_of_init02;
 		}
 	}
 
@@ -1497,12 +1499,30 @@ static int svs_init02(struct svs_platform *svsp)
 		if (svsb->type == SVSB_HIGH || svsb->type == SVSB_LOW) {
 			if (svs_sync_bank_volts_from_opp(svsb)) {
 				dev_err(svsb->dev, "sync volt fail\n");
-				return -EPERM;
+				ret = -EPERM;
+				goto out_of_init02;
 			}
 		}
 	}
 
 	return 0;
+
+out_of_init02:
+	for (idx = 0; idx < svsp->bank_max; idx++) {
+		svsb = &svsp->banks[idx];
+
+		spin_lock_irqsave(&svs_lock, flags);
+		svsp->pbank = svsb;
+		svs_switch_bank(svsp);
+		svs_writel_relaxed(svsp, SVSB_PTPEN_OFF, SVSEN);
+		svs_writel_relaxed(svsp, SVSB_INTSTS_VAL_CLEAN, INTSTS);
+		spin_unlock_irqrestore(&svs_lock, flags);
+
+		svsb->phase = SVSB_PHASE_ERROR;
+		svs_adjust_pm_opp_volts(svsb);
+	}
+
+	return ret;
 }
 
 static void svs_mon_mode(struct svs_platform *svsp)
-- 
2.39.2



