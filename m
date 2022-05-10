Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D97852189E
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236900AbiEJNja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244194AbiEJNhL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:37:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BE32D9EEF;
        Tue, 10 May 2022 06:25:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59F1B617A5;
        Tue, 10 May 2022 13:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5842EC385C6;
        Tue, 10 May 2022 13:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189116;
        bh=U3t5kK9OCHwvOySeFZuGHZJrRFzboJZwTeQJEzdZGVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qkF6BWo8Nx8DrO0ClAjD1N6uQx52hxP9frXwhiPMTjsRleJtKmGfhUxef2P+3kUAa
         TAU214bFH2H4aCdL994CcPgs2DeL8WnTU9BDenwCiosb8ymx+WpTXHWUdxV4m7q5jG
         xgLUflk31xi9MynCrJm31+or73oNM9SnEnTsktRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Charles Keepax <ckeepax@opensource.cirrus.com>
Subject: [PATCH 5.10 18/70] ASoC: wm8958: Fix change notifications for DSP controls
Date:   Tue, 10 May 2022 15:07:37 +0200
Message-Id: <20220510130733.401041023@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.861729621@linuxfoundation.org>
References: <20220510130732.861729621@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

commit b4f5c6b2e52b27462c0599e64e96e53b58438de1 upstream.

The WM8958 DSP controls all return 0 on successful write, not a boolean
value indicating if the write changed the value of the control. Fix this
by returning 1 after a change, there is already a check at the start of
each put() that skips the function in the case that there is no change.

Signed-off-by: Mark Brown <broonie@kernel.org>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220416125408.197440-1-broonie@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wm8958-dsp2.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/sound/soc/codecs/wm8958-dsp2.c
+++ b/sound/soc/codecs/wm8958-dsp2.c
@@ -530,7 +530,7 @@ static int wm8958_mbc_put(struct snd_kco
 
 	wm8958_dsp_apply(component, mbc, wm8994->mbc_ena[mbc]);
 
-	return 0;
+	return 1;
 }
 
 #define WM8958_MBC_SWITCH(xname, xval) {\
@@ -656,7 +656,7 @@ static int wm8958_vss_put(struct snd_kco
 
 	wm8958_dsp_apply(component, vss, wm8994->vss_ena[vss]);
 
-	return 0;
+	return 1;
 }
 
 
@@ -730,7 +730,7 @@ static int wm8958_hpf_put(struct snd_kco
 
 	wm8958_dsp_apply(component, hpf % 3, ucontrol->value.integer.value[0]);
 
-	return 0;
+	return 1;
 }
 
 #define WM8958_HPF_SWITCH(xname, xval) {\
@@ -824,7 +824,7 @@ static int wm8958_enh_eq_put(struct snd_
 
 	wm8958_dsp_apply(component, eq, ucontrol->value.integer.value[0]);
 
-	return 0;
+	return 1;
 }
 
 #define WM8958_ENH_EQ_SWITCH(xname, xval) {\


