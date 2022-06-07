Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01275541D20
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379656AbiFGWIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379898AbiFGWG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:06:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8610F2534C6;
        Tue,  7 Jun 2022 12:16:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F298B823CA;
        Tue,  7 Jun 2022 19:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB75C385A2;
        Tue,  7 Jun 2022 19:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629403;
        bh=2clv+eIChWCU75Deg8PZdCXvoxeLsnNaYAdk+/FkBa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xDIR0CBrbPrZyYEnuuf6Sqtj/KyQJs9jOCiyckjAohhocKtyN9HEZPWtgbbAshA8Y
         Iw0MFYI339yfAaoan4deGP28B0rsBk69LG36PkBwsQgqZLX1JfCAuUPz3ro47KHrAC
         qAr4OX5AP3eJkb7HZwj38cRw0XQ21y5bYmhlx5E0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 638/879] powerpc/64: Only WARN if __pa()/__va() called with bad addresses
Date:   Tue,  7 Jun 2022 19:02:36 +0200
Message-Id: <20220607165021.366729178@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

[ Upstream commit c4bce84d0bd3f396f702d69be2e92bbd8af97583 ]

We added checks to __pa() / __va() to ensure they're only called with
appropriate addresses. But using BUG_ON() is too strong, it means
virt_addr_valid() will BUG when DEBUG_VIRTUAL is enabled.

Instead switch them to warnings, arm64 does the same.

Fixes: 4dd7554a6456 ("powerpc/64: Add VIRTUAL_BUG_ON checks for __va and __pa addresses")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220406145802.538416-5-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/page.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/page.h b/arch/powerpc/include/asm/page.h
index f2c5c26869f1..03ae544eb6cc 100644
--- a/arch/powerpc/include/asm/page.h
+++ b/arch/powerpc/include/asm/page.h
@@ -216,6 +216,9 @@ static inline bool pfn_valid(unsigned long pfn)
 #define __pa(x) ((phys_addr_t)(unsigned long)(x) - VIRT_PHYS_OFFSET)
 #else
 #ifdef CONFIG_PPC64
+
+#define VIRTUAL_WARN_ON(x)	WARN_ON(IS_ENABLED(CONFIG_DEBUG_VIRTUAL) && (x))
+
 /*
  * gcc miscompiles (unsigned long)(&static_var) - PAGE_OFFSET
  * with -mcmodel=medium, so we use & and | instead of - and + on 64-bit.
@@ -223,13 +226,13 @@ static inline bool pfn_valid(unsigned long pfn)
  */
 #define __va(x)								\
 ({									\
-	VIRTUAL_BUG_ON((unsigned long)(x) >= PAGE_OFFSET);		\
+	VIRTUAL_WARN_ON((unsigned long)(x) >= PAGE_OFFSET);		\
 	(void *)(unsigned long)((phys_addr_t)(x) | PAGE_OFFSET);	\
 })
 
 #define __pa(x)								\
 ({									\
-	VIRTUAL_BUG_ON((unsigned long)(x) < PAGE_OFFSET);		\
+	VIRTUAL_WARN_ON((unsigned long)(x) < PAGE_OFFSET);		\
 	(unsigned long)(x) & 0x0fffffffffffffffUL;			\
 })
 
-- 
2.35.1



