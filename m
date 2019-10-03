Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30235CAA58
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390461AbfJCRDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:03:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405051AbfJCQle (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:41:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 027EA2054F;
        Thu,  3 Oct 2019 16:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120894;
        bh=/U8E39KaJHPuCt55oqs9aksyUmQx9j4P9V5W2MqI1Vw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aAemkEjtUuq4e6OYXJguy3dXLrUcAgY7TX81EUrZPwZsQX4wG5TlQHJO9OdOIvLTf
         1udmBbjf4412aTbMTu+Yh8f0XddlMfDWYfieA+Rvj8BP/X2szjCTZL7+kbu1/TyfPy
         I0Aogo+0YMDebOi94L0BojNlothWWt0ZhD+iTsXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junhua Huang <huang.junhua@zte.com.cn>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 078/344] arm64: mm: free the initrd reserved memblock in a aligned manner
Date:   Thu,  3 Oct 2019 17:50:43 +0200
Message-Id: <20191003154547.849626206@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



