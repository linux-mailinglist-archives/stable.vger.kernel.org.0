Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6AFC4ABD50
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387225AbiBGLkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:40:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384770AbiBGLaA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:30:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDCD1C0401E6;
        Mon,  7 Feb 2022 03:28:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8845860918;
        Mon,  7 Feb 2022 11:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF31C004E1;
        Mon,  7 Feb 2022 11:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233300;
        bh=esiT/hIJxVX2S5Y8Ay8ItBQhf+iGcOTS78pGTHXvBrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=moOvvyJSUSZuouXvMw/OP9rpeI+UbSyY8skQ9+J6hnfAS61KaM7on2TbLbx62iX0Q
         vIL+sM8lySsPDy1znr/Ho5+qJTonSf1PLUukASvXEhlZGmKVx16j72ZQmJfqVpfuyH
         a6RIOe5Zs0oB69OhtT8TzKVnFhZUQpfEnFzvW0cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 078/110] ASoC: codecs: wcd938x: fix return value of mixer put function
Date:   Mon,  7 Feb 2022 12:06:51 +0100
Message-Id: <20220207103805.020663399@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
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
 


