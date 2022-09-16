Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65D035BAB00
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbiIPKZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbiIPKYL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:24:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B21EABD7D;
        Fri, 16 Sep 2022 03:15:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0289FB8253A;
        Fri, 16 Sep 2022 10:13:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60750C433C1;
        Fri, 16 Sep 2022 10:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323215;
        bh=hTXg7u7di5Z06XG9BCn6oG8/0a79m4ePnTp0VKoo82Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OJTOF0lJbKg+4U4/Y5akYr9ciOT5nZ7iHiVswWjrNMpb1AnBPmI9/huv7pvBfoNaD
         vkeFlMgMStn3WvNFMaZyoYN64uX6fJjR3aHclcH9wbIfqUfBgdX34zNPrwuOYUMwSf
         xUl8Gf+HiaaVHkzJjrMaie3n4g093kOsrPoZzOPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 14/38] dt-bindings: iio: gyroscope: bosch,bmg160: correct number of pins
Date:   Fri, 16 Sep 2022 12:08:48 +0200
Message-Id: <20220916100449.070863740@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100448.431016349@linuxfoundation.org>
References: <20220916100448.431016349@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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



