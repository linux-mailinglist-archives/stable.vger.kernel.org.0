Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59C446355B3
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237391AbiKWJV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:21:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237496AbiKWJVD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:21:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9189E72998
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:21:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D9DB61B22
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:21:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19BB8C433D6;
        Wed, 23 Nov 2022 09:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195261;
        bh=fFxpn3bdanTQfqo8KO4i/UlcAC1E2m0ZtrDOUJ9vVw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vjV93SC68lV/IdBgbJ2Wee/mQkWIZyu84Pve8WoockyFo/M3rCoy1Ol4YCbx2TB1Z
         yHVk4bTTS2czk+l7S9kjjBhnwqwtb3fxOe3xZqdbWUVLO//lyU/H5Lo396ChcvzyOc
         byciSxmz0kSeybYG8NKW4ZitaPVMK6xMPirA0pXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jos Dehaes <jos.dehaes@gmail.com>,
        =?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/149] ASoC: tas2764: Fix set_tdm_slot in case of single slot
Date:   Wed, 23 Nov 2022 09:50:18 +0100
Message-Id: <20221123084559.261724203@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
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

From: Martin Povišer <povik+lin@cutebit.org>

[ Upstream commit faac764ea1ea6898d93e46c403271fb105c0906e ]

There's a special branch in the set_tdm_slot op for the case of nslots
being 1, but:

 (1) That branch can never work (there's a check for tx_mask being
     non-zero, later there's another check for it *being* zero; one or
     the other always throws -EINVAL).

 (2) The intention of the branch seems to be what the general other
     branch reduces to in case of nslots being 1.

For those reasons remove the 'nslots being 1' special case.

Fixes: 827ed8a0fa50 ("ASoC: tas2764: Add the driver for the TAS2764")
Suggested-by: Jos Dehaes <jos.dehaes@gmail.com>
Signed-off-by: Martin Povišer <povik+lin@cutebit.org>
Link: https://lore.kernel.org/r/20221027095800.16094-2-povik+lin@cutebit.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2764.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/sound/soc/codecs/tas2764.c b/sound/soc/codecs/tas2764.c
index 8b262e7f5275..c8f6f5122cac 100644
--- a/sound/soc/codecs/tas2764.c
+++ b/sound/soc/codecs/tas2764.c
@@ -386,20 +386,13 @@ static int tas2764_set_dai_tdm_slot(struct snd_soc_dai *dai,
 	if (tx_mask == 0 || rx_mask != 0)
 		return -EINVAL;
 
-	if (slots == 1) {
-		if (tx_mask != 1)
-			return -EINVAL;
-		left_slot = 0;
-		right_slot = 0;
+	left_slot = __ffs(tx_mask);
+	tx_mask &= ~(1 << left_slot);
+	if (tx_mask == 0) {
+		right_slot = left_slot;
 	} else {
-		left_slot = __ffs(tx_mask);
-		tx_mask &= ~(1 << left_slot);
-		if (tx_mask == 0) {
-			right_slot = left_slot;
-		} else {
-			right_slot = __ffs(tx_mask);
-			tx_mask &= ~(1 << right_slot);
-		}
+		right_slot = __ffs(tx_mask);
+		tx_mask &= ~(1 << right_slot);
 	}
 
 	if (tx_mask != 0 || left_slot >= slots || right_slot >= slots)
-- 
2.35.1



