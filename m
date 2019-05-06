Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 502DC14DA2
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbfEFOrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:47:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:46084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729267AbfEFOrN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:47:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64F0720449;
        Mon,  6 May 2019 14:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557154032;
        bh=ZWme/I8XL5DLX6KM91dRGi4a4dE7wwzF7MHXMGfGN9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=obu/ygWjkqXN3BWalGEjXQYSsY6ht/3WCtLYa2Yusn9fiejiAhcrZUPLqn54yzLMy
         f5dLd+u1/3P6WgsB5HFEXi2npGfQz1YyfT1Sk0LnHyfoNm2ozxt3yXHoNygd9UqWvT
         7zV78hgU1N8P5ZyVAzq1ugt9N54uiqfnRbY0XgGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Laura Abbott <labbott@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrey Konovalov <andreyknvl@google.com>
Subject: [PATCH 4.9 13/62] arm64: kasan: avoid bad virt_to_pfn()
Date:   Mon,  6 May 2019 16:32:44 +0200
Message-Id: <20190506143052.234114233@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143051.102535767@linuxfoundation.org>
References: <20190506143051.102535767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

commit b0de0ccc8b9edd8846828e0ecdc35deacdf186b0 upstream.

Booting a v4.11-rc1 kernel with DEBUG_VIRTUAL and KASAN enabled produces
the following splat (trimmed for brevity):

[    0.000000] virt_to_phys used for non-linear address: ffff200008080000 (0xffff200008080000)
[    0.000000] WARNING: CPU: 0 PID: 0 at arch/arm64/mm/physaddr.c:14 __virt_to_phys+0x48/0x70
[    0.000000] PC is at __virt_to_phys+0x48/0x70
[    0.000000] LR is at __virt_to_phys+0x48/0x70
[    0.000000] Call trace:
[    0.000000] [<ffff2000080b1ac0>] __virt_to_phys+0x48/0x70
[    0.000000] [<ffff20000a03b86c>] kasan_init+0x1c0/0x498
[    0.000000] [<ffff20000a034018>] setup_arch+0x2fc/0x948
[    0.000000] [<ffff20000a030c68>] start_kernel+0xb8/0x570
[    0.000000] [<ffff20000a0301e8>] __primary_switched+0x6c/0x74

This is because we use virt_to_pfn() on a kernel image address when
trying to figure out its nid, so that we can allocate its shadow from
the same node.

As with other recent changes, this patch uses lm_alias() to solve this.

We could instead use NUMA_NO_NODE, as x86 does for all shadow
allocations, though we'll likely want the "real" memory shadow to be
backed from its corresponding nid anyway, so we may as well be
consistent and find the nid for the image shadow.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Acked-by: Laura Abbott <labbott@redhat.com>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/mm/kasan_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/mm/kasan_init.c
+++ b/arch/arm64/mm/kasan_init.c
@@ -153,7 +153,7 @@ void __init kasan_init(void)
 	clear_pgds(KASAN_SHADOW_START, KASAN_SHADOW_END);
 
 	vmemmap_populate(kimg_shadow_start, kimg_shadow_end,
-			 pfn_to_nid(virt_to_pfn(_text)));
+			 pfn_to_nid(virt_to_pfn(lm_alias(_text))));
 
 	/*
 	 * vmemmap_populate() has populated the shadow region that covers the


