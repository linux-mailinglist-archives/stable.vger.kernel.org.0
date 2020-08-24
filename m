Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122C624F7D1
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbgHXJWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:22:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:36966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730398AbgHXIzO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:55:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFB2D204FD;
        Mon, 24 Aug 2020 08:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259314;
        bh=BR8ucvG+j5PdW4PTpkca7Esn4G0N0ywyyLUws135Kkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i1SI4/3wFoj3aUxlKjE0EixuhAycRlGl7mV+Yd+d9sxIYf+3hDnVz6gSNHi2GJ7RL
         rQjKCdlnr9eT2WE5mmB8xKCON8XpZT9XZyAYtbzyLlpjfmVl+EvbNguQPxuQR6DOZ1
         iczu+VJ+COYyUUpVCO/39/vnVJtnaYKSnP02Mlpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.com>,
        Jason Baron <jbaron@akamai.com>,
        David Rientjes <rientjes@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 12/71] mm: include CMA pages in lowmem_reserve at boot
Date:   Mon, 24 Aug 2020 10:31:03 +0200
Message-Id: <20200824082356.507791160@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082355.848475917@linuxfoundation.org>
References: <20200824082355.848475917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

commit e08d3fdfe2dafa0331843f70ce1ff6c1c4900bf4 upstream.

The lowmem_reserve arrays provide a means of applying pressure against
allocations from lower zones that were targeted at higher zones.  Its
values are a function of the number of pages managed by higher zones and
are assigned by a call to the setup_per_zone_lowmem_reserve() function.

The function is initially called at boot time by the function
init_per_zone_wmark_min() and may be called later by accesses of the
/proc/sys/vm/lowmem_reserve_ratio sysctl file.

The function init_per_zone_wmark_min() was moved up from a module_init to
a core_initcall to resolve a sequencing issue with khugepaged.
Unfortunately this created a sequencing issue with CMA page accounting.

The CMA pages are added to the managed page count of a zone when
cma_init_reserved_areas() is called at boot also as a core_initcall.  This
makes it uncertain whether the CMA pages will be added to the managed page
counts of their zones before or after the call to
init_per_zone_wmark_min() as it becomes dependent on link order.  With the
current link order the pages are added to the managed count after the
lowmem_reserve arrays are initialized at boot.

This means the lowmem_reserve values at boot may be lower than the values
used later if /proc/sys/vm/lowmem_reserve_ratio is accessed even if the
ratio values are unchanged.

In many cases the difference is not significant, but for example
an ARM platform with 1GB of memory and the following memory layout

  cma: Reserved 256 MiB at 0x0000000030000000
  Zone ranges:
    DMA      [mem 0x0000000000000000-0x000000002fffffff]
    Normal   empty
    HighMem  [mem 0x0000000030000000-0x000000003fffffff]

would result in 0 lowmem_reserve for the DMA zone.  This would allow
userspace to deplete the DMA zone easily.

Funnily enough

  $ cat /proc/sys/vm/lowmem_reserve_ratio

would fix up the situation because as a side effect it forces
setup_per_zone_lowmem_reserve.

This commit breaks the link order dependency by invoking
init_per_zone_wmark_min() as a postcore_initcall so that the CMA pages
have the chance to be properly accounted in their zone(s) and allowing
the lowmem_reserve arrays to receive consistent values.

Fixes: bc22af74f271 ("mm: update min_free_kbytes from khugepaged after core initialization")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Jason Baron <jbaron@akamai.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/1597423766-27849-1-git-send-email-opendmb@gmail.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7395,7 +7395,7 @@ int __meminit init_per_zone_wmark_min(vo
 
 	return 0;
 }
-core_initcall(init_per_zone_wmark_min)
+postcore_initcall(init_per_zone_wmark_min)
 
 /*
  * min_free_kbytes_sysctl_handler - just a wrapper around proc_dointvec() so


