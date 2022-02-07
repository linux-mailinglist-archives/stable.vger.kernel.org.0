Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57EEE4ABC3C
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385070AbiBGLbD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352941AbiBGLZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:25:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8685BC0401C8;
        Mon,  7 Feb 2022 03:25:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48098B81028;
        Mon,  7 Feb 2022 11:25:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DEDFC004E1;
        Mon,  7 Feb 2022 11:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233109;
        bh=PXxvrLo0f5n0j+2ESXkHAGvNHfjbEgwhgKzsc6FW1F4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iG5vhJGLs+OLRSd+nwub68O2lJD1RSWeaBOdQpYAPHZgrSHe33xT4KyNGoxd018EU
         xLaPqtUxotsMQG31FRPPQtyzLsLHmu87/+PM4pBNa/y8HetS8StrokdDA3CArGAXxe
         P1VlJRVXhyblynBl8TUioYeNDQ1eEFq1nZ6oxmPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 007/110] ASoC: ops: Reject out of bounds values in snd_soc_put_volsw()
Date:   Mon,  7 Feb 2022 12:05:40 +0100
Message-Id: <20220207103802.532613748@linuxfoundation.org>
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
@@ -316,13 +316,27 @@ int snd_soc_put_volsw(struct snd_kcontro
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


