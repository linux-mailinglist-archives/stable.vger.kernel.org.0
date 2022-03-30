Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8AA4EC1C4
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345049AbiC3L5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345500AbiC3Lyg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:54:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE628285681;
        Wed, 30 Mar 2022 04:51:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 182B961637;
        Wed, 30 Mar 2022 11:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC97C340F2;
        Wed, 30 Mar 2022 11:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641054;
        bh=U5KdjcZpRwnm8d/Y39hurzwu6xnD8BhkqRY0h6mwIEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ggcEj8X6g5+CPicTa5bTzT5sI0bvvXHc+iWSTbxVGGZ5rPpZVDCtHB/wSubfEPcns
         2mtTzGp1U7xqcKyxDUdZ7xDUKVS60nvDx/1DSSz0ryocj7TdYMYufC31ATr5iIW9s0
         GD+6ZwiSbGMjo50G639OxG7E3TC5rOoiUVAKFtmoSQEQhmFKScoBAyKq6b1SRRZU6n
         iTLPohf21UWWaEXg0Au1BFwyOJ8Mgf38c/TPh3Ma3udbzICrnox1PQQwasqI0G9frq
         2pm8j3Zj7NVCDrjSEE0MxeZ04kzk9/IKVdn+NzjMogLnkEI/SPCKLDt5RZ9v76sRCj
         PQtsg1C3K2rBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 32/50] ASoC: soc-core: skip zero num_dai component in searching dai name
Date:   Wed, 30 Mar 2022 07:49:46 -0400
Message-Id: <20220330115005.1671090-32-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115005.1671090-1-sashal@kernel.org>
References: <20220330115005.1671090-1-sashal@kernel.org>
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
index 80ca260595fd..5da762807824 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -3208,7 +3208,7 @@ int snd_soc_get_dai_name(const struct of_phandle_args *args,
 	for_each_component(pos) {
 		struct device_node *component_of_node = soc_component_to_node(pos);
 
-		if (component_of_node != args->np)
+		if (component_of_node != args->np || !pos->num_dai)
 			continue;
 
 		ret = snd_soc_component_of_xlate_dai_name(pos, args, dai_name);
-- 
2.34.1

