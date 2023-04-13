Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD1026E04AF
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 04:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjDMCk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 22:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbjDMCkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 22:40:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1AF17A93;
        Wed, 12 Apr 2023 19:38:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4B3E63AAD;
        Thu, 13 Apr 2023 02:37:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5930AC433A7;
        Thu, 13 Apr 2023 02:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681353463;
        bh=zh5XKJ/UyuqyrJ5hCrGW6axciS0TL/7B2vgoKiTKf2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nV4QMqjUJMEdBr2fKK+7HsY7Zpi2DTAZVvYTFrCCXlIVeqTco/m/WZIgUogu2e1JD
         OxX2B7mPeJVGUjhtwYeIkuPhalMCYZH4lt2WCdYYgsDse19c8PPbJBOvUIxHWAcbJt
         oTQtn/KZrs/xAQg1H1M3b9J2PIqhcnfth2ybwzZ6O/pSKOmUY31WWbvczmLVttrssI
         dzrm5OYDmC8deOg16WHKruN8BaikI0zSA5q6zYGiO+nOcX1i8JPeWZNbXRnY6epdXh
         fo6t07A/8kmF5mX+F+0osPI3Dexl1kzMnIhig588iLw+wPT2dPjme/1BojLDGnIIoZ
         6jJKRqzPB+TiA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-arch@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 7/8] asm-generic/io.h: suppress endianness warnings for readq() and writeq()
Date:   Wed, 12 Apr 2023 22:37:24 -0400
Message-Id: <20230413023727.74875-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230413023727.74875-1-sashal@kernel.org>
References: <20230413023727.74875-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit d564fa1ff19e893e2971d66e5c8f49dc1cdc8ffc ]

Commit c1d55d50139b ("asm-generic/io.h: Fix sparse warnings on
big-endian architectures") missed fixing the 64-bit accessors.

Arnd explains in the attached link why the casts are necessary, even if
__raw_readq() and __raw_writeq() do not take endian-specific types.

Link: https://lore.kernel.org/lkml/9105d6fc-880b-4734-857d-e3d30b87ccf6@app.fastmail.com/
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/io.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 98954dda57344..82f2c01accbb9 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -190,7 +190,7 @@ static inline u64 readq(const volatile void __iomem *addr)
 	u64 val;
 
 	__io_br();
-	val = __le64_to_cpu(__raw_readq(addr));
+	val = __le64_to_cpu((__le64 __force)__raw_readq(addr));
 	__io_ar(val);
 	return val;
 }
@@ -233,7 +233,7 @@ static inline void writel(u32 value, volatile void __iomem *addr)
 static inline void writeq(u64 value, volatile void __iomem *addr)
 {
 	__io_bw();
-	__raw_writeq(__cpu_to_le64(value), addr);
+	__raw_writeq((u64 __force)__cpu_to_le64(value), addr);
 	__io_aw();
 }
 #endif
-- 
2.39.2

