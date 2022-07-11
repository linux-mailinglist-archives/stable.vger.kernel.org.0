Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B105256FD75
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbiGKJz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbiGKJzS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:55:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC8AC33341;
        Mon, 11 Jul 2022 02:26:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0506C61376;
        Mon, 11 Jul 2022 09:26:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC29C34115;
        Mon, 11 Jul 2022 09:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531579;
        bh=w7ayt6OeqqIe/QS+tSiV48KClRgPaOXmOyVXYHm6Q08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EF1tLtFB9O1+ezCuxJOFcK9ZVJNaYK5qURPFeWWD3PGXsKzJH6ftSdIwkzY9volwi
         SScOqzepS8Q1NhilkxaRZDva2y2SHbPWA5B4qg3ri/wdk+W8TF07UL4xjAFgTS48Kw
         Wwfb1aAUwaO9BHOkdldueRmmYZ2l2rkqU9tIAdw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 156/230] module: change to print useful messages from elf_validity_check()
Date:   Mon, 11 Jul 2022 11:06:52 +0200
Message-Id: <20220711090608.486184291@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

[ Upstream commit 7fd982f394c42f25a73fe9dfbf1e6b11fa26b40a ]

elf_validity_check() checks ELF headers for errors and ELF Spec.
compliance and if any of them fail it returns -ENOEXEC from all of
these error paths. Almost all of them don't print any messages.

When elf_validity_check() returns an error, load_module() prints an
error message without error code. It is hard to determine why the
module ELF structure is invalid, even if load_module() prints the
error code which is -ENOEXEC in all of these cases.

Change to print useful error messages from elf_validity_check() to
clearly say what went wrong and why the ELF validity checks failed.

Remove the load_module() error message which is no longer needed.
This patch includes changes to fix build warns on 32-bit platforms:

warning: format '%llu' expects argument of type 'long long unsigned int',
but argument 3 has type 'Elf32_Off' {aka 'unsigned int'}
Reported-by: kernel test robot <lkp@intel.com>

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module.c | 75 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 54 insertions(+), 21 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 83991c2d5af9..256b3c80a771 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2967,14 +2967,29 @@ static int elf_validity_check(struct load_info *info)
 	Elf_Shdr *shdr, *strhdr;
 	int err;
 
-	if (info->len < sizeof(*(info->hdr)))
-		return -ENOEXEC;
+	if (info->len < sizeof(*(info->hdr))) {
+		pr_err("Invalid ELF header len %lu\n", info->len);
+		goto no_exec;
+	}
 
-	if (memcmp(info->hdr->e_ident, ELFMAG, SELFMAG) != 0
-	    || info->hdr->e_type != ET_REL
-	    || !elf_check_arch(info->hdr)
-	    || info->hdr->e_shentsize != sizeof(Elf_Shdr))
-		return -ENOEXEC;
+	if (memcmp(info->hdr->e_ident, ELFMAG, SELFMAG) != 0) {
+		pr_err("Invalid ELF header magic: != %s\n", ELFMAG);
+		goto no_exec;
+	}
+	if (info->hdr->e_type != ET_REL) {
+		pr_err("Invalid ELF header type: %u != %u\n",
+		       info->hdr->e_type, ET_REL);
+		goto no_exec;
+	}
+	if (!elf_check_arch(info->hdr)) {
+		pr_err("Invalid architecture in ELF header: %u\n",
+		       info->hdr->e_machine);
+		goto no_exec;
+	}
+	if (info->hdr->e_shentsize != sizeof(Elf_Shdr)) {
+		pr_err("Invalid ELF section header size\n");
+		goto no_exec;
+	}
 
 	/*
 	 * e_shnum is 16 bits, and sizeof(Elf_Shdr) is
@@ -2983,8 +2998,10 @@ static int elf_validity_check(struct load_info *info)
 	 */
 	if (info->hdr->e_shoff >= info->len
 	    || (info->hdr->e_shnum * sizeof(Elf_Shdr) >
-		info->len - info->hdr->e_shoff))
-		return -ENOEXEC;
+		info->len - info->hdr->e_shoff)) {
+		pr_err("Invalid ELF section header overflow\n");
+		goto no_exec;
+	}
 
 	info->sechdrs = (void *)info->hdr + info->hdr->e_shoff;
 
