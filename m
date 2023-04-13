Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 295886E0492
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 04:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjDMCkG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 22:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjDMCjk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 22:39:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD8D9006;
        Wed, 12 Apr 2023 19:38:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E10F63AB1;
        Thu, 13 Apr 2023 02:38:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DD6C433EF;
        Thu, 13 Apr 2023 02:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681353487;
        bh=4MSEWpCPmsHnmUimKtkF4utaACAQQHhpJqm1WmamqPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fJ6QGMN0pG1gr1d7Oi6zw25f1Wa/w+Y5oeaJ5Ge6Eo6+oqjcHYb6dJHqwhf6QhLaO
         HExE/QhpcWTlhVQXxVvRNWKvklhzbTskIIMrlCg71TVvxdsmMgeOzNlA51h0SFPSWn
         0c1qGQbfHVERBs/t3wV29c4Ygw51SsgyhAzz99ylYW1V0s68xOuWxbWx9+0h82gyw9
         tzZjViqfDwjEbmcpD7QpVHcqt/zS0c2RlxfwkVkusGg/fUzoaq8ieGpzbkWehcjW4W
         RrKqF+NfpdYOmGK6TAAIml9sLq/9yBq9h3uLcBUvWcaEUkoSoCRZ0xLZ0lscVuMoPR
         UsTGpoAahPk+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-arch@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 3/3] asm-generic/io.h: suppress endianness warnings for readq() and writeq()
Date:   Wed, 12 Apr 2023 22:37:58 -0400
Message-Id: <20230413023759.75048-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230413023759.75048-1-sashal@kernel.org>
References: <20230413023759.75048-1-sashal@kernel.org>
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
index d02806513670c..3dd3416f1df03 100644
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

