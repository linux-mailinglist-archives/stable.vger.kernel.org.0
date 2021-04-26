Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C158C36AEBD
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbhDZHqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:46:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234292AbhDZHpG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:45:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67315613FF;
        Mon, 26 Apr 2021 07:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422931;
        bh=u70HHnX1guswWqpHM6QDKDJVZ8xKtECfDyb/9SIhUJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zJVTaxb24XXqUu1diSd0ZIghHeSDqT9KvCUJUwAsK5wtO0G6k6zxF29a8+fDNMZho
         zFYqKqLJvAHPVfTu3SJ8UwXRgCZLHaufKJROpjZNZbC9GkWRdzauv8aCx3nb2KmNeK
         7RaGimgvM7V7xQwiDqUvM678+sKKCTV2RogPRUA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Angelo Dureghello <angelo@kernel-space.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 31/41] m68k: fix flatmem memory model setup
Date:   Mon, 26 Apr 2021 09:30:18 +0200
Message-Id: <20210426072820.748721386@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072819.666570770@linuxfoundation.org>
References: <20210426072819.666570770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Angelo Dureghello <angelo@kernel-space.org>

[ Upstream commit d2bd44c4c05d043fb65cfdf26c54e6d8b94a4b41 ]

Detected a broken boot on mcf54415, likely introduced from

commit 4bfc848e0981
("m68k/mm: enable use of generic memory_model.h for !DISCONTIGMEM")

Fix ARCH_PFN_OFFSET to be a pfn.

Signed-off-by: Angelo Dureghello <angelo@kernel-space.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Greg Ungerer <gerg@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/include/asm/page_mm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/m68k/include/asm/page_mm.h b/arch/m68k/include/asm/page_mm.h
index 7f5912af2a52..21b1071e0a34 100644
--- a/arch/m68k/include/asm/page_mm.h
+++ b/arch/m68k/include/asm/page_mm.h
@@ -167,7 +167,7 @@ static inline __attribute_const__ int __virt_to_node_shift(void)
 	((__p) - pgdat->node_mem_map) + pgdat->node_start_pfn;		\
 })
 #else
-#define ARCH_PFN_OFFSET (m68k_memory[0].addr)
+#define ARCH_PFN_OFFSET (m68k_memory[0].addr >> PAGE_SHIFT)
 #include <asm-generic/memory_model.h>
 #endif
 
-- 
2.30.2



