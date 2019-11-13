Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEAFFA49F
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729176AbfKMBzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:55:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:47252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729165AbfKMBzg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:55:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1277522469;
        Wed, 13 Nov 2019 01:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610136;
        bh=9PcIazD5ai6mg5kNZCsOn/ZzooCD/2R3M4jCxJLn8Pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IILBRTEvaQPddPGoyGg6a3sfXwu0M+alTcPTLhU83XJPv462KRApdZ6+7nJUip82S
         Ll6+9Zbq7wqY9VCDStyU6VqdhmUn1Kjsj7er3uURcNwrYqRn++UJHqU0HzMYSE7VdA
         suIB1c5q3ymxiRXOxkax6fsADbtPOa+jCOrXFj6A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Borislav Petkov <bp@suse.de>, Joerg Roedel <joro@8bytes.org>,
        Kees Cook <keescook@chromium.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 184/209] x86/mm: Do not warn about PCI BIOS W+X mappings
Date:   Tue, 12 Nov 2019 20:50:00 -0500
Message-Id: <20191113015025.9685-184-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

