Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55D33835E1
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240075AbhEQPZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:25:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:39318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238012AbhEQPXd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:23:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BA4361C8D;
        Mon, 17 May 2021 14:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262122;
        bh=SWywZFxgLEYSzzPM7oOJI7cLdUVKxHnWBCc5M0glk6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CxaVKaBAMJnJlXHE9HzbVxU/39zYnOIgAsAsAPKe8wHdSXQo0EoBIe4nejt5A+JI4
         Vs085eUKj2xzHcJ/xKnygiqIjrYx7ARuD398ojmzuMUZHazKENLYQllkGjNR8pdbLH
         AnCOrhYQ+Lysf8rC7px2DpjXcReWMtaQURvJuG3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Baoquan He <bhe@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Dave Young <dyoung@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        Michal Hocko <mhocko@suse.com>, Qian Cai <cai@lca.pw>,
        Oscar Salvador <osalvador@suse.de>,
        Eric Biederman <ebiederm@xmission.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 221/329] kernel/resource: make walk_system_ram_res() find all busy IORESOURCE_SYSTEM_RAM resources
Date:   Mon, 17 May 2021 16:02:12 +0200
Message-Id: <20210517140309.605374467@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 97f61c8f44ec9020708b97a51188170add4f3084 ]

Patch series "kernel/resource: make walk_system_ram_res() and walk_mem_res() search the whole tree", v2.

Playing with kdump+virtio-mem I noticed that kexec_file_load() does not
consider System RAM added via dax/kmem and virtio-mem when preparing the
elf header for kdump.  Looking into the details, the logic used in
walk_system_ram_res() and walk_mem_res() seems to be outdated.

walk_system_ram_range() already does the right thing, let's change
walk_system_ram_res() and walk_mem_res(), and clean up.

Loading a kdump kernel via "kexec -p -s" ...  will result in the kdump
kernel to also dump dax/kmem and virtio-mem added System RAM now.

Note: kexec-tools on x86-64 also have to be updated to consider this
memory in the kexec_load() case when processing /proc/iomem.

This patch (of 3):

It used to be true that we can have system RAM (IORESOURCE_SYSTEM_RAM |
IORESOURCE_BUSY) only on the first level in the resource tree.  However,
this is no longer holds for driver-managed system RAM (i.e., added via
dax/kmem and virtio-mem), which gets added on lower levels, for example,
inside device containers.

We have two users of walk_system_ram_res(), which currently only
consideres the first level:

a) kernel/kexec_file.c:kexec_walk_resources() -- We properly skip
   IORESOURCE_SYSRAM_DRIVER_MANAGED resources via
   locate_mem_hole_callback(), so even after this change, we won't be
   placing kexec images onto dax/kmem and virtio-mem added memory.  No
   change.

b) arch/x86/kernel/crash.c:fill_up_crash_elf_data() -- we're currently
   not adding relevant ranges to the crash elf header, resulting in them
   not getting dumped via kdump.

This change fixes loading a crashkernel via kexec_file_load() and
including dax/kmem and virtio-mem added System RAM in the crashdump on
x86-64.  Note that e.g,, arm64 relies on memblock data and, therefore,
always considers all added System RAM already.

Let's find all IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY resources, making
the function behave like walk_system_ram_range().

Link: https://lkml.kernel.org/r/20210325115326.7826-1-david@redhat.com
Link: https://lkml.kernel.org/r/20210325115326.7826-2-david@redhat.com
Fixes: ebf71552bb0e ("virtio-mem: Add parent resource for all added "System RAM"")
Fixes: c221c0b0308f ("device-dax: "Hotplug" persistent memory for use like normal RAM")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Dave Young <dyoung@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 833394f9c608..5c86d266be34 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -454,7 +454,7 @@ int walk_system_ram_res(u64 start, u64 end, void *arg,
 {
 	unsigned long flags = IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
 
-	return __walk_iomem_res_desc(start, end, flags, IORES_DESC_NONE, true,
+	return __walk_iomem_res_desc(start, end, flags, IORES_DESC_NONE, false,
 				     arg, func);
 }
 
-- 
2.30.2



