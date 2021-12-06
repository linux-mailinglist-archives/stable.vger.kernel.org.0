Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5368469B8D
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347856AbhLFPRu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:17:50 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35098 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346843AbhLFPPT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:15:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FFC861329;
        Mon,  6 Dec 2021 15:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72AF5C341C5;
        Mon,  6 Dec 2021 15:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803491;
        bh=cCKOnF1J9lGvvt+vd6E2ZT5Fps/Grrz8rJbM4Wj70cE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fzYmxdm4JwKDL51ppFD8ehnOftmn1+uY5hn1ICQapvWh8Enm3SBPy2Uozx79Z+IiG
         c+AZgGpfyHBFG3Pp2o0dtPzuma8fS9IM0COnS8dag2sISV5WKH2ZJWIz55fMTyfmmd
         V7ImqzMRtZRFV00wXe6oIbgZo69kHNwB30sJSrLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 12/70] s390/setup: avoid using memblock_enforce_memory_limit
Date:   Mon,  6 Dec 2021 15:56:16 +0100
Message-Id: <20211206145552.325802398@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145551.909846023@linuxfoundation.org>
References: <20211206145551.909846023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



