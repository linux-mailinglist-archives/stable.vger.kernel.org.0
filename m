Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 531A3694A50
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjBMPGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:06:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbjBMPGS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:06:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987791B541
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:06:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E2C7B81256
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4DEC433D2;
        Mon, 13 Feb 2023 15:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300775;
        bh=N68nEjPipR2EjZtfxCf0mBnBAGSWiuZkGQzPgJQ94+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QyouM3RpJ54f/jW5Y2Rr5AX9Y+JaVCJi+8MHY+bo7J5NwHwCNW5lwj0aSoCaGuFay
         /2QpHFex+M+bSi6ONH8MoJWqxMJMqmyaedh6wV/HP4ymK/XoiH5PfH2uRua93HYrUU
         mB2BpkNifpzntKqz34Om1fOD5einejfV8H/ErmWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Guo Ren <guoren@linux.alibaba.com>,
        Guo Ren <guoren@kernel.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.10 134/139] riscv: Fixup race condition on PG_dcache_clean in flush_icache_pte
Date:   Mon, 13 Feb 2023 15:51:19 +0100
Message-Id: <20230213144753.069003240@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

commit 950b879b7f0251317d26bae0687e72592d607532 upstream.

In commit 588a513d3425 ("arm64: Fix race condition on PG_dcache_clean
in __sync_icache_dcache()"), we found RISC-V has the same issue as the
previous arm64. The previous implementation didn't guarantee the correct
sequence of operations, which means flush_icache_all() hasn't been
called when the PG_dcache_clean was set. That would cause a risk of page
synchronization.

Fixes: 08f051eda33b ("RISC-V: Flush I$ when making a dirty page executable")
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20230127035306.1819561-1-guoren@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/mm/cacheflush.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/riscv/mm/cacheflush.c
+++ b/arch/riscv/mm/cacheflush.c
@@ -85,7 +85,9 @@ void flush_icache_pte(pte_t pte)
 {
 	struct page *page = pte_page(pte);
 
-	if (!test_and_set_bit(PG_dcache_clean, &page->flags))
+	if (!test_bit(PG_dcache_clean, &page->flags)) {
 		flush_icache_all();
+		set_bit(PG_dcache_clean, &page->flags);
+	}
 }
 #endif /* CONFIG_MMU */


