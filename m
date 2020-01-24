Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F541147D5E
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730321AbgAXKAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:00:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:35412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730996AbgAXKAC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:00:02 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92E54222D9;
        Fri, 24 Jan 2020 10:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860001;
        bh=mTbh6VmwmnNbc300QdQdLNXtNUMN6hOQArGLLEUBuxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YpeL5JnpWq7dBbmV3Qy7ONDxoC/sFdOladWiZGFuDbMcbUvnVmjyzktrwuChhgHlb
         e3MlgINyXKjOj6VcEcAbyLLcA3qPoAit8yGE3wpYPpHcEUVd1BY0UEnvN97DAOefT6
         W+8EsTqoJpuEeHyG8Mx0HRO374pUGs0zyC8/52NI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 235/343] powerpc/pseries/mobility: rebuild cacheinfo hierarchy post-migration
Date:   Fri, 24 Jan 2020 10:30:53 +0100
Message-Id: <20200124092951.070935019@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit e610a466d16a086e321f0bd421e2fc75cff28605 ]

It's common for the platform to replace the cache device nodes after a
migration. Since the cacheinfo code is never informed about this, it
never drops its references to the source system's cache nodes, causing
it to wind up in an inconsistent state resulting in warnings and oopses
as soon as CPU online/offline occurs after the migration, e.g.

  cache for /cpus/l3-cache@3113(Unified) refers to cache for /cpus/l2-cache@200d(Unified)
  WARNING: CPU: 15 PID: 86 at arch/powerpc/kernel/cacheinfo.c:176 release_cache+0x1bc/0x1d0
  [...]
  NIP release_cache+0x1bc/0x1d0
  LR  release_cache+0x1b8/0x1d0
  Call Trace:
    release_cache+0x1b8/0x1d0 (unreliable)
    cacheinfo_cpu_offline+0x1c4/0x2c0
    unregister_cpu_online+0x1b8/0x260
    cpuhp_invoke_callback+0x114/0xf40
    cpuhp_thread_fun+0x270/0x310
    smpboot_thread_fn+0x2c8/0x390
    kthread+0x1b8/0x1c0
    ret_from_kernel_thread+0x5c/0x68

Using device tree notifiers won't work since we want to rebuild the
hierarchy only after all the removals and additions have occurred and
the device tree is in a consistent state. Call cacheinfo_teardown()
before processing device tree updates, and rebuild the hierarchy
afterward.

Fixes: 410bccf97881 ("powerpc/pseries: Partition migration in the kernel")
Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Reviewed-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/mobility.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/powerpc/platforms/pseries/mobility.c b/arch/powerpc/platforms/pseries/mobility.c
index 9739a055e5f7b..2d3668acb6ef5 100644
--- a/arch/powerpc/platforms/pseries/mobility.c
+++ b/arch/powerpc/platforms/pseries/mobility.c
@@ -23,6 +23,7 @@
 #include <asm/machdep.h>
 #include <asm/rtas.h>
 #include "pseries.h"
+#include "../../kernel/cacheinfo.h"
 
 static struct kobject *mobility_kobj;
 
@@ -359,11 +360,20 @@ void post_mobility_fixup(void)
 	 */
 	cpus_read_lock();
 
+	/*
+	 * It's common for the destination firmware to replace cache
+	 * nodes.  Release all of the cacheinfo hierarchy's references
+	 * before updating the device tree.
+	 */
+	cacheinfo_teardown();
+
 	rc = pseries_devicetree_update(MIGRATION_SCOPE);
 	if (rc)
 		printk(KERN_ERR "Post-mobility device tree update "
 			"failed: %d\n", rc);
 
+	cacheinfo_rebuild();
+
 	cpus_read_unlock();
 
 	/* Possibly switch to a new RFI flush type */
-- 
2.20.1



