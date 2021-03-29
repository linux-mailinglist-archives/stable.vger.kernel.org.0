Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFC934C830
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbhC2IUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:20:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232541AbhC2ITu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:19:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD1B761580;
        Mon, 29 Mar 2021 08:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005981;
        bh=djpNkGju6d37DXQmFTxK3UK3zgNSMkShLn30xmyCwiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L3+q+QEnLlkflMvHBhiXnI3pB0CTivHWd/1XDeh0FWvcIJMWvb1pRh3W52+Z49dzu
         Bz9/00A60yNZe+FnDplhYrsDKuO3SAzZ5WcNHDtWm1weI5N4wUPKz5Cf+jLUM8wI/4
         ynBPSkndwxfK+aJ/iyK2qIONcI6zV7Np3e9j/LtI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Bob Moore <robert.moore@intel.com>,
        Erik Kaneda <erik.kaneda@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.10 075/221] ACPICA: Always create namespace nodes using acpi_ns_create_node()
Date:   Mon, 29 Mar 2021 09:56:46 +0200
Message-Id: <20210329075631.691712911@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vegard Nossum <vegard.nossum@oracle.com>

commit 25928deeb1e4e2cdae1dccff349320c6841eb5f8 upstream.

ACPICA commit 29da9a2a3f5b2c60420893e5c6309a0586d7a329

ACPI is allocating an object using kmalloc(), but then frees it
using kmem_cache_free(<"Acpi-Namespace" kmem_cache>).

This is wrong and can lead to boot failures manifesting like this:

    hpet0: 3 comparators, 64-bit 100.000000 MHz counter
    clocksource: Switched to clocksource tsc-early
    BUG: unable to handle page fault for address: 000000003ffe0018
    #PF: supervisor read access in kernel mode
    #PF: error_code(0x0000) - not-present page
    PGD 0 P4D 0
    Oops: 0000 [#1] SMP PTI
    CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.6.0+ #211
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
Ubuntu-1.8.2-1ubuntu1 04/01/2014
    RIP: 0010:kmem_cache_alloc+0x70/0x1d0
    Code: 00 00 4c 8b 45 00 65 49 8b 50 08 65 4c 03 05 6f cc e7 7e 4d 8b
20 4d 85 e4 0f 84 3d 01 00 00 8b 45 20 48 8b 7d 00 48 8d 4a 01 <49> 8b
   1c 04 4c 89 e0 65 48 0f c7 0f 0f 94 c0 84 c0 74 c5 8b 45 20
    RSP: 0000:ffffc90000013df8 EFLAGS: 00010206
    RAX: 0000000000000018 RBX: ffffffff81c49200 RCX: 0000000000000002
    RDX: 0000000000000001 RSI: 0000000000000dc0 RDI: 000000000002b300
    RBP: ffff88803e403d00 R08: ffff88803ec2b300 R09: 0000000000000001
    R10: 0000000000000dc0 R11: 0000000000000006 R12: 000000003ffe0000
    R13: ffffffff8110a583 R14: 0000000000000dc0 R15: ffffffff81c49a80
    FS:  0000000000000000(0000) GS:ffff88803ec00000(0000)
knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 000000003ffe0018 CR3: 0000000001c0a001 CR4: 00000000003606f0
    DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
    Call Trace:
     __trace_define_field+0x33/0xa0
     event_trace_init+0xeb/0x2b4
     tracer_init_tracefs+0x60/0x195
     ? register_tracer+0x1e7/0x1e7
     do_one_initcall+0x74/0x160
     kernel_init_freeable+0x190/0x1f0
     ? rest_init+0x9a/0x9a
     kernel_init+0x5/0xf6
     ret_from_fork+0x35/0x40
    CR2: 000000003ffe0018
    ---[ end trace 707efa023f2ee960 ]---
    RIP: 0010:kmem_cache_alloc+0x70/0x1d0

Bisection leads to unrelated changes in slab; Vlastimil Babka
suggests an unrelated layout or slab merge change merely exposed
the underlying bug.

Link: https://lore.kernel.org/lkml/4dc93ff8-f86e-f4c9-ebeb-6d3153a78d03@oracle.com/
Link: https://lore.kernel.org/r/a1461e21-c744-767d-6dfc-6641fd3e3ce2@siemens.com
Link: https://github.com/acpica/acpica/commit/29da9a2a
Fixes: f79c8e4136ea ("ACPICA: Namespace: simplify creation of the initial/default namespace")
Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
Diagnosed-by: Vlastimil Babka <vbabka@suse.cz>
Diagnosed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Erik Kaneda <erik.kaneda@intel.com>
Cc: 5.10+ <stable@vger.kernel.org> # 5.10+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpica/nsaccess.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/acpi/acpica/nsaccess.c
+++ b/drivers/acpi/acpica/nsaccess.c
@@ -99,13 +99,12 @@ acpi_status acpi_ns_root_initialize(void
 		 * just create and link the new node(s) here.
 		 */
 		new_node =
-		    ACPI_ALLOCATE_ZEROED(sizeof(struct acpi_namespace_node));
+		    acpi_ns_create_node(*ACPI_CAST_PTR(u32, init_val->name));
 		if (!new_node) {
 			status = AE_NO_MEMORY;
 			goto unlock_and_exit;
 		}
 
-		ACPI_COPY_NAMESEG(new_node->name.ascii, init_val->name);
 		new_node->descriptor_type = ACPI_DESC_TYPE_NAMED;
 		new_node->type = init_val->type;
 


