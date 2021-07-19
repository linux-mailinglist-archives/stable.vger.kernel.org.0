Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1705F3CE238
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347827AbhGSP3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:29:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348166AbhGSPYh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F1FD60FDA;
        Mon, 19 Jul 2021 16:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710556;
        bh=vSVAZJAf9NUT16t6rsVFqUNTQln4OjKyDGN+FG2NMHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mWMQrCWWXCryrU2DHkgqHwbbfU+pBxT82nTaAnVPqcmkXcSJE00CLG77kPosB6Y8w
         GkBPiDHJ+o6S1NMcZIYxr5E771dlbB5k+Q4nWsFnZg8swoznFB6K8PSTIOuQ+CYtGl
         lCCE/smPeU88iUefmY+RvN6sMpmNcygNA8hWPH98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
        vkuznets@redhat.com, wanghaibin.wang@huawei.com,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 5.13 005/351] KVM: selftests: do not require 64GB in set_memory_region_test
Date:   Mon, 19 Jul 2021 16:49:11 +0200
Message-Id: <20210719144944.712904163@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

commit cd4220d23bf3f43cf720e82bdee681f383433ae2 upstream.

Unless the user sets overcommit_memory or has plenty of swap, the latest
changes to the testcase will result in ENOMEM failures for hosts with
less than 64GB RAM. As we do not use much of the allocated memory, we
can use MAP_NORESERVE to avoid this error.

Cc: Zenghui Yu <yuzenghui@huawei.com>
Cc: vkuznets@redhat.com
Cc: wanghaibin.wang@huawei.com
Cc: stable@vger.kernel.org
Fixes: 309505dd5685 ("KVM: selftests: Fix mapping length truncation in m{,un}map()")
Tested-by: Zenghui Yu <yuzenghui@huawei.com>
Link: https://lore.kernel.org/kvm/20210701160425.33666-1-borntraeger@de.ibm.com/
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/kvm/set_memory_region_test.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index d8812f27648c..d31f54ac4e98 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -377,7 +377,8 @@ static void test_add_max_memory_regions(void)
 		(max_mem_slots - 1), MEM_REGION_SIZE >> 10);
 
 	mem = mmap(NULL, (size_t)max_mem_slots * MEM_REGION_SIZE + alignment,
-		   PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+		   PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
 	TEST_ASSERT(mem != MAP_FAILED, "Failed to mmap() host");
 	mem_aligned = (void *)(((size_t) mem + alignment - 1) & ~(alignment - 1));
 
-- 
2.32.0



