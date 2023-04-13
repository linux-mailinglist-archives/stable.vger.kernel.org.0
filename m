Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D3E6E048F
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 04:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbjDMCj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 22:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbjDMCj2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 22:39:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330B1116;
        Wed, 12 Apr 2023 19:37:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10F7A63AB0;
        Thu, 13 Apr 2023 02:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C827AC4339E;
        Thu, 13 Apr 2023 02:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681353477;
        bh=1eO2mQahIqPUHlcx0RY6P55blfFH5Nk26/p9x67hqlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RjNi92wimtViUaV+THs6bxRWyvng0d0vcBHwFa1KpsVTOaUyL/bbI1CClbqBS+iaz
         4hUJINI+3y2xyfAsDIPmvBAeZR8Uj1IhGcVXNJx3FOngndEx7tV/a+Eoi8N3r7EYEi
         03RfOibV4oQXaYkvTkdyBEbaokfuWYby3LLp9ytvs0BiXdwzIfYiRyBjOFCZohHV8k
         kuJ26dKCK0Ws2pjP04mGz469XVLiaG1Orrrw2wXOPi+05CbPZYdAZUN17cQ2izKCNe
         8oVaI7jxH+5AIug9wCfs9hpjULAHQCjnXL4NYbMT+U7bkxSB0RXObAA0b4LuJMPCMG
         OVbRIxJxW0kwg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-arch@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 4/4] asm-generic/io.h: suppress endianness warnings for readq() and writeq()
Date:   Wed, 12 Apr 2023 22:37:44 -0400
Message-Id: <20230413023746.74984-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230413023746.74984-1-sashal@kernel.org>
References: <20230413023746.74984-1-sashal@kernel.org>
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
index 9ea83d80eb6f9..dcbd41048b4e7 100644
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

