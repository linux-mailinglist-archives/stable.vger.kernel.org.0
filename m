Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6BF37C9CA
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235968AbhELQV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:21:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240265AbhELQRu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:17:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9505461D68;
        Wed, 12 May 2021 15:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834212;
        bh=mZqMfqIyQnFIX1dFL66/P3v+WkMGX+WqxDWMNiC+Lg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w1c8wesGpsEJTeuZ2haD3zdmCMvFVbdGQNMgQiWOJ0qCNfqEvh0qsBHkWtFKGYjgV
         mTaSjuhIY9PT7/uUl5pcmsDYxjDS0VbvNtUvTm2uz56GACk+7zPe2IxoXetfuoP2sj
         F8pMQS/z8luFZFFNoUL6ixWk3rI4fvYBU3ZvKleE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Daniel Axtens <dja@axtens.net>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 454/601] powerpc/64s: Use htab_convert_pte_flags() in hash__mark_rodata_ro()
Date:   Wed, 12 May 2021 16:48:51 +0200
Message-Id: <20210512144842.793257110@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 2c02e656a29d5f64193eb93da92781bcf0517146 ]

In hash__mark_rodata_ro() we pass the raw PP_RXXX value to
hash__change_memory_range(). That has the effect of setting the key to
zero, because PP_RXXX contains no key value.

Fix it by using htab_convert_pte_flags(), which knows how to convert a
pgprot into a pp value, including the key.

Fixes: d94b827e89dc ("powerpc/book3s64/kuap: Use Key 3 for kernel mapping with hash translation")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Daniel Axtens <dja@axtens.net>
Link: https://lore.kernel.org/r/20210331003845.216246-3-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/book3s64/hash_pgtable.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/hash_pgtable.c b/arch/powerpc/mm/book3s64/hash_pgtable.c
index 567e0c6b3978..03819c259f0a 100644
--- a/arch/powerpc/mm/book3s64/hash_pgtable.c
+++ b/arch/powerpc/mm/book3s64/hash_pgtable.c
@@ -428,12 +428,14 @@ static bool hash__change_memory_range(unsigned long start, unsigned long end,
 
 void hash__mark_rodata_ro(void)
 {
-	unsigned long start, end;
+	unsigned long start, end, pp;
 
 	start = (unsigned long)_stext;
 	end = (unsigned long)__init_begin;
 
-	WARN_ON(!hash__change_memory_range(start, end, PP_RXXX));
+	pp = htab_convert_pte_flags(pgprot_val(PAGE_KERNEL_ROX), HPTE_USE_KERNEL_KEY);
+
+	WARN_ON(!hash__change_memory_range(start, end, pp));
 }
 
 void hash__mark_initmem_nx(void)
-- 
2.30.2



