Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5169545E634
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 04:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358869AbhKZCuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:50:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:51032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352559AbhKZCqM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:46:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE4096135F;
        Fri, 26 Nov 2021 02:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894206;
        bh=j1J/Be+AtqWEmIy3RZBDchghsQ1lLnJrU1m/FQSV4oc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gmDxnkfnHL86ysdKnkyBVstgUh0X8gioWlcPiVM3Od0rbpWOD6P4k1jHGMv6SEheU
         S2sZSJeOEcoyzR6ozqKi1xV4Kjl348hK6ak5ftoxvzZmcoAjYA2HG2KaW/LM+BYmnn
         Rg0i4FuAhu6fpsfFz33XziZV2QEk2eynom/0uYCK54XmmSTZg4gGLMOaiPolC9FMh+
         MaPWi4OtM8cYEhlL0Zztn0dX+reLT5KDikrUqo7ztEo6w/TZQOnGWW9F3fRH+8tiKT
         C5Tb3iF//Aux3qm60b5eUoNy+VlfOTkDr7hQpUfYatKYz/pqp1JY+zh6O1L1qoFcg9
         4uGlmRCSXbjZw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, borntraeger@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com,
        egorenar@linux.ibm.com, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 3/8] s390/setup: avoid using memblock_enforce_memory_limit
Date:   Thu, 25 Nov 2021 21:36:35 -0500
Message-Id: <20211126023640.443271-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023640.443271-1-sashal@kernel.org>
References: <20211126023640.443271-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 5dbc4cb4667457b0c53bcd7bff11500b3c362975 ]

There is a difference in how architectures treat "mem=" option. For some
that is an amount of online memory, for s390 and x86 this is the limiting
max address. Some memblock api like memblock_enforce_memory_limit()
take limit argument and explicitly treat it as the size of online memory,
and use __find_max_addr to convert it to an actual max address. Current
s390 usage:

memblock_enforce_memory_limit(memblock_end_of_DRAM());

yields different results depending on presence of memory holes (offline
memory blocks in between online memory). If there are no memory holes
limit == max_addr in memblock_enforce_memory_limit() and it does trim
online memory and reserved memory regions. With memory holes present it
actually does nothing.

Since we already use memblock_remove() explicitly to trim online memory
regions to potential limit (think mem=, kdump, addressing limits, etc.)
drop the usage of memblock_enforce_memory_limit() altogether. Trimming
reserved regions should not be required, since we now use
memblock_set_current_limit() to limit allocations and any explicit memory
reservations above the limit is an actual problem we should not hide.

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/setup.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 9939879f5f253..2f3b7802d8b87 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -693,9 +693,6 @@ static void __init setup_memory(void)
 		storage_key_init_range(reg->base, reg->base + reg->size);
 	}
 	psw_set_key(PAGE_DEFAULT_KEY);
-
-	/* Only cosmetics */
-	memblock_enforce_memory_limit(memblock_end_of_DRAM());
 }
 
 /*
-- 
2.33.0

