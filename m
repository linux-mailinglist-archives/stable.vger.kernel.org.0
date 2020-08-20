Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3064224BABC
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730263AbgHTMQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:16:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728018AbgHTJ4k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:56:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 922682067C;
        Thu, 20 Aug 2020 09:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917399;
        bh=d2a5Hbbktp632+zIHqHVtSxvKpr65FFnZhZqKx3Udg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B9vQGaZJqRPBwofcHfBfn+fy2sU5Cpvo3inaW/H9OFHMccO9vGkuIDtviXB+6PkDF
         wc8xB1l6w5oMpTZGHtISDqh969K9Ksm+bsnMscgRqadZQvWukEidXCwtIBJd1gTPVL
         Sji3xurS9zdXM6U/ZtaWHOfDM/vZm6V/zKe9p3WU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 018/212] x86, vmlinux.lds: Page-align end of ..page_aligned sections
Date:   Thu, 20 Aug 2020 11:19:51 +0200
Message-Id: <20200820091603.261226300@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

[ Upstream commit de2b41be8fcccb2f5b6c480d35df590476344201 ]

On x86-32 the idt_table with 256 entries needs only 2048 bytes. It is
page-aligned, but the end of the .bss..page_aligned section is not
guaranteed to be page-aligned.

As a result, objects from other .bss sections may end up on the same 4k
page as the idt_table, and will accidentially get mapped read-only during
boot, causing unexpected page-faults when the kernel writes to them.

This could be worked around by making the objects in the page aligned
sections page sized, but that's wrong.

Explicit sections which store only page aligned objects have an implicit
guarantee that the object is alone in the page in which it is placed. That
works for all objects except the last one. That's inconsistent.

Enforcing page sized objects for these sections would wreckage memory
sanitizers, because the object becomes artificially larger than it should
be and out of bound access becomes legit.

Align the end of the .bss..page_aligned and .data..page_aligned section on
page-size so all objects places in these sections are guaranteed to have
their own page.

[ tglx: Amended changelog ]

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200721093448.10417-1-joro@8bytes.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/vmlinux.lds.S     | 1 +
 include/asm-generic/vmlinux.lds.h | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 0df44e4fe7cb1..a1082dc61bb96 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -329,6 +329,7 @@ SECTIONS
 	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {
 		__bss_start = .;
 		*(.bss..page_aligned)
+		. = ALIGN(PAGE_SIZE);
 		*(BSS_MAIN)
 		. = ALIGN(PAGE_SIZE);
 		__bss_stop = .;
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 1462071a19bf2..4fdb1d9848444 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -250,7 +250,8 @@
 
 #define PAGE_ALIGNED_DATA(page_align)					\
 	. = ALIGN(page_align);						\
-	*(.data..page_aligned)
+	*(.data..page_aligned)						\
+	. = ALIGN(page_align);
 
 #define READ_MOSTLY_DATA(align)						\
 	. = ALIGN(align);						\
@@ -625,7 +626,9 @@
 	. = ALIGN(bss_align);						\
 	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {				\
 		BSS_FIRST_SECTIONS					\
+		. = ALIGN(PAGE_SIZE);					\
 		*(.bss..page_aligned)					\
+		. = ALIGN(PAGE_SIZE);					\
 		*(.dynbss)						\
 		*(BSS_MAIN)						\
 		*(COMMON)						\
-- 
2.25.1



