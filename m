Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A15BC9E16E
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731273AbfH0H7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:59:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730030AbfH0H7o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:59:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E53DC206BF;
        Tue, 27 Aug 2019 07:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892783;
        bh=xcF3pwW281JUt2RUmFVom/YBg0958fmp5Qz9HKBi+EA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yfK8xC3CNJ8zVA9fux/kDbhXfG5sPxlBsx134ZxFyYBSOSj1e/4P55CFHm+Qst68F
         GhGdv7HRN1JMjjv26VsMJgAAXB0pjIxPlr1kh2/6KTz/UwqNftBq6wtCLm1ZNbABBN
         9eePRGm4Hmz4lVzLuSZzy8pM135Z7SvxjBPFcpbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wen.yang99@zte.com.cn>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 003/162] ASoC: simple-card: fix an use-after-free in simple_for_each_link()
Date:   Tue, 27 Aug 2019 09:48:51 +0200
Message-Id: <20190827072738.264961530@linuxfoundation.org>
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



