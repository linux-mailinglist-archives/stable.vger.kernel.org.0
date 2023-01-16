Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 621B866C872
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233580AbjAPQjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233488AbjAPQiu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:38:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A457B34568
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:27:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6877161083
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D06BC433F2;
        Mon, 16 Jan 2023 16:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886453;
        bh=+27C/0b0foiGuIh079CADww5J4m9OPdTFKDfV1YFugU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s8VT38hpVoQg1FkvH5mZtvglh+1ypIlHaqOMpQCNS7C+5LyzmBvryjSmOGS38EtmD
         rMmuQqPr0CgxwBVHDoBFyx9Q+Fz1zC61sMjSZp18ce0bArE/V+bZHG0PeQ+r6NxTig
         f1mawFANMM/B4CcjjIlXoS0f13Oy5UN3Oh5x8B+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 436/658] ASoC: wm8994: Fix potential deadlock
Date:   Mon, 16 Jan 2023 16:48:44 +0100
Message-Id: <20230116154929.501485219@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 9529dc167ffcdfd201b9f0eda71015f174095f7e ]

Fix this by dropping wm8994->accdet_lock while calling
cancel_delayed_work_sync(&wm8994->mic_work) in wm1811_jackdet_irq().

Fixes: c0cc3f166525 ("ASoC: wm8994: Allow a delay between jack insertion and microphone detect")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20221209091657.1183-1-m.szyprowski@samsung.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8994.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 6dbab3fc6537..4ae7ec8d71cd 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -3711,7 +3711,12 @@ static irqreturn_t wm1811_jackdet_irq(int irq, void *data)
 	} else {
 		dev_dbg(component->dev, "Jack not detected\n");
 
+		/* Release wm8994->accdet_lock to avoid deadlock:
+		 * cancel_delayed_work_sync() takes wm8994->mic_work internal
+		 * lock and wm1811_mic_work takes wm8994->accdet_lock */
+		mutex_unlock(&wm8994->accdet_lock);
 		cancel_delayed_work_sync(&wm8994->mic_work);
+		mutex_lock(&wm8994->accdet_lock);
 
 		snd_soc_component_update_bits(component, WM8958_MICBIAS2,
 				    WM8958_MICB2_DISCH, WM8958_MICB2_DISCH);
-- 
2.35.1



