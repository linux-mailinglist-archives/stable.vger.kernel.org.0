Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1E752E409C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408058AbgL1Oyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:54:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:52332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441393AbgL1ORM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:17:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59E61205CB;
        Mon, 28 Dec 2020 14:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164992;
        bh=RlDsBlXLsQ3QoR4KAsOlMurTbZ/ADKzYradXQZvelg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OBRlbtUft8X9UM5uR1FQQ6w5dhei7K1B2LhLihOAG8NtWf9umXKCGk3V6STqzlGBH
         dU+2CzybvTnOVN4Ua2qy76M5iS0/1esw+TJyReKUgrErwk59hM9VdYYbUdaW09Z/sA
         SgNa8Wq0PJy2/kjTfH6Pg9pfwOeuBeelhRX/2Olw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 371/717] powerpc/mm: sanity_check_fault() should work for all, not only BOOK3S
Date:   Mon, 28 Dec 2020 13:46:09 +0100
Message-Id: <20201228125038.782440876@linuxfoundation.org>
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
index 0add963a849b3..72e1b51beb10c 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -303,7 +303,6 @@ static inline void cmo_account_page_fault(void)
 static inline void cmo_account_page_fault(void) { }
 #endif /* CONFIG_PPC_SMLPAR */
 
-#ifdef CONFIG_PPC_BOOK3S
 static void sanity_check_fault(bool is_write, bool is_user,
 			       unsigned long error_code, unsigned long address)
 {
@@ -320,6 +319,9 @@ static void sanity_check_fault(bool is_write, bool is_user,
 		return;
 	}
 
+	if (!IS_ENABLED(CONFIG_PPC_BOOK3S))
+		return;
+
 	/*
 	 * For hash translation mode, we should never get a
 	 * PROTFAULT. Any update to pte to reduce access will result in us
@@ -354,10 +356,6 @@ static void sanity_check_fault(bool is_write, bool is_user,
 
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



