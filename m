Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021631D8678
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgERRqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:46:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:45942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730073AbgERRqX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:46:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77FFD20671;
        Mon, 18 May 2020 17:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823982;
        bh=OJtl/DPKcnPBAinaU+XsrpPzPk9DjxH6KkyxoHcCLeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ezn0817SQQ/QDpZgw4DjkFYoZrnFJjGH/aXXjyaKyoJREYK8uuMeVzIdgPx3WtAxE
         UN/M1/Je5nHx5wXSDo/2+r3A8PFbEqFtzAczlpYJlO8QAtoz6Ylgb8IE/VBmnqyQhF
         wgH4cdtkJ/L/KZlLfOEHQKRBd02/Sg8HnBrTCcRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Baoquan He <bhe@redhat.com>,
        Shile Zhang <shile.zhang@linux.alibaba.com>,
        Michal Hocko <mhocko@suse.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Michal Hocko <mhocko@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Oscar Salvador <osalvador@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 023/114] mm/page_alloc: fix watchdog soft lockups during set_zone_contiguous()
Date:   Mon, 18 May 2020 19:35:55 +0200
Message-Id: <20200518173507.906629646@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

commit e84fe99b68ce353c37ceeecc95dce9696c976556 upstream.

Without CONFIG_PREEMPT, it can happen that we get soft lockups detected,
e.g., while booting up.

  watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [swapper/0:1]
  CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.6.0-next-20200331+ #4
  Hardware name: Red Hat KVM, BIOS 1.11.1-4.module+el8.1.0+4066+0f1aadab 04/01/2014
  RIP: __pageblock_pfn_to_page+0x134/0x1c0
  Call Trace:
   set_zone_contiguous+0x56/0x70
   page_alloc_init_late+0x166/0x176
   kernel_init_freeable+0xfa/0x255
   kernel_init+0xa/0x106
   ret_from_fork+0x35/0x40

The issue becomes visible when having a lot of memory (e.g., 4TB)
assigned to a single NUMA node - a system that can easily be created
using QEMU.  Inside VMs on a hypervisor with quite some memory
overcommit, this is fairly easy to trigger.

Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Shile Zhang <shile.zhang@linux.alibaba.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Shile Zhang <shile.zhang@linux.alibaba.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200416073417.5003-1-david@redhat.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1405,6 +1405,7 @@ void set_zone_contiguous(struct zone *zo
 		if (!__pageblock_pfn_to_page(block_start_pfn,
 					     block_end_pfn, zone))
 			return;
+		cond_resched();
 	}
 
 	/* We confirm that there is no hole */


