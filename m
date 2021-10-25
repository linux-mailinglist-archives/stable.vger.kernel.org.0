Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73FC143A20C
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235642AbhJYTop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:44:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:59644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236945AbhJYTlw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:41:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6305161184;
        Mon, 25 Oct 2021 19:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190617;
        bh=vjwLFw9pgANuK9TG71AsJEVkX6MUy+j94W9z9q5Dh6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ygP1SFKtJ3cgWQ2ZQQSIfd165C9JWa9nWpkKfR57PdXj7nCUMX2ZbRmLNWuNT3S3w
         WXgLy9CvlzFi5/zgNCmM2E0fbLQczLGG6RUQnWnueHchOj1KroYE/EfP2185Qf2qpw
         lOkyusqUr27/Q274VuF6iXq277aUcxd/TQEmfWho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Daniel Palmer <daniel@thingy.jp>,
        Rob Landley <rob@landley.net>,
        Yoshinori Sato <ysato@users.osdn.me>,
        Rich Felker <dalias@libc.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.14 003/169] sh: pgtable-3level: fix cast to pointer from integer of different size
Date:   Mon, 25 Oct 2021 21:13:04 +0200
Message-Id: <20211025191018.181512762@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit e8e9f1e6327005be9656aa135aeb9dfdaf6b3032 upstream.

If X2TLB=y (CPU_SHX2=y or CPU_SHX3=y, e.g. migor_defconfig), pgd_t.pgd
is "unsigned long long", causing:

    In file included from arch/sh/include/asm/pgtable.h:13,
		     from include/linux/pgtable.h:6,
		     from include/linux/mm.h:33,
		     from arch/sh/kernel/asm-offsets.c:14:
    arch/sh/include/asm/pgtable-3level.h: In function `pud_pgtable':
    arch/sh/include/asm/pgtable-3level.h:37:9: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
       37 |  return (pmd_t *)pud_val(pud);
	  |         ^

Fix this by adding an intermediate cast to "unsigned long", which is
basically what the old code did before.

Link: https://lkml.kernel.org/r/2c2eef3c9a2f57e5609100a4864715ccf253d30f.1631713483.git.geert+renesas@glider.be
Fixes: 9cf6fa2458443118 ("mm: rename pud_page_vaddr to pud_pgtable and make it return pmd_t *")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Daniel Palmer <daniel@thingy.jp>
Acked-by: Rob Landley <rob@landley.net>
Cc: Yoshinori Sato <ysato@users.osdn.me>
Cc: Rich Felker <dalias@libc.org>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sh/include/asm/pgtable-3level.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sh/include/asm/pgtable-3level.h
+++ b/arch/sh/include/asm/pgtable-3level.h
@@ -34,7 +34,7 @@ typedef struct { unsigned long long pmd;
 
 static inline pmd_t *pud_pgtable(pud_t pud)
 {
-	return (pmd_t *)pud_val(pud);
+	return (pmd_t *)(unsigned long)pud_val(pud);
 }
 
 /* only used by the stubbed out hugetlb gup code, should never be called */


