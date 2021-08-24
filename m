Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12793F6462
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238580AbhHXRDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:03:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239084AbhHXRBi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:01:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B34446140B;
        Tue, 24 Aug 2021 16:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824284;
        bh=pP6bmhH3tT/9yS0Lw3n8AP5dHpZMt8HdRW2hU46QoyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xd/k0KFZ9eC+xre8R5sNpWudrj68D+wuBuEzvZFPl9R92Y9++LlYdVmJ+gQjxWmfs
         OTQdUk5I+Z6FiZAlH2MPlbS7xCYVJMFinnowGQ6ZIGPZ5jls/BHP9cAhRf+MLxC6VX
         KoQoWqIv4fqKbvzyW6pP8fWBF/zasybK722DhcmoOfeLqhFafu9aQzPbvsqwbS6R2J
         4cCaYVqloExCp8D+eS2RHudnqLSgmbof/DMTTPmwjCXpIjdE0CyuUJPkWQqp97FRHj
         60zJsvkzS1tb6hrYjTTGdMM5huyA019MXRn+WiTtM2x5mbUlMoV/k7kmtyQzA4ALdi
         87eUJJmfl3B8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petr Pavlu <petr.pavlu@suse.com>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Nick Kossifidis <mick@ics.forth.gr>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 119/127] riscv: Fix a number of free'd resources in init_resources()
Date:   Tue, 24 Aug 2021 12:55:59 -0400
Message-Id: <20210824165607.709387-120-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Pavlu <petr.pavlu@suse.com>

[ Upstream commit aa3e1ba32e553e611a58145c2eb349802feaa6eb ]

Function init_resources() allocates a boot memory block to hold an array of
resources which it adds to iomem_resource. The array is filled in from its
end and the function then attempts to free any unused memory at the
beginning. The problem is that size of the unused memory is incorrectly
calculated and this can result in releasing memory which is in use by
active resources. Their data then gets corrupted later when the memory is
reused by a different part of the system.

Fix the size of the released memory to correctly match the number of unused
resource entries.

Fixes: ffe0e5261268 ("RISC-V: Improve init_resources()")
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Reviewed-by: Sunil V L <sunilvl@ventanamicro.com>
Acked-by: Nick Kossifidis <mick@ics.forth.gr>
Tested-by: Sunil V L <sunilvl@ventanamicro.com>
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/setup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index 9a1b7a0603b2..f2a9cd4284b0 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -230,8 +230,8 @@ static void __init init_resources(void)
 	}
 
 	/* Clean-up any unused pre-allocated resources */
-	mem_res_sz = (num_resources - res_idx + 1) * sizeof(*mem_res);
-	memblock_free(__pa(mem_res), mem_res_sz);
+	if (res_idx >= 0)
+		memblock_free(__pa(mem_res), (res_idx + 1) * sizeof(*mem_res));
 	return;
 
  error:
-- 
2.30.2

