Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63A34ABBB1
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384721AbiBGL3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:29:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383302AbiBGLWF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:22:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC87C0401C0;
        Mon,  7 Feb 2022 03:22:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAF0E61380;
        Mon,  7 Feb 2022 11:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446C6C004E1;
        Mon,  7 Feb 2022 11:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232923;
        bh=qGx8pLorX6OJ0M3ZEKrK/Gl5ED4V6pQ8BoJGOTE1Dts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uGnzqlTiR7wML5f9KqCkF4iUYmIUYViR4ZjvqSzpjV9Z+kCbNqT6ImVo8ihgrruQv
         Uzj8tb2hrWeJok4vm9KddbcKIiKbFad32a354tzNGTaaRH5pylS2hVJS9XrOMJ0vYS
         toTru6tvIiX7vkaqpKQTDc7D7bVS6hrWwVHHA/2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pasha Tatashin <pasha.tatashin@soleen.com>,
        Zi Yan <ziy@nvidia.com>, David Rientjes <rientjes@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Paul Turner <pjt@google.com>, Wei Xu <weixugc@google.com>,
        Greg Thelen <gthelen@google.com>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Mike Rapoport <rppt@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 17/74] mm/debug_vm_pgtable: remove pte entry from the page table
Date:   Mon,  7 Feb 2022 12:06:15 +0100
Message-Id: <20220207103757.797627637@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
References: <20220207103757.232676988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pasha Tatashin <pasha.tatashin@soleen.com>

commit fb5222aae64fe25e5f3ebefde8214dcf3ba33ca5 upstream.

Patch series "page table check fixes and cleanups", v5.

This patch (of 4):

The pte entry that is used in pte_advanced_tests() is never removed from
the page table at the end of the test.

The issue is detected by page_table_check, to repro compile kernel with
the following configs:

CONFIG_DEBUG_VM_PGTABLE=y
CONFIG_PAGE_TABLE_CHECK=y
CONFIG_PAGE_TABLE_CHECK_ENFORCED=y

During the boot the following BUG is printed:

  debug_vm_pgtable: [debug_vm_pgtable         ]: Validating architecture page table helpers
  ------------[ cut here ]------------
  kernel BUG at mm/page_table_check.c:162!
  invalid opcode: 0000 [#1] PREEMPT SMP PTI
  CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.16.0-11413-g2c271fe77d52 #3
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
  ...

The entry should be properly removed from the page table before the page
is released to the free list.

Link: https://lkml.kernel.org/r/20220131203249.2832273-1-pasha.tatashin@soleen.com
Link: https://lkml.kernel.org/r/20220131203249.2832273-2-pasha.tatashin@soleen.com
Fixes: a5c3b9ffb0f4 ("mm/debug_vm_pgtable: add tests validating advanced arch page table helpers")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Paul Turner <pjt@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>	[5.9+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/debug_vm_pgtable.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -128,6 +128,8 @@ static void __init pte_advanced_tests(st
 	ptep_test_and_clear_young(vma, vaddr, ptep);
 	pte = ptep_get(ptep);
 	WARN_ON(pte_young(pte));
+
+	ptep_get_and_clear_full(mm, vaddr, ptep, 1);
 }
 
 static void __init pte_savedwrite_tests(unsigned long pfn, pgprot_t prot)


