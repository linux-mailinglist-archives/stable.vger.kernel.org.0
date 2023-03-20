Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B418A6C19D5
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbjCTPiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233188AbjCTPi1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:38:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2252AD537
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:29:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0220B6158F
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:29:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13AD2C433EF;
        Mon, 20 Mar 2023 15:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679326197;
        bh=VJo3hoM7rw25fjMR1e/8yeqq6uNK7j+UmmrgwfD1feE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kFJ6/Te8TDVJrWANxjEWAwwAjwab5isuxlvSCrFUp0t+jGLmhF8H4ZQK6MQam7vk6
         +XMbHvQQ2wz8Kw2wwsx7T0sQNPHngUq1uyb4FUvUY86Rj46NvkvHok/7tBS0vVwPdJ
         syunOWGqlFwX6mBpn5wUfqjOlQtbWCv60jevFrlk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dylan Jhong <dylan@andestech.com>,
        Alexandre Ghiti <alexghiti@rivosinc.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.2 196/211] RISC-V: mm: Support huge page in vmalloc_fault()
Date:   Mon, 20 Mar 2023 15:55:31 +0100
Message-Id: <20230320145521.748427474@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
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

From: Dylan Jhong <dylan@andestech.com>

commit 47dd902aaee9b9341808a3a994793199e7eddb88 upstream.

Since RISC-V supports ioremap() with huge page (pud/pmd) mapping,
However, vmalloc_fault() assumes that the vmalloc range is limited
to pte mappings. To complete the vmalloc_fault() function by adding
huge page support.

Fixes: 310f541a027b ("riscv: Enable HAVE_ARCH_HUGE_VMAP for 64BIT")
Cc: stable@vger.kernel.org
Signed-off-by: Dylan Jhong <dylan@andestech.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20230310075021.3919290-1-dylan@andestech.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/mm/fault.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/riscv/mm/fault.c b/arch/riscv/mm/fault.c
index 460f785f6e09..d5f3e501dffb 100644
--- a/arch/riscv/mm/fault.c
+++ b/arch/riscv/mm/fault.c
@@ -143,6 +143,8 @@ static inline void vmalloc_fault(struct pt_regs *regs, int code, unsigned long a
 		no_context(regs, addr);
 		return;
 	}
+	if (pud_leaf(*pud_k))
+		goto flush_tlb;
 
 	/*
 	 * Since the vmalloc area is global, it is unnecessary
@@ -153,6 +155,8 @@ static inline void vmalloc_fault(struct pt_regs *regs, int code, unsigned long a
 		no_context(regs, addr);
 		return;
 	}
+	if (pmd_leaf(*pmd_k))
+		goto flush_tlb;
 
 	/*
 	 * Make sure the actual PTE exists as well to
@@ -172,6 +176,7 @@ static inline void vmalloc_fault(struct pt_regs *regs, int code, unsigned long a
 	 * ordering constraint, not a cache flush; it is
 	 * necessary even after writing invalid entries.
 	 */
+flush_tlb:
 	local_flush_tlb_page(addr);
 }
 
-- 
2.40.0



