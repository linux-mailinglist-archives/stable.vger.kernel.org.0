Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176B0451F0A
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352862AbhKPAiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:45214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344531AbhKOTY4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 644F8633D4;
        Mon, 15 Nov 2021 18:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002758;
        bh=+XnHw3g7g9D+RFsVTPRs+GWW8on9ZiD2JFN64wI7XZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jB8qdlV5RuJU5fmhqi5sX8h9i822gUkSKzJj73WOHURMkC4dFmysBIVxRgkZP1q9T
         jCZ6L9effyn6q5j4Ohri7c/TPl9prn21gYpuW5EQ9zLJCKPsM6z5CVg44hVtUbA36d
         HZwjW8xPP7s1ElDIm+yXeJ2xgevnAqLcBd/Ao28k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 686/917] ASoC: rsnd: Fix an error handling path in rsnd_node_count()
Date:   Mon, 15 Nov 2021 18:03:01 +0100
Message-Id: <20211115165452.159744655@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 173632358fde7a567f28e07c4549b959ee857986 ]

If we return before the end of the 'for_each_child_of_node()' iterator, the
reference taken on 'np' must be released.

Add the missing 'of_node_put()' call.

Fixes: c413983eb66a ("ASoC: rsnd: adjust disabled module")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/4c0e893cbfa21dc76c1ede0b6f4f8cff42209299.1634586167.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rcar/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/sh/rcar/core.c b/sound/soc/sh/rcar/core.c
index 978bd0406729a..6a8fe0da7670b 100644
--- a/sound/soc/sh/rcar/core.c
+++ b/sound/soc/sh/rcar/core.c
@@ -1225,6 +1225,7 @@ int rsnd_node_count(struct rsnd_priv *priv, struct device_node *node, char *name
 		if (i < 0) {
 			dev_err(dev, "strange node numbering (%s)",
 				of_node_full_name(node));
+			of_node_put(np);
 			return 0;
 		}
 		i++;
-- 
2.33.0



