Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0C22B140F
	for <lists+stable@lfdr.de>; Fri, 13 Nov 2020 02:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgKMB5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 20:57:41 -0500
Received: from mga05.intel.com ([192.55.52.43]:63123 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgKMB5l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Nov 2020 20:57:41 -0500
IronPort-SDR: gycJapKiqvVQ674HsJe+aUbOYKL/SvBkhkgYvJ9Coxrs0e3cF3yh+gwdF3QF3urZs1FSIZwU/V
 V301vD9Nl3xQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9803"; a="255122665"
X-IronPort-AV: E=Sophos;i="5.77,473,1596524400"; 
   d="scan'208";a="255122665"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2020 17:57:40 -0800
IronPort-SDR: nE/rl1EmvXlpolV38Y1vDuFYYfFY9/DEDOeBjSm4ozFSqymabLM0P66AGgEy5YKFTwmSUDqzVp
 lyXU/fWwQHWQ==
X-IronPort-AV: E=Sophos;i="5.77,473,1596524400"; 
   d="scan'208";a="474499145"
Received: from chenyu-office.sh.intel.com ([10.239.158.173])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2020 17:57:37 -0800
From:   Chen Yu <yu.c.chen@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Ashok Raj <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Tony Luck <tony.luck@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Chen Yu <yu.c.chen@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH][v2] x86/microcode/intel: check cpu stepping and processor flag before saving microcode
Date:   Fri, 13 Nov 2020 09:59:23 +0800
Message-Id: <20201113015923.13960-1-yu.c.chen@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently scan_microcode() leverages microcode_matches() to check if the
microcode matches the CPU by comparing the family and model. However before
saving the microcode in scan_microcode(), the processor stepping and flag
of the microcode signature should also be considered in order to avoid
incompatible update and caused the failure of microcode update.

For example on one platform the microcode failed to be updated to the
latest revison on APs during resume from S3 due to incompatible cpu
stepping and signature->pf. This is because the scan_microcode() has
saved an incompatible copy of intel_ucode_patch in
save_microcode_in_initrd_intel() after bootup. And this intel_ucode_patch
is used by APs during early resume from S3 which results in unchecked MSR
access error during resume from S3:

[   95.519390] unchecked MSR access error: RDMSR from 0x123 at
	rIP: 0xffffffffb7676208 (native_read_msr+0x8/0x40)
[   95.519391] Call Trace:
[   95.519395]  update_srbds_msr+0x38/0x80
[   95.519396]  identify_secondary_cpu+0x7a/0x90
[   95.519397]  smp_store_cpu_info+0x4e/0x60
[   95.519398]  start_secondary+0x49/0x150
[   95.519399]  secondary_startup_64_no_verify+0xa6/0xab

The system keeps running on old microcode during resume:
[  210.366757] microcode: load_ucode_intel_ap: CPU1, enter, intel_ucode_patch: 0xffff9bf2816e0000
[  210.366757] microcode: load_ucode_intel_ap: CPU1, p: 0xffff9bf2816e0000, rev: 0xd6
[  210.366759] microcode: apply_microcode_early: rev: 0x84
[  210.367826] microcode: apply_microcode_early: rev after upgrade: 0x84

until mc_cpu_starting() is invoked on each AP during resume and the
correct microcode is updated via apply_microcode_intel().

To fix this issue, the scan_microcode() uses find_matching_signature()
instead of microcode_matches() to compare the (family, model, stepping,
processor flag), and only save the microcode that matches. As there is
no other place invoking microcode_matches(), remove it accordingly.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=208535
Fixes: 06b8534cb728 ("x86/microcode: Rework microcode loading")
Cc: stable@vger.kernel.org#v4.10+
Reviewed-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
---
v2: Remove RFC tag and Cc the stable mailing list.
---
 arch/x86/kernel/cpu/microcode/intel.c | 50 ++-------------------------
 1 file changed, 2 insertions(+), 48 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index 6a99535d7f37..923853f79099 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -100,53 +100,6 @@ static int has_newer_microcode(void *mc, unsigned int csig, int cpf, int new_rev
 	return find_matching_signature(mc, csig, cpf);
 }
 
-/*
- * Given CPU signature and a microcode patch, this function finds if the
- * microcode patch has matching family and model with the CPU.
- *
- * %true - if there's a match
- * %false - otherwise
- */
-static bool microcode_matches(struct microcode_header_intel *mc_header,
-			      unsigned long sig)
-{
-	unsigned long total_size = get_totalsize(mc_header);
-	unsigned long data_size = get_datasize(mc_header);
-	struct extended_sigtable *ext_header;
-	unsigned int fam_ucode, model_ucode;
-	struct extended_signature *ext_sig;
-	unsigned int fam, model;
-	int ext_sigcount, i;
-
-	fam   = x86_family(sig);
-	model = x86_model(sig);
-
-	fam_ucode   = x86_family(mc_header->sig);
-	model_ucode = x86_model(mc_header->sig);
-
-	if (fam == fam_ucode && model == model_ucode)
-		return true;
-
-	/* Look for ext. headers: */
-	if (total_size <= data_size + MC_HEADER_SIZE)
-		return false;
-
-	ext_header   = (void *) mc_header + data_size + MC_HEADER_SIZE;
-	ext_sig      = (void *)ext_header + EXT_HEADER_SIZE;
-	ext_sigcount = ext_header->count;
-
-	for (i = 0; i < ext_sigcount; i++) {
-		fam_ucode   = x86_family(ext_sig->sig);
-		model_ucode = x86_model(ext_sig->sig);
-
-		if (fam == fam_ucode && model == model_ucode)
-			return true;
-
-		ext_sig++;
-	}
-	return false;
-}
-
 static struct ucode_patch *memdup_patch(void *data, unsigned int size)
 {
 	struct ucode_patch *p;
@@ -344,7 +297,8 @@ scan_microcode(void *data, size_t size, struct ucode_cpu_info *uci, bool save)
 
 		size -= mc_size;
 
-		if (!microcode_matches(mc_header, uci->cpu_sig.sig)) {
+		if (!find_matching_signature(data, uci->cpu_sig.sig,
+					     uci->cpu_sig.pf)) {
 			data += mc_size;
 			continue;
 		}
-- 
2.17.1

