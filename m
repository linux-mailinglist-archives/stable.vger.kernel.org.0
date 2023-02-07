Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6094B68D7F0
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbjBGNEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbjBGNEo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:04:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA583A584
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:04:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9FCCB81989
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:04:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BBC6C4339B;
        Tue,  7 Feb 2023 13:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775064;
        bh=yTIYNGziTg5Jh33hB4ppgzFiGuBfNKAeKiQnWnbadz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OB3YOzUoztlX+fk0TAxlVUe4mmIIUQax8n8tis88qFmyOgsjyX0anzr2tbPxbWya6
         kilXTeu/rZuxHVFn2qDNVqTAGJC9qjyzKYQ8Req9YKituArZcIMi2dwo7/cp4wvCt8
         xR8HxN3FdZfqmCgIcI7rznZprxjdDK24eKcpPz2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 126/208] ASoC: codecs: wsa883x: correct playback min/max rates
Date:   Tue,  7 Feb 2023 13:56:20 +0100
Message-Id: <20230207125640.114853269@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 100c94ffde489ee11e23400f2a07b236144b048f upstream.

Correct reversed values used in min/max rates, leading to incorrect
playback constraints.

Cc: <stable@vger.kernel.org>
Fixes: 43b8c7dc85a1 ("ASoC: codecs: add wsa883x amplifier support")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230124123049.285395-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wsa883x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wsa883x.c b/sound/soc/codecs/wsa883x.c
index 966ba4909204..58fdb4e9fd97 100644
--- a/sound/soc/codecs/wsa883x.c
+++ b/sound/soc/codecs/wsa883x.c
@@ -1359,8 +1359,8 @@ static struct snd_soc_dai_driver wsa883x_dais[] = {
 			.stream_name = "SPKR Playback",
 			.rates = WSA883X_RATES | WSA883X_FRAC_RATES,
 			.formats = WSA883X_FORMATS,
-			.rate_max = 8000,
-			.rate_min = 352800,
+			.rate_min = 8000,
+			.rate_max = 352800,
 			.channels_min = 1,
 			.channels_max = 1,
 		},
-- 
2.39.1



