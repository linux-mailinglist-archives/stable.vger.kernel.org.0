Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F5E5B4987
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbiIJVUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiIJVUE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:20:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE2A4F385;
        Sat, 10 Sep 2022 14:18:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C320F60ED2;
        Sat, 10 Sep 2022 21:18:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1194DC433D6;
        Sat, 10 Sep 2022 21:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844682;
        bh=hTXg7u7di5Z06XG9BCn6oG8/0a79m4ePnTp0VKoo82Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CG6o00K2dCfLwceRNLmpSpSCcaic2uyVWej/dfQVMc16+JSiL+RmetQQ5xXiKJV3j
         X4/9+wrxSLsiMnN4O1kndQtW2FDv0k2TvjjIoGfXpj0lhKrI8ZmB9ZFfFChVQ8ktV9
         /64VmHPg+7oL6FRvQGX5brEeXBQEZIRtjwVYiYRTOpgM361IsX4fdxVkHsm90JDPRc
         rCpGYhKKLJrbs+Cu13aaC63DOV932T5PGsAxlPJCuudYPYhja4114zV1EwQ9w4bG3z
         1wMDxEtL8n62XlC195EG/8DurRdG9Mitcy0e0iaMnS/pwPMotOZc8in3C4PoNkeO1K
         41i8CI+kQZ3/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, jic23@kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        hns@goldelico.com, linux-iio@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 05/21] dt-bindings: iio: gyroscope: bosch,bmg160: correct number of pins
Date:   Sat, 10 Sep 2022 17:17:36 -0400
Message-Id: <20220910211752.70291-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211752.70291-1-sashal@kernel.org>
References: <20220910211752.70291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 767470209cedbe2cc72ba38d77c9f096d2c7694c ]

BMG160 has two interrupt pins to which interrupts can be freely mapped.
Correct the schema to express such case and fix warnings like:

  qcom/msm8916-alcatel-idol347.dtb: gyroscope@68: interrupts: [[97, 1], [98, 1]] is too long

However the basic issue still persists - the interrupts should come in a
defined order.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220805075503.16983-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/iio/gyroscope/bosch,bmg160.yaml         | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/iio/gyroscope/bosch,bmg160.yaml b/Documentation/devicetree/bindings/iio/gyroscope/bosch,bmg160.yaml
index b6bbc312a7cf7..1414ba9977c16 100644
--- a/Documentation/devicetree/bindings/iio/gyroscope/bosch,bmg160.yaml
+++ b/Documentation/devicetree/bindings/iio/gyroscope/bosch,bmg160.yaml
@@ -24,8 +24,10 @@ properties:
 
   interrupts:
     minItems: 1
+    maxItems: 2
     description:
       Should be configured with type IRQ_TYPE_EDGE_RISING.
+      If two interrupts are provided, expected order is INT1 and INT2.
 
 required:
   - compatible
-- 
2.35.1

