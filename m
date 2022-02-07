Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE434ABB77
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359393AbiBGL2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:28:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383537AbiBGLWx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:22:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CC6C043181;
        Mon,  7 Feb 2022 03:22:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 852BE61380;
        Mon,  7 Feb 2022 11:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EAD6C004E1;
        Mon,  7 Feb 2022 11:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232972;
        bh=07DXET1mUt27c2qdzB5vxavcElMoUr/eGhq3NzQRh/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1pHTi5bOijZ8kYen/So6i/BAoXZ4cqpVCT3Rg3F1LSlgAxfdjyVQaAp+f/Z1kqFQz
         Zz8t3aZG9kXYdk5l7r2J05XyvmDnvBT0eOccSddss7AgB2iIQgxCWN5dcZyQwmTOGM
         Xbh7u+dYsmocEjO4ZKlLT0gcfKD8r9QevHWEKubE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 48/74] ASoC: max9759: fix underflow in speaker_gain_control_put()
Date:   Mon,  7 Feb 2022 12:06:46 +0100
Message-Id: <20220207103758.795570151@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
References: <20220207103757.232676988@linuxfoundation.org>
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


