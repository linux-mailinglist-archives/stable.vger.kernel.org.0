Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD1438344C
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239301AbhEQPHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:07:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:47750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242845AbhEQPEz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:04:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96C6561622;
        Mon, 17 May 2021 14:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261711;
        bh=aTRJM9PX6GuayuMjXAlg4d6sNsLrbWdta4625LtSnns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D/eXaPp1hoXDZ3sVFiK900maeiuDoKPpBonCsBRzswO8DHN4oLtr4oDUWNbAkC3O6
         i6w+ixhc3tkjXMM12bZxHxSR8isPalG9bPYx13Pt63hSK7wqTBxqPjjbbU1rgSiRlC
         uTkxDVhy72mhabe8+tUK8t9dMNSYNs0sWN5F8apQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Vaibhav Jain <vaibhav@linux.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 055/289] powerpc/mm: Add cond_resched() while removing hpte mappings
Date:   Mon, 17 May 2021 15:59:40 +0200
Message-Id: <20210517140307.056034393@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vaibhav Jain <vaibhav@linux.ibm.com>

[ Upstream commit a5d6a3e73acbd619dd5b7b831762b755f9e2db80 ]

While removing large number of mappings from hash page tables for
large memory systems as soft-lockup is reported because of the time
spent inside htap_remove_mapping() like one below:

 watchdog: BUG: soft lockup - CPU#8 stuck for 23s!
 <snip>
 NIP plpar_hcall+0x38/0x58
 LR  pSeries_lpar_hpte_invalidate+0x68/0xb0
 Call Trace:
  0x1fffffffffff000 (unreliable)
  pSeries_lpar_hpte_removebolted+0x9c/0x230
  hash__remove_section_mapping+0xec/0x1c0
  remove_section_mapping+0x28/0x3c
  arch_remove_memory+0xfc/0x150
  devm_memremap_pages_release+0x180/0x2f0
  devm_action_release+0x30/0x50
  release_nodes+0x28c/0x300
  device_release_driver_internal+0x16c/0x280
  unbind_store+0x124/0x170
  drv_attr_store+0x44/0x60
  sysfs_kf_write+0x64/0x90
  kernfs_fop_write+0x1b0/0x290
  __vfs_write+0x3c/0x70
  vfs_write+0xd4/0x270
  ksys_write+0xdc/0x130
  system_call+0x5c/0x70

Fix this by adding a cond_resched() to the loop in
htap_remove_mapping() that issues hcall to remove hpte mapping. The
call to cond_resched() is issued every HZ jiffies which should prevent
the soft-lockup from being reported.

Suggested-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210404163148.321346-1-vaibhav@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/book3s64/hash_utils.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/book3s64/hash_utils.c b/arch/powerpc/mm/book3s64/hash_utils.c
index 24702c0a92e0..0141d571476c 100644
--- a/arch/powerpc/mm/book3s64/hash_utils.c
+++ b/arch/powerpc/mm/book3s64/hash_utils.c
@@ -336,7 +336,7 @@ repeat:
 int htab_remove_mapping(unsigned long vstart, unsigned long vend,
 		      int psize, int ssize)
 {
-	unsigned long vaddr;
+	unsigned long vaddr, time_limit;
 	unsigned int step, shift;
 	int rc;
 	int ret = 0;
@@ -349,8 +349,19 @@ int htab_remove_mapping(unsigned long vstart, unsigned long vend,
 
 	/* Unmap the full range specificied */
 	vaddr = ALIGN_DOWN(vstart, step);
+	time_limit = jiffies + HZ;
+
 	for (;vaddr < vend; vaddr += step) {
 		rc = mmu_hash_ops.hpte_removebolted(vaddr, psize, ssize);
+
+		/*
+		 * For large number of mappings introduce a cond_resched()
+		 * to prevent softlockup warnings.
+		 */
+		if (time_after(jiffies, time_limit)) {
+			cond_resched();
+			time_limit = jiffies + HZ;
+		}
 		if (rc == -ENOENT) {
 			ret = -ENOENT;
 			continue;
-- 
2.30.2



