Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7DB069490B
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbjBMOzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:55:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbjBMOzc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:55:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39ABFB756
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:55:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3C6961122
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:55:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17BBC433EF;
        Mon, 13 Feb 2023 14:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300127;
        bh=3tWLMNI+rhFeIFsx8Bs6iEKpiMQhzleDU7LP1bQ7FKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VoxXwD0ywxmmxGRja+ckTUNLKNjgtWfoB3QTNAVGwI5r2ORasZh2A6nImFjsT3PMb
         aMntTSLZq46UJtJhy+PwXBzf/YL4sU2LiiLsqsLBeFYD18q3Udrjz0GPKvDWZp4trO
         HilAwVTKhalOtbc6m8u57njw8CIknhw1fxpks18Q=
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
Subject: [PATCH 6.1 069/114] ASoC: topology: Return -ENOMEM on memory allocation failure
Date:   Mon, 13 Feb 2023 15:48:24 +0100
Message-Id: <20230213144745.790479981@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
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
index c3be24b2fac55..a79a2fb260b87 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -1401,13 +1401,17 @@ static int soc_tplg_dapm_widget_create(struct soc_tplg *tplg,
 
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
 
 	for (i = 0; i < le32_to_cpu(w->num_kcontrols); i++) {
 		control_hdr = (struct snd_soc_tplg_ctl_hdr *)tplg->pos;
-- 
2.39.0



