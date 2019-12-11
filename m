Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87E4511B2C2
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733114AbfLKPiG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:38:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:44200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388117AbfLKPfU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:35:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A899F2173E;
        Wed, 11 Dec 2019 15:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078520;
        bh=fEqdX+7S7tkDo7Pq70+Qc8Hu7erKpC+qHRMyteevV7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZsL0gyIy5sS/PKABW9Kx+5OtrBnNbKTpN93BCCsoODR11d8HmY1E0yyFZ4XLb8H7F
         cVyRILI85DdF/LEjw6VfXkaRxu9dM8dXN2j19Kt/w4GiAK+HX+8Lv/0FlX0f+9r4il
         LxbZ33Tt9ELNQtexKJM/H50mB6NOo3dvTsOD+Zuo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.9 09/42] powerpc/pseries: Don't fail hash page table insert for bolted mapping
Date:   Wed, 11 Dec 2019 10:34:37 -0500
Message-Id: <20191211153510.23861-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211153510.23861-1-sashal@kernel.org>
References: <20191211153510.23861-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>

[ Upstream commit 75838a3290cd4ebbd1f567f310ba04b6ef017ce4 ]

If the hypervisor returned H_PTEG_FULL for H_ENTER hcall, retry a hash page table
insert by removing a random entry from the group.

After some runtime, it is very well possible to find all the 8 hash page table
entry slot in the hpte group used for mapping. Don't fail a bolted entry insert
in that case. With Storage class memory a user can find this error easily since
a namespace enable/disable is equivalent to memory add/remove.

This results in failures as reported below:

$ ndctl create-namespace -r region1 -t pmem -m devdax -a 65536 -s 100M
libndctl: ndctl_dax_enable: dax1.3: failed to enable
  Error: namespace1.2: failed to enable

failed to create namespace: No such device or address

In kernel log we find the details as below:

Unable to create mapping for hot added memory 0xc000042006000000..0xc00004200d000000: -1
dax_pmem: probe of dax1.3 failed with error -14

This indicates that we failed to create a bolted hash table entry for direct-map
address backing the namespace.

We also observe failures such that not all namespaces will be enabled with
ndctl enable-namespace all command.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191024093542.29777-2-aneesh.kumar@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/hash_utils_64.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
index bd666287c5eda..de1d8cdd29915 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -289,7 +289,14 @@ int htab_bolt_mapping(unsigned long vstart, unsigned long vend,
 		ret = mmu_hash_ops.hpte_insert(hpteg, vpn, paddr, tprot,
 					       HPTE_V_BOLTED, psize, psize,
 					       ssize);
-
+		if (ret == -1) {
+			/* Try to remove a non bolted entry */
+			ret = mmu_hash_ops.hpte_remove(hpteg);
+			if (ret != -1)
+				ret = mmu_hash_ops.hpte_insert(hpteg, vpn, paddr, tprot,
+							       HPTE_V_BOLTED, psize, psize,
+							       ssize);
+		}
 		if (ret < 0)
 			break;
 
-- 
2.20.1

