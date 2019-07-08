Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F11EB61F82
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 15:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730812AbfGHNX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 09:23:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:52774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729736AbfGHNX5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 09:23:57 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 926F6204EC;
        Mon,  8 Jul 2019 13:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562592236;
        bh=5unjiGXyZMe7nrADNmOUxzDWIctjoRwlIq26XQXLoxc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MRsfeUafFOFljnmQC3MNzrQasf6DbORI/v84iuy3gpkIjlsVn4WmeJrZm8aUU4EQ9
         s8S1gTO8gc088qDH44pBLOXm0hR+1H9t0qGrkFm0yUBJMk+0qfjXk9/9nO3KTDR9Oz
         8E9WSOfVTbDidCA3ROGbTnD9gaQdEc/UjOwlds8U=
Date:   Mon, 8 Jul 2019 14:23:52 +0100
From:   Will Deacon <will@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     ard.biesheuvel@linaro.org, catalin.marinas@arm.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: kaslr: keep modules inside module
 region when KASAN is" failed to apply to 4.9-stable tree
Message-ID: <20190708132351.kxai726abg2piley@willie-the-truck>
References: <1562316860240248@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562316860240248@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 05, 2019 at 10:54:20AM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 6f496a555d93db7a11d4860b9220d904822f586a Mon Sep 17 00:00:00 2001
> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Date: Tue, 25 Jun 2019 19:08:54 +0200
> Subject: [PATCH] arm64: kaslr: keep modules inside module region when KASAN is
>  enabled

4.9 backport below.

Will

--->8

From aea0e2ae427420e14ee0f442ff901de7945e3b8b Mon Sep 17 00:00:00 2001
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 25 Jun 2019 19:08:54 +0200
Subject: [PATCH] arm64: kaslr: keep modules inside module region when KASAN is
 enabled

[Commit 6f496a555d93db7a11d4860b9220d904822f586a upstream.]

When KASLR and KASAN are both enabled, we keep the modules where they
are, and randomize the placement of the kernel so it is within 2 GB
of the module region. The reason for this is that putting modules in
the vmalloc region (like we normally do when KASLR is enabled) is not
possible in this case, given that the entire vmalloc region is already
backed by KASAN zero shadow pages, and so allocating dedicated KASAN
shadow space as required by loaded modules is not possible.

The default module allocation window is set to [_etext - 128MB, _etext]
in kaslr.c, which is appropriate for KASLR kernels booted without a
seed or with 'nokaslr' on the command line. However, as it turns out,
it is not quite correct for the KASAN case, since it still intersects
the vmalloc region at the top, where attempts to allocate shadow pages
will collide with the KASAN zero shadow pages, causing a WARN() and all
kinds of other trouble. So cap the top end to MODULES_END explicitly
when running with KASAN.

Cc: <stable@vger.kernel.org> # 4.9
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
[will: backport to 4.9.y]
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kernel/module.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
index 7f316982ce00..4130f1f26852 100644
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -33,10 +33,14 @@
 void *module_alloc(unsigned long size)
 {
 	void *p;
+	u64 module_alloc_end = module_alloc_base + MODULES_VSIZE;
+
+	if (IS_ENABLED(CONFIG_KASAN))
+		/* don't exceed the static module region - see below */
+		module_alloc_end = MODULES_END;
 
 	p = __vmalloc_node_range(size, MODULE_ALIGN, module_alloc_base,
-				module_alloc_base + MODULES_VSIZE,
-				GFP_KERNEL, PAGE_KERNEL_EXEC, 0,
+				module_alloc_end, GFP_KERNEL, PAGE_KERNEL_EXEC, 0,
 				NUMA_NO_NODE, __builtin_return_address(0));
 
 	if (!p && IS_ENABLED(CONFIG_ARM64_MODULE_PLTS) &&
-- 
2.11.0

