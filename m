Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF2354156C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356319AbiFGUfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377616AbiFGUdx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:33:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1761E562E;
        Tue,  7 Jun 2022 11:35:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0FBEB8237C;
        Tue,  7 Jun 2022 18:35:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED334C385A2;
        Tue,  7 Jun 2022 18:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626931;
        bh=K1VJeX5GCDsY+9X8S0bObVsEpIXlCrJ6Ne/vbZkkzvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FR+jnPisAy8yUUHtryOpQrOo6wNnzXmeQlQMs9bvH/V1+xo4GAbEWjk1cVLZYck4+
         QTi6TJsqkP7IWNZ5yLkMzBmeR8/4Opn94CJWbMugZHElPDyS/5zrGmi3qfFLg8L+pa
         KoXTEv6m0/+QihovVwi49YYMeA5Mk/e+lBlxJkdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 554/772] powerpc/fsl_book3e: Dont set rodata RO too early
Date:   Tue,  7 Jun 2022 19:02:26 +0200
Message-Id: <20220607165005.286053255@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit ad91f66f5fa7c6f9346e721c3159ce818568028b ]

On fsl_book3e, rodata is set read-only at the same time as
init text is set NX at the end of init. That's too early.

As both action are performed at the same time, delay both
actions to the time rodata is expected to be made read-only.

It means we will have a small window with init mem freed but
still executable. It shouldn't be an issue though, especially
because the said memory gets poisoned and should therefore
result to a bad instruction fault in case it gets executed.

mmu_mark_initmem_nx() is bailing out before doing anything when
CONFIG_STRICT_KERNEL_RWX is not selected or rodata_enabled is false.

mmu_mark_rodata_ro() is called only when CONFIG_STRICT_KERNEL_RWX
is selected and rodata_enabled is true so this is equivalent.

Move code from mmu_mark_initmem_nx() into mmu_mark_rodata_ro() and
remove the call to strict_kernel_rwx_enabled() which is not needed
anymore.

Fixes: d5970045cf9e ("powerpc/fsl_booke: Update of TLBCAMs after init")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/2e35f0fd649c83c5add17a99514ac040767be93a.1652981047.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/nohash/fsl_book3e.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/mm/nohash/fsl_book3e.c b/arch/powerpc/mm/nohash/fsl_book3e.c
index dfe715e0f70a..388f7c7dabd3 100644
--- a/arch/powerpc/mm/nohash/fsl_book3e.c
+++ b/arch/powerpc/mm/nohash/fsl_book3e.c
@@ -287,22 +287,19 @@ void __init adjust_total_lowmem(void)
 
 #ifdef CONFIG_STRICT_KERNEL_RWX
 void mmu_mark_rodata_ro(void)
-{
-	/* Everything is done in mmu_mark_initmem_nx() */
-}
-#endif
-
-void mmu_mark_initmem_nx(void)
 {
 	unsigned long remapped;
 
-	if (!strict_kernel_rwx_enabled())
-		return;
-
 	remapped = map_mem_in_cams(__max_low_memory, CONFIG_LOWMEM_CAM_NUM, false, false);
 
 	WARN_ON(__max_low_memory != remapped);
 }
+#endif
+
+void mmu_mark_initmem_nx(void)
+{
+	/* Everything is done in mmu_mark_rodata_ro() */
+}
 
 void setup_initial_memory_limit(phys_addr_t first_memblock_base,
 				phys_addr_t first_memblock_size)
-- 
2.35.1



