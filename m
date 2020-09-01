Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551B12599EE
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730070AbgIAQpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:45:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730195AbgIAP1Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:27:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F36420684;
        Tue,  1 Sep 2020 15:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974045;
        bh=w+CCad3qJGbJT8Ndl3AfagyrBeavJyGH/yTjj8xmuA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M1qDALxjO/T2F55DXWs2NJrHe1BF6s3EZHHVN2oUD1wwUmFgBOV1VXo/PlX2px6Cg
         pst4N1r3eSAuKpL/wcPu2B5GfO9kNPS/HUAni5HVIAzv3PG3gRCV1ArfdEJlsT7xxY
         O9gR8Ih7pGq+COQeS0OZA+w/kt17ZAQ57jh8Y/dg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 022/214] powerpc/xive: Ignore kmemleak false positives
Date:   Tue,  1 Sep 2020 17:08:22 +0200
Message-Id: <20200901150954.031909019@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

[ Upstream commit f0993c839e95dd6c7f054a1015e693c87e33e4fb ]

xive_native_provision_pages() allocates memory and passes the pointer to
OPAL so kmemleak cannot find the pointer usage in the kernel memory and
produces a false positive report (below) (even if the kernel did scan
OPAL memory, it is unable to deal with __pa() addresses anyway).

This silences the warning.

unreferenced object 0xc000200350c40000 (size 65536):
  comm "qemu-system-ppc", pid 2725, jiffies 4294946414 (age 70776.530s)
  hex dump (first 32 bytes):
    02 00 00 00 50 00 00 00 00 00 00 00 00 00 00 00  ....P...........
    01 00 08 07 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000081ff046c>] xive_native_alloc_vp_block+0x120/0x250
    [<00000000d555d524>] kvmppc_xive_compute_vp_id+0x248/0x350 [kvm]
    [<00000000d69b9c9f>] kvmppc_xive_connect_vcpu+0xc0/0x520 [kvm]
    [<000000006acbc81c>] kvm_arch_vcpu_ioctl+0x308/0x580 [kvm]
    [<0000000089c69580>] kvm_vcpu_ioctl+0x19c/0xae0 [kvm]
    [<00000000902ae91e>] ksys_ioctl+0x184/0x1b0
    [<00000000f3e68bd7>] sys_ioctl+0x48/0xb0
    [<0000000001b2c127>] system_call_exception+0x124/0x1f0
    [<00000000d2b2ee40>] system_call_common+0xe8/0x214

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200612043303.84894-1-aik@ozlabs.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/xive/native.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/sysdev/xive/native.c b/arch/powerpc/sysdev/xive/native.c
index 50e1a8e02497d..3fd086533dcfc 100644
--- a/arch/powerpc/sysdev/xive/native.c
+++ b/arch/powerpc/sysdev/xive/native.c
@@ -18,6 +18,7 @@
 #include <linux/delay.h>
 #include <linux/cpumask.h>
 #include <linux/mm.h>
+#include <linux/kmemleak.h>
 
 #include <asm/prom.h>
 #include <asm/io.h>
@@ -646,6 +647,7 @@ static bool xive_native_provision_pages(void)
 			pr_err("Failed to allocate provisioning page\n");
 			return false;
 		}
+		kmemleak_ignore(p);
 		opal_xive_donate_page(chip, __pa(p));
 	}
 	return true;
-- 
2.25.1



