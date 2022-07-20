Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580D857AC0A
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240995AbiGTBPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241001AbiGTBPT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:15:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D52E691F5;
        Tue, 19 Jul 2022 18:13:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6FF361769;
        Wed, 20 Jul 2022 01:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18AFC341CA;
        Wed, 20 Jul 2022 01:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279604;
        bh=H6+CHYRVq143W7sez+eI90XwcYLzJ7SJBwXBuJodYv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IMm+7z0xAi+zQevlsNVKelfiNNlNvxn8tFHKIa/pHKvZx0JluXN032fUurVxGCDGH
         vVa6eYlOmMrP/LuDlwvtwCE+S/JHdbvjzPWttyg9dhaHiO7/qqLPedYhCBIvG/j+tI
         YGsPePG+frqYksCha6grmnrbaoEQWYDziaj6NksNnwYEcUeI1NwBN64bA6wM84F04x
         t7T3T0aGH+VJrmJRw/QiBFfZn1me/j0bGhotDMHaQnhf2XAbdMwHRsVnhXrto5XYk5
         4mPKc35dfFq8JYN8iZAchcG3FTxvBOxq+wbuvcUXEjJLSl4ussyhgBJQ8jsGgl8Bb4
         h7auRsB4rwabw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jianglei Nie <niejianglei2021@163.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, bgoswami@quicinc.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        pierre-louis.bossart@linux.intel.com, dan.carpenter@oracle.com,
        linmq006@gmail.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 43/54] ASoC: qdsp6: fix potential memory leak in q6apm_get_audioreach_graph()
Date:   Tue, 19 Jul 2022 21:10:20 -0400
Message-Id: <20220720011031.1023305-43-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011031.1023305-1-sashal@kernel.org>
References: <20220720011031.1023305-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianglei Nie <niejianglei2021@163.com>

[ Upstream commit df5b4aca7248dc5a5cae93f162eae0decf972e48 ]

q6apm_get_audioreach_graph() allocates a memory chunk for graph->graph
with audioreach_alloc_graph_pkt(). When idr_alloc() fails, graph->graph
is not released, which will lead to a memory leak.

We can release the graph->graph with kfree() when idr_alloc() fails to
fix the memory leak.

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220629182520.2164409-1-niejianglei2021@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6apm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/qcom/qdsp6/q6apm.c b/sound/soc/qcom/qdsp6/q6apm.c
index f424d7aa389a..794019286c70 100644
--- a/sound/soc/qcom/qdsp6/q6apm.c
+++ b/sound/soc/qcom/qdsp6/q6apm.c
@@ -75,6 +75,7 @@ static struct audioreach_graph *q6apm_get_audioreach_graph(struct q6apm *apm, ui
 	id = idr_alloc(&apm->graph_idr, graph, graph_id, graph_id + 1, GFP_KERNEL);
 	if (id < 0) {
 		dev_err(apm->dev, "Unable to allocate graph id (%d)\n", graph_id);
+		kfree(graph->graph);
 		kfree(graph);
 		mutex_unlock(&apm->lock);
 		return ERR_PTR(id);
-- 
2.35.1

