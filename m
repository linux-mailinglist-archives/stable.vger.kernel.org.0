Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A832579D11
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239455AbiGSMrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242107AbiGSMpT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:45:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E2E88CC9;
        Tue, 19 Jul 2022 05:18:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A5E5B81B13;
        Tue, 19 Jul 2022 12:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BDFC341C6;
        Tue, 19 Jul 2022 12:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233085;
        bh=oXmiPHef9sNQdd78/D5gyH14NvZuBXfGyDVPUHBBn3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ag+s/q/s4OwuXZOY8hVYHqhcavOh3pSbQbqe1pYZdTOb+xlN6Cryb5cjQsR9Mjl9T
         QWX0jQhTaYddKGp+BTjG+kmWc48zEVEqCTemwyQSe49OgO3zaLNzxWb+A9OnGp7MXr
         Z9hnsK1uEfqfkcAhTb331frW6HJQxMC2un2LFL1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuming Fan <shumingf@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 143/167] ASoC: rt711-sdca: fix kernel NULL pointer dereference when IO error
Date:   Tue, 19 Jul 2022 13:54:35 +0200
Message-Id: <20220719114710.325178974@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuming Fan <shumingf@realtek.com>

[ Upstream commit 1df793d479bef546569fc2e409ff8bb3f0fb8e99 ]

The initial settings will be written before the codec probe function.
But, the rt711->component doesn't be assigned yet.
If IO error happened during initial settings operations, it will cause the kernel panic.
This patch changed component->dev to slave->dev to fix this issue.

Signed-off-by: Shuming Fan <shumingf@realtek.com>
Link: https://lore.kernel.org/r/20220621090719.30558-1-shumingf@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt711-sdca.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt711-sdca.c b/sound/soc/codecs/rt711-sdca.c
index 60aef52b3fe4..3b5df3ea2f60 100644
--- a/sound/soc/codecs/rt711-sdca.c
+++ b/sound/soc/codecs/rt711-sdca.c
@@ -34,7 +34,7 @@ static int rt711_sdca_index_write(struct rt711_sdca_priv *rt711,
 
 	ret = regmap_write(regmap, addr, value);
 	if (ret < 0)
-		dev_err(rt711->component->dev,
+		dev_err(&rt711->slave->dev,
 			"Failed to set private value: %06x <= %04x ret=%d\n",
 			addr, value, ret);
 
@@ -50,7 +50,7 @@ static int rt711_sdca_index_read(struct rt711_sdca_priv *rt711,
 
 	ret = regmap_read(regmap, addr, value);
 	if (ret < 0)
-		dev_err(rt711->component->dev,
+		dev_err(&rt711->slave->dev,
 			"Failed to get private value: %06x => %04x ret=%d\n",
 			addr, *value, ret);
 
-- 
2.35.1



