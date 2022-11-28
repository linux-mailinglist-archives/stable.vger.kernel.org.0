Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B36D263AFF2
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbiK1Rr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:47:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233868AbiK1Rr0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:47:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8C427900;
        Mon, 28 Nov 2022 09:42:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E790612C4;
        Mon, 28 Nov 2022 17:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8A0C433D6;
        Mon, 28 Nov 2022 17:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657346;
        bh=kodpPhPiGEHVncs7lHlgeyBV0cizVTBtEmqJi9UoSh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TNt4nvx2GI4uw/M7r4ahCIA/eEz8RmlBGLKPk24XJDs28rG4qrg3xVNPGbVCloI/3
         3vM14af2VjIAVhgba1HZY9clnEiWELPQ57WeJsLBy8Lq0uvP8VBoUpN50tctENKm34
         NdKWfO4ixSlLdBlmz5vHE0/Pj+Dd44lYlqkcCyHnPacQ66V1VPGp+pzkKcqM65p6Q6
         8Sa23uYMkRWDf+vOy+nJO+Cv5C2YUX+rUTt59xuBSXioF3t6PdoGNOGwpkZ/d6iwV/
         pYRm7R60n0yapPIgfREa/bd6mvL+SKEbdSzKs+ug+04/YL1DGT3WpnJUCQElFKb/ps
         VRFv/Z46/Jlwg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 12/16] ASoC: soc-pcm: Add NULL check in BE reparenting
Date:   Mon, 28 Nov 2022 12:41:55 -0500
Message-Id: <20221128174201.1442499-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128174201.1442499-1-sashal@kernel.org>
References: <20221128174201.1442499-1-sashal@kernel.org>
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

From: Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>

[ Upstream commit db8f91d424fe0ea6db337aca8bc05908bbce1498 ]

Add NULL check in dpcm_be_reparent API, to handle
kernel NULL pointer dereference error.
The issue occurred in fuzzing test.

Signed-off-by: Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>
Link: https://lore.kernel.org/r/1669098673-29703-1-git-send-email-quic_srivasam@quicinc.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-pcm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 1196167364d4..2f1ab70a68fc 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1201,6 +1201,8 @@ static void dpcm_be_reparent(struct snd_soc_pcm_runtime *fe,
 		return;
 
 	be_substream = snd_soc_dpcm_get_substream(be, stream);
+	if (!be_substream)
+		return;
 
 	for_each_dpcm_fe(be, stream, dpcm) {
 		if (dpcm->fe == fe)
-- 
2.35.1

