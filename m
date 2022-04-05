Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825374F25EE
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbiDEHwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232911AbiDEHvr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:51:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA683986C6;
        Tue,  5 Apr 2022 00:47:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5322BB81B18;
        Tue,  5 Apr 2022 07:47:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D12C340EE;
        Tue,  5 Apr 2022 07:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144877;
        bh=xd16qT32WppJot+7Ia2t6I4wkr34eWUzdX4MXxOiUus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RT3ZUh3v2blXoiJI4xwX275/wk0hj9TPn6v4oWZ9JGUj5SsmJ6EUjNsPp433M9znU
         uI0AGQM5dITaX7UvI9W0qabG9Q3TCNoKqwIvNCb4Pn3kHM3QabSoT2wXf/i0/c8auj
         mLSKP7APigCLnZ0xpN81Tysxe7g3vSS1fy3D4WlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0203/1126] hwrng: cavium - HW_RANDOM_CAVIUM should depend on ARCH_THUNDER
Date:   Tue,  5 Apr 2022 09:15:50 +0200
Message-Id: <20220405070413.567882815@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index 9704963f9d50..a087156a5818 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -401,7 +401,7 @@ config HW_RANDOM_MESON
 
 config HW_RANDOM_CAVIUM
 	tristate "Cavium ThunderX Random Number Generator support"
-	depends on HW_RANDOM && PCI && ARM64
+	depends on HW_RANDOM && PCI && ARCH_THUNDER
 	default HW_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
-- 
2.34.1



