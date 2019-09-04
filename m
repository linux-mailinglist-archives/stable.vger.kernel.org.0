Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24BADA8E0A
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732863AbfIDRzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:55:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:60904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732839AbfIDRzn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:55:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F89822CF7;
        Wed,  4 Sep 2019 17:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619742;
        bh=ScZ5QTYk4GXp07IKFfpar44gcHvE3kABQmHUVVU2oN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sDq2n5a060MfafOeY3WQJKWqaw62X58EP67ZhCVBXsVf1XYDC/wMjaJAkXit+y9Px
         7VryDef6Qn3fHZ9fSe19fxPmV8baKUUsF8iPAPDPL4/cXeR6vvyAjFT1qJUBUkrH0s
         tFYSfzIj/RcJd7llZyGW2sG5YDFt6efkEU9UI8Ws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ricard Wanderlof <ricardw@axis.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 06/77] ASoC: Fail card instantiation if DAI format setup fails
Date:   Wed,  4 Sep 2019 19:52:53 +0200
Message-Id: <20190904175304.060004729@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
References: <20190904175303.317468926@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 40aa5383e393d72f6aa3943a4e7b1aae25a1e43b ]

If the DAI format setup fails, there is no valid communication format
between CPU and CODEC, so fail card instantiation, rather than continue
with a card that will most likely not function properly.

Signed-off-by: Ricard Wanderlof <ricardw@axis.com>
Link: https://lore.kernel.org/r/alpine.DEB.2.20.1907241132350.6338@lnxricardw1.se.axis.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index b927f9c81d922..8d10a24d38e06 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1357,8 +1357,11 @@ static int soc_probe_link_dais(struct snd_soc_card *card, int num, int order)
 		}
 	}
 
-	if (dai_link->dai_fmt)
-		snd_soc_runtime_set_dai_fmt(rtd, dai_link->dai_fmt);
+	if (dai_link->dai_fmt) {
+		ret = snd_soc_runtime_set_dai_fmt(rtd, dai_link->dai_fmt);
+		if (ret)
+			return ret;
+	}
 
 	ret = soc_post_component_init(rtd, dai_link->name);
 	if (ret)
-- 
2.20.1



