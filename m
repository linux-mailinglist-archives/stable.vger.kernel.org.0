Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78CFD66CD7F
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234947AbjAPRgk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:36:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234919AbjAPRgR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:36:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777B43C2AD
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:12:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFBC9B81071
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:12:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43306C433D2;
        Mon, 16 Jan 2023 17:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673889158;
        bh=C7C5Ik7Hf2wbOGLRgyTRdxYtnixTmXGm6fvWKsrm3tA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bGPW0lWZod5iTXBL2LWoSRx6RmfoBYdI0e2kiEESFFeG60/lyIRH+UTVPKTAKBwy0
         0SM2AXR4W3avkISyDoYHtBCUmQP028kCHHkx85n/QDDoWlj6fRaXTNLV9WhuvgP7CG
         simy3QqzXZHkkQ9qeYDmGzxFecWEEjQGXhkVSHSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 251/338] ASoC: wm8994: Fix potential deadlock
Date:   Mon, 16 Jan 2023 16:52:04 +0100
Message-Id: <20230116154832.007820019@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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
index f289762cd676..1feeeed4bfb2 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -3704,7 +3704,12 @@ static irqreturn_t wm1811_jackdet_irq(int irq, void *data)
 	} else {
 		dev_dbg(codec->dev, "Jack not detected\n");
 
+		/* Release wm8994->accdet_lock to avoid deadlock:
+		 * cancel_delayed_work_sync() takes wm8994->mic_work internal
+		 * lock and wm1811_mic_work takes wm8994->accdet_lock */
+		mutex_unlock(&wm8994->accdet_lock);
 		cancel_delayed_work_sync(&wm8994->mic_work);
+		mutex_lock(&wm8994->accdet_lock);
 
 		snd_soc_update_bits(codec, WM8958_MICBIAS2,
 				    WM8958_MICB2_DISCH, WM8958_MICB2_DISCH);
-- 
2.35.1



