Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5DD4BE157
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243791AbiBUJXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:23:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350081AbiBUJWE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:22:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F41F0377DE;
        Mon, 21 Feb 2022 01:09:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6B256CE0E77;
        Mon, 21 Feb 2022 09:09:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499B2C340E9;
        Mon, 21 Feb 2022 09:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434563;
        bh=u2BL9KfYaOeHl3fDuBSVd0eyNFAA6AtmARcIQBuaaPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ws+pCJGHtvAZF2cGOY2rX9jtauEd55jzQm82prr4p00CInVj+cx1Zb99rlxpjY3GW
         6zaGyVLdU7jAxAlqhR4mOtLkXStCAEE1bnD3fWyGfiR9znAFNoqIKHFSw84uOoG+1u
         2OQRm+faprCoz/7eaeuLRGTDdfbRIp49fWZqZI78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 009/196] parisc: Drop __init from map_pages declaration
Date:   Mon, 21 Feb 2022 09:47:21 +0100
Message-Id: <20220221084931.206852763@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
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

From: John David Anglin <dave.anglin@bell.net>

commit 9129886b88185962538180625ca8051362b01327 upstream.

With huge kernel pages, we randomly eat a SPARC in map_pages(). This
is fixed by dropping __init from the declaration.

However, map_pages references the __init routine memblock_alloc_try_nid
via memblock_alloc.  Thus, it needs to be marked with __ref.

memblock_alloc is only called before the kernel text is set to readonly.

The __ref on free_initmem is no longer needed.

Comment regarding map_pages being in the init section is removed.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/mm/init.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -341,9 +341,9 @@ static void __init setup_bootmem(void)
 
 static bool kernel_set_to_readonly;
 
-static void __init map_pages(unsigned long start_vaddr,
-			     unsigned long start_paddr, unsigned long size,
-			     pgprot_t pgprot, int force)
+static void __ref map_pages(unsigned long start_vaddr,
+			    unsigned long start_paddr, unsigned long size,
+			    pgprot_t pgprot, int force)
 {
 	pmd_t *pmd;
 	pte_t *pg_table;
@@ -453,7 +453,7 @@ void __init set_kernel_text_rw(int enabl
 	flush_tlb_all();
 }
 
-void __ref free_initmem(void)
+void free_initmem(void)
 {
 	unsigned long init_begin = (unsigned long)__init_begin;
 	unsigned long init_end = (unsigned long)__init_end;
@@ -467,7 +467,6 @@ void __ref free_initmem(void)
 	/* The init text pages are marked R-X.  We have to
 	 * flush the icache and mark them RW-
 	 *
-	 * This is tricky, because map_pages is in the init section.
 	 * Do a dummy remap of the data section first (the data
 	 * section is already PAGE_KERNEL) to pull in the TLB entries
 	 * for map_kernel */


