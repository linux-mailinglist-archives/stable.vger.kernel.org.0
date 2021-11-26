Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFEF45E5B7
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 04:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358545AbhKZCoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:44:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:50034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357798AbhKZCmL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:42:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BACD61157;
        Fri, 26 Nov 2021 02:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894106;
        bh=cCKOnF1J9lGvvt+vd6E2ZT5Fps/Grrz8rJbM4Wj70cE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pievkG9sSMofFLfTlDkW9rbugm5N0H19wXZ1Kd8UnbaEdrnD1KPB5KNawXa2cUrfA
         1zw+zABXeNl/EF53Yi5A+Utm6pE6brfXEhV9InnOpM8Sr1EDZj/wHsfSTdn3BtnUGx
         UZPWBsLzACWKfjoH8OlK0oK/hG5HBL6VHPJ3OdN5CRLhGuw+u+JK093T3rRIaxneL8
         q3O9wk4AdSQsgu0TEOp20mo4GycE4oVMep0InPBMUeQBry/dGjJU9+CEIhnn4Sc1Pv
         0wbnK2ABWWTY4yk1jpCbfltPnmSooQZ/w9LhLHgk18n1nYLdiiaBBSvU7J9Gng+0bV
         j+lROwMt3Nbiw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, borntraeger@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com,
        egorenar@linux.ibm.com, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 10/19] s390/setup: avoid using memblock_enforce_memory_limit
Date:   Thu, 25 Nov 2021 21:34:39 -0500
Message-Id: <20211126023448.442529-10-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023448.442529-1-sashal@kernel.org>
References: <20211126023448.442529-1-sashal@kernel.org>
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
index f661f176966f5..9a0316a067a11 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -841,9 +841,6 @@ static void __init setup_memory(void)
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

