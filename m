Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32FF24F27DB
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbiDEIJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235546AbiDEH7u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374E93F8B4;
        Tue,  5 Apr 2022 00:55:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6B6E615CD;
        Tue,  5 Apr 2022 07:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A8FC340EE;
        Tue,  5 Apr 2022 07:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145320;
        bh=/9Zl6SwhKKLl2eqmGV3+M5EBkUz2ZL2+HLu0YTX6/TU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M5yZeWU7ZvhASS2kbkZbGmEiRO1gwxkxxHeQ3l0DRz49+ImVciFBbx51g3Bbkhb53
         DWK07bEutVSpatQlbK/j7dKLFBt3z9T+2KQGiGhxCr15GbuILf/HV1YVjR7NeGjA4w
         zihiw46U8dCNOat4kngsIa0lsZxKT0dpLkC9/u7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0362/1126] ASoC: codecs: wcd938x: fix kcontrol max values
Date:   Tue,  5 Apr 2022 09:18:29 +0200
Message-Id: <20220405070418.253807700@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit b0217519236924f77a8382b4004e43ef8fd0dcbb ]

set "HPH Type" Kcontrol max value of WCD_MBHC_HPH_STEREO instead of UINT_MAX.
set "HPHL/R Impedance" Kcontrols max value to INT_MAX instead of UINT_MAX as
max field is integer type.

Without this patch amixer for these controls will show -1 as max value to userspace.

Fixes: bcee7ed09b8e ("ASoC: codecs: wcd938x: add Multi Button Headset Control support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220222183212.11580-8-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd938x.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wcd938x.c b/sound/soc/codecs/wcd938x.c
index 33d5403d4e62..9ae65cbabb1a 100644
--- a/sound/soc/codecs/wcd938x.c
+++ b/sound/soc/codecs/wcd938x.c
@@ -3575,14 +3575,14 @@ static int wcd938x_hph_impedance_get(struct snd_kcontrol *kcontrol,
 }
 
 static const struct snd_kcontrol_new hph_type_detect_controls[] = {
-	SOC_SINGLE_EXT("HPH Type", 0, 0, UINT_MAX, 0,
+	SOC_SINGLE_EXT("HPH Type", 0, 0, WCD_MBHC_HPH_STEREO, 0,
 		       wcd938x_get_hph_type, NULL),
 };
 
 static const struct snd_kcontrol_new impedance_detect_controls[] = {
-	SOC_SINGLE_EXT("HPHL Impedance", 0, 0, UINT_MAX, 0,
+	SOC_SINGLE_EXT("HPHL Impedance", 0, 0, INT_MAX, 0,
 		       wcd938x_hph_impedance_get, NULL),
-	SOC_SINGLE_EXT("HPHR Impedance", 0, 1, UINT_MAX, 0,
+	SOC_SINGLE_EXT("HPHR Impedance", 0, 1, INT_MAX, 0,
 		       wcd938x_hph_impedance_get, NULL),
 };
 
-- 
2.34.1



