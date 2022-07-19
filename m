Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59DC2579EDE
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238959AbiGSNHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243067AbiGSNGy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:06:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D05A024F;
        Tue, 19 Jul 2022 05:27:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A197B6195D;
        Tue, 19 Jul 2022 12:26:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C46CC341C6;
        Tue, 19 Jul 2022 12:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233609;
        bh=1KmHyOePefQuZwKR3wjta7U25tAiCddu1jgMJvAPAfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PYnCi6hIN9LkTtjNm4z6iDrzCQDwP7NcBUbytXNpc4PqZv1y61NKvPyaxqGNxf+TS
         uYjOH5Q9BFUtNy982EkMY9OMyGnDiTezAMjqxQrHwekYuUDpMJyiQQWissfNItXX00
         E+M5uLfUfxrCqtB3woSJ4Z0n6INlBGw8kB2gQXD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 151/231] ARM: 9211/1: domain: drop modify_domain()
Date:   Tue, 19 Jul 2022 13:53:56 +0200
Message-Id: <20220719114727.031651925@linuxfoundation.org>
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

[ Upstream commit cc45b836388f0ccc6831288a08f77a33845f10b0 ]

This function/macro isn't used anywhere in the kernel.
The only user was set_fs() and was deleted in the set_fs()
removal patch set.

Fixes: 8ac6f5d7f84b ("ARM: 9113/1: uaccess: remove set_fs() implementation")
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/domain.h | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/arch/arm/include/asm/domain.h b/arch/arm/include/asm/domain.h
index f1d0a7807cd0..41536feb4392 100644
--- a/arch/arm/include/asm/domain.h
+++ b/arch/arm/include/asm/domain.h
@@ -112,19 +112,6 @@ static __always_inline void set_domain(unsigned int val)
 }
 #endif
 
-#ifdef CONFIG_CPU_USE_DOMAINS
-#define modify_domain(dom,type)					\
-	do {							\
-		unsigned int domain = get_domain();		\
-		domain &= ~domain_mask(dom);			\
-		domain = domain | domain_val(dom, type);	\
-		set_domain(domain);				\
-	} while (0)
-
-#else
-static inline void modify_domain(unsigned dom, unsigned type)	{ }
-#endif
-
 /*
  * Generate the T (user) versions of the LDR/STR and related
  * instructions (inline assembly)
-- 
2.35.1



