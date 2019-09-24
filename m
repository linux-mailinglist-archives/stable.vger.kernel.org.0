Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B41EFBCDE7
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 18:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387659AbfIXQrT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:47:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410356AbfIXQrS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:47:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2592920673;
        Tue, 24 Sep 2019 16:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343637;
        bh=ZrLi2JF1gXBIO8UjLt7eus8vyU6RSKJMJP9EwGTXIH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCPnrbmemEN5ZURH77DR2omWFUNT57giK8n1HxFkt/pX666pZDcXo8mrmMxVmsLym
         QTRlzPJZAp+RjWITIII3/qoZsG0YpchRwiqZumK8byxqGWyg3KMzNDA/sVYNsgHjah
         0Bj6+8ygXGT6Xc7+nftcl/6QETu9cJPPOxI0fBrc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.2 36/70] powerpc/64s/radix: Fix memory hotplug section page table creation
Date:   Tue, 24 Sep 2019 12:45:15 -0400
Message-Id: <20190924164549.27058-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164549.27058-1-sashal@kernel.org>
References: <20190924164549.27058-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 8f51e3929470942e6a8744061254fdeef646cd36 ]

create_physical_mapping expects physical addresses, but creating and
splitting these mappings after boot is supplying virtual (effective)
addresses. This can be irritated by booting with mem= to limit memory
then probing an unused physical memory range:

  echo <addr> > /sys/devices/system/memory/probe

This mostly works by accident, firstly because __va(__va(x)) == __va(x)
so the virtual address does not get corrupted. Secondly because pfn_pte
masks out the upper bits of the pfn beyond the physical address limit,
so a pfn constructed with a 0xc000000000000000 virtual linear address
will be masked back to the correct physical address in the pte.

Fixes: 6cc27341b21a8 ("powerpc/mm: add radix__create_section_mapping()")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190724084638.24982-1-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/book3s64/radix_pgtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 8deb432c29754..2b6cc823046a3 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -901,7 +901,7 @@ int __meminit radix__create_section_mapping(unsigned long start, unsigned long e
 		return -1;
 	}
 
-	return create_physical_mapping(start, end, nid);
+	return create_physical_mapping(__pa(start), __pa(end), nid);
 }
 
 int __meminit radix__remove_section_mapping(unsigned long start, unsigned long end)
-- 
2.20.1

