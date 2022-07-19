Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1E99579D20
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241493AbiGSMrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239317AbiGSMqm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:46:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A9E8BA85;
        Tue, 19 Jul 2022 05:18:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5398861746;
        Tue, 19 Jul 2022 12:18:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44502C341C6;
        Tue, 19 Jul 2022 12:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233105;
        bh=RUUKpFFgLZU5wPepFLY7h5IaUmNL/AXE1xUV7qaneFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qzXDM5lZjA8/wxh/dsVhHcoubTpAH+nY/PiksvhnOqF0MLeWJ7EFWheUUTdUG6oE9
         MZacW5BgZr/CpXQm9wKt9pZU2BvsXkZtR1nqNEt9eFpHSJK3jcremhxRvnRl76jmvY
         A4ZEruvS7fAaTcnk16aISYwBo7/ZHpmbHE9PEuPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 140/167] ASoC: wcd938x: Fix event generation for some controls
Date:   Tue, 19 Jul 2022 13:54:32 +0200
Message-Id: <20220719114710.032619335@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 10e7ff0047921e32b919ecee7be706dd33c107f8 ]

Currently wcd938x_*_put() unconditionally report that the value of the
control changed, resulting in spurious events being generated. Return 0 in
that case instead as we should. There is still an issue in the compander
control which is a bit more complex.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/r/20220603122526.3914942-1-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd938x.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/soc/codecs/wcd938x.c b/sound/soc/codecs/wcd938x.c
index 4480c118ed5d..8cdc45e669f2 100644
--- a/sound/soc/codecs/wcd938x.c
+++ b/sound/soc/codecs/wcd938x.c
@@ -2517,6 +2517,9 @@ static int wcd938x_tx_mode_put(struct snd_kcontrol *kcontrol,
 	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
 	int path = e->shift_l;
 
+	if (wcd938x->tx_mode[path] == ucontrol->value.enumerated.item[0])
+		return 0;
+
 	wcd938x->tx_mode[path] = ucontrol->value.enumerated.item[0];
 
 	return 1;
@@ -2539,6 +2542,9 @@ static int wcd938x_rx_hph_mode_put(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
 	struct wcd938x_priv *wcd938x = snd_soc_component_get_drvdata(component);
 
+	if (wcd938x->hph_mode == ucontrol->value.enumerated.item[0])
+		return 0;
+
 	wcd938x->hph_mode = ucontrol->value.enumerated.item[0];
 
 	return 1;
@@ -2630,6 +2636,9 @@ static int wcd938x_ldoh_put(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
 	struct wcd938x_priv *wcd938x = snd_soc_component_get_drvdata(component);
 
+	if (wcd938x->ldoh == ucontrol->value.integer.value[0])
+		return 0;
+
 	wcd938x->ldoh = ucontrol->value.integer.value[0];
 
 	return 1;
@@ -2652,6 +2661,9 @@ static int wcd938x_bcs_put(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
 	struct wcd938x_priv *wcd938x = snd_soc_component_get_drvdata(component);
 
+	if (wcd938x->bcs_dis == ucontrol->value.integer.value[0])
+		return 0;
+
 	wcd938x->bcs_dis = ucontrol->value.integer.value[0];
 
 	return 1;
-- 
2.35.1



