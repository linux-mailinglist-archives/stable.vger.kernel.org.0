Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E47A94F3AF0
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245549AbiDELuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356120AbiDEKW6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:22:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0750CB6E4A;
        Tue,  5 Apr 2022 03:06:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 968886172B;
        Tue,  5 Apr 2022 10:06:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34EAC385A3;
        Tue,  5 Apr 2022 10:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153180;
        bh=gLRfcfw5hLBS9tnt1abhOUV0hMKG5+3gLd24ZnKwaqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WQz0NST+SpZ8D8hkAi4BT4MK6CwEcz9IvKDbd7IO3VjGYGtmEosL/P1/Z167hNVeW
         8JSqCrl7v8BxB70qRGya9i7XYR27ArwUjrL4UYqUfwGg0X1oCF3UJaKaNItqGO638q
         nwk25Na83K6Fzs12/bxaYuExdhzFXPuVjrYSW0M4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 131/599] hwrng: cavium - HW_RANDOM_CAVIUM should depend on ARCH_THUNDER
Date:   Tue,  5 Apr 2022 09:27:05 +0200
Message-Id: <20220405070302.739838362@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit ab7d88549e2f7ae116afd303f32e1950cb790a1d ]

The Cavium ThunderX Random Number Generator is only present on Cavium
ThunderX SoCs, and not available as an independent PCIe endpoint.  Hence
add a dependency on ARCH_THUNDER, to prevent asking the user about this
driver when configuring a kernel without Cavium Thunder SoC  support.

Fixes: cc2f1908c6b8f625 ("hwrng: cavium - Add Cavium HWRNG driver for ThunderX SoC.")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 31d367949fad..a7d9e4600d40 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -427,7 +427,7 @@ config HW_RANDOM_MESON
 
 config HW_RANDOM_CAVIUM
 	tristate "Cavium ThunderX Random Number Generator support"
-	depends on HW_RANDOM && PCI && ARM64
+	depends on HW_RANDOM && PCI && ARCH_THUNDER
 	default HW_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
-- 
2.34.1



