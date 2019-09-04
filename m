Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB8C0A8E87
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730371AbfIDR6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:58:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731727AbfIDR6c (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:58:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91DC3208E4;
        Wed,  4 Sep 2019 17:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619911;
        bh=KFODnPUszH4MM9Zm/k4q06s97DmxuuLgP9E4w7ZP23Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KLFPRELXwW+Q9CRpJDMP0oh6vGhgliY5rognZOaBjHB3gkv7gNogzFd09YLfK6uAN
         iWHmqlx37NCFvpf5+MmdPbpmbALk/ad75kw9stFid5qK2Gy33N9g389fo1MM/akUyu
         AQYl3YR/eydx4ITZvgNQVu7k0wg0oHlrAD23rUOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Bandan Das <bsd@redhat.com>
Subject: [PATCH 4.4 62/77] x86/apic: Do not initialize LDR and DFR for bigsmp
Date:   Wed,  4 Sep 2019 19:53:49 +0200
Message-Id: <20190904175309.184658503@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
References: <20190904175303.317468926@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bandan Das <bsd@redhat.com>

commit bae3a8d3308ee69a7dbdf145911b18dfda8ade0d upstream.

Legacy apic init uses bigsmp for smp systems with 8 and more CPUs. The
bigsmp APIC implementation uses physical destination mode, but it
nevertheless initializes LDR and DFR. The LDR even ends up incorrectly with
multiple bit being set.

This does not cause a functional problem because LDR and DFR are ignored
when physical destination mode is active, but it triggered a problem on a
32-bit KVM guest which jumps into a kdump kernel.

The multiple bits set unearthed a bug in the KVM APIC implementation. The
code which creates the logical destination map for VCPUs ignores the
disabled state of the APIC and ends up overwriting an existing valid entry
and as a result, APIC calibration hangs in the guest during kdump
initialization.

Remove the bogus LDR/DFR initialization.

This is not intended to work around the KVM APIC bug. The LDR/DFR
ininitalization is wrong on its own.

The issue goes back into the pre git history. The fixes tag is the commit
in the bitkeeper import which introduced bigsmp support in 2003.

  git://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git

Fixes: db7b9e9f26b8 ("[PATCH] Clustered APIC setup for >8 CPU systems")
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Bandan Das <bsd@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20190826101513.5080-2-bsd@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/apic/bigsmp_32.c |   24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -37,32 +37,12 @@ static int bigsmp_early_logical_apicid(i
 	return early_per_cpu(x86_cpu_to_apicid, cpu);
 }
 
-static inline unsigned long calculate_ldr(int cpu)
-{
-	unsigned long val, id;
-
-	val = apic_read(APIC_LDR) & ~APIC_LDR_MASK;
-	id = per_cpu(x86_bios_cpu_apicid, cpu);
-	val |= SET_APIC_LOGICAL_ID(id);
-
-	return val;
-}
-
 /*
- * Set up the logical destination ID.
- *
- * Intel recommends to set DFR, LDR and TPR before enabling
- * an APIC.  See e.g. "AP-388 82489DX User's Manual" (Intel
- * document number 292116).  So here it goes...
+ * bigsmp enables physical destination mode
+ * and doesn't use LDR and DFR
  */
 static void bigsmp_init_apic_ldr(void)
 {
-	unsigned long val;
-	int cpu = smp_processor_id();
-
-	apic_write(APIC_DFR, APIC_DFR_FLAT);
-	val = calculate_ldr(cpu);
-	apic_write(APIC_LDR, val);
 }
 
 static void bigsmp_setup_apic_routing(void)


