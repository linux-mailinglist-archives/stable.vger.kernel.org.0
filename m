Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A405574270
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235011AbiGNEYz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234804AbiGNEYJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:24:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8E229802;
        Wed, 13 Jul 2022 21:22:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6721BB8237C;
        Thu, 14 Jul 2022 04:22:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5B4C341C6;
        Thu, 14 Jul 2022 04:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772576;
        bh=dt8pDqk8iKTyANiXWzkfAhvww3xMsxUF+gbazu59Dis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PSJXdR4CKJlvx9qYNN4saKAJCdyWWxGsD3HTFG9eZi5rz82LQhSsOOBNXDqXJ75eN
         YWg9uYXKAmcPYYiTVWqu3tTHYxwi9+0p+W5H8TD+jJY50lNSAKfT4M22K4axex4tWY
         XJ/QLuu2uiZ1LbxPN4EUSGFNb9imPCg4IiY0Ljh+SqgKUxlaMwsh4uWLjuTzgwT8sW
         DpINz5cZT9Oc1IozTknGlobU/p7Di7oD1jCyVeMiYtJQlS63kGSHSPy8CTcUrBHcrE
         hzkEMNAhWanOT8aYp9Fm5CjzM0DnzvA/YCirejGS6HbK/tSXqjmuh1UerZ0e4dzw9a
         bKDw1u0XfIieA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>,
        srinivas.kandagatla@linaro.org, bgoswami@quicinc.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 13/41] ASoC: wcd9335: Fix spurious event generation
Date:   Thu, 14 Jul 2022 00:21:53 -0400
Message-Id: <20220714042221.281187-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042221.281187-1-sashal@kernel.org>
References: <20220714042221.281187-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit a7786cbae4b2732815da98efa39df96746b5bd0d ]

The slimbus mux put operation unconditionally reports a change in value
which means that spurious events are generated. Fix this by exiting early
in that case.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220603124609.4024666-1-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd9335.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
index 12be043ee9a3..aa685980a97b 100644
--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -1287,6 +1287,9 @@ static int slim_rx_mux_put(struct snd_kcontrol *kc,
 	struct snd_soc_dapm_update *update = NULL;
 	u32 port_id = w->shift;
 
+	if (wcd->rx_port_value[port_id] == ucontrol->value.enumerated.item[0])
+		return 0;
+
 	wcd->rx_port_value[port_id] = ucontrol->value.enumerated.item[0];
 
 	/* Remove channel from any list it's in before adding it to a new one */
-- 
2.35.1

