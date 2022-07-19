Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B555F5798EE
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 13:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237465AbiGSL4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 07:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237476AbiGSL4N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 07:56:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8CC841D37;
        Tue, 19 Jul 2022 04:56:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73B2360B27;
        Tue, 19 Jul 2022 11:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F98C341C6;
        Tue, 19 Jul 2022 11:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658231768;
        bh=FGbsfRAkzXDG408skh5FLJgLjQK83LBjEkUjRQg2WZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0CoJBcA24xBh266tYp66SBcBoxWE/o8dPyWWHHyWkG+MfWJZhrunmV7My2VFRSW9p
         v3LkHQWQm8N9xBa77gH7je41QA7QEXudd3DVpYoV1ATVmI/A+iFonne/BdQgmap+8i
         uitglcpl7SyW99TkuG4rT3MjIxL/PsQJaRgEQFjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 20/28] ASoC: wm5110: Fix DRE control
Date:   Tue, 19 Jul 2022 13:53:58 +0200
Message-Id: <20220719114458.073064651@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114455.701304968@linuxfoundation.org>
References: <20220719114455.701304968@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 0bc0ae9a5938d512fd5d44f11c9c04892dcf4961 ]

The DRE controls on wm5110 should return a value of 1 if the DRE state
is actually changed, update to fix this.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220621102041.1713504-2-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm5110.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm5110.c b/sound/soc/codecs/wm5110.c
index 06bae3b23fce..2b0342bcede4 100644
--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -404,6 +404,7 @@ static int wm5110_put_dre(struct snd_kcontrol *kcontrol,
 	unsigned int rnew = (!!ucontrol->value.integer.value[1]) << mc->rshift;
 	unsigned int lold, rold;
 	unsigned int lena, rena;
+	bool change = false;
 	int ret;
 
 	snd_soc_dapm_mutex_lock(dapm);
@@ -431,8 +432,8 @@ static int wm5110_put_dre(struct snd_kcontrol *kcontrol,
 		goto err;
 	}
 
-	ret = regmap_update_bits(arizona->regmap, ARIZONA_DRE_ENABLE,
-				 mask, lnew | rnew);
+	ret = regmap_update_bits_check(arizona->regmap, ARIZONA_DRE_ENABLE,
+				       mask, lnew | rnew, &change);
 	if (ret) {
 		dev_err(arizona->dev, "Failed to set DRE: %d\n", ret);
 		goto err;
@@ -445,6 +446,9 @@ static int wm5110_put_dre(struct snd_kcontrol *kcontrol,
 	if (!rnew && rold)
 		wm5110_clear_pga_volume(arizona, mc->rshift);
 
+	if (change)
+		ret = 1;
+
 err:
 	snd_soc_dapm_mutex_unlock(dapm);
 
-- 
2.35.1



