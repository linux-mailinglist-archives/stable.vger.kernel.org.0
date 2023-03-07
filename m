Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C47A6AF587
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234157AbjCGT0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:26:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234180AbjCGT0X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:26:23 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76C53D087
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:12:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B0223CE1C84
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E69AC433EF;
        Tue,  7 Mar 2023 19:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678216335;
        bh=MhWUKmwn7nZ/j3LM6EDvd1RDU0zOygRlDWGV6FthwJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DPGlftNgXIkemkCJdzT8PQw3WtwwvQMVDTJSNmadrU/weS6mEX4jB1if+Isit6dOG
         1EL5iJUt9TReA6BAI4BYcIP0AmX2av0OeYbb2hsoVenofisD3Vy399u6ICbXpR8O42
         JUmaG8DaUVPVGIBq8au3XfCU39VeAti0R75lqcfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 551/567] riscv: mm: fix regression due to update_mmu_cache change
Date:   Tue,  7 Mar 2023 18:04:47 +0100
Message-Id: <20230307165929.855218963@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Matyukevich <sergey.matyukevich@syntacore.com>

commit b49f700668fff7565b945dce823def79bff59bb0 upstream.

This is a partial revert of the commit 4bd1d80efb5a ("riscv: mm: notify
remote harts about mmu cache updates"). Original commit included two
loosely related changes serving the same purpose of fixing stale TLB
entries causing user-space application crash:
- introduce deferred per-ASID TLB flush for CPUs not running the task
- switch to per-ASID TLB flush on all CPUs running the task in update_mmu_cache

According to report and discussion in [1], the second part caused a
regression on Renesas RZ/Five SoC. For now restore the old behavior
of the update_mmu_cache.

[1] https://lore.kernel.org/linux-riscv/20220829205219.283543-1-geomatsi@gmail.com/

Fixes: 4bd1d80efb5a ("riscv: mm: notify remote harts about mmu cache updates")
Reported-by: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Signed-off-by: Sergey Matyukevich <sergey.matyukevich@syntacore.com>
Link: trailer, so that it can be parsed with git's trailer functionality?
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20230129211818.686557-1-geomatsi@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -386,7 +386,7 @@ static inline void update_mmu_cache(stru
 	 * Relying on flush_tlb_fix_spurious_fault would suffice, but
 	 * the extra traps reduce performance.  So, eagerly SFENCE.VMA.
 	 */
-	flush_tlb_page(vma, address);
+	local_flush_tlb_page(address);
 }
 
 static inline void update_mmu_cache_pmd(struct vm_area_struct *vma,


