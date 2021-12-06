Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464FB469A6A
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346833AbhLFPHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:07:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346322AbhLFPGR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:06:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363FEC0698E4;
        Mon,  6 Dec 2021 07:02:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7E0661316;
        Mon,  6 Dec 2021 15:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE7DC341C1;
        Mon,  6 Dec 2021 15:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638802966;
        bh=j1J/Be+AtqWEmIy3RZBDchghsQ1lLnJrU1m/FQSV4oc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VSn9XyjvcBhLBsnF+PLF698holbJCN9xBg+n7CAAuEx9UcNj7SxU5uCA0PGJeQ7x+
         cmXnE4x6Qx9AyKy5ndGZDNkhVl4QKXq3M1yuyXujJsVAh8OgAYqNPI4eVaPcGrYJuy
         dupzbb7a+QBFAe2dObAPUSZ/dQ0U1rTCcyTZN/fM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 42/62] s390/setup: avoid using memblock_enforce_memory_limit
Date:   Mon,  6 Dec 2021 15:56:25 +0100
Message-Id: <20211206145550.660609848@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145549.155163074@linuxfoundation.org>
References: <20211206145549.155163074@linuxfoundation.org>
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



