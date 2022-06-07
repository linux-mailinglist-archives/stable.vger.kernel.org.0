Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6301540948
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349529AbiFGSHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350796AbiFGSB0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:01:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F56514CDE0;
        Tue,  7 Jun 2022 10:43:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C5F9B82324;
        Tue,  7 Jun 2022 17:43:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6197C385A5;
        Tue,  7 Jun 2022 17:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623805;
        bh=cB/zmou4JNBatz0EsRvy0e6Im6lxkG/oKJCnqFwoMfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZXs60A+j1JAsbMtJ+X6/ncMMG1GLcCPgpdaza7dAN434Pf57CA/Sgq8atrSZThl1p
         q826cYtVevIVe+E2bwc6HDZDydf1eqQurM27zwFgo0FH2M2aQ4xkc9z9JachgLSIzZ
         GrQgVMFgPhtkH4spjYKqgNFjnnZPV0loAFNNEOL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 099/667] regulator: mt6315: Enforce regulator-compatible, not name
Date:   Tue,  7 Jun 2022 18:56:04 +0200
Message-Id: <20220607164937.791000999@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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



