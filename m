Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9367B2E3B67
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406165AbgL1Ntc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:49:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:51172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406145AbgL1Ntb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:49:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF399206D4;
        Mon, 28 Dec 2020 13:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163330;
        bh=zaxgaEkKzxTl4/XQu3GTS5usm3K8DeoIEXavCOHkPjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w9iw2lXwot2JQ0k8hdFaJdeLzsyjoAJgEO90s+veBurGSUBFw6wsW6mtRm0tIiUIJ
         qUvK0Tf9zI2qHb1qQ27dqKCW/Adb6JWDJE8DzOkEUN6BC5SKl/29Sf3vF46M1Tb+7/
         e5p12+bnThvV+CEZZe+GTLPDUZvezNqgZWn1v+uc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 249/453] powerpc/mm: sanity_check_fault() should work for all, not only BOOK3S
Date:   Mon, 28 Dec 2020 13:48:05 +0100
Message-Id: <20201228124949.209954959@linuxfoundation.org>
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

[ Upstream commit 7ceb40027e19567a0a066e3b380cc034cdd9a124 ]

The verification and message introduced by commit 374f3f5979f9
("powerpc/mm/hash: Handle user access of kernel address gracefully")
applies to all platforms, it should not be limited to BOOK3S.

Make the BOOK3S version of sanity_check_fault() the one for all,
and bail out earlier if not BOOK3S.

Fixes: 374f3f5979f9 ("powerpc/mm/hash: Handle user access of kernel address gracefully")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/fe199d5af3578d3bf80035d203a94d742a7a28af.1607491748.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/fault.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 187047592d53c..bb01a862aaf8d 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -349,7 +349,6 @@ static inline void cmo_account_page_fault(void)
 static inline void cmo_account_page_fault(void) { }
 #endif /* CONFIG_PPC_SMLPAR */
 
-#ifdef CONFIG_PPC_BOOK3S
 static void sanity_check_fault(bool is_write, bool is_user,
 			       unsigned long error_code, unsigned long address)
 {
@@ -366,6 +365,9 @@ static void sanity_check_fault(bool is_write, bool is_user,
 		return;
 	}
 
+	if (!IS_ENABLED(CONFIG_PPC_BOOK3S))
+		return;
+
 	/*
 	 * For hash translation mode, we should never get a
 	 * PROTFAULT. Any update to pte to reduce access will result in us
@@ -400,10 +402,6 @@ static void sanity_check_fault(bool is_write, bool is_user,
 
 	WARN_ON_ONCE(error_code & DSISR_PROTFAULT);
 }
-#else
-static void sanity_check_fault(bool is_write, bool is_user,
-			       unsigned long error_code, unsigned long address) { }
-#endif /* CONFIG_PPC_BOOK3S */
 
 /*
  * Define the correct "is_write" bit in error_code based
-- 
2.27.0



