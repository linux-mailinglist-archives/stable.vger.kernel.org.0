Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4847C4ABB39
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384284AbiBGL1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381889AbiBGLRk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:17:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8962CC03E954;
        Mon,  7 Feb 2022 03:17:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E87DB811B2;
        Mon,  7 Feb 2022 11:17:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782D5C004E1;
        Mon,  7 Feb 2022 11:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232651;
        bh=07DXET1mUt27c2qdzB5vxavcElMoUr/eGhq3NzQRh/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iY1OjOFF4YA5B+SONB8+tptLHI7OgN7LAZRW4d/Szyc9267Hhw+Ipgz6vT8gjuITB
         BeDtUGAqdTgoMNVza0GaY9hJ0OnIgVK6kLqwYlouxbEhv1Yn0DO6xdWQAV/GthilDA
         FzWWZkyq+zQt6xKBg5a4dKon6PCKAp4Cg4cW8b3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 79/86] ASoC: max9759: fix underflow in speaker_gain_control_put()
Date:   Mon,  7 Feb 2022 12:06:42 +0100
Message-Id: <20220207103800.258553455@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.550973048@linuxfoundation.org>
References: <20220207103757.550973048@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 4c907bcd9dcd233da6707059d777ab389dcbd964 upstream.

Check for negative values of "priv->gain" to prevent an out of bounds
access.  The concern is that these might come from the user via:
  -> snd_ctl_elem_write_user()
    -> snd_ctl_elem_write()
      -> kctl->put()

Fixes: fa8d915172b8 ("ASoC: max9759: Add Amplifier Driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20220119123101.GA9509@kili
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/max9759.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/soc/codecs/max9759.c
+++ b/sound/soc/codecs/max9759.c
@@ -64,7 +64,8 @@ static int speaker_gain_control_put(stru
 	struct snd_soc_component *c = snd_soc_kcontrol_component(kcontrol);
 	struct max9759 *priv = snd_soc_component_get_drvdata(c);
 
-	if (ucontrol->value.integer.value[0] > 3)
+	if (ucontrol->value.integer.value[0] < 0 ||
+	    ucontrol->value.integer.value[0] > 3)
 		return -EINVAL;
 
 	priv->gain = ucontrol->value.integer.value[0];


