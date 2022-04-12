Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374624FD119
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236320AbiDLG5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351481AbiDLGxm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:53:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329F61834F;
        Mon, 11 Apr 2022 23:41:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5B8E60A69;
        Tue, 12 Apr 2022 06:41:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7896C385A1;
        Tue, 12 Apr 2022 06:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745678;
        bh=j+rku0b+Icgd7VM9KfTkDjJB1stnzRIZQZl4d330c/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MUziD5Pru4zBQ9UXaE0+2ll7IrWCIo2mH0IrbM1XMZPJB5HgQn1Q35L8Xu47GXz7c
         Fg739DXUKQRyY14Ue++mAHrMSZ7iI850I9/51kcvU8jT5GDshW5ZGPhJP1SQBw5+RE
         CCv6oMlaOxbJ0CEPq+9I3RkhWsnwsMbvwadZhQwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 001/277] lib/logic_iomem: correct fallback config references
Date:   Tue, 12 Apr 2022 08:26:44 +0200
Message-Id: <20220412062942.069577288@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 2a6852cb8ff0c8c1363cac648d68489343813212 ]

Due to some renaming, we ended up with the "indirect iomem"
naming in Kconfig, following INDIRECT_PIO. However, clearly
I missed following through on that in the ifdefs, but so far
INDIRECT_IOMEM_FALLBACK isn't used by any architecture.

Reported-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Fixes: ca2e334232b6 ("lib: add iomem emulation (logic_iomem)")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/logic_iomem.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/logic_iomem.c b/lib/logic_iomem.c
index 549b22d4bcde..e7ea9b28d8db 100644
--- a/lib/logic_iomem.c
+++ b/lib/logic_iomem.c
@@ -68,7 +68,7 @@ int logic_iomem_add_region(struct resource *resource,
 }
 EXPORT_SYMBOL(logic_iomem_add_region);
 
-#ifndef CONFIG_LOGIC_IOMEM_FALLBACK
+#ifndef CONFIG_INDIRECT_IOMEM_FALLBACK
 static void __iomem *real_ioremap(phys_addr_t offset, size_t size)
 {
 	WARN(1, "invalid ioremap(0x%llx, 0x%zx)\n",
@@ -81,7 +81,7 @@ static void real_iounmap(void __iomem *addr)
 	WARN(1, "invalid iounmap for addr 0x%llx\n",
 	     (unsigned long long)(uintptr_t __force)addr);
 }
-#endif /* CONFIG_LOGIC_IOMEM_FALLBACK */
+#endif /* CONFIG_INDIRECT_IOMEM_FALLBACK */
 
 void __iomem *ioremap(phys_addr_t offset, size_t size)
 {
@@ -168,7 +168,7 @@ void iounmap(void __iomem *addr)
 }
 EXPORT_SYMBOL(iounmap);
 
-#ifndef CONFIG_LOGIC_IOMEM_FALLBACK
+#ifndef CONFIG_INDIRECT_IOMEM_FALLBACK
 #define MAKE_FALLBACK(op, sz) 						\
 static u##sz real_raw_read ## op(const volatile void __iomem *addr)	\
 {									\
@@ -213,7 +213,7 @@ static void real_memcpy_toio(volatile void __iomem *addr, const void *buffer,
 	WARN(1, "Invalid memcpy_toio at address 0x%llx\n",
 	     (unsigned long long)(uintptr_t __force)addr);
 }
-#endif /* CONFIG_LOGIC_IOMEM_FALLBACK */
+#endif /* CONFIG_INDIRECT_IOMEM_FALLBACK */
 
 #define MAKE_OP(op, sz) 						\
 u##sz __raw_read ## op(const volatile void __iomem *addr)		\
-- 
2.35.1



