Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5623B5A4BCA
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 14:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbiH2M2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 08:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiH2M1w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 08:27:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C02AE205;
        Mon, 29 Aug 2022 05:11:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2F8A6123D;
        Mon, 29 Aug 2022 11:17:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E6FC433D7;
        Mon, 29 Aug 2022 11:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771827;
        bh=gcZSMS/DK5coU0N9vP5BKXdPmMcCP9sZHKX5Iz1YpP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ujXWigU00y44mI2pEXTx2I0J+gH1regmgD+lP/imqFtAWjnCQER7n3n/uUUsj4zF0
         9XymOfqBCL3DZyNmiBa2szuUXpWjr42vHqkdof2R8kqh8lA3CBS8je5FEYVAYJ6lO2
         HKSDCKNnpfgd/XvzANJIvcav+oDkkGhscVXyGlwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 5.19 109/158] x86/PAT: Have pat_enabled() properly reflect state when running on Xen
Date:   Mon, 29 Aug 2022 12:59:19 +0200
Message-Id: <20220829105813.685677959@linuxfoundation.org>
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

From: Jan Beulich <jbeulich@suse.com>

commit 72cbc8f04fe2fa93443c0fcccb7ad91dfea3d9ce upstream.

After commit ID in the Fixes: tag, pat_enabled() returns false (because
of PAT initialization being suppressed in the absence of MTRRs being
announced to be available).

This has become a problem: the i915 driver now fails to initialize when
running PV on Xen (i915_gem_object_pin_map() is where I located the
induced failure), and its error handling is flaky enough to (at least
sometimes) result in a hung system.

Yet even beyond that problem the keying of the use of WC mappings to
pat_enabled() (see arch_can_pci_mmap_wc()) means that in particular
graphics frame buffer accesses would have been quite a bit less optimal
than possible.

Arrange for the function to return true in such environments, without
undermining the rest of PAT MSR management logic considering PAT to be
disabled: specifically, no writes to the PAT MSR should occur.

For the new boolean to live in .init.data, init_cache_modes() also needs
moving to .init.text (where it could/should have lived already before).

  [ bp: This is the "small fix" variant for stable. It'll get replaced
    with a proper PAT and MTRR detection split upstream but that is too
    involved for a stable backport.
    - additional touchups to commit msg. Use cpu_feature_enabled(). ]

Fixes: bdd8b6c98239 ("drm/i915: replace X86_FEATURE_PAT with pat_enabled()")
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>
Cc: Juergen Gross <jgross@suse.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://lore.kernel.org/r/9385fa60-fa5d-f559-a137-6608408f88b0@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/pat/memtype.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/arch/x86/mm/pat/memtype.c
+++ b/arch/x86/mm/pat/memtype.c
@@ -62,6 +62,7 @@
 
 static bool __read_mostly pat_bp_initialized;
 static bool __read_mostly pat_disabled = !IS_ENABLED(CONFIG_X86_PAT);
+static bool __initdata pat_force_disabled = !IS_ENABLED(CONFIG_X86_PAT);
 static bool __read_mostly pat_bp_enabled;
 static bool __read_mostly pat_cm_initialized;
 
@@ -86,6 +87,7 @@ void pat_disable(const char *msg_reason)
 static int __init nopat(char *str)
 {
 	pat_disable("PAT support disabled via boot option.");
+	pat_force_disabled = true;
 	return 0;
 }
 early_param("nopat", nopat);
@@ -272,7 +274,7 @@ static void pat_ap_init(u64 pat)
 	wrmsrl(MSR_IA32_CR_PAT, pat);
 }
 
-void init_cache_modes(void)
+void __init init_cache_modes(void)
 {
 	u64 pat = 0;
 
@@ -313,6 +315,12 @@ void init_cache_modes(void)
 		 */
 		pat = PAT(0, WB) | PAT(1, WT) | PAT(2, UC_MINUS) | PAT(3, UC) |
 		      PAT(4, WB) | PAT(5, WT) | PAT(6, UC_MINUS) | PAT(7, UC);
+	} else if (!pat_force_disabled && cpu_feature_enabled(X86_FEATURE_HYPERVISOR)) {
+		/*
+		 * Clearly PAT is enabled underneath. Allow pat_enabled() to
+		 * reflect this.
+		 */
+		pat_bp_enabled = true;
 	}
 
 	__init_cache_modes(pat);


