Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5964B8C88A
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbfHNCQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:16:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728992AbfHNCQR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:16:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E06902133F;
        Wed, 14 Aug 2019 02:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748976;
        bh=yR0Bwe2hLotHOgOBT0ItHLz8LNWZjOMnQDA3JpCv/8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WMImMAzFdvCC0cxSe0rFeRnAtG31n1rH/LMYrmbnZUvIy/itysDBqRdmUmO2uPgpE
         U9C2m0TVRuPYYmu0Zt0NhOhPZakfU0XQuat+lhcIVqYqnkv/mI7SWi0J4TEJHtDCgU
         Zs5GjhmKJkhsxdxVkd8VnOqQDS6gU/w6Vc9IXVh0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ricard Wanderlof <ricard.wanderlof@axis.com>,
        Ricard Wanderlof <ricardw@axis.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 16/68] ASoC: Fail card instantiation if DAI format setup fails
Date:   Tue, 13 Aug 2019 22:14:54 -0400
Message-Id: <20190814021548.16001-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021548.16001-1-sashal@kernel.org>
References: <20190814021548.16001-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricard Wanderlof <ricard.wanderlof@axis.com>

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
index 62aa320c20708..dafc3b7f8d723 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1513,8 +1513,11 @@ static int soc_probe_link_dais(struct snd_soc_card *card,
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

