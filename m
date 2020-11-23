Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDA42C05A2
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbgKWMYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:24:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:33300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729706AbgKWMYC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:24:02 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39FA220728;
        Mon, 23 Nov 2020 12:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134241;
        bh=qoFZcs952dIVzRftkmt9QH5dLbkFvIP1Y0DN+B3Lo/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ssTJvgE5yp2OgjPPbrBNSi12AyOjIf9WMWeC3mX/7wfEqVCChth6QDf5RN/3XIhgn
         zNikjZon9mdDPx3ZvJlVM/Uy/3bHaHDJlIBZzNuMI/mEONTN4geMnRTjd0HetT6OmL
         hF1SKVWH6TqRSoqyNzM1GCEJwH1Py6t+oDKRBuO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Yu <yu.c.chen@intel.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 4.4 38/38] x86/microcode/intel: Check patch signature before saving microcode for early loading
Date:   Mon, 23 Nov 2020 13:22:24 +0100
Message-Id: <20201123121806.118856434@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121804.306030358@linuxfoundation.org>
References: <20201123121804.306030358@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Yu <yu.c.chen@intel.com>

commit 1a371e67dc77125736cc56d3a0893f06b75855b6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 arch/x86/kernel/cpu/microcode/intel.c |   49 +---------------------------------
 1 file changed, 2 insertions(+), 47 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -132,51 +132,6 @@ load_microcode(struct mc_saved_data *mc_
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
-	fam   = __x86_family(sig);
-	model = x86_model(sig);
-
-	fam_ucode   = __x86_family(mc_header->sig);
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
-		fam_ucode   = __x86_family(ext_sig->sig);
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
 save_microcode(struct mc_saved_data *mc_saved_data,
 	       struct microcode_intel **mc_saved_src,
@@ -321,8 +276,8 @@ get_matching_model_microcode(int cpu, un
 		 * the platform, we need to find and save microcode patches
 		 * with the same family and model as the BSP.
 		 */
-		if (matching_model_microcode(mc_header, uci->cpu_sig.sig) !=
-			 UCODE_OK) {
+		if (!find_matching_signature(mc_header, uci->cpu_sig.sig,
+					     uci->cpu_sig.pf)) {
 			ucode_ptr += mc_size;
 			continue;
 		}


