Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C69B1FE168
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729938AbgFRByi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:54:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:33174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728404AbgFRBZ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:25:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 729092075E;
        Thu, 18 Jun 2020 01:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443556;
        bh=os6n/9kN27wCSarGN1/VzYvMf39rkPiyKxsiw3Y+JXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=neHP/Pr0nlFdKdbS+DdieEC9pjNO4bNMWxBoHtTWIlJhY1EK+GpwNd9Xst6b44/CG
         OZsZA1xDMsE+wx0//pixYgf6K7Vn0GPICISNE4IgDiaO7XYbij3OkRLrJ0CMyqQbwd
         4WSd5oq3qWVHjE9ETmUdC/qQ+tY9EeKN/H+9uVZc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 170/172] x86/idt: Keep spurious entries unset in system_vectors
Date:   Wed, 17 Jun 2020 21:22:16 -0400
Message-Id: <20200618012218.607130-170-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012218.607130-1-sashal@kernel.org>
References: <20200618012218.607130-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit 1f1fbc70c10e81f70e9fbe2102d439c883269811 ]

With commit dc20b2d52653 ("x86/idt: Move interrupt gate initialization to
IDT code") non assigned system vectors are also marked as used in
'used_vectors' (now 'system_vectors') bitmap. This makes checks in
arch_show_interrupts() whether a particular system vector is allocated to
always pass and e.g. 'Hyper-V reenlightenment interrupts' entry always
shows up in /proc/interrupts.

Another side effect of having all unassigned system vectors marked as used
is that irq_matrix_debug_show() will wrongly count them among 'System'
vectors.

As it is now ensured that alloc_intr_gate() is not called after init, it is
possible to leave unused entries in 'system_vectors' unset to fix these
issues.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20200428093824.1451532-4-vkuznets@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/idt.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/idt.c b/arch/x86/kernel/idt.c
index a7e0e975043f..e1f9355307b8 100644
--- a/arch/x86/kernel/idt.c
+++ b/arch/x86/kernel/idt.c
@@ -320,7 +320,11 @@ void __init idt_setup_apic_and_irq_gates(void)
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	for_each_clear_bit_from(i, system_vectors, NR_VECTORS) {
-		set_bit(i, system_vectors);
+		/*
+		 * Don't set the non assigned system vectors in the
+		 * system_vectors bitmap. Otherwise they show up in
+		 * /proc/interrupts.
+		 */
 		entry = spurious_entries_start + 8 * (i - FIRST_SYSTEM_VECTOR);
 		set_intr_gate(i, entry);
 	}
-- 
2.25.1

