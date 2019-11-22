Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B73A6106E63
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbfKVLID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:08:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:60344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731633AbfKVLE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:04:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9252F20854;
        Fri, 22 Nov 2019 11:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420697;
        bh=9PcIazD5ai6mg5kNZCsOn/ZzooCD/2R3M4jCxJLn8Pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=axYRvsQy5YGuUxB03wJmsI0w4+osoaWh0kbRtaz5aRf9oq06MBqqKh76p4lHRZ2UF
         ko2N/H9gdS8/T/bUx/fAVRDtRLH19T5E8O2TKiQe9kJLLv6GSqTvBnWKSM5YAti5AG
         kwR9M68Ca4mSJWInKPR6Ynp9QJdpB4aJ6+KD2pU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>, Joerg Roedel <joro@8bytes.org>,
        Kees Cook <keescook@chromium.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 195/220] x86/mm: Do not warn about PCI BIOS W+X mappings
Date:   Fri, 22 Nov 2019 11:29:20 +0100
Message-Id: <20191122100928.049975473@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit c200dac78fec66d87ef262cac38cfe4feabdf737 ]

PCI BIOS requires the BIOS area 0x0A0000-0x0FFFFFF to be mapped W+X for
various legacy reasons. When CONFIG_DEBUG_WX is enabled, this triggers the
WX warning, but this is misleading because the mapping is required and is
not a result of an accidental oversight.

Prevent the full warning when PCI BIOS is enabled and the detected WX
mapping is in the BIOS area. Just emit a pr_warn() which denotes the
fact. This is partially duplicating the info which the PCI BIOS code emits
when it maps the area as executable, but that info is not in the context of
the WX checking output.

Remove the extra %p printout in the WARN_ONCE() while at it. %pS is enough.

Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Borislav Petkov <bp@suse.de>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Link: https://lkml.kernel.org/r/alpine.DEB.2.21.1810082151160.2455@nanos.tec.linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/dump_pagetables.c | 35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index c05a818224bb0..abcb8d00b0148 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -19,7 +19,9 @@
 #include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/highmem.h>
+#include <linux/pci.h>
 
+#include <asm/e820/types.h>
 #include <asm/pgtable.h>
 
 /*
@@ -238,6 +240,29 @@ static unsigned long normalize_addr(unsigned long u)
 	return (signed long)(u << shift) >> shift;
 }
 
+static void note_wx(struct pg_state *st)
+{
+	unsigned long npages;
+
+	npages = (st->current_address - st->start_address) / PAGE_SIZE;
+
+#ifdef CONFIG_PCI_BIOS
+	/*
+	 * If PCI BIOS is enabled, the PCI BIOS area is forced to WX.
+	 * Inform about it, but avoid the warning.
+	 */
+	if (pcibios_enabled && st->start_address >= PAGE_OFFSET + BIOS_BEGIN &&
+	    st->current_address <= PAGE_OFFSET + BIOS_END) {
+		pr_warn_once("x86/mm: PCI BIOS W+X mapping %lu pages\n", npages);
+		return;
+	}
+#endif
+	/* Account the WX pages */
+	st->wx_pages += npages;
+	WARN_ONCE(1, "x86/mm: Found insecure W+X mapping at address %pS\n",
+		  (void *)st->start_address);
+}
+
 /*
  * This function gets called on a break in a continuous series
  * of PTE entries; the next one is different so we need to
@@ -273,14 +298,8 @@ static void note_page(struct seq_file *m, struct pg_state *st,
 		unsigned long delta;
 		int width = sizeof(unsigned long) * 2;
 
-		if (st->check_wx && (eff & _PAGE_RW) && !(eff & _PAGE_NX)) {
-			WARN_ONCE(1,
-				  "x86/mm: Found insecure W+X mapping at address %p/%pS\n",
-				  (void *)st->start_address,
-				  (void *)st->start_address);
-			st->wx_pages += (st->current_address -
-					 st->start_address) / PAGE_SIZE;
-		}
+		if (st->check_wx && (eff & _PAGE_RW) && !(eff & _PAGE_NX))
+			note_wx(st);
 
 		/*
 		 * Now print the actual finished series
-- 
2.20.1



