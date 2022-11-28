Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8735463B03C
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbiK1RtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:49:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233964AbiK1Rrp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:47:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD1A2A70C;
        Mon, 28 Nov 2022 09:42:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A491B80E56;
        Mon, 28 Nov 2022 17:42:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E594C43149;
        Mon, 28 Nov 2022 17:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657374;
        bh=AuLd3sjbpowRys+MOonoJBhaxU3YsOhUU6SmRGUiprE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fl4UvhwZqV+6knxNqSVD5nDl6negPs0tS7c5pQcJPDIRW3nz0SVXBUFOGpJrMo2xj
         e59mv3ekF9U+BSSFjxI8bmNaRY2nIAl7h/GnFi8dIRel8eQ2q4pWJTd+4lrR1JHEcn
         IMTBejhv3n7dz/ww28EzgPOMOboBXICT1v3PWp66SmaWTiwASq0ihnLTTXwluaeQ4N
         J8EkVN5wg8U8lhkuQsJGxr6hSRSzA3waaeU7wuNUQYXqjE5a8zdkk3RV5ZXuDErT2P
         kLC4glnS0wC1tM+ccJJIAOZy32E91bkFmwnKW4AOSKmJ5tVTmk5xtR8WddcxwW52Eb
         0CkIc5RrQ5OuA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 08/12] ASoC: soc-pcm: Add NULL check in BE reparenting
Date:   Mon, 28 Nov 2022 12:42:31 -0500
Message-Id: <20221128174235.1442841-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128174235.1442841-1-sashal@kernel.org>
References: <20221128174235.1442841-1-sashal@kernel.org>
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
index c03b653bf6ff..1fabb285b016 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1266,6 +1266,8 @@ static void dpcm_be_reparent(struct snd_soc_pcm_runtime *fe,
 		return;
 
 	be_substream = snd_soc_dpcm_get_substream(be, stream);
+	if (!be_substream)
+		return;
 
 	list_for_each_entry(dpcm, &be->dpcm[stream].fe_clients, list_fe) {
 		if (dpcm->fe == fe)
-- 
2.35.1

