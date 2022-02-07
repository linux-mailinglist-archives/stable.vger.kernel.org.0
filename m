Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 285E34ABDB2
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 13:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389007AbiBGLpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378775AbiBGLf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:35:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383F0C0401D9;
        Mon,  7 Feb 2022 03:35:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A411160B20;
        Mon,  7 Feb 2022 11:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB8EC004E1;
        Mon,  7 Feb 2022 11:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233749;
        bh=esiT/hIJxVX2S5Y8Ay8ItBQhf+iGcOTS78pGTHXvBrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l4iRpQEH5NPZLRRias6/jFUGCGSjoodc/6YTDZPOWvOq93K+v/bJeJDzt300XAn0o
         Y+tNYDtNmJQxrUOloNJHwZt90bXWfHMt6REXgqouMDjZdMSRWzOx6ZTcMc9F3sgBVG
         lvqlwvxmIx+KwEGRPdosiHnj9HWpifyT9F2eMnvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.16 091/126] ASoC: codecs: wcd938x: fix return value of mixer put function
Date:   Mon,  7 Feb 2022 12:07:02 +0100
Message-Id: <20220207103807.234352095@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
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

commit bd2347fd67d8da0fa76296507cc556da0a233bcb upstream.

wcd938x_ear_pa_put_gain, wcd938x_set_swr_port and  wcd938x_set_compander
currently returns zero eventhough it changes the value.
Fix this, so that change notifications are sent correctly.

Fixes: e8ba1e05bdc01 ("ASoC: codecs: wcd938x: add basic controls")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220126113549.8853-4-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wcd938x.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/soc/codecs/wcd938x.c
+++ b/sound/soc/codecs/wcd938x.c
@@ -2559,7 +2559,7 @@ static int wcd938x_ear_pa_put_gain(struc
 				      WCD938X_EAR_GAIN_MASK,
 				      ucontrol->value.integer.value[0]);
 
-	return 0;
+	return 1;
 }
 
 static int wcd938x_get_compander(struct snd_kcontrol *kcontrol,
@@ -2610,7 +2610,7 @@ static int wcd938x_set_compander(struct
 	else
 		wcd938x_connect_port(wcd, portidx, mc->reg, false);
 
-	return 0;
+	return 1;
 }
 
 static int wcd938x_ldoh_get(struct snd_kcontrol *kcontrol,
@@ -2917,7 +2917,7 @@ static int wcd938x_set_swr_port(struct s
 
 	wcd938x_connect_port(wcd, portidx, ch_idx, enable);
 
-	return 0;
+	return 1;
 
 }
 


