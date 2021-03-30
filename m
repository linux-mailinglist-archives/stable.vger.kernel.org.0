Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A3934F24A
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 22:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbhC3UfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 16:35:13 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:17487 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232246AbhC3Uel (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Mar 2021 16:34:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1617136481; x=1648672481;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=K4HHufMNciX8+L1F/zw4B6v2vlVq/r1VQaY15M5rAQ8=;
  b=joI057LkT7iQb2WoRdbG+Khg2FEYe04rnxTDd1wT2S6qpO/G9eur7453
   lLWmjRhll22zFzFI71PAoZnKZqDW1tuOJIpgYHuCVjplFveihAURf031Y
   EDNZCOsAG6B7lXa6RagABCuNiGok211nfQUEKyhBm9RnoHwWbNWU6YC0L
   4=;
X-IronPort-AV: E=Sophos;i="5.81,291,1610409600"; 
   d="scan'208";a="922522939"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-c7f73527.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 30 Mar 2021 20:34:41 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-c7f73527.us-east-1.amazon.com (Postfix) with ESMTPS id A5112B35D2
        for <stable@vger.kernel.org>; Tue, 30 Mar 2021 20:34:40 +0000 (UTC)
Received: from EX13D13UWB002.ant.amazon.com (10.43.161.21) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 30 Mar 2021 20:34:40 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D13UWB002.ant.amazon.com (10.43.161.21) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 30 Mar 2021 20:34:40 +0000
Received: from dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com
 (172.23.141.97) by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Tue, 30 Mar 2021 20:34:39 +0000
Received: by dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com (Postfix, from userid 6262777)
        id 1EEDFDF935; Tue, 30 Mar 2021 20:34:38 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <fllinden@amazon.com>
Subject: [PATCH 5.4] module: harden ELF info handling
Date:   Tue, 30 Mar 2021 20:34:38 +0000
Message-ID: <20210330203438.4171-1-fllinden@amazon.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit ec2a29593c83ed71a7f16e3243941ebfcf75fdf6 upstream.

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
[fllinden@amazon.com: backport to 5.4]
---
 kernel/module.c           | 141 +++++++++++++++++++++++++++++++++-----
 kernel/module_signature.c |   2 +-
 kernel/module_signing.c   |   2 +-
 3 files changed, 126 insertions(+), 19 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index ab1f97cfe18d..b8c9989dc0e3 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2938,9 +2938,33 @@ static int module_sig_check(struct load_info *info, int flags)
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
 
@@ -2950,11 +2974,78 @@ static int elf_header_check(struct load_info *info)
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
 
@@ -3051,11 +3142,6 @@ static int rewrite_section_headers(struct load_info *info, int flags)
 
 	for (i = 1; i < info->hdr->e_shnum; i++) {
 		Elf_Shdr *shdr = &info->sechdrs[i];
-		if (shdr->sh_type != SHT_NOBITS
-		    && info->len < shdr->sh_offset + shdr->sh_size) {
-			pr_err("Module len %lu truncated\n", info->len);
-			return -ENOEXEC;
-		}
 
 		/* Mark all sections sh_addr with their address in the
 		   temporary image. */
@@ -3087,11 +3173,6 @@ static int setup_load_info(struct load_info *info, int flags)
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
@@ -3819,23 +3900,49 @@ static int load_module(struct load_info *info, const char __user *uargs,
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
 	if (err)
 		goto free_copy;
 
+	/*
+	 * Do basic sanity checks against the ELF header and
+	 * sections.
+	 */
+	err = elf_validity_check(info);
+	if (err) {
+		pr_err("Module has invalid ELF structures\n");
+		goto free_copy;
+	}
+
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
2.23.3

