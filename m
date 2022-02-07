Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D6F4ABA4C
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiBGLZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:25:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355803AbiBGLMq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:12:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3FEC043181;
        Mon,  7 Feb 2022 03:12:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49906611AA;
        Mon,  7 Feb 2022 11:12:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1FEC340F0;
        Mon,  7 Feb 2022 11:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232364;
        bh=vkO4ua145R0keyih7o+xMQabayYOpPFOejC9Fq+jX6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pvz4UL5///FmJVnv4psJCqvR5kU9L2y7KugLqrNt3WzxyJkdjAuXpwk49azjb+/AB
         0D+oSP3TRzjxSZ1DqGmbkEzivQfxCp9U+gBt59Stk/6KmTkg2obqqTlYzo8H6Dplx5
         /OFMLAhGGSGFHAguxBEzV4IQVxlY2hb39mIHkT+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.14 47/69] ASoC: ops: Reject out of bounds values in snd_soc_put_volsw()
Date:   Mon,  7 Feb 2022 12:06:09 +0100
Message-Id: <20220207103757.171298534@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103755.604121441@linuxfoundation.org>
References: <20220207103755.604121441@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

commit 817f7c9335ec01e0f5e8caffc4f1dcd5e458a4c0 upstream.

We don't currently validate that the values being set are within the range
we advertised to userspace as being valid, do so and reject any values
that are out of range.

Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220124153253.3548853-2-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/soc-ops.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -327,13 +327,27 @@ int snd_soc_put_volsw(struct snd_kcontro
 	if (sign_bit)
 		mask = BIT(sign_bit + 1) - 1;
 
-	val = ((ucontrol->value.integer.value[0] + min) & mask);
+	val = ucontrol->value.integer.value[0];
+	if (mc->platform_max && val > mc->platform_max)
+		return -EINVAL;
+	if (val > max - min)
+		return -EINVAL;
+	if (val < 0)
+		return -EINVAL;
+	val = (val + min) & mask;
 	if (invert)
 		val = max - val;
 	val_mask = mask << shift;
 	val = val << shift;
 	if (snd_soc_volsw_is_stereo(mc)) {
-		val2 = ((ucontrol->value.integer.value[1] + min) & mask);
+		val2 = ucontrol->value.integer.value[1];
+		if (mc->platform_max && val2 > mc->platform_max)
+			return -EINVAL;
+		if (val2 > max - min)
+			return -EINVAL;
+		if (val2 < 0)
+			return -EINVAL;
+		val2 = (val2 + min) & mask;
 		if (invert)
 			val2 = max - val2;
 		if (reg == reg2) {


