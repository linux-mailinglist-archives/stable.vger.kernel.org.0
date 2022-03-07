Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3CE4CF940
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239102AbiCGKEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:04:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240892AbiCGKBa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:01:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB6C6E2BA;
        Mon,  7 Mar 2022 01:51:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1E4260929;
        Mon,  7 Mar 2022 09:51:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEC1C340F6;
        Mon,  7 Mar 2022 09:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646663;
        bh=a3ONiWZbtGmbWMaDBIz7szQySVCi5LFkDtFJQO9O+rU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2s/iESb6AJsWJlS9KebLimMbsP466dJWrQmBuwLpKPGj/tbjpV28nDE+ZbruQQYyy
         zrw0ZRi3faFd+3Wo/erNNZjoUzVhaymIOtUmmQO2JzAw2sWj1TzleRjHRk7UAE7EYN
         AqtZ2V48dAd2ynED8qj2bhhg/LKl/Fu7usSot0dY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.16 052/186] riscv: Fix config KASAN && SPARSEMEM && !SPARSE_VMEMMAP
Date:   Mon,  7 Mar 2022 10:18:10 +0100
Message-Id: <20220307091655.548686128@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Ghiti <alexandre.ghiti@canonical.com>

commit a3d328037846d013bb4c7f3777241e190e4c75e1 upstream.

In order to get the pfn of a struct page* when sparsemem is enabled
without vmemmap, the mem_section structures need to be initialized which
happens in sparse_init.

But kasan_early_init calls pfn_to_page way before sparse_init is called,
which then tries to dereference a null mem_section pointer.

Fix this by removing the usage of this function in kasan_early_init.

Fixes: 8ad8b72721d0 ("riscv: Add KASAN support")
Signed-off-by: Alexandre Ghiti <alexandre.ghiti@canonical.com>
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/mm/kasan_init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/riscv/mm/kasan_init.c
+++ b/arch/riscv/mm/kasan_init.c
@@ -22,8 +22,7 @@ asmlinkage void __init kasan_early_init(
 
 	for (i = 0; i < PTRS_PER_PTE; ++i)
 		set_pte(kasan_early_shadow_pte + i,
-			mk_pte(virt_to_page(kasan_early_shadow_page),
-			       PAGE_KERNEL));
+			pfn_pte(virt_to_pfn(kasan_early_shadow_page), PAGE_KERNEL));
 
 	for (i = 0; i < PTRS_PER_PMD; ++i)
 		set_pmd(kasan_early_shadow_pmd + i,


