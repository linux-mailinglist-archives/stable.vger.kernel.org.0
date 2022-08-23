Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43A8E59EB5B
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 20:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234046AbiHWSr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 14:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233963AbiHWSqu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 14:46:50 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68A467449;
        Tue, 23 Aug 2022 10:11:28 -0700 (PDT)
Received: from zn.tnic (p200300ea971b9893329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971b:9893:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BD3FB1EC04D3;
        Tue, 23 Aug 2022 19:11:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1661274682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=90Ruzok7hIfJ+x0Mkc/L99TT4hiulspY7+OuuRXz9Ec=;
        b=JM4V7coOjRQXVe96uW4LhBWQ0vVNsng1EOMXKA5i0b376ju4bTz8U+i3e/XuI3n0Z1eVVK
        4gJFpBMxTaXhLDpztbacwnA/fI0K+FcjWqutDf2GrPSq13d03hWk7eAo8QZ3jI9j/g1I2R
        padxfXuWnDFTAoLuBR3aDqg3nyifjro=
Date:   Tue, 23 Aug 2022 19:11:17 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Michael Roth <michael.roth@amd.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        x86@kernel.org, watnuss@gmx.de,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] x86/boot: Don't propagate uninitialized
 boot_params->cc_blob_address
Message-ID: <YwUKNX6USrBSrSa6@zn.tnic>
References: <20220823160734.89036-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220823160734.89036-1-michael.roth@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 23, 2022 at 11:07:34AM -0500, Michael Roth wrote:
> In some cases bootloaders will leave boot_params->cc_blob_address
> uninitialized rather than zero'ing it out. This field is only meant to
> be set by the boot/compressed kernel to pass information to the
> uncompressed kernel when SEV-SNP support is enabled, so there are no
> cases where the bootloader-provided values should be treated as
> anything other than garbage. Otherwise, the uncompressed kernel may
> attempt to access this bogus address, leading to a crash during early
> boot.
> 
> Normally sanitize_boot_params() would be used to clear out such fields,
> but that happens too late: sev_enable() may have already initialized it
> to a valid value that should not be zero'd out. Instead, have
> sev_enable() zero it out unconditionally beforehand.
> 
> Also ensure this happens for !CONFIG_AMD_MEM_ENCRYPT as well by also
> including this handling in the sev_enable() stub function.
> 
> Fixes: b190a043c49a ("x86/sev: Add SEV-SNP feature detection/setup")
> Cc: stable@vger.kernel.org
> Reported-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
> Reported-by: watnuss@gmx.de
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=216387
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/boot/compressed/misc.h | 11 ++++++++++-
>  arch/x86/boot/compressed/sev.c  |  8 ++++++++
>  2 files changed, 18 insertions(+), 1 deletion(-)

I extended the stub comment too so that it is clear that yes, the stub
is supposed to do it too and not someone later wonders why there's code
in the stub function.

---
From 4065a25f2b287e42642fe31509304cfd0a1ee125 Mon Sep 17 00:00:00 2001
From: Michael Roth <michael.roth@amd.com>
Date: Tue, 23 Aug 2022 11:07:34 -0500
Subject: [PATCH] x86/boot: Don't propagate uninitialized
 boot_params->cc_blob_address

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
2.35.1

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
