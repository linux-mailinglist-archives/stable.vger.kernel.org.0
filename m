Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4694EC1F7
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244088AbiC3L5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345886AbiC3LzI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:55:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8DE265E83;
        Wed, 30 Mar 2022 04:52:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2F51B81C25;
        Wed, 30 Mar 2022 11:52:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66147C3410F;
        Wed, 30 Mar 2022 11:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641121;
        bh=ZUyGEIPqcGSavK6gDVBH0SFeUocT4xTRicNG7dXTtlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RNAMk4+6Syds3VazcoCuwKgdlgbgbHX2n1DpqXSNhK05d4ueJlmtPd0U+xrY/cf2N
         8p5DNN80tblauTrq6lxwhir5rY1k6HRXl0E4kCqHA/b5WCX8iu5NgitpiohRnAiOx9
         /WQnk5PAASYGpNYWhMSfEBQZLfQ4AMiTBgq4UvFVdIUYpZ7cZl7VFytnZnuQyHycU+
         3DRTmzwElnZyj/yT+UCHYhf3SxSp2dLW4BEtnRe9SYH4dJOLNs/U6L/KWa06p352Ji
         BCUC1xVxFjQqidee9nDHbFvXkPyNkBNQNO6ypbfyfmBkJSFlmRQJTbdG6x83j5mYhr
         X8n9k4hPBiW/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 23/37] ASoC: soc-core: skip zero num_dai component in searching dai name
Date:   Wed, 30 Mar 2022 07:51:08 -0400
Message-Id: <20220330115122.1671763-23-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115122.1671763-1-sashal@kernel.org>
References: <20220330115122.1671763-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit f7d344a2bd5ec81fbd1ce76928fd059e57ec9bea ]

In the case like dmaengine which's not a dai but as a component, the
num_dai is zero, dmaengine component has the same component_of_node
as cpu dai, when cpu dai component is not ready, but dmaengine component
is ready, try to get cpu dai name, the snd_soc_get_dai_name() return
-EINVAL, not -EPROBE_DEFER, that cause below error:

asoc-simple-card <card name>: parse error -22
asoc-simple-card: probe of <card name> failed with error -22

The sound card failed to probe.

So this patch fixes the issue above by skipping the zero num_dai
component in searching dai name.

Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1644491952-7457-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 133296596864..a6d6d10cd471 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -3020,7 +3020,7 @@ int snd_soc_get_dai_name(struct of_phandle_args *args,
 	for_each_component(pos) {
 		component_of_node = soc_component_to_node(pos);
 
-		if (component_of_node != args->np)
+		if (component_of_node != args->np || !pos->num_dai)
 			continue;
 
 		ret = snd_soc_component_of_xlate_dai_name(pos, args, dai_name);
-- 
2.34.1

