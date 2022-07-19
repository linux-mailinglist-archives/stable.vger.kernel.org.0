Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73D77579F13
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237116AbiGSNKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243493AbiGSNJh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:09:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17E16554E;
        Tue, 19 Jul 2022 05:28:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4E8BB81B29;
        Tue, 19 Jul 2022 12:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32AFC341D7;
        Tue, 19 Jul 2022 12:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233719;
        bh=8oR8txlHLyxmwdMdLQFzwIKBinSn6adtCLJySAog5fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eFI6SGoSC89cLqRGLbQd3JmzoCYHRErP10ZIWt9QOOhRj9m0dPW8586EvSE1h4r9r
         Tslh8W/7VGMb+rUvvibhc36Qx5hyZuXYNIKm4z6E0P3anhSJvLUensj647MjaSb43M
         jv2Xa4rXi8soXP8xPf5umPp8g99SxaZuCD/KIQh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 210/231] soc: ixp4xx/npe: Fix unused match warning
Date:   Tue, 19 Jul 2022 13:54:55 +0200
Message-Id: <20220719114731.558015819@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
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



