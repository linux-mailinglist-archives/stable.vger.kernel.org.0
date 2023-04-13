Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C6F6E0489
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 04:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbjDMCjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 22:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbjDMCjB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 22:39:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B3D86A1;
        Wed, 12 Apr 2023 19:37:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 526E663AAB;
        Thu, 13 Apr 2023 02:37:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E5FC433D2;
        Thu, 13 Apr 2023 02:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681353443;
        bh=++5gnSPH5suOIckcoNOW3Cu+lShLaYYyqEza+Scb1Ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k9+hgmYSVaA7VpBMxUYsZOUPMcfoqh71nTwj03mTc8cuVEnBfOzt9PD+dhABGVtJR
         rco+MxnJyuX0LMGIaynmSUQedOqceVMOIYiBsyE5gi0AfgoAy/IcX9zLH6hm0k0yj0
         ihwGcZ/UIhf8FXPdXlhE46ylwgsR4ksy5K6k1XUeHhlHroVfyhJRPOA4QP7ErmM9i2
         FJ06SjFnj3rB+Zwsv6yIBijsMRyTYFV/LLmQYk6Kv+90Wnya7YZ6CdR5IM5TIaDxVK
         29326rx6DIUxAHEqlu31+WoslKjofdAGerh7ldFXpmYaifdtWOgprzSHkaSike8v7I
         uc84V4Lxi9edQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-arch@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 16/17] asm-generic/io.h: suppress endianness warnings for readq() and writeq()
Date:   Wed, 12 Apr 2023 22:36:44 -0400
Message-Id: <20230413023647.74661-16-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230413023647.74661-1-sashal@kernel.org>
References: <20230413023647.74661-1-sashal@kernel.org>
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
index a68f8fbf423be..cde032f86856e 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -236,7 +236,7 @@ static inline u64 readq(const volatile void __iomem *addr)
 
 	log_read_mmio(64, addr, _THIS_IP_);
 	__io_br();
-	val = __le64_to_cpu(__raw_readq(addr));
+	val = __le64_to_cpu((__le64 __force)__raw_readq(addr));
 	__io_ar(val);
 	log_post_read_mmio(val, 64, addr, _THIS_IP_);
 	return val;
@@ -287,7 +287,7 @@ static inline void writeq(u64 value, volatile void __iomem *addr)
 {
 	log_write_mmio(value, 64, addr, _THIS_IP_);
 	__io_bw();
-	__raw_writeq(__cpu_to_le64(value), addr);
+	__raw_writeq((u64 __force)__cpu_to_le64(value), addr);
 	__io_aw();
 	log_post_write_mmio(value, 64, addr, _THIS_IP_);
 }
-- 
2.39.2

