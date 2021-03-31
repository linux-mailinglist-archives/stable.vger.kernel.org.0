Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E367344295
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbhCVMn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:43:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:35490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231719AbhCVMlN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:41:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A840619BA;
        Mon, 22 Mar 2021 12:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416754;
        bh=Oodc14il+7eTjhQAyXx3/6PMJ9Zmmpe91MtkjhR9CgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P5ZCHJsvbUi4ftCZksJ9NdJD+I0PkSXaHj+5Ls4nar5OnErTywu0R6lbbrJ7Eg/Gq
         4agFquz3jTT1OhzF/y/uVtCVvxK8ncLSIGcXvmbwVDrHcZVkHxtFxhV2zbtYQaS+hR
         urODSQjVred4Ji/0KlP2aMV0uiVPuvg/5XBBJskM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank van der Linden <fllinden@amazon.com>,
        Jessica Yu <jeyu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/157] module: harden ELF info handling
Date:   Mon, 22 Mar 2021 13:27:11 +0100
Message-Id: <20210322121936.106292580@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank van der Linden <fllinden@amazon.com>

[ Upstream commit ec2a29593c83ed71a7f16e3243941ebfcf75fdf6 ]

5fdc7db644 ("module: setup load info before module_sig_check()")
moved the ELF setup, so that it was done before the signature
check. This made the module name available to signature error
messages.

However, the checks for ELF correctness in setup_load_info
are not sufficient to prevent bad memory references due to
corrupted offset fields, indices, etc.

So, there's a regression in behavior here: a corrupt and unsigned
(or badly signed) module, which might previously have been rejected
immediately, can now cause an oops/crash.

Harden ELF handling for module loading by doing the following:

- Move the signature check back up so that it comes before ELF
  initialization. It's best to do the signature check to see
  if we can trust the module, before using the ELF structures
  inside it. This also makes checks against info->len
  more accurate again, as this field will be reduced by the
  length of the signature in mod_check_sig().

  The module name is now once again not available for error
  messages during the signature check, but that seems like
  a fair tradeoff.

- Check if sections have offset / size fields that at least don't
  exceed the length of the module.

- Check if sections have section name offsets that don't fall
  outside the section name table.

- Add a few other sanity checks against invalid section indices,
  etc.

This is not an exhaustive consistency check, but the idea is to
at least get through the signature and blacklist checks without
crashing because of corrupted ELF info, and to error out gracefully
for most issues that would have caused problems later on.

Fixes: 5fdc7db6448a ("module: setup load info before module_sig_check()")
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module.c           | 143 +++++++++++++++++++++++++++++++++-----
 kernel/module_signature.c |   2 +-
 kernel/module_signing.c   |   2 +-
 3 files changed, 126 insertions(+), 21 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index f1be6b6a3a3d..908d46abe165 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2940,7 +2940,7 @@ static int module_sig_check(struct load_info *info, int flags)
 	}
 
 	if (is_module_sig_enforced()) {
-		pr_notice("%s: loading of %s is rejected\n", info->name, reason);
+		pr_notice("Loading of %s is rejected\n", reason);
 		return -EKEYREJECTED;
 	}
 
@@ -2953,9 +2953,33 @@ static int module_sig_check(struct load_info *info, int flags)
 }
 #endif /* !CONFIG_MODULE_SIG */
 
-/* Sanity checks against invalid binaries, wrong arch, weird elf version. */
-static int elf_header_check(struct load_info *info)
+static int validate_section_offset(struct load_info *info, Elf_Shdr *shdr)
 {
+	unsigned long secend;
+
+	/*
+	 * Check for both overflow and offset/size being
+	 * too large.
+	 */
+	secend = shdr->sh_offset + shdr->sh_size;
+	if (secend < shdr->sh_offset || secend > info->len)
+		return -ENOEXEC;
+
+	return 0;
+}
+
+/*
+ * Sanity checks against invalid binaries, wrong arch, weird elf version.
+ *
+ * Also do basic validity checks against section offsets and sizes, the
+ * section name string table, and the indices used for it (sh_name).
+ */
+static int elf_validity_check(struct load_info *info)
+{
+	unsigned int i;
+	Elf_Shdr *shdr, *strhdr;
+	int err;
+
 	if (info->len < sizeof(*(info->hdr)))
 		return -ENOEXEC;
 
@@ -2965,11 +2989,78 @@ static int elf_header_check(struct load_info *info)
 	    || info->hdr->e_shentsize != sizeof(Elf_Shdr))
 		return -ENOEXEC;
 
+	/*
+	 * e_shnum is 16 bits, and sizeof(Elf_Shdr) is
+	 * known and small. So e_shnum * sizeof(Elf_Shdr)
+	 * will not overflow unsigned long on any platform.
+	 */
 	if (info->hdr->e_shoff >= info->len
 	    || (info->hdr->e_shnum * sizeof(Elf_Shdr) >
 		info->len - info->hdr->e_shoff))
 		return -ENOEXEC;
 
