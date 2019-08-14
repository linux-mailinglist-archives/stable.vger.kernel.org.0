Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 530C58C5E0
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfHNCKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:10:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726383AbfHNCKy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:10:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D11020842;
        Wed, 14 Aug 2019 02:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748653;
        bh=bqerZwTnM7WuSIJtdXA+eZuk2L2Y1zKGa2r14rGFV94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VmEtAIbkGDBjrylmaM9LpTe56CpZJRlAt8iouPF3wDHG4g3NPDK+XVWmCyw28Z/w/
         ox7MgwExnkFQotRbVoNeK5wriiTuWcWACHcFx9Ur8LHqX/gfunRujbEBNVnZ7fSRFw
         137MQGVVYfsSoceYXZ0CVcixpdx6kNyZNRcwYFfc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Yang <wen.yang99@zte.com.cn>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 003/123] ASoC: simple-card: fix an use-after-free in simple_for_each_link()
Date:   Tue, 13 Aug 2019 22:08:47 -0400
Message-Id: <20190814021047.14828-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <wen.yang99@zte.com.cn>

[ Upstream commit 27862d5a3325bc531ec15e3c607e44aa0fd57f6f ]

The codec variable is still being used after the of_node_put() call,
which may result in use-after-free.

Fixes: d947cdfd4be2 ("ASoC: simple-card: cleanup DAI link loop method - step1")
Link: https://lore.kernel.org/r/1562743509-30496-3-git-send-email-wen.yang99@zte.com.cn
Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/simple-card.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 544064fdc780c..2712a2b201024 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -378,8 +378,6 @@ static int simple_for_each_link(struct asoc_simple_priv *priv,
 			goto error;
 		}
 
-		of_node_put(codec);
-
 		/* get convert-xxx property */
 		memset(&adata, 0, sizeof(adata));
 		for_each_child_of_node(node, np)
@@ -401,11 +399,13 @@ static int simple_for_each_link(struct asoc_simple_priv *priv,
 				ret = func_noml(priv, np, codec, li, is_top);
 
 			if (ret < 0) {
+				of_node_put(codec);
 				of_node_put(np);
 				goto error;
 			}
 		}
 
+		of_node_put(codec);
 		node = of_get_next_child(top, node);
 	} while (!is_top && node);
 
-- 
2.20.1

