Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29ECE5AB0A1
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238215AbiIBMzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238297AbiIBMyS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:54:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EBE02E9EE;
        Fri,  2 Sep 2022 05:38:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFA4762201;
        Fri,  2 Sep 2022 12:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B378BC433D7;
        Fri,  2 Sep 2022 12:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122167;
        bh=BaSsjwnDE85Wh8aHli0vywtZ1D1KO4NAanwGkKufopA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0rvpDsVELRR56bP6VjBqgFMa+sjPLOxJFPPqMaWUw9NIDcEmhcen+D68n1xYECs/q
         YYRq3crwRboXH2ivRcE5dsbKtz6Q8BnqXbnfmyomupFL4+HZPORpkTHIdRhI//EtAy
         WKoPGrjLhb3IyRn/DjE280ulMlD6YONnqY6OhQiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oder Chiou <oder_chiou@realtek.com>,
        Mohan Kumar D <mkumard@nvidia.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 34/72] ASoC: rt5640: Fix the JD voltage dropping issue
Date:   Fri,  2 Sep 2022 14:19:10 +0200
Message-Id: <20220902121405.912516755@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Oder Chiou <oder_chiou@realtek.com>

[ Upstream commit afb176d45870048eea540991b082208270824037 ]

The patch fixes the JD voltage dropping issue in the HDA JD using.

Signed-off-by: Oder Chiou <oder_chiou@realtek.com>
Reported-by: Mohan Kumar D <mkumard@nvidia.com>
Link: https://lore.kernel.org/r/20220808052836.25791-1-oder_chiou@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5640.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt5640.c b/sound/soc/codecs/rt5640.c
index 18b3da9211e32..5ada0d318d0ff 100644
--- a/sound/soc/codecs/rt5640.c
+++ b/sound/soc/codecs/rt5640.c
@@ -1986,7 +1986,7 @@ static int rt5640_set_bias_level(struct snd_soc_component *component,
 		snd_soc_component_write(component, RT5640_PWR_MIXER, 0x0000);
 		if (rt5640->jd_src == RT5640_JD_SRC_HDA_HEADER)
 			snd_soc_component_write(component, RT5640_PWR_ANLG1,
-				0x0018);
+				0x2818);
 		else
 			snd_soc_component_write(component, RT5640_PWR_ANLG1,
 				0x0000);
@@ -2592,7 +2592,8 @@ static void rt5640_enable_hda_jack_detect(
 	snd_soc_component_update_bits(component, RT5640_DUMMY1, 0x400, 0x0);
 
 	snd_soc_component_update_bits(component, RT5640_PWR_ANLG1,
-		RT5640_PWR_VREF2, RT5640_PWR_VREF2);
+		RT5640_PWR_VREF2 | RT5640_PWR_MB | RT5640_PWR_BG,
+		RT5640_PWR_VREF2 | RT5640_PWR_MB | RT5640_PWR_BG);
 	usleep_range(10000, 15000);
 	snd_soc_component_update_bits(component, RT5640_PWR_ANLG1,
 		RT5640_PWR_FV2, RT5640_PWR_FV2);
-- 
2.35.1



