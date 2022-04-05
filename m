Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4222B4F36C6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244605AbiDELHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348752AbiDEJsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B303E4833A;
        Tue,  5 Apr 2022 02:34:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 639FEB81C82;
        Tue,  5 Apr 2022 09:34:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC275C385A2;
        Tue,  5 Apr 2022 09:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151288;
        bh=3WCk8sBpIkZCS0IofelWfKv101rypvwobF2dXzA2GKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zRkJjstNbmpfo5bDWwOhNP9GZ72Lv5XoNmCOtPf14SAV+YVkdN278q7pOhNAT9OX4
         ND1m2u2TtXf80MRcv5zEo172YEAnYGFBxS92sZPEJt6cTLRHClb/TNyB1SMU49QDY6
         8tYAAUxR9d4mIK1P03i4fhhg6mdI09kqhtJmniNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Chris Morgan <macromorgan@hotmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 360/913] ASoC: rk817: Fix missing clk_disable_unprepare() in rk817_platform_probe
Date:   Tue,  5 Apr 2022 09:23:42 +0200
Message-Id: <20220405070350.637046054@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit a6b44a2518a08348bd0f0401e4d2b99233bbabc2 ]

Fix the missing clk_disable_unprepare() before return
from rk817_platform_probe() in the error handling case.

Fixes: 0d6a04da9b25 ("ASoC: Add Rockchip rk817 audio CODEC support")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Tested-by: Chris Morgan <macromorgan@hotmail.com>
Link: https://lore.kernel.org/r/20220307090146.4104-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rk817_codec.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rk817_codec.c b/sound/soc/codecs/rk817_codec.c
index 03f24edfe4f6..8fffe378618d 100644
--- a/sound/soc/codecs/rk817_codec.c
+++ b/sound/soc/codecs/rk817_codec.c
@@ -508,12 +508,14 @@ static int rk817_platform_probe(struct platform_device *pdev)
 	if (ret < 0) {
 		dev_err(&pdev->dev, "%s() register codec error %d\n",
 			__func__, ret);
-		goto err_;
+		goto err_clk;
 	}
 
 	return 0;
-err_:
 
+err_clk:
+	clk_disable_unprepare(rk817_codec_data->mclk);
+err_:
 	return ret;
 }
 
-- 
2.34.1



