Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADA8D157840
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729847AbgBJNGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:06:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:38534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729554AbgBJMjx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:53 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C17B208C4;
        Mon, 10 Feb 2020 12:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338392;
        bh=8u5vfo0W6dwew4wkxSb7nqRjuWXE9FNdYdLLyBEAE/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MdYmF6REsu87ZdFwirY0MaiYf5Ertsfb6A1aDtLNs/yKoWkZKgl7DuUSK64RAMzBg
         0dnH0E6Fcw3raSHVSEIuAdPOH3BCBE4iqnKKI3V0P/UxZxf5n/12bD2VtJrLlJo/2J
         KT3yWGTg93iS/HCJjnpte2G6l/3QqcVmeB/wb4sQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.5 084/367] powerpc/ptdump: Fix W+X verification
Date:   Mon, 10 Feb 2020 04:29:57 -0800
Message-Id: <20200210122432.102362739@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit d80ae83f1f932ab7af47b54d0d3bef4f4dba489f upstream.

Verification cannot rely on simple bit checking because on some
platforms PAGE_RW is 0, checking that a page is not W means
checking that PAGE_RO is set instead of checking that PAGE_RW
is not set.

Use pte helpers instead of checking bits.

Fixes: 453d87f6a8ae ("powerpc/mm: Warn if W+X pages found on boot")
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/0d894839fdbb19070f0e1e4140363be4f2bb62fc.1578989540.git.christophe.leroy@c-s.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/ptdump/ptdump.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/powerpc/mm/ptdump/ptdump.c
+++ b/arch/powerpc/mm/ptdump/ptdump.c
@@ -173,10 +173,12 @@ static void dump_addr(struct pg_state *s
 
 static void note_prot_wx(struct pg_state *st, unsigned long addr)
 {
+	pte_t pte = __pte(st->current_flags);
+
 	if (!IS_ENABLED(CONFIG_PPC_DEBUG_WX) || !st->check_wx)
 		return;
 
-	if (!((st->current_flags & pgprot_val(PAGE_KERNEL_X)) == pgprot_val(PAGE_KERNEL_X)))
+	if (!pte_write(pte) || !pte_exec(pte))
 		return;
 
 	WARN_ONCE(1, "powerpc/mm: Found insecure W+X mapping at address %p/%pS\n",


