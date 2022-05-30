Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A7F537F37
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238733AbiE3NxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239029AbiE3NvB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:51:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750E78217E;
        Mon, 30 May 2022 06:35:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6478B80DB6;
        Mon, 30 May 2022 13:35:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19738C341C7;
        Mon, 30 May 2022 13:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917706;
        bh=cB/zmou4JNBatz0EsRvy0e6Im6lxkG/oKJCnqFwoMfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GZUlB9s5JH+JNsIlBG6NEr5Bi6dlYEbiDJdxlsd9nD7LFJuyGz6uWocQRYNPe13Mx
         q7EVfdlrnfdzpJ9j9a+WpRXf7t9Nb+gNG9bQGIY02Ez4Y+ATzlYFAcmGxGZX+1TEK2
         /42gvU8ci2U5DXHukHpTK4dR4+IXzfyZNbIQJBXUb72ng5u6eS5qqR7JoIYw2SBjTm
         uZU5fT3tWXfRW48cN4qIBZSagerussar3tEl5jrvSHCDQswn2KJTERdEexEt75YQFH
         1R/KK3WCAqeERfS2nPtAoqAlGZqL1GZgTUVCNai3CzCuQeOU1796YH8w+STqhMnPDj
         YFA/ikA3vy4bg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?N=C3=ADcolas=20F=2E=20R=2E=20A=2E=20Prado?= 
        <nfraprado@collabora.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        matthias.bgg@gmail.com, hsin-hsiung.wang@mediatek.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.17 070/135] regulator: mt6315: Enforce regulator-compatible, not name
Date:   Mon, 30 May 2022 09:30:28 -0400
Message-Id: <20220530133133.1931716-70-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 6d435a94ba5bb4f2ad381c0828fbae89c66b50fe ]

The MT6315 PMIC dt-binding should enforce that one of the valid
regulator-compatible is set in each regulator node. However it was
mistakenly matching against regulator-name instead.

Fix the typo. This not only fixes the compatible verification, but also
lifts the regulator-name restriction, so that more meaningful names can
be set for each platform.

Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/r/20220429201325.2205799-1-nfraprado@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/regulator/mt6315-regulator.yaml         | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/regulator/mt6315-regulator.yaml b/Documentation/devicetree/bindings/regulator/mt6315-regulator.yaml
index 61dd5af80db6..5d2d989de893 100644
--- a/Documentation/devicetree/bindings/regulator/mt6315-regulator.yaml
+++ b/Documentation/devicetree/bindings/regulator/mt6315-regulator.yaml
@@ -31,7 +31,7 @@ properties:
         $ref: "regulator.yaml#"
 
         properties:
-          regulator-name:
+          regulator-compatible:
             pattern: "^vbuck[1-4]$"
 
     additionalProperties: false
-- 
2.35.1

