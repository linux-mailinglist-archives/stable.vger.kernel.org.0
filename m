Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 821D86B430B
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbjCJOKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:10:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbjCJOJr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:09:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABAE117FF3
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:09:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 578EEB822C0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3DCFC433D2;
        Fri, 10 Mar 2023 14:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457343;
        bh=NOCtR16MvCE5si4/jGeWf/tHDwOeSNEGL7wKjhq/Jo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X9Lv3PVPm7p5umLTVgBteFOKls1KbStsx8KL06Z9IYHk4MWRmh0V5iH2o/AWDqGPD
         paGcVXX30ASpjQFgxsgIdfSFW7/1e0khuf863wWS/8FknSolBB4E0fM99R2qiyPWMd
         B3B/Y0F93Rzq0R6dezdbpFkGHp+sWkXxEIEqo6bo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 105/200] ASoC: apple: mca: Fix final status read on SERDES reset
Date:   Fri, 10 Mar 2023 14:38:32 +0100
Message-Id: <20230310133720.322419776@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
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

From: Martin Povišer <povik+lin@cutebit.org>

[ Upstream commit aaf5f0d76b6e1870e3674408de2b13a92a4d4059 ]

>From within the early trigger we are doing a reset of the SERDES unit,
but the final status read is on a bad address. Add the missing SERDES
unit offset in calculation of the address.

Fixes: 3df5d0d97289 ("ASoC: apple: mca: Start new platform driver")
Signed-off-by: Martin Povišer <povik+lin@cutebit.org>
Link: https://lore.kernel.org/r/20230224153302.45365-1-povik+lin@cutebit.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/apple/mca.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/apple/mca.c b/sound/soc/apple/mca.c
index 24381c42eb54c..9cceeb2599524 100644
--- a/sound/soc/apple/mca.c
+++ b/sound/soc/apple/mca.c
@@ -210,7 +210,7 @@ static void mca_fe_early_trigger(struct snd_pcm_substream *substream, int cmd,
 			   SERDES_CONF_SOME_RST);
 		readl_relaxed(cl->base + serdes_conf);
 		mca_modify(cl, serdes_conf, SERDES_STATUS_RST, 0);
-		WARN_ON(readl_relaxed(cl->base + REG_SERDES_STATUS) &
+		WARN_ON(readl_relaxed(cl->base + serdes_unit + REG_SERDES_STATUS) &
 			SERDES_STATUS_RST);
 		break;
 	default:
-- 
2.39.2



