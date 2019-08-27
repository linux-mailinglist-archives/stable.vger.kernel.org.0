Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 325129E007
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729841AbfH0H7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:59:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731307AbfH0H7x (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:59:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94384206BF;
        Tue, 27 Aug 2019 07:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892792;
        bh=8TDFbr7RkbMoGPvXkqpT52K8yZTMGptc2snI75xJq5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pQcXJHB49ROLo8OHtzZMqgXkyBhEI/kBKN68Eh02+85RmA20dHfdiHD8iNQSkP+MX
         Bfu0HGLp2gbxRlNrWZjVI/rtZBqnHV3hSey0x8+dv/rV+HiidHorO36zNoyV+0fNVY
         n+WQya8NYZM9g4NOame2c5VTtpCw17pgNPiPoOEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Wen Yang <wen.yang99@zte.com.cn>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 006/162] ASoC: audio-graph-card: add missing const at graph_get_dai_id()
Date:   Tue, 27 Aug 2019 09:48:54 +0200
Message-Id: <20190827072738.439707488@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ec3042ad39d4e2ddbc3a3344f90bb10d8feb53bc ]

commit c152f8491a8d9 ("ASoC: audio-graph-card: fix an use-after-free in
graph_get_dai_id()") fixups use-after-free issue,
but, it need to use "const" for reg. This patch adds it.

We will have below without this patch

LINUX/sound/soc/generic/audio-graph-card.c: In function 'graph_get_dai_id':
LINUX/sound/soc/generic/audio-graph-card.c:87:7: warning: assignment discards\
 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
   reg = of_get_property(node, "reg", NULL);

Fixes: c152f8491a8d9 ("ASoC: audio-graph-card: fix an use-after-free in graph_get_dai_id()")
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Acked-by: Wen Yang <wen.yang99@zte.com.cn>
Link: https://lore.kernel.org/r/87sgrd43ja.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/audio-graph-card.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/generic/audio-graph-card.c b/sound/soc/generic/audio-graph-card.c
index a681ea443fc16..6398741ebd0ef 100644
--- a/sound/soc/generic/audio-graph-card.c
+++ b/sound/soc/generic/audio-graph-card.c
@@ -63,7 +63,7 @@ static int graph_get_dai_id(struct device_node *ep)
 	struct device_node *endpoint;
 	struct of_endpoint info;
 	int i, id;
-	u32 *reg;
+	const u32 *reg;
 	int ret;
 
 	/* use driver specified DAI ID if exist */
-- 
2.20.1



