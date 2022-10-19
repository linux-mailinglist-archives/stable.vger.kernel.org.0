Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B537F603CB5
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbiJSIvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbiJSIuW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:50:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642848E704;
        Wed, 19 Oct 2022 01:48:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABC4461804;
        Wed, 19 Oct 2022 08:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0254C433C1;
        Wed, 19 Oct 2022 08:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169266;
        bh=zg+p61KItxBrk4fp24Kbh1QhrpK1b7WGZ7RcxpNQlec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mmnCTUDEdGvdkmM3go/QS+HV2hecDfmXuOImaeLlEJ8eny38JJ1b73459PUblKdN+
         7r6uFftTha0J+szs87nd3F8eSNrcAXPQ/rjaM/KWylpGv50+BJB/zsP4ebExPYxd1i
         bBoixQQ9eQVVgkrw3O4o8CANaRe9xXpZA964CXLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Bart Van Assche <bvanassche@acm.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 214/862] ARM: 9243/1: riscpc: Unbreak the build
Date:   Wed, 19 Oct 2022 10:25:01 +0200
Message-Id: <20221019083259.482159525@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 32844a8eecaa4a3e65841c53e43e04a9087d1ef6 ]

This patch fixes the following build error:

In file included from ./include/linux/io.h:13,
                 from ./arch/arm/mach-rpc/include/mach/uncompress.h:9,
                 from arch/arm/boot/compressed/misc.c:31:
./arch/arm/include/asm/io.h:85:22: error: conflicting types for ‘__raw_writeb’
   85 | #define __raw_writeb __raw_writeb
      |                      ^~~~~~~~~~~~
./arch/arm/include/asm/io.h:86:20: note: in expansion of macro ‘__raw_writeb’
   86 | static inline void __raw_writeb(u8 val, volatile void __iomem *addr)
      |                    ^~~~~~~~~~~~
In file included from arch/arm/boot/compressed/misc.c:26:
arch/arm/boot/compressed/misc-ep93xx.h:13:20: note: previous definition of ‘__raw_writeb’ was here
   13 | static inline void __raw_writeb(unsigned char value, unsigned int ptr)
      |                    ^~~~~~~~~~~~

To: Russell King <linux@armlinux.org.uk>

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org
Fixes: 0361c7e504b1 ("ARM: ep93xx: multiplatform support")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/compressed/misc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/compressed/misc.c b/arch/arm/boot/compressed/misc.c
index cb2e069dc73f..abfed1aa2baa 100644
--- a/arch/arm/boot/compressed/misc.c
+++ b/arch/arm/boot/compressed/misc.c
@@ -23,7 +23,9 @@ unsigned int __machine_arch_type;
 #include <linux/types.h>
 #include <linux/linkage.h>
 #include "misc.h"
+#ifdef CONFIG_ARCH_EP93XX
 #include "misc-ep93xx.h"
+#endif
 
 static void putstr(const char *ptr);
 
-- 
2.35.1



