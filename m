Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7ABC2E3E9B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503561AbgL1OaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:30:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:38076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503498AbgL1O37 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:29:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D119520731;
        Mon, 28 Dec 2020 14:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165759;
        bh=vFPyLfDPH6Ev0LuAJ5FVdAVsKR+J70aSxKEyxcdBivE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G5Wm05W2NnNOHscUdI6qrMC5ppPsMBFIsfGsCu3JD478ncoeYYQpPqDX+tdcYwXKC
         vvzGmRwruc1okyVZkXcH+hX9jPmWMHcHpSEOAX6bnEm3e7yo63VS3KYRWkaEqsVvYW
         kZBBIKaoaUSWglJ2KLBizJBJZIwq0znB2xZHAu5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 614/717] powerpc/mm: Fix verification of MMU_FTR_TYPE_44x
Date:   Mon, 28 Dec 2020 13:50:12 +0100
Message-Id: <20201228125050.334345593@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
@@ -532,7 +532,7 @@ void __flush_dcache_icache(void *p)
 	 * space occurs, before returning to user space.
 	 */
 
-	if (cpu_has_feature(MMU_FTR_TYPE_44x))
+	if (mmu_has_feature(MMU_FTR_TYPE_44x))
 		return;
 
 	invalidate_icache_range(addr, addr + PAGE_SIZE);


