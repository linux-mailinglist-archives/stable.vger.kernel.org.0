Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 697301861F1
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 03:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729944AbgCPCeq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 22:34:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729939AbgCPCeo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Mar 2020 22:34:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DE2A2073E;
        Mon, 16 Mar 2020 02:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584326084;
        bh=+Wrdt2IjNJU/+2f1OXPiWEBQi2rieRBad78UzbSNW1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JCSk/IgsalNh7v2ncI5MgijhkdyWDMZLzYnqSsZWwFBxmoS6+KvzoZ1i1ow0sfDAz
         /2abz+ajR0WzrJj8X/28LEThr1YxpSqUoMg2AhjegGWAkWJXhvut1BUcv/AaG0563X
         YuEiE8Uffj1cx1LI1N0UwHMXiUQWFpOj+5UE5jj0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Ghiti <alex@ghiti.fr>, Anup Patel <anup@brainfault.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 28/35] riscv: Fix range looking for kernel image memblock
Date:   Sun, 15 Mar 2020 22:34:04 -0400
Message-Id: <20200316023411.1263-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316023411.1263-1-sashal@kernel.org>
References: <20200316023411.1263-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Ghiti <alex@ghiti.fr>

[ Upstream commit a160eed4b783d7b250a32f7e5787c9867abc5686 ]

When looking for the memblock where the kernel lives, we should check
that the memory range associated to the memblock entirely comprises the
kernel image and not only intersects with it.

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 573463d1c799a..f5d813c1304da 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -98,7 +98,7 @@ void __init setup_bootmem(void)
 	for_each_memblock(memory, reg) {
 		phys_addr_t end = reg->base + reg->size;
 
-		if (reg->base <= vmlinux_end && vmlinux_end <= end) {
+		if (reg->base <= vmlinux_start && vmlinux_end <= end) {
 			mem_size = min(reg->size, (phys_addr_t)-PAGE_OFFSET);
 
 			/*
-- 
2.20.1

