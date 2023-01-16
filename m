Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB2366C1D6
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbjAPOPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:15:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232752AbjAPOOc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:14:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0582ED6F;
        Mon, 16 Jan 2023 06:05:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6F41B80F9E;
        Mon, 16 Jan 2023 14:05:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED55C43392;
        Mon, 16 Jan 2023 14:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877936;
        bh=yc5OYjMqNcPoUPNOcHjmUyy1SW2ocbOgpitqHAhQQrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aODN7lTzhhNBPHx0mrjxEIk/YzzpP1l2FzujXpJrMVFdCxjbIDC51x7SjWizxLaKq
         5XQZs5UQF2omHaXjM+9RVB/ofxvtT6fCJK5ElipFfOBbAIRiNltLAk9lfJqf77TB9F
         dyOhchbzwJhtBZk0L0ylWGIt0clvyyOJ3w/qifCtuc0eR4rrkqvPV9Tr8ztNQW9lTS
         twRw4yxmMW47K0ygIDgfJdkCKXSzeQtJUWVI4zI8YUN5CjT6OCM4tTm+xch1ZXI18H
         BXHC928SQhQyZeoaIxPAat/f7DdWL+MvpWHTOnL6UrUzN0aiQzeYX04ZjzSZmS4J93
         LT07Gdva5qdtg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>,
        Shengjiu Wang <shengjiu.wang@gmail.com>,
        Sasha Levin <sashal@kernel.org>, Xiubo.Lee@gmail.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 08/16] ASoC: fsl-asoc-card: Fix naming of AC'97 CODEC widgets
Date:   Mon, 16 Jan 2023 09:05:11 -0500
Message-Id: <20230116140520.116257-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140520.116257-1-sashal@kernel.org>
References: <20230116140520.116257-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 242fc66ae6e1e2b8519daacc7590a73cd0e8a6e4 ]

The fsl-asoc-card AC'97 support currently tries to route to Playback and
Capture widgets provided by the AC'97 CODEC. This doesn't work since the
generic AC'97 driver registers with an "AC97" at the front of the stream
and hence widget names, update to reflect reality. It's not clear to me
if or how this ever worked.

Acked-by: Shengjiu Wang <shengjiu.wang@gmail.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20230106-asoc-udoo-probe-v1-2-a5d7469d4f67@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl-asoc-card.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/fsl/fsl-asoc-card.c b/sound/soc/fsl/fsl-asoc-card.c
index d78eb9f9d24c..db663e7d17a4 100644
--- a/sound/soc/fsl/fsl-asoc-card.c
+++ b/sound/soc/fsl/fsl-asoc-card.c
@@ -112,8 +112,8 @@ static const struct snd_soc_dapm_route audio_map[] = {
 
 static const struct snd_soc_dapm_route audio_map_ac97[] = {
 	/* 1st half -- Normal DAPM routes */
-	{"Playback",  NULL, "CPU AC97 Playback"},
-	{"CPU AC97 Capture",  NULL, "Capture"},
+	{"AC97 Playback",  NULL, "CPU AC97 Playback"},
+	{"CPU AC97 Capture",  NULL, "AC97 Capture"},
 	/* 2nd half -- ASRC DAPM routes */
 	{"CPU AC97 Playback",  NULL, "ASRC-Playback"},
 	{"ASRC-Capture",  NULL, "CPU AC97 Capture"},
-- 
2.35.1

