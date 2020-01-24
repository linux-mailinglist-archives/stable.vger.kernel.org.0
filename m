Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 826D614829D
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391782AbgAXL32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:29:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:46264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391600AbgAXL30 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:29:26 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 765A520718;
        Fri, 24 Jan 2020 11:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865365;
        bh=U2PLpoci/yUhxT8jIEH2WLn6BfW0CI6w1iFzQdGslHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nyyv+G511jiv7n4OX1gbalvCzTlvdx+/VDarA4DAc3YFl81DDXzgz1RgmuyorNZFJ
         rh+JZYOWYBeE1xtcceG8bMS/kQ+Zv1FHo3oHKe5v7OrCxfHPHLbntXUz71qA6oPUhn
         cRVux+iRananHLMHYvpL1003r4gAiSqjif7f6y/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 513/639] powerpc/64s/radix: Fix memory hot-unplug page table split
Date:   Fri, 24 Jan 2020 10:31:23 +0100
Message-Id: <20200124093153.071642943@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 31f210cf42d4b308eacef89b6cb0b1459338b8de ]

create_physical_mapping expects physical addresses, but splitting
these mapping on hot unplug is supplying virtual (effective)
addresses.

Fixes: 4dd5f8a99e791 ("powerpc/mm/radix: Split linear mapping on hot-unplug")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190724084638.24982-2-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/pgtable-radix.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/mm/pgtable-radix.c b/arch/powerpc/mm/pgtable-radix.c
index 69caeb5bccb21..5404a631d5834 100644
--- a/arch/powerpc/mm/pgtable-radix.c
+++ b/arch/powerpc/mm/pgtable-radix.c
@@ -717,8 +717,8 @@ static int __meminit stop_machine_change_mapping(void *data)
 
 	spin_unlock(&init_mm.page_table_lock);
 	pte_clear(&init_mm, params->aligned_start, params->pte);
-	create_physical_mapping(params->aligned_start, params->start, -1);
-	create_physical_mapping(params->end, params->aligned_end, -1);
+	create_physical_mapping(__pa(params->aligned_start), __pa(params->start), -1);
+	create_physical_mapping(__pa(params->end), __pa(params->aligned_end), -1);
 	spin_lock(&init_mm.page_table_lock);
 	return 0;
 }
-- 
2.20.1



