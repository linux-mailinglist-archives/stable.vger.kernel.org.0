Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625DE3CA99F
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242321AbhGOTHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:07:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242261AbhGOTGx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:06:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FF806140F;
        Thu, 15 Jul 2021 19:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375773;
        bh=36uWLMfmCtfxLVMGxi41DWgaM+LISYVe+Ya879sk9tY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wsSta3MEprn3ABad0faG9QZdEQwHhgw01hSWszgkGmu2ijahwA/qwOc+JGEiuB8F2
         7MaCOax3+Xpq9nJKfmWGCCkeS7sXLWqoT5mzFhwRoxJSm9D9dIOV7gn8ZDosquA7Wy
         qO4ZX7RmVuVqX3mATCTFahwIO197HSo0nQNhuIRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.12 230/242] s390/vdso: always enable vdso
Date:   Thu, 15 Jul 2021 20:39:52 +0200
Message-Id: <20210715182633.356307910@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

commit d57778feb9878aa6b79c615fd029c2112d40a747 upstream.

With the upcoming move of the svc sigreturn instruction from
the signal frame to vdso we need to have vdso always enabled.

Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/elf.h |   11 ++++-------
 arch/s390/kernel/vdso.c     |   21 ++++-----------------
 2 files changed, 8 insertions(+), 24 deletions(-)

--- a/arch/s390/include/asm/elf.h
+++ b/arch/s390/include/asm/elf.h
@@ -146,8 +146,6 @@ typedef s390_compat_regs compat_elf_greg
 
 #include <asm/vdso.h>
 
-extern unsigned int vdso_enabled;
-
 /*
  * This is used to ensure we don't load something for the wrong architecture.
  */
@@ -268,11 +266,10 @@ do {								\
 #define STACK_RND_MASK	MMAP_RND_MASK
 
 /* update AT_VECTOR_SIZE_ARCH if the number of NEW_AUX_ENT entries changes */
-#define ARCH_DLINFO							    \
-do {									    \
-	if (vdso_enabled)						    \
-		NEW_AUX_ENT(AT_SYSINFO_EHDR,				    \
-			    (unsigned long)current->mm->context.vdso_base); \
+#define ARCH_DLINFO							\
+do {									\
+	NEW_AUX_ENT(AT_SYSINFO_EHDR,					\
+		    (unsigned long)current->mm->context.vdso_base);	\
 } while (0)
 
 struct linux_binprm;
--- a/arch/s390/kernel/vdso.c
+++ b/arch/s390/kernel/vdso.c
@@ -37,18 +37,6 @@ enum vvar_pages {
 	VVAR_NR_PAGES,
 };
 
-unsigned int __read_mostly vdso_enabled = 1;
-
-static int __init vdso_setup(char *str)
-{
-	bool enabled;
-
-	if (!kstrtobool(str, &enabled))
-		vdso_enabled = enabled;
-	return 1;
-}
-__setup("vdso=", vdso_setup);
-
 #ifdef CONFIG_TIME_NS
 struct vdso_data *arch_get_vdso_data(void *vvar_page)
 {
@@ -176,7 +164,7 @@ int arch_setup_additional_pages(struct l
 	int rc;
 
 	BUILD_BUG_ON(VVAR_NR_PAGES != __VVAR_PAGES);
-	if (!vdso_enabled || is_compat_task())
+	if (is_compat_task())
 		return 0;
 	if (mmap_write_lock_killable(mm))
 		return -EINTR;
@@ -218,10 +206,9 @@ static int __init vdso_init(void)
 
 	vdso_pages = (vdso64_end - vdso64_start) >> PAGE_SHIFT;
 	pages = kcalloc(vdso_pages + 1, sizeof(struct page *), GFP_KERNEL);
-	if (!pages) {
-		vdso_enabled = 0;
-		return -ENOMEM;
-	}
+	if (!pages)
+		panic("failed to allocate VDSO pages");
+
 	for (i = 0; i < vdso_pages; i++)
 		pages[i] = virt_to_page(vdso64_start + i * PAGE_SIZE);
 	pages[vdso_pages] = NULL;


