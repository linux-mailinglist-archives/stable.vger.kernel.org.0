Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDAEAACDD2
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387440AbfIHMxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:53:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387431AbfIHMxG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:53:06 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59BCC21479;
        Sun,  8 Sep 2019 12:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947185;
        bh=2LOeju+fO134tMo7NuDC68/erkLik4eZPU8wzgwt80M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kZhJYDrsV0IJdsA0bxHHdnSRxs6wF06KHEU8WJfS8PxwmUo3b5PKDoUyv3fUXNVYU
         vXTTwAW+p3ZbGB+RSz1AHSbNWFTT3KvZGyZD7irJ7n0zANw6Vjmt98Ai7OACGBWSzI
         ugYAoXUVYNb+7e1h2kcikutC6d8b+5nJvmT/jRVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bandan Das <bsd@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 92/94] Revert "x86/apic: Include the LDR when clearing out APIC registers"
Date:   Sun,  8 Sep 2019 13:42:28 +0100
Message-Id: <20190908121153.061234422@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 950b07c14e8c59444e2359f15fd70ed5112e11a0 ]

This reverts commit 558682b5291937a70748d36fd9ba757fb25b99ae.

Chris Wilson reports that it breaks his CPU hotplug test scripts.  In
particular, it breaks offlining and then re-onlining the boot CPU, which
we treat specially (and the BIOS does too).

The symptoms are that we can offline the CPU, but it then does not come
back online again:

    smpboot: CPU 0 is now offline
    smpboot: Booting Node 0 Processor 0 APIC 0x0
    smpboot: do_boot_cpu failed(-1) to wakeup CPU#0

Thomas says he knows why it's broken (my personal suspicion: our magic
handling of the "cpu0_logical_apicid" thing), but for 5.3 the right fix
is to just revert it, since we've never touched the LDR bits before, and
it's not worth the risk to do anything else at this stage.

[ Hotpluging of the boot CPU is special anyway, and should be off by
  default. See the "BOOTPARAM_HOTPLUG_CPU0" config option and the
  cpu0_hotplug kernel parameter.

  In general you should not do it, and it has various known limitations
  (hibernate and suspend require the boot CPU, for example).

  But it should work, even if the boot CPU is special and needs careful
  treatment       - Linus ]

Link: https://lore.kernel.org/lkml/156785100521.13300.14461504732265570003@skylake-alporthouse-com/
Reported-by: Chris Wilson <chris@chris-wilson.co.uk>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Bandan Das <bsd@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/apic/apic.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 97c3a1c9502e7..2f067b443326e 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1152,10 +1152,6 @@ void clear_local_APIC(void)
 	apic_write(APIC_LVT0, v | APIC_LVT_MASKED);
 	v = apic_read(APIC_LVT1);
 	apic_write(APIC_LVT1, v | APIC_LVT_MASKED);
-	if (!x2apic_enabled()) {
-		v = apic_read(APIC_LDR) & ~APIC_LDR_MASK;
-		apic_write(APIC_LDR, v);
-	}
 	if (maxlvt >= 4) {
 		v = apic_read(APIC_LVTPC);
 		apic_write(APIC_LVTPC, v | APIC_LVT_MASKED);
-- 
2.20.1



