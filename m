Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3FE29C739
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503814AbgJ0N4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 09:56:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S368092AbgJ0N4y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 09:56:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B488F2074B;
        Tue, 27 Oct 2020 13:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807013;
        bh=vYqHa6lv0tcd1MlRaQ+jJjgy7UFuZEKXGYbCMNvfk1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uNXAfI3u+ce9dZPVwJP/PwrbNLH7wCt+nkC2Jh4YaXpR67ZBH5oTdTurA7KXHXJk0
         /3god1EIQc9SpvYhvrbzvpZ/Bjm1Hra7cCrpNJajmsh/hRg0g/WxSMt0KCy+QUBuHq
         FTL/990ZcMg4xgQVoxSCHWDlAdSiit6lOBzytmho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Regnery <tobias.regnery@gmail.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        kasan-dev@googlegroups.com,
        Alexander Potapenko <glider@google.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.4 011/112] x86/mm/ptdump: Fix soft lockup in page table walker
Date:   Tue, 27 Oct 2020 14:48:41 +0100
Message-Id: <20201027134901.090009773@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134900.532249571@linuxfoundation.org>
References: <20201027134900.532249571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ryabinin <aryabinin@virtuozzo.com>

commit 146fbb766934dc003fcbf755b519acef683576bf upstream.

CONFIG_KASAN=y needs a lot of virtual memory mapped for its shadow.
In that case ptdump_walk_pgd_level_core() takes a lot of time to
walk across all page tables and doing this without
a rescheduling causes soft lockups:

 NMI watchdog: BUG: soft lockup - CPU#3 stuck for 23s! [swapper/0:1]
 ...
 Call Trace:
  ptdump_walk_pgd_level_core+0x40c/0x550
  ptdump_walk_pgd_level_checkwx+0x17/0x20
  mark_rodata_ro+0x13b/0x150
  kernel_init+0x2f/0x120
  ret_from_fork+0x2c/0x40

I guess that this issue might arise even without KASAN on huge machines
with several terabytes of RAM.

Stick cond_resched() in pgd loop to fix this.

Reported-by: Tobias Regnery <tobias.regnery@gmail.com>
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: kasan-dev@googlegroups.com
Cc: Alexander Potapenko <glider@google.com>
Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/20170210095405.31802-1-aryabinin@virtuozzo.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 4.4: adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/dump_pagetables.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -15,6 +15,7 @@
 #include <linux/debugfs.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/seq_file.h>
 
 #include <asm/pgtable.h>
@@ -407,6 +408,7 @@ static void ptdump_walk_pgd_level_core(s
 		} else
 			note_page(m, &st, __pgprot(0), 1);
 
+		cond_resched();
 		start++;
 	}
 


