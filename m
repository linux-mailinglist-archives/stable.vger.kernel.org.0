Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB3C6CC37F
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbjC1Oya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233534AbjC1Oy1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:54:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14DEDDBC7
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:54:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7018B80976
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:54:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19246C433D2;
        Tue, 28 Mar 2023 14:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015263;
        bh=DJ0CbK1NqKRNGloDc3w5YezRfW2KvfTJEJX1fXL9Vs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xl/Agg5JTkNkb1BMqe68pEjs8l/QivoGvnG367N61mrgXkpwMLcns23/GZ715oSZT
         7kSVHZGIJqUTw52Sx7NQ9iwhzn4kyKS4sulhwEjrVyYvS0lZMZXGcUe0wQ6AYi/6eb
         YFbZ9So2+1YktI+y1QLKJIZJZXgkcWGJqCeGLxc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dylan Jhong <dylan@andestech.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.2 225/240] riscv: mm: Fix incorrect ASID argument when flushing TLB
Date:   Tue, 28 Mar 2023 16:43:08 +0200
Message-Id: <20230328142629.107774069@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dylan Jhong <dylan@andestech.com>

commit 9a801afd3eb95e1a89aba17321062df06fb49d98 upstream.

Currently, we pass the CONTEXTID instead of the ASID to the TLB flush
function. We should only take the ASID field to prevent from touching
the reserved bit field.

Fixes: 3f1e782998cd ("riscv: add ASID-based tlbflushing methods")
Signed-off-by: Dylan Jhong <dylan@andestech.com>
Reviewed-by: Sergey Matyukevich <sergey.matyukevich@syntacore.com>
Link: https://lore.kernel.org/r/20230313034906.2401730-1-dylan@andestech.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/tlbflush.h |    2 ++
 arch/riscv/mm/context.c           |    2 +-
 arch/riscv/mm/tlbflush.c          |    2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)

--- a/arch/riscv/include/asm/tlbflush.h
+++ b/arch/riscv/include/asm/tlbflush.h
@@ -12,6 +12,8 @@
 #include <asm/errata_list.h>
 
 #ifdef CONFIG_MMU
+extern unsigned long asid_mask;
+
 static inline void local_flush_tlb_all(void)
 {
 	__asm__ __volatile__ ("sfence.vma" : : : "memory");
--- a/arch/riscv/mm/context.c
+++ b/arch/riscv/mm/context.c
@@ -22,7 +22,7 @@ DEFINE_STATIC_KEY_FALSE(use_asid_allocat
 
 static unsigned long asid_bits;
 static unsigned long num_asids;
-static unsigned long asid_mask;
+unsigned long asid_mask;
 
 static atomic_long_t current_version;
 
--- a/arch/riscv/mm/tlbflush.c
+++ b/arch/riscv/mm/tlbflush.c
@@ -42,7 +42,7 @@ static void __sbi_tlb_flush_range(struct
 	/* check if the tlbflush needs to be sent to other CPUs */
 	broadcast = cpumask_any_but(cmask, cpuid) < nr_cpu_ids;
 	if (static_branch_unlikely(&use_asid_allocator)) {
-		unsigned long asid = atomic_long_read(&mm->context.id);
+		unsigned long asid = atomic_long_read(&mm->context.id) & asid_mask;
 
 		if (broadcast) {
 			sbi_remote_sfence_vma_asid(cmask, start, size, asid);


