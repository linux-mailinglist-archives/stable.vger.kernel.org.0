Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEC65742D2
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234822AbiGNE1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235029AbiGNE0X (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:26:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E3F186E7;
        Wed, 13 Jul 2022 21:23:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBAA2B82373;
        Thu, 14 Jul 2022 04:23:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5218C385A5;
        Thu, 14 Jul 2022 04:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772618;
        bh=8oR8txlHLyxmwdMdLQFzwIKBinSn6adtCLJySAog5fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ETL3GH2CDRMLpRkIOrwLv+nfifpNcRagcmlEL2MUgMO8YlRoArJHbKiM4maLITCmd
         Apj5YyXek/uPi2tA8qNYnd/X1Tlda9UpWg08Mzd2NIjSLO9x3/fZ5DplHQj4DKIJBr
         eOJWpvMDFcFeMCR/LSnTgQhwc16gmu2rtLqJkjzw4Eg8HX4gV9lizG64FPsjOZ+mc1
         Zw4A+RJDYGo5IrcRcmfqAL+YwmaP+XbOyVlX2QBxU5sc6VjRJtzwo/e9n5RMSiMt8E
         waWTQMj3c8mQ5SbiGuHEPIlftcLfT8ESBKxKT/nIf1AtyaBghl9LQJbvddYny2h0ah
         HkDhMeJki75ag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>,
        khalasa@piap.pl
Subject: [PATCH AUTOSEL 5.18 30/41] soc: ixp4xx/npe: Fix unused match warning
Date:   Thu, 14 Jul 2022 00:22:10 -0400
Message-Id: <20220714042221.281187-30-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042221.281187-1-sashal@kernel.org>
References: <20220714042221.281187-1-sashal@kernel.org>
MIME-Version: 1.0
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

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 620f83b8326ce9706b1118334f0257ae028ce045 ]

The kernel test robot found this inconsistency:

  drivers/soc/ixp4xx/ixp4xx-npe.c:737:34: warning:
  'ixp4xx_npe_of_match' defined but not used [-Wunused-const-variable=]
     737 | static const struct of_device_id ixp4xx_npe_of_match[] = {

This is because the match is enclosed in the of_match_ptr()
which compiles into NULL when OF is disabled and this
is unnecessary.

Fix it by dropping of_match_ptr() around the match.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20220626074315.61209-1-linus.walleij@linaro.org'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ixp4xx/ixp4xx-npe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/ixp4xx/ixp4xx-npe.c b/drivers/soc/ixp4xx/ixp4xx-npe.c
index 613935cb6a48..58240e320c13 100644
--- a/drivers/soc/ixp4xx/ixp4xx-npe.c
+++ b/drivers/soc/ixp4xx/ixp4xx-npe.c
@@ -758,7 +758,7 @@ static const struct of_device_id ixp4xx_npe_of_match[] = {
 static struct platform_driver ixp4xx_npe_driver = {
 	.driver = {
 		.name           = "ixp4xx-npe",
-		.of_match_table = of_match_ptr(ixp4xx_npe_of_match),
+		.of_match_table = ixp4xx_npe_of_match,
 	},
 	.probe = ixp4xx_npe_probe,
 	.remove = ixp4xx_npe_remove,
-- 
2.35.1

