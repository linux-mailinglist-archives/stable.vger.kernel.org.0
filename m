Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD65D2009F3
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732715AbgFSNYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732699AbgFSNYj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:24:39 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253F8C061794
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 06:24:38 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id x62so3772580qtd.3
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 06:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=UMmRwCkRAhMS3MbiqQcecS88t7B8fQ168Nxabe54lAo=;
        b=TLUB1RFGf2DXf2lMtsNGm0Z61F53yxlBfSVOci3GvntHq50uUGDHaVY0Mq8A/Htbhe
         HrObzydPUXM9jYQddTMnH3n3ZEuW5ltAsn1IYEIskwo09vMJvuWVx/3geAvGRkjapyeE
         I+1MzLOdMO/bqSDwtxpTD1aSr3r54nCWoi9nScny80dXJlcZo41e9L2jaizJPkzQyip9
         W9/4zR8n6U3eSQ5okgOrQedTBU+QH9qiLDzHMVlJhog3MKusqDtmamHJ8TFkviPCC+Bv
         2XU6b3ENxo+HvQ8tDdCzE9IoY8O5BARZ6B8AJdheB0OfqXuD9KnYW9FzV7rBOvmTMhS8
         euDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UMmRwCkRAhMS3MbiqQcecS88t7B8fQ168Nxabe54lAo=;
        b=bxGx9ByNEbNAOT2PKht/+feVvPvBVoAIi2ji/QcoSG5QouVCdXzxAgB0H3G+bLHx3w
         lXOFgEF8fbTIccxDG2ALTSsazjEkg+ovn3EWJLZMaedqMRLPjcYBbl8pAeyxrPFrn+0b
         da2Xb27DGBZBjxsEEMd8j8A1UrNS/EYjnlwqF/n575t9NYvW/9v8Ovc82AEf2Wb7qa5Z
         11qtHpLO4dju1FrA/8llDNmFBkXzX0dqrTWd7fhtVzgXpfvzyVvbcJtmgvrVtswBMKKj
         LPwi8hWb62o6j/Ccx++JHLo/KbGULW1U8zhrD7AOyyBgXSicG+aOwillwZvuOevLIaQj
         R7zg==
X-Gm-Message-State: AOAM530+H5N2R26NF5/GkVOVtybxVkWaFW1u0EiDvUHranj8Yls5ktec
        rPu5BIexbAetZ4mXTwFvq5EFAnDrN9Q=
X-Google-Smtp-Source: ABdhPJy8CkK8fpA7AN7mH2AOLC1PEgIFwO2iFMu/A0yTeNpMOu9bQE+Kt+886emGTWfKlSZZAn1z3A==
X-Received: by 2002:ac8:4088:: with SMTP id p8mr3298769qtl.119.1592573076968;
        Fri, 19 Jun 2020 06:24:36 -0700 (PDT)
Received: from localhost.localdomain (c-73-69-118-222.hsd1.nh.comcast.net. [73.69.118.222])
        by smtp.gmail.com with ESMTPSA id m26sm7146268qtm.73.2020.06.19.06.24.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 06:24:36 -0700 (PDT)
From:   Pavel Tatashin <pasha.tatashin@soleen.com>
To:     stable@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com,
        dan.j.williams@intel.com, shile.zhang@linux.alibaba.com,
        daniel.m.jordan@oracle.com, pasha.tatashin@soleen.com,
        ktkhai@virtuozzo.com, david@redhat.com, jmorris@namei.org,
        sashal@kernel.org, vbabka@suse.cz, gregkh@linuxfoundation.org,
        torvalds@linux-foundation.org
Subject: [PATCH 4.19 7/7] mm: call cond_resched() from deferred_init_memmap()
Date:   Fri, 19 Jun 2020 09:24:25 -0400
Message-Id: <20200619132425.425063-7-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200619132425.425063-1-pasha.tatashin@soleen.com>
References: <20200619132425.425063-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Tatashin <pasha.tatashin@soleen.com>

