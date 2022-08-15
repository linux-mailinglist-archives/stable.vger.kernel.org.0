Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55453594CAB
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbiHPAmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244311AbiHPAkG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:40:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB67818D59C;
        Mon, 15 Aug 2022 13:38:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66D9D61185;
        Mon, 15 Aug 2022 20:38:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59807C433C1;
        Mon, 15 Aug 2022 20:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595926;
        bh=tF6X0cVbkIYmd45yS0JO877bUIEvIeiAB9OCmGl9T3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=swz5vup62/ISlbz0Ji77QJ9jphMVY/TFVMcnZtSJu5CguZq+gTOLDqrf0wy02ugoR
         vGIOyWy9uCWM53eO2Re+Pslp7+VNBqPRM6n467csl9UPoqC2oTra03oYvV6lS6H69l
         AebVtFgfp2CHql9HRjUrusjvbk+Ji7LgC0+vB7HE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        =?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0918/1157] ASoC: soc-core.c: fixup snd_soc_of_get_dai_link_cpus()
Date:   Mon, 15 Aug 2022 20:04:34 +0200
Message-Id: <20220815180516.164608792@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 586fb2641371cf7f23a401ab1c79b17e3ec457f4 ]

commit 900dedd7e47cc3f ("ASoC: Introduce snd_soc_of_get_dai_link_cpus")
adds new snd_soc_of_get_dai_link_cpus(), but it is using
"codec" everywhere. It is very strange, and is issue when error case.
It should call cpu instead of codec in error case.
This patch tidyup it.

Fixes: 900dedd7e47cc3f ("ASoC: Introduce snd_soc_of_get_dai_link_cpus")
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Reviewed-by: Martin Povišer <povik+lin@cutebit.org>
Link: https://lore.kernel.org/r/87zgi5p7k1.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-core.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 9574f86dd4de..46f0e8eb79b3 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -3433,26 +3433,26 @@ int snd_soc_of_get_dai_link_cpus(struct device *dev,
 	struct of_phandle_args args;
 	struct snd_soc_dai_link_component *component;
 	char *name;
-	int index, num_codecs, ret;
+	int index, num_cpus, ret;
 
-	/* Count the number of CODECs */
+	/* Count the number of CPUs */
 	name = "sound-dai";
-	num_codecs = of_count_phandle_with_args(of_node, name,
+	num_cpus = of_count_phandle_with_args(of_node, name,
 						"#sound-dai-cells");
-	if (num_codecs <= 0) {
-		if (num_codecs == -ENOENT)
+	if (num_cpus <= 0) {
+		if (num_cpus == -ENOENT)
 			dev_err(dev, "No 'sound-dai' property\n");
 		else
 			dev_err(dev, "Bad phandle in 'sound-dai'\n");
-		return num_codecs;
+		return num_cpus;
 	}
 	component = devm_kcalloc(dev,
-				 num_codecs, sizeof(*component),
+				 num_cpus, sizeof(*component),
 				 GFP_KERNEL);
 	if (!component)
 		return -ENOMEM;
 	dai_link->cpus = component;
-	dai_link->num_cpus = num_codecs;
+	dai_link->num_cpus = num_cpus;
 
 	/* Parse the list */
 	for_each_link_cpus(dai_link, index, component) {
@@ -3468,7 +3468,7 @@ int snd_soc_of_get_dai_link_cpus(struct device *dev,
 	}
 	return 0;
 err:
-	snd_soc_of_put_dai_link_codecs(dai_link);
+	snd_soc_of_put_dai_link_cpus(dai_link);
 	dai_link->cpus = NULL;
 	dai_link->num_cpus = 0;
 	return ret;
-- 
2.35.1



