Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150252E42D2
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406772AbgL1N46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:56:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:57712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405399AbgL1N4A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:56:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55FCE207B2;
        Mon, 28 Dec 2020 13:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163719;
        bh=PZUVlD8vaoqY2SjVW9TsaC6wGz3NxxKcN0zJnovltDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yuCsnYGFBe/eHQsuODZylTSsZXyoKv/wtY3C/GZKcr3XCscy5GT3VOl8JPT0aEhoR
         7garK3Jb8fgpbcOjFhgJEd4akyFi8syRn0kuAH1+t/7NoOP2OSfgo24hnk0KTV/4t/
         LKKb/XRXhfycevHUAw6VJmodgYC/DKqoInXdJj2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 385/453] powerpc/mm: Fix verification of MMU_FTR_TYPE_44x
Date:   Mon, 28 Dec 2020 13:50:21 +0100
Message-Id: <20201228124955.728150407@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 17179aeb9d34cc81e1a4ae3f85e5b12b13a1f8d0 upstream.

MMU_FTR_TYPE_44x cannot be checked by cpu_has_feature()

Use mmu_has_feature() instead

Fixes: 23eb7f560a2a ("powerpc: Convert flush_icache_range & friends to C")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/ceede82fadf37f3b8275e61fcf8cf29a3e2ec7fe.1602351011.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -530,7 +530,7 @@ void __flush_dcache_icache(void *p)
 	 * space occurs, before returning to user space.
 	 */
 
-	if (cpu_has_feature(MMU_FTR_TYPE_44x))
+	if (mmu_has_feature(MMU_FTR_TYPE_44x))
 		return;
 
 	invalidate_icache_range(addr, addr + PAGE_SIZE);


