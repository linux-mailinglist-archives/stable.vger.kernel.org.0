Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A815A4AB2
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbiH2LtM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233145AbiH2Lsp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:48:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F5D7B7B4;
        Mon, 29 Aug 2022 04:32:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E68EB80F9E;
        Mon, 29 Aug 2022 11:16:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A004BC433D6;
        Mon, 29 Aug 2022 11:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771799;
        bh=1nf+LBF2sKGwkTpTN8P40gOXyki1/W9fa4kqIVgEXNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Duvo/fRt7/5+4bXaF+mtIyfjhq6maTISK9WiK6wfGnNUyBj87OngR3N60yi9DyXvG
         BVJc45lvVeOI7PBsxYZ5lACxKUYkuQ8B192+C+kguFC5EJlQf/R/puZ4ZWLnySWWwW
         ipiKNPzipSAG1pEea/6rZr5FYQm+HrtI8lNyUMqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        watnuss@gmx.de, Michael Roth <michael.roth@amd.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.19 101/158] x86/boot: Dont propagate uninitialized boot_params->cc_blob_address
Date:   Mon, 29 Aug 2022 12:59:11 +0200
Message-Id: <20220829105813.324012491@linuxfoundation.org>
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

From: Michael Roth <michael.roth@amd.com>

commit 4b1c742407571eff58b6de9881889f7ca7c4b4dc upstream.

In some cases, bootloaders will leave boot_params->cc_blob_address
uninitialized rather than zeroing it out. This field is only meant to be
set by the boot/compressed kernel in order to pass information to the
uncompressed kernel when SEV-SNP support is enabled.

Therefore, there are no cases where the bootloader-provided values
should be treated as anything other than garbage. Otherwise, the
uncompressed kernel may attempt to access this bogus address, leading to
a crash during early boot.

Normally, sanitize_boot_params() would be used to clear out such fields
but that happens too late: sev_enable() may have already initialized
it to a valid value that should not be zeroed out. Instead, have
sev_enable() zero it out unconditionally beforehand.

Also ensure this happens for !CONFIG_AMD_MEM_ENCRYPT as well by also
including this handling in the sev_enable() stub function.

  [ bp: Massage commit message and comments. ]

Fixes: b190a043c49a ("x86/sev: Add SEV-SNP feature detection/setup")
Reported-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Reported-by: watnuss@gmx.de
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216387
Link: https://lore.kernel.org/r/20220823160734.89036-1-michael.roth@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/misc.h | 12 +++++++++++-
 arch/x86/boot/compressed/sev.c  |  8 ++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 4910bf230d7b..62208ec04ca4 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -132,7 +132,17 @@ void snp_set_page_private(unsigned long paddr);
 void snp_set_page_shared(unsigned long paddr);
 void sev_prep_identity_maps(unsigned long top_level_pgt);
 #else
-static inline void sev_enable(struct boot_params *bp) { }
+static inline void sev_enable(struct boot_params *bp)
+{
+	/*
+	 * bp->cc_blob_address should only be set by boot/compressed kernel.
+	 * Initialize it to 0 unconditionally (thus here in this stub too) to
+	 * ensure that uninitialized values from buggy bootloaders aren't
+	 * propagated.
+	 */
+	if (bp)
+		bp->cc_blob_address = 0;
+}
 static inline void sev_es_shutdown_ghcb(void) { }
 static inline bool sev_es_check_ghcb_fault(unsigned long address)
 {
diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index 52f989f6acc2..c93930d5ccbd 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -276,6 +276,14 @@ void sev_enable(struct boot_params *bp)
 	struct msr m;
 	bool snp;
 
+	/*
+	 * bp->cc_blob_address should only be set by boot/compressed kernel.
+	 * Initialize it to 0 to ensure that uninitialized values from
+	 * buggy bootloaders aren't propagated.
+	 */
+	if (bp)
+		bp->cc_blob_address = 0;
+
 	/*
 	 * Setup/preliminary detection of SNP. This will be sanity-checked
 	 * against CPUID/MSR values later.
-- 
2.37.2



