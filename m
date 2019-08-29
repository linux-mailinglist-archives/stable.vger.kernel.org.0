Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFE53A2536
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729114AbfH2SPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:15:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729055AbfH2SPB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:15:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F00F233FF;
        Thu, 29 Aug 2019 18:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102500;
        bh=UawKxel9NpXxg9oacRYyoPRRnVT7c7gYBtipihZk+NQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=da25sV5KMmt/x3ExG0jyioeOvL+g07wk0FuGkDfcrsMeRP5nYxiNbEHWsIOo00HLL
         jPU5cOg2UHILt/HhFulsdc5vvJJVmcVriNRw4ZacV5w+SSEvHv1MU6C1MCitq7cWyA
         9E1XDxfN7deEZju3TukEz8+U/cn6rdUolWU7F1Xc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 51/76] x86/boot/compressed/64: Fix boot on machines with broken E820 table
Date:   Thu, 29 Aug 2019 14:12:46 -0400
Message-Id: <20190829181311.7562-51-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Kirill A. Shutemov" <kirill@shutemov.name>

[ Upstream commit 0a46fff2f9108c2c44218380a43a736cf4612541 ]

BIOS on Samsung 500C Chromebook reports very rudimentary E820 table that
consists of 2 entries:

  BIOS-e820: [mem 0x0000000000000000-0x0000000000000fff] usable
  BIOS-e820: [mem 0x00000000fffff000-0x00000000ffffffff] reserved

It breaks logic in find_trampoline_placement(): bios_start lands on the
end of the first 4k page and trampoline start gets placed below 0.

Detect underflow and don't touch bios_start for such cases. It makes
kernel ignore E820 table on machines that doesn't have two usable pages
below BIOS_START_MAX.

Fixes: 1b3a62643660 ("x86/boot/compressed/64: Validate trampoline placement against E820")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86-ml <x86@kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=203463
Link: https://lkml.kernel.org/r/20190813131654.24378-1-kirill.shutemov@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/boot/compressed/pgtable_64.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/compressed/pgtable_64.c b/arch/x86/boot/compressed/pgtable_64.c
index f8debf7aeb4c1..f0537a1f7fc25 100644
--- a/arch/x86/boot/compressed/pgtable_64.c
+++ b/arch/x86/boot/compressed/pgtable_64.c
@@ -73,6 +73,8 @@ static unsigned long find_trampoline_placement(void)
 
 	/* Find the first usable memory region under bios_start. */
 	for (i = boot_params->e820_entries - 1; i >= 0; i--) {
+		unsigned long new;
+
 		entry = &boot_params->e820_table[i];
 
 		/* Skip all entries above bios_start. */
@@ -85,15 +87,20 @@ static unsigned long find_trampoline_placement(void)
 
 		/* Adjust bios_start to the end of the entry if needed. */
 		if (bios_start > entry->addr + entry->size)
-			bios_start = entry->addr + entry->size;
+			new = entry->addr + entry->size;
 
 		/* Keep bios_start page-aligned. */
-		bios_start = round_down(bios_start, PAGE_SIZE);
+		new = round_down(new, PAGE_SIZE);
 
 		/* Skip the entry if it's too small. */
-		if (bios_start - TRAMPOLINE_32BIT_SIZE < entry->addr)
+		if (new - TRAMPOLINE_32BIT_SIZE < entry->addr)
 			continue;
 
+		/* Protect against underflow. */
+		if (new - TRAMPOLINE_32BIT_SIZE > bios_start)
+			break;
+
+		bios_start = new;
 		break;
 	}
 
-- 
2.20.1

