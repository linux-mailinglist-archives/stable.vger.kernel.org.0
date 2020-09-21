Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 159C0272EDD
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbgIUQwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:52:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729863AbgIUQsy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:48:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 659E02399C;
        Mon, 21 Sep 2020 16:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706928;
        bh=3ioXhZTkuCbwVoUSCKevH6YI1Uibc46lPepIcXAm9mo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ds/NDvw192DI1wXCxyQkkvGku6e6R4oH9+RSGLXN6v7AMmZEVea5/nqkFPLkIzAwb
         r2cjmVzYL9i4WH41afbaLblBBE/zFk0YFWcRipXsnKRNdD/qLmeoO3WaUGuJ+4tOj1
         4k4R0WgStvsiXmkBL6C7QeqCBWp5uhEwNZV6lKmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 31/72] ASoC: qcom: common: Fix refcount imbalance on error
Date:   Mon, 21 Sep 2020 18:31:10 +0200
Message-Id: <20200921163123.346720429@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921163121.870386357@linuxfoundation.org>
References: <20200921163121.870386357@linuxfoundation.org>
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



