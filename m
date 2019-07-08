Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A07D3622BE
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389325AbfGHP2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:28:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731889AbfGHP2g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:28:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 288CE21738;
        Mon,  8 Jul 2019 15:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599715;
        bh=+LiCpwHsjJSrbJyVIAOZQxJz3K+eHJCNVBkQ9T3ckGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jhLYGoNthqwYdqyQtKKyE2GLkaPJKSLgj4Jz3rON8qeKHXgVFS1cbFpfrMYcaiDi/
         ET/HSOM3s8ho2iCZu4PvaEa6FLloiNvOZIC/uI8BOb66Q8n1Oo7XGjSE48MgnSPY+V
         PQI5FdUo1nyFK8qFOPNu5tTF0qkCBMttASLUCM1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 4.19 54/90] arm64: kaslr: keep modules inside module region when KASAN is enabled
Date:   Mon,  8 Jul 2019 17:13:21 +0200
Message-Id: <20190708150525.232113672@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

commit 6f496a555d93db7a11d4860b9220d904822f586a upstream.

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

Cc: <stable@vger.kernel.org> # 4.9+
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/module.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -32,6 +32,7 @@
 
 void *module_alloc(unsigned long size)
 {
+	u64 module_alloc_end = module_alloc_base + MODULES_VSIZE;
 	gfp_t gfp_mask = GFP_KERNEL;
 	void *p;
 
@@ -39,9 +40,12 @@ void *module_alloc(unsigned long size)
 	if (IS_ENABLED(CONFIG_ARM64_MODULE_PLTS))
 		gfp_mask |= __GFP_NOWARN;
 
+	if (IS_ENABLED(CONFIG_KASAN))
+		/* don't exceed the static module region - see below */
+		module_alloc_end = MODULES_END;
+
 	p = __vmalloc_node_range(size, MODULE_ALIGN, module_alloc_base,
-				module_alloc_base + MODULES_VSIZE,
-				gfp_mask, PAGE_KERNEL_EXEC, 0,
+				module_alloc_end, gfp_mask, PAGE_KERNEL_EXEC, 0,
 				NUMA_NO_NODE, __builtin_return_address(0));
 
 	if (!p && IS_ENABLED(CONFIG_ARM64_MODULE_PLTS) &&


