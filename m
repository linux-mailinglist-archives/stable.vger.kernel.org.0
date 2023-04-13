Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90AFC6E0470
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 04:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbjDMCi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 22:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjDMCiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 22:38:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA5293EF;
        Wed, 12 Apr 2023 19:37:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8F8D63A8D;
        Thu, 13 Apr 2023 02:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24C7C433A1;
        Thu, 13 Apr 2023 02:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681353403;
        bh=ZFRK8jiGYOCs5wAhqWnSdxJfdodA4PcK7ZFCYNL7ZZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NtGBPaeZG3+GuQ8tNg0uaybTjXVKIo/TjBGyXut4+V3JnKwUYVZtC1ZNwmN86Ojfi
         AK82mWXR68atPOsA6HXYg/MNLRMDVgIt2DBWERnPPtWnlZHy/EpyHJfnIKckArl9I2
         YBzF7qANldJG++oVwScuqeuXGUpH1Pk9dErw0ZwtzTrXStv4oc5teuv3neDR8oNlwT
         eldGawxVjP52J5Aw5qVXVT46p9H9WDojElSJLvjtEqapy167aOXjgOtcsslMHg0PMV
         EZgd+VbdHgfRgBd/F0/JUsxDoZv21ynTP0k7pnskRvug+mBU8MU7+3CazxHrorSJCa
         7Wp+A4OkiPkzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>,
        linux-arch@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 19/20] asm-generic/io.h: suppress endianness warnings for relaxed accessors
Date:   Wed, 12 Apr 2023 22:35:57 -0400
Message-Id: <20230413023601.74410-19-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230413023601.74410-1-sashal@kernel.org>
References: <20230413023601.74410-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 05d3855b4d21ef3c2df26be1cbba9d2c68915fcb ]

Copy the forced type casts from the normal MMIO accessors to suppress
the sparse warnings that point out __raw_readl() returns a native endian
word (just like readl()).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/io.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index d78c3056c98f9..587e7e9b9a375 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -319,7 +319,7 @@ static inline u16 readw_relaxed(const volatile void __iomem *addr)
 	u16 val;
 
 	log_read_mmio(16, addr, _THIS_IP_, _RET_IP_);
-	val = __le16_to_cpu(__raw_readw(addr));
+	val = __le16_to_cpu((__le16 __force)__raw_readw(addr));
 	log_post_read_mmio(val, 16, addr, _THIS_IP_, _RET_IP_);
 	return val;
 }
@@ -332,7 +332,7 @@ static inline u32 readl_relaxed(const volatile void __iomem *addr)
 	u32 val;
 
 	log_read_mmio(32, addr, _THIS_IP_, _RET_IP_);
-	val = __le32_to_cpu(__raw_readl(addr));
+	val = __le32_to_cpu((__le32 __force)__raw_readl(addr));
 	log_post_read_mmio(val, 32, addr, _THIS_IP_, _RET_IP_);
 	return val;
 }
@@ -345,7 +345,7 @@ static inline u64 readq_relaxed(const volatile void __iomem *addr)
 	u64 val;
 
 	log_read_mmio(64, addr, _THIS_IP_, _RET_IP_);
-	val = __le64_to_cpu(__raw_readq(addr));
+	val = __le64_to_cpu((__le64 __force)__raw_readq(addr));
 	log_post_read_mmio(val, 64, addr, _THIS_IP_, _RET_IP_);
 	return val;
 }
@@ -366,7 +366,7 @@ static inline void writeb_relaxed(u8 value, volatile void __iomem *addr)
 static inline void writew_relaxed(u16 value, volatile void __iomem *addr)
 {
 	log_write_mmio(value, 16, addr, _THIS_IP_, _RET_IP_);
-	__raw_writew(cpu_to_le16(value), addr);
+	__raw_writew((u16 __force)cpu_to_le16(value), addr);
 	log_post_write_mmio(value, 16, addr, _THIS_IP_, _RET_IP_);
 }
 #endif
@@ -376,7 +376,7 @@ static inline void writew_relaxed(u16 value, volatile void __iomem *addr)
 static inline void writel_relaxed(u32 value, volatile void __iomem *addr)
 {
 	log_write_mmio(value, 32, addr, _THIS_IP_, _RET_IP_);
-	__raw_writel(__cpu_to_le32(value), addr);
+	__raw_writel((u32 __force)__cpu_to_le32(value), addr);
 	log_post_write_mmio(value, 32, addr, _THIS_IP_, _RET_IP_);
 }
 #endif
@@ -386,7 +386,7 @@ static inline void writel_relaxed(u32 value, volatile void __iomem *addr)
 static inline void writeq_relaxed(u64 value, volatile void __iomem *addr)
 {
 	log_write_mmio(value, 64, addr, _THIS_IP_, _RET_IP_);
-	__raw_writeq(__cpu_to_le64(value), addr);
+	__raw_writeq((u64 __force)__cpu_to_le64(value), addr);
 	log_post_write_mmio(value, 64, addr, _THIS_IP_, _RET_IP_);
 }
 #endif
-- 
2.39.2

