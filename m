Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D360548C06
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383687AbiFMO1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384065AbiFMOYm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:24:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE06F48316;
        Mon, 13 Jun 2022 04:46:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3E51612AC;
        Mon, 13 Jun 2022 11:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBAA8C34114;
        Mon, 13 Jun 2022 11:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120799;
        bh=D30LyP4x5zEhrVjuQDj45JBU4eQu6819dhg1fmv8l+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n5cPVGI/JgKPmvRIkrtS+v5E0ftANcfz/xSsQKMLSn83E7L0eIQGK479jN0P4VpF/
         aLlZKIKTnKzvcO6AtnBQEOII+hJqx2pYGwYAJfl4pmus/qltl0yexKIzt1xpPI/mvv
         kSa9mirodzh1HKjtsaiopgOTaguoXSwyum45TSY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erhard Furtner <erhard_f@mailbox.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 161/298] powerpc/kasan: Force thread size increase with KASAN
Date:   Mon, 13 Jun 2022 12:10:55 +0200
Message-Id: <20220613094929.818510517@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 3e8635fb2e072672cbc650989ffedf8300ad67fb ]

KASAN causes increased stack usage, which can lead to stack overflows.

The logic in Kconfig to suggest a larger default doesn't work if a user
has CONFIG_EXPERT enabled and has an existing .config with a smaller
value.

Follow the lead of x86 and arm64, and force the thread size to be
increased when KASAN is enabled.

That also has the effect of enlarging the stack for 64-bit KASAN builds,
which is also desirable.

Fixes: edbadaf06710 ("powerpc/kasan: Fix stack overflow by increasing THREAD_SHIFT")
Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Reported-by: Christophe Leroy <christophe.leroy@csgroup.eu>
[mpe: Use MIN_THREAD_SHIFT as suggested by Christophe]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220601143114.133524-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Kconfig                   |  1 -
 arch/powerpc/include/asm/thread_info.h | 10 ++++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index b779603978e1..574e4ba13959 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -764,7 +764,6 @@ config THREAD_SHIFT
 	range 13 15
 	default "15" if PPC_256K_PAGES
 	default "14" if PPC64
-	default "14" if KASAN
 	default "13"
 	help
 	  Used to define the stack size. The default is almost always what you
diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
index d6e649b3c70b..bc3e1de9d08b 100644
--- a/arch/powerpc/include/asm/thread_info.h
+++ b/arch/powerpc/include/asm/thread_info.h
@@ -14,10 +14,16 @@
 
 #ifdef __KERNEL__
 
-#if defined(CONFIG_VMAP_STACK) && CONFIG_THREAD_SHIFT < PAGE_SHIFT
+#ifdef CONFIG_KASAN
+#define MIN_THREAD_SHIFT	(CONFIG_THREAD_SHIFT + 1)
+#else
+#define MIN_THREAD_SHIFT	CONFIG_THREAD_SHIFT
+#endif
+
+#if defined(CONFIG_VMAP_STACK) && MIN_THREAD_SHIFT < PAGE_SHIFT
 #define THREAD_SHIFT		PAGE_SHIFT
 #else
-#define THREAD_SHIFT		CONFIG_THREAD_SHIFT
+#define THREAD_SHIFT		MIN_THREAD_SHIFT
 #endif
 
 #define THREAD_SIZE		(1 << THREAD_SHIFT)
-- 
2.35.1



