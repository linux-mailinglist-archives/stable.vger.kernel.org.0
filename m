Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6342D12ECF3
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbgABWXd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:23:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:45896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728427AbgABWXc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:23:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D977F20866;
        Thu,  2 Jan 2020 22:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003812;
        bh=NTude421O7wRuk91q6VqmT4Lm56y8Mn+TAu/ykcgd0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gIoVgorpyHgnqpY4jcLbdy83+ybrzIdB4pVpfFUz6aUDPBkiFZww5gF/jnKzRTi9L
         ls3SirhQcX3U4MN8bgW05VZB8G3IVOE1Zsw1FQpR4jbowKJbQC/JyE5+qjV5t17AyO
         //IjmpI4QYsYAuHnw0w6vTj5Rnb4Mx7KvyQrAs1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 10/91] powerpc/pseries: Dont fail hash page table insert for bolted mapping
Date:   Thu,  2 Jan 2020 23:06:52 +0100
Message-Id: <20200102220409.314933080@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220356.856162165@linuxfoundation.org>
References: <20200102220356.856162165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

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
index 58c14749bb0c..cf1d76e03635 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -292,7 +292,14 @@ int htab_bolt_mapping(unsigned long vstart, unsigned long vend,
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



