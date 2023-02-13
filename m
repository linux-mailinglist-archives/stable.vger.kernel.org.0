Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87B47694985
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbjBMO7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:59:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbjBMO72 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:59:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55231DB8A
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:59:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97C4DB81257
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:59:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1449BC433D2;
        Mon, 13 Feb 2023 14:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300344;
        bh=G1hbgvGyTA1ykW6a6sTrxkWMUvTi6Q8w6wMd0ycfdUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VyEu2r406zjfp/wX9X6k9R5MWZYl4kW3FM+jQvmigtW8Evwt72GvS7fLRQzJ06JR1
         OoyFpvwELAG8S8L+D2Sa+x3WR/bRNphySffUeqMqxyRMjQCRIwsaAwSW/Xy7+MDGbI
         Pot2ULmbgJajpJi94hSm2oSwFPJVDlaqNNvq3B9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 43/67] ASoC: topology: Return -ENOMEM on memory allocation failure
Date:   Mon, 13 Feb 2023 15:49:24 +0100
Message-Id: <20230213144734.407217526@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit c173ee5b2fa6195066674d66d1d7e191010fb1ff ]

When handling error path, ret needs to be set to correct value.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Fixes: d29d41e28eea ("ASoC: topology: Add support for multiple kcontrol types to a widget")
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://lore.kernel.org/r/20230207210428.2076354-1-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-topology.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index eff8d4f715611..55b69e3c67186 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -1480,13 +1480,17 @@ static int soc_tplg_dapm_widget_create(struct soc_tplg *tplg,
 
 	template.num_kcontrols = le32_to_cpu(w->num_kcontrols);
 	kc = devm_kcalloc(tplg->dev, le32_to_cpu(w->num_kcontrols), sizeof(*kc), GFP_KERNEL);
-	if (!kc)
+	if (!kc) {
+		ret = -ENOMEM;
 		goto hdr_err;
+	}
 
 	kcontrol_type = devm_kcalloc(tplg->dev, le32_to_cpu(w->num_kcontrols), sizeof(unsigned int),
 				     GFP_KERNEL);
-	if (!kcontrol_type)
+	if (!kcontrol_type) {
+		ret = -ENOMEM;
 		goto hdr_err;
+	}
 
 	for (i = 0; i < w->num_kcontrols; i++) {
 		control_hdr = (struct snd_soc_tplg_ctl_hdr *)tplg->pos;
-- 
2.39.0



