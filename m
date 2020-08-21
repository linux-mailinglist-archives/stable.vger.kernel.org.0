Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E01624DE49
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgHUR2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:28:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727008AbgHUQOo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:14:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D43222B47;
        Fri, 21 Aug 2020 16:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026479;
        bh=+kj9s/5ZqlyNsnM52p3naaPPs/OU12x7yQGwDwRDM5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X0QRBfCex3UjWr4vHs6U6MYytIvohPYar/AgCcHqIKeiDiUfdTRiUMFJMFrdUxUjs
         mFiAP0O4yE16HmGPyf6hR+TTzaAvEKOIfWjbtGTFGlTASUGIBDJ+YLxarFpZnT74y5
         TZCAwj0ADu96aA/8HQqJcNNx3wPs3x5zIahORu8w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.8 12/62] powerpc/xive: Ignore kmemleak false positives
Date:   Fri, 21 Aug 2020 12:13:33 -0400
Message-Id: <20200821161423.347071-12-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161423.347071-1-sashal@kernel.org>
References: <20200821161423.347071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 71b881e554fcb..cb58ec7ce77ac 100644
--- a/arch/powerpc/sysdev/xive/native.c
+++ b/arch/powerpc/sysdev/xive/native.c
@@ -18,6 +18,7 @@
 #include <linux/delay.h>
 #include <linux/cpumask.h>
 #include <linux/mm.h>
+#include <linux/kmemleak.h>
 
 #include <asm/machdep.h>
 #include <asm/prom.h>
@@ -647,6 +648,7 @@ static bool xive_native_provision_pages(void)
 			pr_err("Failed to allocate provisioning page\n");
 			return false;
 		}
+		kmemleak_ignore(p);
 		opal_xive_donate_page(chip, __pa(p));
 	}
 	return true;
-- 
2.25.1

