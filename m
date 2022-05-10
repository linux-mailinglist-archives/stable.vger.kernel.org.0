Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41DEF52171D
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240405AbiEJNX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242878AbiEJNWj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:22:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4381A29DE;
        Tue, 10 May 2022 06:16:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC42EB81D7A;
        Tue, 10 May 2022 13:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590ECC385C6;
        Tue, 10 May 2022 13:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188602;
        bh=7ni6v9EcwTeRnymZXJCe2F2vv9mVcGy9VAalwjR/0ls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G9itMwvt8im3pN8BvabH2mjS981tB854PiDgRejri6Vj+hj8HX5mXLGkhUrU1Dlpo
         TYbFzre/5E+s3cnWuFDqs3Cg+nQ7HhlPFwpJLfyZMnHWASC4uGjMN81wsO81Wuro19
         xSNFUBAceeaQZXjRUKjWs0A6wEL+Dt3jh6qcXJ3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Charles Keepax <ckeepax@opensource.cirrus.com>
Subject: [PATCH 4.14 61/78] ASoC: wm8958: Fix change notifications for DSP controls
Date:   Tue, 10 May 2022 15:07:47 +0200
Message-Id: <20220510130734.338358207@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.522479698@linuxfoundation.org>
References: <20220510130732.522479698@linuxfoundation.org>
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
@@ -533,7 +533,7 @@ static int wm8958_mbc_put(struct snd_kco
 
 	wm8958_dsp_apply(codec, mbc, wm8994->mbc_ena[mbc]);
 
-	return 0;
+	return 1;
 }
 
 #define WM8958_MBC_SWITCH(xname, xval) {\
@@ -659,7 +659,7 @@ static int wm8958_vss_put(struct snd_kco
 
 	wm8958_dsp_apply(codec, vss, wm8994->vss_ena[vss]);
 
-	return 0;
+	return 1;
 }
 
 
@@ -733,7 +733,7 @@ static int wm8958_hpf_put(struct snd_kco
 
 	wm8958_dsp_apply(codec, hpf % 3, ucontrol->value.integer.value[0]);
 
-	return 0;
+	return 1;
 }
 
 #define WM8958_HPF_SWITCH(xname, xval) {\
@@ -827,7 +827,7 @@ static int wm8958_enh_eq_put(struct snd_
 
 	wm8958_dsp_apply(codec, eq, ucontrol->value.integer.value[0]);
 
-	return 0;
+	return 1;
 }
 
 #define WM8958_ENH_EQ_SWITCH(xname, xval) {\


