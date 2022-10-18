Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A589F601FAB
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbiJRAh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbiJRAhm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:37:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B061CB3E;
        Mon, 17 Oct 2022 17:37:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04F82B81BFC;
        Tue, 18 Oct 2022 00:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29B6C43140;
        Tue, 18 Oct 2022 00:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051806;
        bh=eF1HCerYSQLmfVk0O1HCpkdY+DEyEI5og/haJCONFg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nz1AlDtAiW0TQluU20rb3v+bMrmio3g+hC+8rovfmYh1K/ruH51MVTwKikVIfgzL0
         68VHljFHpVnws+TxwHrRyOXZ2M+UhBDBsfnPS/6BHL5odA22NDsclsvD0lS93iDkv4
         qCBAFqkRk9KEmYtTCzLW/EZ6dpOU5nfBxYapQkyhdINZNCjO9rwi3vM2Ww14znJiTu
         O6GhVzTbCbrlOrK1uYfPxXgowuxLcAJwh43OfajWruuRstd6iyj4mcytoYw3DFYqTH
         qfW5+6pfKvqes0CCtZ+X/NES+qDuXMFysD73gWuC5kwKJg14BCwTM0+IY8o+H+uC+d
         vMJk6ZQB7emdw==
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
Subject: [PATCH AUTOSEL 5.15 14/21] x86/hyperv: Replace kmap() with kmap_local_page()
Date:   Mon, 17 Oct 2022 20:09:33 -0400
Message-Id: <20221018000940.2731329-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018000940.2731329-1-sashal@kernel.org>
References: <20221018000940.2731329-1-sashal@kernel.org>
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
index b6d48ca5b0f1..7c9288143943 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -407,13 +407,13 @@ void __init hyperv_init(void)
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

