Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76EA3601E58
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiJRAJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbiJRAIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:08:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0F287FB8;
        Mon, 17 Oct 2022 17:08:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C79661302;
        Tue, 18 Oct 2022 00:08:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2F3C433D6;
        Tue, 18 Oct 2022 00:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051690;
        bh=cHle/rKV0zuFV5/oUsPF+6blyk2FbZRXAyUsGqr80Ts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e2huqvdq2wO6sQBm/EZQmUpZIoz6lR/eyWwb0Yp+eOVqFFTQkCzoID/taeL3hXhDg
         FJ4F8zm7o5HIfEmrCPaHxSxo9seywBkHd9IMywfqyNObeXjR7wOfW+hHlzO7jfI+Af
         FyApJkfikCSZbU8XVG9caTsNMoNFPu/S8MCWYPZCh5X0pSyBPNgYol4SpN4c1tS8iC
         tR0SDO/DVqai8ruOPCMGzqfJ6LGQguiv3BTWHx37Bh2MnggYItPO+LGxNEUEQq9VlO
         YyJZzwk0rHn//5KRVCS8tUYQ+j/JyJfqgsdyzzv/LwsKvIeZi6236VaUbHNUAhWGpV
         4K4mxWLN01Klw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhao Liu <zhao1.liu@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 21/32] x86/hyperv: Replace kmap() with kmap_local_page()
Date:   Mon, 17 Oct 2022 20:07:18 -0400
Message-Id: <20221018000729.2730519-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018000729.2730519-1-sashal@kernel.org>
References: <20221018000729.2730519-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhao Liu <zhao1.liu@intel.com>

[ Upstream commit 154fb14df7a3c81dea82eca7c0c46590f5ffc3d2 ]

kmap() is being deprecated in favor of kmap_local_page()[1].

There are two main problems with kmap(): (1) It comes with an overhead as
mapping space is restricted and protected by a global lock for
synchronization and (2) it also requires global TLB invalidation when the
kmap's pool wraps and it might block when the mapping space is fully
utilized until a slot becomes available.

With kmap_local_page() the mappings are per thread, CPU local, can take
page faults, and can be called from any context (including interrupts).
It is faster than kmap() in kernels with HIGHMEM enabled. Furthermore,
the tasks can be preempted and, when they are scheduled to run again, the
kernel virtual addresses are restored and are still valid.

In the fuction hyperv_init() of hyperv/hv_init.c, the mapping is used in a
single thread and is short live. So, in this case, it's safe to simply use
kmap_local_page() to create mapping, and this avoids the wasted cost of
kmap() for global synchronization.

In addtion, the fuction hyperv_init() checks if kmap() fails by BUG_ON().
From the original discussion[2], the BUG_ON() here is just used to
explicitly panic NULL pointer. So still keep the BUG_ON() in place to check
if kmap_local_page() fails. Based on this consideration, memcpy_to_page()
is not selected here but only kmap_local_page() is used.

Therefore, replace kmap() with kmap_local_page() in hyperv/hv_init.c.

[1]: https://lore.kernel.org/all/20220813220034.806698-1-ira.weiny@intel.com
[2]: https://lore.kernel.org/lkml/20200915103710.cqmdvzh5lys4wsqo@liuwe-devbox-debian-v2/

Suggested-by: Dave Hansen <dave.hansen@intel.com>
Suggested-by: Ira Weiny <ira.weiny@intel.com>
Suggested-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Link: https://lore.kernel.org/r/20220928095640.626350-1-zhao1.liu@linux.intel.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/hyperv/hv_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index 3de6d8b53367..72fe46eb183f 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -459,13 +459,13 @@ void __init hyperv_init(void)
 		wrmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
 
 		pg = vmalloc_to_page(hv_hypercall_pg);
-		dst = kmap(pg);
+		dst = kmap_local_page(pg);
 		src = memremap(hypercall_msr.guest_physical_address << PAGE_SHIFT, PAGE_SIZE,
 				MEMREMAP_WB);
 		BUG_ON(!(src && dst));
 		memcpy(dst, src, HV_HYP_PAGE_SIZE);
 		memunmap(src);
-		kunmap(pg);
+		kunmap_local(dst);
 	} else {
 		hypercall_msr.guest_physical_address = vmalloc_to_pfn(hv_hypercall_pg);
 		wrmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
-- 
2.35.1

