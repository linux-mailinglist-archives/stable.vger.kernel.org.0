Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 971C55A49BC
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiH2L3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbiH2L2W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:28:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999A079600;
        Mon, 29 Aug 2022 04:16:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1BF7B80F92;
        Mon, 29 Aug 2022 11:16:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ADB7C433C1;
        Mon, 29 Aug 2022 11:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771814;
        bh=zP9teG4g2k77iBIISVR9f46KcpRZc5GjFyYLRroBqsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jl/rvxdXa/uGM3doo/WvMjbUXOJddDRtUGzhhSxRy1aVf4Dh+4VDXKaFUiLmtY3gB
         dqtADNpRzVKfujinUJncrzrSwk+KrTJQSeLNOGNOVaEU5yW3z38Vu871jdKMwDLbHb
         U2IZj3w4Sof0QtX3RDlXetgpQb+2D6TghWUn3Fa4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.19 106/158] x86/sev: Dont use cc_platform_has() for early SEV-SNP calls
Date:   Mon, 29 Aug 2022 12:59:16 +0200
Message-Id: <20220829105813.541426749@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Tom Lendacky <thomas.lendacky@amd.com>

commit cdaa0a407f1acd3a44861e3aea6e3c7349e668f1 upstream.

When running identity-mapped and depending on the kernel configuration,
it is possible that the compiler uses jump tables when generating code
for cc_platform_has().

This causes a boot failure because the jump table uses un-mapped kernel
virtual addresses, not identity-mapped addresses. This has been seen
with CONFIG_RETPOLINE=n.

Similar to sme_encrypt_kernel(), use an open-coded direct check for the
status of SNP rather than trying to eliminate the jump table. This
preserves any code optimization in cc_platform_has() that can be useful
post boot. It also limits the changes to SEV-specific files so that
future compiler features won't necessarily require possible build changes
just because they are not compatible with running identity-mapped.

  [ bp: Massage commit message. ]

Fixes: 5e5ccff60a29 ("x86/sev: Add helper for validating pages in early enc attribute changes")
Reported-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org> # 5.19.x
Link: https://lore.kernel.org/all/YqfabnTRxFSM+LoX@google.com/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/sev.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -701,7 +701,13 @@ e_term:
 void __init early_snp_set_memory_private(unsigned long vaddr, unsigned long paddr,
 					 unsigned int npages)
 {
-	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
+	/*
+	 * This can be invoked in early boot while running identity mapped, so
+	 * use an open coded check for SNP instead of using cc_platform_has().
+	 * This eliminates worries about jump tables or checking boot_cpu_data
+	 * in the cc_platform_has() function.
+	 */
+	if (!(sev_status & MSR_AMD64_SEV_SNP_ENABLED))
 		return;
 
 	 /*
@@ -717,7 +723,13 @@ void __init early_snp_set_memory_private
 void __init early_snp_set_memory_shared(unsigned long vaddr, unsigned long paddr,
 					unsigned int npages)
 {
-	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
+	/*
+	 * This can be invoked in early boot while running identity mapped, so
+	 * use an open coded check for SNP instead of using cc_platform_has().
+	 * This eliminates worries about jump tables or checking boot_cpu_data
+	 * in the cc_platform_has() function.
+	 */
+	if (!(sev_status & MSR_AMD64_SEV_SNP_ENABLED))
 		return;
 
 	/* Invalidate the memory pages before they are marked shared in the RMP table. */


