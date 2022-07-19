Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C822B579F07
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238308AbiGSNKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243200AbiGSNI7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:08:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E828BB8E4;
        Tue, 19 Jul 2022 05:28:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEE2CB81B36;
        Tue, 19 Jul 2022 12:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2182EC341C6;
        Tue, 19 Jul 2022 12:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233662;
        bh=21nWqJIuJuPyc3MGE2rDN2XazBAGhO1m2aDnsDAArdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aW9tjYyqw1g+44ylGU122aVVJHm4TU1R0rl3bg6goB77FHwF58leo8b+0oiNAd9eN
         XLhIJrqcrWY1Giu1WDDIByJDpEtBp/ktVceSZ2ZGN8WA0UDFOBL6FrA419WkdGlMuw
         rpk3rp/YEGmIcCtsN8yhqzjwEbT6KBOLSt6Tz5eE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 198/231] ASoC: wm_adsp: Fix event for preloader
Date:   Tue, 19 Jul 2022 13:54:43 +0200
Message-Id: <20220719114730.718305101@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 9896c029f0df628c6cb108253d09b1d61f1d4a88 ]

The preloader controls on ADSP should return a value of 1 if the
preloader value was changed, update to correct this.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220621102041.1713504-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm_adsp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index 9cfd4f18493f..d3ecff3bdef2 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -997,7 +997,7 @@ int wm_adsp2_preloader_put(struct snd_kcontrol *kcontrol,
 		snd_soc_dapm_sync(dapm);
 	}
 
-	return 0;
+	return 1;
 }
 EXPORT_SYMBOL_GPL(wm_adsp2_preloader_put);
 
-- 
2.35.1



