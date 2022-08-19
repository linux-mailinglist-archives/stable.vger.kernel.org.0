Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E486E59A163
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352675AbiHSQ3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352705AbiHSQ1A (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:27:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9E511984B;
        Fri, 19 Aug 2022 09:04:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC289B82802;
        Fri, 19 Aug 2022 16:04:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1F7C433D6;
        Fri, 19 Aug 2022 16:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925044;
        bh=b/eO7T93VBhO6VzwHMxUEiwNGAQVm+L3XWdxZH0KhPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pzUU1nc9sfzEPM42P+kTgWR5xSVgGExAcF7ihsgO9VqaLDFT8h0dCFFJFwySTvX8u
         kNb7OVNnk/RuXuOw7bIOoztCq/pW+ypLsxh5wQudO0JlF2Pn/taUWU3Ut/7INEkpCM
         V2u9gXbyTy7CrPQspLUJzyjiUAY4PkP1MgnoOZE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 365/545] ASoC: samsung: Fix error handling in aries_audio_probe
Date:   Fri, 19 Aug 2022 17:42:15 +0200
Message-Id: <20220819153845.723399486@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 3e2649c5e8643bea0867bb1dd970fedadb0eb7f3 ]

of_get_child_by_name() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
This function is missing of_node_put(cpu) in the error path.
Fix this by goto out label. of_node_put() will check NULL pointer.

Fixes: 7a3a7671fa6c ("ASoC: samsung: Add driver for Aries boards")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220603130640.37624-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/samsung/aries_wm8994.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/samsung/aries_wm8994.c b/sound/soc/samsung/aries_wm8994.c
index 18458192aff1..d2908c1ea835 100644
--- a/sound/soc/samsung/aries_wm8994.c
+++ b/sound/soc/samsung/aries_wm8994.c
@@ -628,8 +628,10 @@ static int aries_audio_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	codec = of_get_child_by_name(dev->of_node, "codec");
-	if (!codec)
-		return -EINVAL;
+	if (!codec) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	for_each_card_prelinks(card, i, dai_link) {
 		dai_link->codecs->of_node = of_parse_phandle(codec,
-- 
2.35.1



