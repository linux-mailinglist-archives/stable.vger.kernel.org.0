Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C542470E5
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390445AbgHQSRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:17:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388376AbgHQQFo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:05:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A79A820748;
        Mon, 17 Aug 2020 16:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680339;
        bh=9cWvJtpb0yUXyiUKt+lWycMgFqe/Z1V/1bKWEND9nUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tbwPhf9a/cu3SYN/rRU5x2x4Wle+2PKUsN4ro80I7xFjj8yggy5cTcBYjAA/AXlSp
         gSucn0EKdRbfYewEbm6cDzxKHKBkymzIZHe5XMZVLlLTWjP0W0wnrkQ9MRhNTTO0od
         ioDbMoRQcaNSu1ogi8WaKSo55B8u35A41GToNt4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 147/270] ASoC: meson: fixes the missed kfree() for axg_card_add_tdm_loopback
Date:   Mon, 17 Aug 2020 17:15:48 +0200
Message-Id: <20200817143803.132321114@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>

[ Upstream commit bd054ece7d9cdd88e900df6625e951a01d9f655e ]

axg_card_add_tdm_loopback() misses to call kfree() in an error path. We
can use devm_kasprintf() to fix the issue, also improve maintainability.
So use it instead.

Fixes: c84836d7f650 ("ASoC: meson: axg-card: use modern dai_link style")
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Reviewed-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20200717082242.130627-1-jingxiangfeng@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/axg-card.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/meson/axg-card.c b/sound/soc/meson/axg-card.c
index 1f698adde506c..7126344017fa6 100644
--- a/sound/soc/meson/axg-card.c
+++ b/sound/soc/meson/axg-card.c
@@ -266,7 +266,7 @@ static int axg_card_add_tdm_loopback(struct snd_soc_card *card,
 
 	lb = &card->dai_link[*index + 1];
 
-	lb->name = kasprintf(GFP_KERNEL, "%s-lb", pad->name);
+	lb->name = devm_kasprintf(card->dev, GFP_KERNEL, "%s-lb", pad->name);
 	if (!lb->name)
 		return -ENOMEM;
 
-- 
2.25.1



