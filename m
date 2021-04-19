Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C50364B69
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 22:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242229AbhDSUo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 16:44:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242324AbhDSUo2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 16:44:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9CA0613C2;
        Mon, 19 Apr 2021 20:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865038;
        bh=u70HHnX1guswWqpHM6QDKDJVZ8xKtECfDyb/9SIhUJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=byUsYtqXlH5l+BX369F6c66vmV5tDdv+ovRWkw3L0D0VwgjmnR3sisOXB9kJ+CjN0
         U4U4BaBza33KwIc4c3dGQkjStdWbofQSz6LN/9H8A9G7tz9WIwogeiuDBjwVOyilzd
         aeiDX+jxbyE27iY284Wb8wrbsAEYTBhnjx+zu8yrgATTdFyIHLZje/unIXrBEPtXgX
         G28DPW82Zjuojw/YepNMSP9qKAWciOW+kdg5tutuFxpRQWfrIBzLPGVwVVmVDUYwAL
         O/Qhf4REiAk74BnnbQDgfs+YVO31FYaFm4K3gWdUaw+BbnvjNyE8OOOI1UsSmh5UDz
         79cCuwYwgRpJQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Angelo Dureghello <angelo@kernel-space.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-m68k@lists.linux-m68k.org
Subject: [PATCH AUTOSEL 5.11 10/23] m68k: fix flatmem memory model setup
Date:   Mon, 19 Apr 2021 16:43:29 -0400
Message-Id: <20210419204343.6134-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204343.6134-1-sashal@kernel.org>
References: <20210419204343.6134-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

