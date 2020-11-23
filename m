Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6385C2C03AD
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 11:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbgKWKui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 05:50:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:45366 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728650AbgKWKuh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 05:50:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5A076AC41;
        Mon, 23 Nov 2020 10:50:36 +0000 (UTC)
Date:   Mon, 23 Nov 2020 11:50:30 +0100
From:   Borislav Petkov <bp@suse.de>
To:     gregkh@linuxfoundation.org
Cc:     yu.c.chen@intel.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/microcode/intel: Check patch
 signature before saving" failed to apply to 4.9-stable tree
Message-ID: <20201123105030.GE29678@zn.tnic>
References: <16061247634917@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <16061247634917@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 23, 2020 at 10:46:03AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

---
From: Chen Yu <yu.c.chen@intel.com>
Date: Fri, 13 Nov 2020 09:59:23 +0800
Subject: [PATCH] x86/microcode/intel: Check patch signature before saving
 microcode for early loading

Commit 1a371e67dc77125736cc56d3a0893f06b75855b6 upstream.

Currently, scan_microcode() leverages microcode_matches() to check
if the microcode matches the CPU by comparing the family and model.
However, the processor stepping and flags of the microcode signature
should also be considered when saving a microcode patch for early
update.

Use find_matching_signature() in scan_microcode() and get rid of the
now-unused microcode_matches() which is a good cleanup in itself.

Complete the verification of the patch being saved for early loading in
save_microcode_patch() directly. This needs to be done there too because
save_mc_for_early() will call save_microcode_patch() too.

The second reason why this needs to be done is because the loader still
tries to support, at least hypothetically, mixed-steppings systems and
thus adds all patches to the cache that belong to the same CPU model
albeit with different steppings.

For example:

  microcode: CPU: sig=0x906ec, pf=0x2, rev=0xd6
  microcode: mc_saved[0]: sig=0x906e9, pf=0x2a, rev=0xd6, total size=0x19400, date = 2020-04-23
  microcode: mc_saved[1]: sig=0x906ea, pf=0x22, rev=0xd6, total size=0x19000, date = 2020-04-27
  microcode: mc_saved[2]: sig=0x906eb, pf=0x2, rev=0xd6, total size=0x19400, date = 2020-04-23
  microcode: mc_saved[3]: sig=0x906ec, pf=0x22, rev=0xd6, total size=0x19000, date = 2020-04-27
  microcode: mc_saved[4]: sig=0x906ed, pf=0x22, rev=0xd6, total size=0x19400, date = 2020-04-23

The patch which is being saved for early loading, however, can only be
the one which fits the CPU this runs on so do the signature verification
before saving.

 [ bp: Do signature verification in save_microcode_patch()
       and rewrite commit message. ]

Fixes: ec400ddeff20 ("x86/microcode_intel_early.c: Early update ucode on Intel's CPU")
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=208535
Link: https://lkml.kernel.org/r/20201113015923.13960-1-yu.c.chen@intel.com
---
 arch/x86/kernel/cpu/microcode/intel.c | 48 ++-------------------------
 1 file changed, 2 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index 1308abfc4758..0939151a42a9 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -147,51 +147,6 @@ load_microcode(struct mc_saved_data *mcs, unsigned long *mc_ptrs,
 	}
 }
 
-/*
- * Given CPU signature and a microcode patch, this function finds if the
- * microcode patch has matching family and model with the CPU.
- */
-static enum ucode_state
-matching_model_microcode(struct microcode_header_intel *mc_header,
-			unsigned long sig)
-{
-	unsigned int fam, model;
-	unsigned int fam_ucode, model_ucode;
-	struct extended_sigtable *ext_header;
-	unsigned long total_size = get_totalsize(mc_header);
-	unsigned long data_size = get_datasize(mc_header);
-	int ext_sigcount, i;
-	struct extended_signature *ext_sig;
-
-	fam   = x86_family(sig);
-	model = x86_model(sig);
-
-	fam_ucode   = x86_family(mc_header->sig);
-	model_ucode = x86_model(mc_header->sig);
-
-	if (fam == fam_ucode && model == model_ucode)
-		return UCODE_OK;
-
-	/* Look for ext. headers: */
-	if (total_size <= data_size + MC_HEADER_SIZE)
-		return UCODE_NFOUND;
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
-			return UCODE_OK;
-
-		ext_sig++;
-	}
-	return UCODE_NFOUND;
-}
-
 static int
 save_microcode(struct mc_saved_data *mcs,
 	       struct microcode_intel **mc_saved_src,
@@ -332,7 +287,8 @@ get_matching_model_microcode(unsigned long start, void *data, size_t size,
 		 * the platform, we need to find and save microcode patches
 		 * with the same family and model as the BSP.
 		 */
-		if (matching_model_microcode(mc_header, uci->cpu_sig.sig) != UCODE_OK) {
+		if (!find_matching_signature(mc_header, uci->cpu_sig.sig,
+					     uci->cpu_sig.pf)) {
 			ucode_ptr += mc_size;
 			continue;
 		}
-- 
2.21.0

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