commit 3d060856adfc59afb9d029c233141334cfaba418 upstream.

Now that deferred pages are initialized with interrupts enabled we can
replace touch_nmi_watchdog() with cond_resched(), as it was before
3a2d7fa8a3d5.

For now, we cannot do the same in deferred_grow_zone() as it is still
initializes pages with interrupts disabled.

This change fixes RCU problem described in
https://lkml.kernel.org/r/20200401104156.11564-2-david@redhat.com

[   60.474005] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[   60.475000] rcu:  1-...0: (0 ticks this GP) idle=02a/1/0x4000000000000000 softirq=1/1 fqs=15000
[   60.475000] rcu:  (detected by 0, t=60002 jiffies, g=-1199, q=1)
[   60.475000] Sending NMI from CPU 0 to CPUs 1:
[    1.760091] NMI backtrace for cpu 1
[    1.760091] CPU: 1 PID: 20 Comm: pgdatinit0 Not tainted 4.18.0-147.9.1.el8_1.x86_64 #1
[    1.760091] Hardware name: Red Hat KVM, BIOS 1.13.0-1.module+el8.2.0+5520+4e5817f3 04/01/2014
[    1.760091] RIP: 0010:__init_single_page.isra.65+0x10/0x4f
[    1.760091] Code: 48 83 cf 63 48 89 f8 0f 1f 40 00 48 89 c6 48 89 d7 e8 6b 18 80 ff 66 90 5b c3 31 c0 b9 10 00 00 00 49 89 f8 48 c1 e6 33 f3 ab <b8> 07 00 00 00 48 c1 e2 36 41 c7 40 34 01 00 00 00 48 c1 e0 33 41
[    1.760091] RSP: 0000:ffffba783123be40 EFLAGS: 00000006
[    1.760091] RAX: 0000000000000000 RBX: fffffad34405e300 RCX: 0000000000000000
[    1.760091] RDX: 0000000000000000 RSI: 0010000000000000 RDI: fffffad34405e340
[    1.760091] RBP: 0000000033f3177e R08: fffffad34405e300 R09: 0000000000000002
[    1.760091] R10: 000000000000002b R11: ffff98afb691a500 R12: 0000000000000002
[    1.760091] R13: 0000000000000000 R14: 000000003f03ea00 R15: 000000003e10178c
[    1.760091] FS:  0000000000000000(0000) GS:ffff9c9ebeb00000(0000) knlGS:0000000000000000
[    1.760091] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.760091] CR2: 00000000ffffffff CR3: 000000a1cf20a001 CR4: 00000000003606e0
[    1.760091] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    1.760091] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    1.760091] Call Trace:
[    1.760091]  deferred_init_pages+0x8f/0xbf
[    1.760091]  deferred_init_memmap+0x184/0x29d
[    1.760091]  ? deferred_free_pages.isra.97+0xba/0xba
[    1.760091]  kthread+0x112/0x130
[    1.760091]  ? kthread_flush_work_fn+0x10/0x10
[    1.760091]  ret_from_fork+0x35/0x40
[   89.123011] node 0 initialised, 1055935372 pages in 88650ms

Fixes: 3a2d7fa8a3d5 ("mm: disable interrupts while initializing deferred pages")
Reported-by: Yiqian Wei <yiwei@redhat.com>
Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: James Morris <jmorris@namei.org>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Shile Zhang <shile.zhang@linux.alibaba.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>	[4.17+]
Link: http://lkml.kernel.org/r/20200403140952.17177-4-pasha.tatashin@soleen.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 05c27edbe076..96b8f5e8a008 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1670,7 +1670,7 @@ static int __init deferred_init_memmap(void *data)
 	 */
 	while (spfn < epfn) {
 		nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
-		touch_nmi_watchdog();
+		cond_resched();
 	}
 zone_empty:
 	/* Sanity check that the next zone really is unpopulated */
-- 
2.25.1