+	info->sechdrs = (void *)info->hdr + info->hdr->e_shoff;
+
+	/*
+	 * Verify if the section name table index is valid.
+	 */
+	if (info->hdr->e_shstrndx == SHN_UNDEF
+	    || info->hdr->e_shstrndx >= info->hdr->e_shnum)
+		return -ENOEXEC;
+
+	strhdr = &info->sechdrs[info->hdr->e_shstrndx];
+	err = validate_section_offset(info, strhdr);
+	if (err < 0)
+		return err;
+
+	/*
+	 * The section name table must be NUL-terminated, as required
+	 * by the spec. This makes strcmp and pr_* calls that access
+	 * strings in the section safe.
+	 */
+	info->secstrings = (void *)info->hdr + strhdr->sh_offset;
+	if (info->secstrings[strhdr->sh_size - 1] != '\0')
+		return -ENOEXEC;
+
+	/*
+	 * The code assumes that section 0 has a length of zero and
+	 * an addr of zero, so check for it.
+	 */
+	if (info->sechdrs[0].sh_type != SHT_NULL
+	    || info->sechdrs[0].sh_size != 0
+	    || info->sechdrs[0].sh_addr != 0)
+		return -ENOEXEC;
+
+	for (i = 1; i < info->hdr->e_shnum; i++) {
+		shdr = &info->sechdrs[i];
+		switch (shdr->sh_type) {
+		case SHT_NULL:
+		case SHT_NOBITS:
+			continue;
+		case SHT_SYMTAB:
+			if (shdr->sh_link == SHN_UNDEF
+			    || shdr->sh_link >= info->hdr->e_shnum)
+				return -ENOEXEC;
+			fallthrough;
+		default:
+			err = validate_section_offset(info, shdr);
+			if (err < 0) {
+				pr_err("Invalid ELF section in module (section %u type %u)\n",
+					i, shdr->sh_type);
+				return err;
+			}
+
+			if (shdr->sh_flags & SHF_ALLOC) {
+				if (shdr->sh_name >= strhdr->sh_size) {
+					pr_err("Invalid ELF section name in module (section %u type %u)\n",
+					       i, shdr->sh_type);
+					return -ENOEXEC;
+				}
+			}
+			break;
+		}
+	}
+
 	return 0;
 }
 
@@ -3071,11 +3162,6 @@ static int rewrite_section_headers(struct load_info *info, int flags)
 
 	for (i = 1; i < info->hdr->e_shnum; i++) {
 		Elf_Shdr *shdr = &info->sechdrs[i];
-		if (shdr->sh_type != SHT_NOBITS
-		    && info->len < shdr->sh_offset + shdr->sh_size) {
-			pr_err("Module len %lu truncated\n", info->len);
-			return -ENOEXEC;
-		}
 
 		/* Mark all sections sh_addr with their address in the
 		   temporary image. */
@@ -3107,11 +3193,6 @@ static int setup_load_info(struct load_info *info, int flags)
 {
 	unsigned int i;
 
-	/* Set up the convenience variables */
-	info->sechdrs = (void *)info->hdr + info->hdr->e_shoff;
-	info->secstrings = (void *)info->hdr
-		+ info->sechdrs[info->hdr->e_shstrndx].sh_offset;
-
 	/* Try to find a name early so we can log errors with a module name */
 	info->index.info = find_sec(info, ".modinfo");
 	if (info->index.info)
@@ -3855,26 +3936,50 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	long err = 0;
 	char *after_dashes;
 
-	err = elf_header_check(info);
+	/*
+	 * Do the signature check (if any) first. All that
+	 * the signature check needs is info->len, it does
+	 * not need any of the section info. That can be
+	 * set up later. This will minimize the chances
+	 * of a corrupt module causing problems before
+	 * we even get to the signature check.
+	 *
+	 * The check will also adjust info->len by stripping
+	 * off the sig length at the end of the module, making
+	 * checks against info->len more correct.
+	 */
+	err = module_sig_check(info, flags);
+	if (err)
+		goto free_copy;
+
+	/*
+	 * Do basic sanity checks against the ELF header and
+	 * sections.
+	 */
+	err = elf_validity_check(info);
 	if (err) {
-		pr_err("Module has invalid ELF header\n");
+		pr_err("Module has invalid ELF structures\n");
 		goto free_copy;
 	}
 
+	/*
+	 * Everything checks out, so set up the section info
+	 * in the info structure.
+	 */
 	err = setup_load_info(info, flags);
 	if (err)
 		goto free_copy;
 
+	/*
+	 * Now that we know we have the correct module name, check
+	 * if it's blacklisted.
+	 */
 	if (blacklisted(info->name)) {
 		err = -EPERM;
 		pr_err("Module %s is blacklisted\n", info->name);
 		goto free_copy;
 	}
 
-	err = module_sig_check(info, flags);
-	if (err)
-		goto free_copy;
-
 	err = rewrite_section_headers(info, flags);
 	if (err)
 		goto free_copy;
diff --git a/kernel/module_signature.c b/kernel/module_signature.c
index 4224a1086b7d..00132d12487c 100644
--- a/kernel/module_signature.c
+++ b/kernel/module_signature.c
@@ -25,7 +25,7 @@ int mod_check_sig(const struct module_signature *ms, size_t file_len,
 		return -EBADMSG;
 
 	if (ms->id_type != PKEY_ID_PKCS7) {
-		pr_err("%s: Module is not signed with expected PKCS#7 message\n",
+		pr_err("%s: not signed with expected PKCS#7 message\n",
 		       name);
 		return -ENOPKG;
 	}
diff --git a/kernel/module_signing.c b/kernel/module_signing.c
index 9d9fc678c91d..8723ae70ea1f 100644
--- a/kernel/module_signing.c
+++ b/kernel/module_signing.c
@@ -30,7 +30,7 @@ int mod_verify_sig(const void *mod, struct load_info *info)
 
 	memcpy(&ms, mod + (modlen - sizeof(ms)), sizeof(ms));
 
-	ret = mod_check_sig(&ms, modlen, info->name);
+	ret = mod_check_sig(&ms, modlen, "module");
 	if (ret)
 		return ret;
 
-- 
2.30.1



