Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897342B5BDB
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 10:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725770AbgKQJhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 04:37:18 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:47126 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgKQJhS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 04:37:18 -0500
Date:   Tue, 17 Nov 2020 09:37:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605605834;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fQ7OVL5zUp1dRHHqiye6cfkISaYJKqaGkukaoe40K7M=;
        b=UecBPSHCMbxXPl6VPb5Drr6VkVj6/SbH9CV5L6YvRucE/6XS5uzWx3unCnmALtzXdt79E8
        E8H4s+v+xNlbVWxY2rbnDpoCCQuYkYGHx3FwYQIql9R43XWb6bLqZuper3M8VtQcltkLnU
        sDN9W8bdiiMp1YJIdG8csDtw7jG3PD3zhd0Tk8dILohSFz+dvrVoCoOC2fz9iTF83N+HPU
        WPzSR4vLcDMYGvILH645jAAw2iKbQp7YT1zEeBd24erZrq9LUmNEUUYoLkZfVAkpE5wmc1
        1uPVQ7IlHcUDkrX3Wm8bwFBrdTxdHFK9HA0i/ExAe9bNqnBy8W3EgEA7Co4D+Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605605834;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fQ7OVL5zUp1dRHHqiye6cfkISaYJKqaGkukaoe40K7M=;
        b=kiViCLZ0EFJXo63UWvXiAO+06chz16BNlSfw2NDUK8imMSU23cJlarOaLh8bClpl19782S
        qClrOd/WyIKKz2Cw==
From:   "tip-bot2 for Chen Yu" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/microcode/intel: Check patch signature before
 saving microcode for early loading
Cc:     Chen Yu <yu.c.chen@intel.com>, Borislav Petkov <bp@suse.de>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20201113015923.13960-1-yu.c.chen@intel.com>
References: <20201113015923.13960-1-yu.c.chen@intel.com>
MIME-Version: 1.0
Message-ID: <160560583321.11244.936702015885379911.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     1a371e67dc77125736cc56d3a0893f06b75855b6
Gitweb:        https://git.kernel.org/tip/1a371e67dc77125736cc56d3a0893f06b75855b6
Author:        Chen Yu <yu.c.chen@intel.com>
AuthorDate:    Fri, 13 Nov 2020 09:59:23 +08:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 17 Nov 2020 10:33:18 +01:00

x86/microcode/intel: Check patch signature before saving microcode for early loading

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
 arch/x86/kernel/cpu/microcode/intel.c | 63 ++++----------------------
 1 file changed, 10 insertions(+), 53 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index 6a99535..7e8e07b 100644
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
@@ -164,7 +117,7 @@ static struct ucode_patch *memdup_patch(void *data, unsigned int size)
 	return p;
 }
 
-static void save_microcode_patch(void *data, unsigned int size)
+static void save_microcode_patch(struct ucode_cpu_info *uci, void *data, unsigned int size)
 {
 	struct microcode_header_intel *mc_hdr, *mc_saved_hdr;
 	struct ucode_patch *iter, *tmp, *p = NULL;
@@ -210,6 +163,9 @@ static void save_microcode_patch(void *data, unsigned int size)
 	if (!p)
 		return;
 
+	if (!find_matching_signature(p->data, uci->cpu_sig.sig, uci->cpu_sig.pf))
+		return;
+
 	/*
 	 * Save for early loading. On 32-bit, that needs to be a physical
 	 * address as the APs are running from physical addresses, before
@@ -344,13 +300,14 @@ scan_microcode(void *data, size_t size, struct ucode_cpu_info *uci, bool save)
 
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
@@ -935,7 +892,7 @@ static enum ucode_state generic_load_microcode(int cpu, struct iov_iter *iter)
 	 * permanent memory. So it will be loaded early when a CPU is hot added
 	 * or resumes.
 	 */
-	save_mc_for_early(new_mc, new_mc_size);
+	save_mc_for_early(uci, new_mc, new_mc_size);
 
 	pr_debug("CPU%d found a matching microcode update with version 0x%x (current=0x%x)\n",
 		 cpu, new_rev, uci->cpu_sig.rev);
