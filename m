Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8128E6AF300
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbjCGS6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:58:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbjCGS6M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:58:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E73A50F9E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:45:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA6E3B8199A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:45:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17876C433D2;
        Tue,  7 Mar 2023 18:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214730;
        bh=v4jX79Ehyah2vsbCTFBNpXEWQOgNH+O8ga9XaJwvRIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fczHnCggLb61iuLX0lBdLBY3zjYUQpkDD5tUtX+W5jDgjOIkfOxg7uTZa7Skoksu2
         uhz8kKVq6ipSnRz1r85uO1eS0+ekNKhH592ftBdcNEim3no83LDryKJWJ7JwUn3BT8
         6DwAUsiG6PSt6mwaiQ5gB8z3DDPphu0wF7zZHIQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 031/567] ARM: s3c: fix s3c64xx_set_timer_source prototype
Date:   Tue,  7 Mar 2023 17:56:07 +0100
Message-Id: <20230307165907.267213113@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 5bf52f5e4d12b8109f348cab60cb7d51092c4270 ]

The prototype does not match the definition, as gcc-13 points
out:

arch/arm/mach-s3c/s3c64xx.c:169:13: error: conflicting types for 's3c64xx_set_timer_source' due to enum/integer mismatch; have 'void(unsigned int,  unsigned int)' [-Werror=enum-int-mismatch]
  169 | void __init s3c64xx_set_timer_source(unsigned int event, unsigned int source)
      |             ^~~~~~~~~~~~~~~~~~~~~~~~
In file included from arch/arm/mach-s3c/s3c64xx.c:50:
arch/arm/mach-s3c/s3c64xx.h:62:20: note: previous declaration of 's3c64xx_set_timer_source' with type 'void(enum s3c64xx_timer_mode,  enum s3c64xx_timer_mode)'
   62 | extern void __init s3c64xx_set_timer_source(enum s3c64xx_timer_mode event,
      |                    ^~~~~~~~~~~~~~~~~~~~~~~~

Fixes: 4280506ac9bb ("ARM: SAMSUNG: Move all platforms to new clocksource driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20230118090224.2162863-1-arnd@kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-s3c/s3c64xx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-s3c/s3c64xx.c b/arch/arm/mach-s3c/s3c64xx.c
index 4dfb648142f2a..17f0065031490 100644
--- a/arch/arm/mach-s3c/s3c64xx.c
+++ b/arch/arm/mach-s3c/s3c64xx.c
@@ -173,7 +173,8 @@ static struct samsung_pwm_variant s3c64xx_pwm_variant = {
 	.tclk_mask	= (1 << 7) | (1 << 6) | (1 << 5),
 };
 
-void __init s3c64xx_set_timer_source(unsigned int event, unsigned int source)
+void __init s3c64xx_set_timer_source(enum s3c64xx_timer_mode event,
+				     enum s3c64xx_timer_mode source)
 {
 	s3c64xx_pwm_variant.output_mask = BIT(SAMSUNG_PWM_NUM) - 1;
 	s3c64xx_pwm_variant.output_mask &= ~(BIT(event) | BIT(source));
-- 
2.39.2



