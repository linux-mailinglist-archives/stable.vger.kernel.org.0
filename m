Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34D9272F70
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730180AbgIUQ47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:56:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:49878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729330AbgIUQob (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:44:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F81923A03;
        Mon, 21 Sep 2020 16:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706665;
        bh=3ioXhZTkuCbwVoUSCKevH6YI1Uibc46lPepIcXAm9mo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gWyLsnPYVbo+uqSBeyRAdo4/SSJiRRB71Oct/MNYZLuAiXvaPiqJx94+OAyRvR7p3
         KuqFKBmMPvkkVLn+YIEbr4Np1IAz7VLGQdqB9UX2Q4Tgi1vMs4nPkUoYvoDhV08i0Q
         n55AV/FNa4L52BCIy7+M7fzqnqmqiMxJMVvnfV+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 044/118] ASoC: qcom: common: Fix refcount imbalance on error
Date:   Mon, 21 Sep 2020 18:27:36 +0200
Message-Id: <20200921162038.358828139@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit c1e6414cdc371f9ed82cefebba7538499a3059f9 ]

for_each_child_of_node returns a node pointer np with
refcount incremented. So when devm_kzalloc fails, a
pairing refcount decrement is needed to keep np's
refcount balanced.

Fixes: 16395ceee11f8 ("ASoC: qcom: common: Fix NULL pointer in of parser")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Link: https://lore.kernel.org/r/20200820042828.10308-1-dinghao.liu@zju.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/common.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/qcom/common.c b/sound/soc/qcom/common.c
index 8ada4ecba8472..10322690c0eaa 100644
--- a/sound/soc/qcom/common.c
+++ b/sound/soc/qcom/common.c
@@ -45,8 +45,10 @@ int qcom_snd_parse_of(struct snd_soc_card *card)
 
 	for_each_child_of_node(dev->of_node, np) {
 		dlc = devm_kzalloc(dev, 2 * sizeof(*dlc), GFP_KERNEL);
-		if (!dlc)
-			return -ENOMEM;
+		if (!dlc) {
+			ret = -ENOMEM;
+			goto err;
+		}
 
 		link->cpus	= &dlc[0];
 		link->platforms	= &dlc[1];
-- 
2.25.1



