Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB1DC4F3214
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353650AbiDEKIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345181AbiDEJWU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:22:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0B92A714;
        Tue,  5 Apr 2022 02:09:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3995B81BAE;
        Tue,  5 Apr 2022 09:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB67C385A2;
        Tue,  5 Apr 2022 09:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149771;
        bh=111nFQNGUUvNUOoM3silLV8vcRp4KOZ0W6kSv0vS8KU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OFZ9fytw+H6Cqd5PkoIjOnzr+iLrcWC49DStxgMSZ85AYAy/2hrj2JHX5+T6N78Uw
         8qrMmumMJl7CgCsHOkNRrRjcIkzeTAnalxY737Dd30xd73o+cft3Qer+rxHBJ+1FEg
         ZZpCkU+8DzSKU2A9rnfO3MK2Oie+MiYYxCbHSsaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0833/1017] ASoC: soc-core: skip zero num_dai component in searching dai name
Date:   Tue,  5 Apr 2022 09:29:06 +0200
Message-Id: <20220405070418.970627526@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index dcf6be4c4aaa..0dc89f568407 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -3184,7 +3184,7 @@ int snd_soc_get_dai_name(const struct of_phandle_args *args,
 	for_each_component(pos) {
 		struct device_node *component_of_node = soc_component_to_node(pos);
 
-		if (component_of_node != args->np)
+		if (component_of_node != args->np || !pos->num_dai)
 			continue;
 
 		ret = snd_soc_component_of_xlate_dai_name(pos, args, dai_name);
-- 
2.34.1



