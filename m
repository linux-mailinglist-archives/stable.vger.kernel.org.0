Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49CE82C088B
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387865AbgKWMxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:53:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:36848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387859AbgKWMxH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:53:07 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1438D2173E;
        Mon, 23 Nov 2020 12:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135956;
        bh=5+ZCyDUwJ3Q3qlpiSIC2SUHV9TMncCct0WpoDAZ6ErA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OZ7BdB8zXLaM1WCY+z3dh5yNa0gH7rgLCHe+G2Il2pe/bqJQcnTCn9pnBo6dFNyu4
         IhiPWs9Hz5RDZ6awrtlrW6vxkjhNn6RQDn/6x2s4ckdQ6KFAidey9q4+tBytV54OeC
         slVoN4B3atpJr4Snh1l4rhnB/hyjNuKs3Jtm0xvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Yu <yu.c.chen@intel.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.9 248/252] x86/microcode/intel: Check patch signature before saving microcode for early loading
Date:   Mon, 23 Nov 2020 13:23:18 +0100
Message-Id: <20201123121847.554492527@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
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
 arch/x86/kernel/cpu/microcode/intel.c |   63 +++++-----------------------------
 1 file changed, 10 insertions(+), 53 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -100,53 +100,6 @@ static int has_newer_microcode(void *mc,
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
@@ -164,7 +117,7 @@ static struct ucode_patch *memdup_patch(
 	return p;
 }
 
-static void save_microcode_patch(void *data, unsigned int size)
+static void save_microcode_patch(struct ucode_cpu_info *uci, void *data, unsigned int size)
 {
 	struct microcode_header_intel *mc_hdr, *mc_saved_hdr;
 	struct ucode_patch *iter, *tmp, *p = NULL;
@@ -210,6 +163,9 @@ static void save_microcode_patch(void *d
 	if (!p)
 		return;
 
+	if (!find_matching_signature(p->data, uci->cpu_sig.sig, uci->cpu_sig.pf))
+		return;
+
 	/*
 	 * Save for early loading. On 32-bit, that needs to be a physical
 	 * address as the APs are running from physical addresses, before
@@ -344,13 +300,14 @@ scan_microcode(void *data, size_t size,
 
 		size -= mc_size;
 
-		if (!microcode_matches(mc_header, uci->cpu_sig.sig)) {
+		if (!find_matching_signature(data, uci->cpu_sig.sig,
+					     uci->cpu_sig.pf)) {
 			data += mc_size;
 			continue;
 		}
 
 		if (save) {
-			save_microcode_patch(data, mc_size);
+			save_microcode_patch(uci, data, mc_size);
 			goto next;
 		}
 
@@ -483,14 +440,14 @@ static void show_saved_mc(void)
  * Save this microcode patch. It will be loaded early when a CPU is
  * hot-added or resumes.
  */
-static void save_mc_for_early(u8 *mc, unsigned int size)
+static void save_mc_for_early(struct ucode_cpu_info *uci, u8 *mc, unsigned int size)
 {
 	/* Synchronization during CPU hotplug. */
 	static DEFINE_MUTEX(x86_cpu_microcode_mutex);
 
 	mutex_lock(&x86_cpu_microcode_mutex);
 
-	save_microcode_patch(mc, size);
+	save_microcode_patch(uci, mc, size);
 	show_saved_mc();
 
 	mutex_unlock(&x86_cpu_microcode_mutex);
@@ -935,7 +892,7 @@ static enum ucode_state generic_load_mic
 	 * permanent memory. So it will be loaded early when a CPU is hot added
 	 * or resumes.
 	 */
-	save_mc_for_early(new_mc, new_mc_size);
+	save_mc_for_early(uci, new_mc, new_mc_size);
 
 	pr_debug("CPU%d found a matching microcode update with version 0x%x (current=0x%x)\n",
 		 cpu, new_rev, uci->cpu_sig.rev);


