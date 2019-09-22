Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F270BA5C7
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389332AbfIVSpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:45:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:41180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389320AbfIVSpc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:45:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 130FE206C2;
        Sun, 22 Sep 2019 18:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569177931;
        bh=/U8E39KaJHPuCt55oqs9aksyUmQx9j4P9V5W2MqI1Vw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LZbwd8I6iIvnkwexRsYzR5p8va2+X5uX37rsth1/vBiLR5kYsk4R3PlNnb61FDYRX
         g31A+fSETvK2bPtkod1C4QOmZNZ79zMJcdGeqrBEXRZMEiUSfGvMlSrcJDVlNPivTu
         TrePFY29v/Mb3vXYxMW2nGQ40wbewpQHDTZLeFFk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Junhua Huang <huang.junhua@zte.com.cn>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 042/203] arm64: mm: free the initrd reserved memblock in a aligned manner
Date:   Sun, 22 Sep 2019 14:41:08 -0400
Message-Id: <20190922184350.30563-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junhua Huang <huang.junhua@zte.com.cn>

[ Upstream commit 13776f9d40a028a245bb766269e360f5b7a62721 ]

We should free the initrd reserved memblock in an aligned manner,
because the initrd reserves the memblock in an aligned manner
in arm64_memblock_init().
Otherwise there are some fragments in memblock_reserved regions
after free_initrd_mem(). e.g.:
/sys/kernel/debug/memblock # cat reserved
   0: 0x0000000080080000..0x00000000817fafff
   1: 0x0000000083400000..0x0000000083ffffff
   2: 0x0000000090000000..0x000000009000407f
   3: 0x00000000b0000000..0x00000000b000003f
   4: 0x00000000b26184ea..0x00000000b2618fff
The fragments like the ranges from b0000000 to b000003f and
from b26184ea to b2618fff should be freed.

And we can do free_reserved_area() after memblock_free(),
as free_reserved_area() calls __free_pages(), once we've done
that it could be allocated somewhere else,
but memblock and iomem still say this is reserved memory.

Fixes: 05c58752f9dc ("arm64: To remove initrd reserved area entry from memblock")
Signed-off-by: Junhua Huang <huang.junhua@zte.com.cn>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/init.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index f3c795278def0..b1ee6cb4b17fc 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -570,8 +570,12 @@ void free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void __init free_initrd_mem(unsigned long start, unsigned long end)
 {
+	unsigned long aligned_start, aligned_end;
+
+	aligned_start = __virt_to_phys(start) & PAGE_MASK;
+	aligned_end = PAGE_ALIGN(__virt_to_phys(end));
+	memblock_free(aligned_start, aligned_end - aligned_start);
 	free_reserved_area((void *)start, (void *)end, 0, "initrd");
-	memblock_free(__virt_to_phys(start), end - start);
 }
 #endif
 
-- 
2.20.1

