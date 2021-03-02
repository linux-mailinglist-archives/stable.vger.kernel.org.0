Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 105EB32B027
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238614AbhCCAcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:32:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:60554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351016AbhCBNDf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 08:03:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 573B964FB6;
        Tue,  2 Mar 2021 11:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686352;
        bh=ptzyW/0mmUSRWNhRFXDl/1PsK4UFMVMHL9x/cnNy9y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yd/bxH4/PxwKp7oGekkAaieh4OuW4AHbN4cwnh9HQX/2GwxLPuwWl1J91hAmwmKcH
         Orrng4ItZ2jN081tnB8DdoLEQj8yv7R9Wqs97BvQq03ZPZnT4K0/Mi6XnqgwEsGjXf
         HI9PvwDFhnDz07q3HgmDO/UYMyEPXS6RJvrx6WKNbc8zccEeoWnvMAI+kNbF7egfHy
         nX8wQjvJpMz5y+hmqrnJX+Tx1NWw9M1YlAeRHwM+2NVhXUuUpVXAOt6vOFlRQhyW79
         q7mlS5d8Db/Mx/ZJIK0vihcD+a56IDUBSP7l8IDvK2PuzgL8TNh8b3xwweRMSDA9+H
         H4PLoQalkGKAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Larsson <andreas@gaisler.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, sparclinux@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 06/13] sparc32: Limit memblock allocation to low memory
Date:   Tue,  2 Mar 2021 06:58:56 -0500
Message-Id: <20210302115903.63458-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115903.63458-1-sashal@kernel.org>
References: <20210302115903.63458-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Larsson <andreas@gaisler.com>

[ Upstream commit bda166930c37604ffa93f2425426af6921ec575a ]

Commit cca079ef8ac29a7c02192d2bad2ffe4c0c5ffdd0 changed sparc32 to use
memblocks instead of bootmem, but also made high memory available via
memblock allocation which does not work together with e.g. phys_to_virt
and can lead to kernel panic.

This changes back to only low memory being allocatable in the early
stages, now using memblock allocation.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/mm/init_32.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/sparc/mm/init_32.c b/arch/sparc/mm/init_32.c
index 95fe4f081ba3..372a4f08ddf8 100644
--- a/arch/sparc/mm/init_32.c
+++ b/arch/sparc/mm/init_32.c
@@ -230,6 +230,9 @@ unsigned long __init bootmem_init(unsigned long *pages_avail)
 	reserve_bootmem((bootmap_pfn << PAGE_SHIFT), size, BOOTMEM_DEFAULT);
 	*pages_avail -= PAGE_ALIGN(size) >> PAGE_SHIFT;
 
+	/* Only allow low memory to be allocated via memblock allocation */
+	memblock_set_current_limit(max_low_pfn << PAGE_SHIFT);
+
 	return max_pfn;
 }
 
-- 
2.30.1