@@ -2992,13 +3009,19 @@ static int elf_validity_check(struct load_info *info)
 	 * Verify if the section name table index is valid.
 	 */
 	if (info->hdr->e_shstrndx == SHN_UNDEF
-	    || info->hdr->e_shstrndx >= info->hdr->e_shnum)
-		return -ENOEXEC;
+	    || info->hdr->e_shstrndx >= info->hdr->e_shnum) {
+		pr_err("Invalid ELF section name index: %d || e_shstrndx (%d) >= e_shnum (%d)\n",
+		       info->hdr->e_shstrndx, info->hdr->e_shstrndx,
+		       info->hdr->e_shnum);
+		goto no_exec;
+	}
 
 	strhdr = &info->sechdrs[info->hdr->e_shstrndx];
 	err = validate_section_offset(info, strhdr);
-	if (err < 0)
+	if (err < 0) {
+		pr_err("Invalid ELF section hdr(type %u)\n", strhdr->sh_type);
 		return err;
+	}
 
 	/*
 	 * The section name table must be NUL-terminated, as required
@@ -3006,8 +3029,10 @@ static int elf_validity_check(struct load_info *info)
 	 * strings in the section safe.
 	 */
 	info->secstrings = (void *)info->hdr + strhdr->sh_offset;
-	if (info->secstrings[strhdr->sh_size - 1] != '\0')
-		return -ENOEXEC;
+	if (info->secstrings[strhdr->sh_size - 1] != '\0') {
+		pr_err("ELF Spec violation: section name table isn't null terminated\n");
+		goto no_exec;
+	}
 
 	/*
 	 * The code assumes that section 0 has a length of zero and
@@ -3015,8 +3040,11 @@ static int elf_validity_check(struct load_info *info)
 	 */
 	if (info->sechdrs[0].sh_type != SHT_NULL
 	    || info->sechdrs[0].sh_size != 0
-	    || info->sechdrs[0].sh_addr != 0)
-		return -ENOEXEC;
+	    || info->sechdrs[0].sh_addr != 0) {
+		pr_err("ELF Spec violation: section 0 type(%d)!=SH_NULL or non-zero len or addr\n",
+		       info->sechdrs[0].sh_type);
+		goto no_exec;
+	}
 
 	for (i = 1; i < info->hdr->e_shnum; i++) {
 		shdr = &info->sechdrs[i];
@@ -3026,8 +3054,12 @@ static int elf_validity_check(struct load_info *info)
 			continue;
 		case SHT_SYMTAB:
 			if (shdr->sh_link == SHN_UNDEF
-			    || shdr->sh_link >= info->hdr->e_shnum)
-				return -ENOEXEC;
+			    || shdr->sh_link >= info->hdr->e_shnum) {
+				pr_err("Invalid ELF sh_link!=SHN_UNDEF(%d) or (sh_link(%d) >= hdr->e_shnum(%d)\n",
+				       shdr->sh_link, shdr->sh_link,
+				       info->hdr->e_shnum);
+				goto no_exec;
+			}
 			fallthrough;
 		default:
 			err = validate_section_offset(info, shdr);
@@ -3049,6 +3081,9 @@ static int elf_validity_check(struct load_info *info)
 	}
 
 	return 0;
+
+no_exec:
+	return -ENOEXEC;
 }
 
 #define COPY_CHUNK_SIZE (16*PAGE_SIZE)
@@ -3925,10 +3960,8 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	 * sections.
 	 */
 	err = elf_validity_check(info);
-	if (err) {
-		pr_err("Module has invalid ELF structures\n");
+	if (err)
 		goto free_copy;
-	}
 
 	/*
 	 * Everything checks out, so set up the section info
-- 
2.35.1



