Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0CF24AB93
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 02:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbgHTAL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 20:11:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbgHTACH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 20:02:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E290A207FB;
        Thu, 20 Aug 2020 00:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881726;
        bh=COjiY0b/wWEh1aAE8ioSHBgdaNmtR5MlWi3AkEpblWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OOeQnnwtGA1Adv8q7iKke6zi3+VjC4QuGxcMLBfW02JMzSlMxphmqHY/6rMlu7y4J
         2At8vmD9bvK4AXMS39gjVc40nyEyIkL5aWsxA2sdXuJIu/qUoHu/+hEbbbDJrdk+tj
         UoD+cNwq7q240KiyLqHgNEyP24jpuYRHBudjWL2U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jinyang He <hejinyang@loongson.cn>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 08/24] MIPS: Fix unable to reserve memory for Crash kernel
Date:   Wed, 19 Aug 2020 20:01:39 -0400
Message-Id: <20200820000155.215089-8-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200820000155.215089-1-sashal@kernel.org>
References: <20200820000155.215089-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jinyang He <hejinyang@loongson.cn>

[ Upstream commit b1ce9716f3b5ed3b49badf1f003b9e34b7ead0f9 ]

Use 0 as the align parameter in memblock_find_in_range() is
incorrect when we reserve memory for Crash kernel.

The environment as follows:
[    0.000000] MIPS: machine is loongson,loongson64c-4core-rs780e
...
[    1.951016]     crashkernel=64M@128M

The warning as follows:
[    0.000000] Invalid memory region reserved for crash kernel

And the iomem as follows:
00200000-0effffff : System RAM
  04000000-0484009f : Kernel code
  048400a0-04ad7fff : Kernel data
  04b40000-05c4c6bf : Kernel bss
1a000000-1bffffff : pci@1a000000
...

The align parameter may be finally used by round_down() or round_up().
Like the following call tree:

mips-next: mm/memblock.c

memblock_find_in_range
└── memblock_find_in_range_node
    ├── __memblock_find_range_bottom_up
    │   └── round_up
    └── __memblock_find_range_top_down
        └── round_down
\#define round_up(x, y) ((((x)-1) | __round_mask(x, y))+1)
\#define round_down(x, y) ((x) & ~__round_mask(x, y))
\#define __round_mask(x, y) ((__typeof__(x))((y)-1))

The round_down(or round_up)'s second parameter must be a power of 2.
If the second parameter is 0, it both will return 0.

Use 1 as the parameter to fix the bug and the iomem as follows:
00200000-0effffff : System RAM
  04000000-0484009f : Kernel code
  048400a0-04ad7fff : Kernel data
  04b40000-05c4c6bf : Kernel bss
  08000000-0bffffff : Crash kernel
1a000000-1bffffff : pci@1a000000
...

Signed-off-by: Jinyang He <hejinyang@loongson.cn>
Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index 573509e0f2d4e..3ace115740dd1 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -497,7 +497,7 @@ static void __init mips_parse_crashkernel(void)
 	if (ret != 0 || crash_size <= 0)
 		return;
 
-	if (!memblock_find_in_range(crash_base, crash_base + crash_size, crash_size, 0)) {
+	if (!memblock_find_in_range(crash_base, crash_base + crash_size, crash_size, 1)) {
 		pr_warn("Invalid memory region reserved for crash kernel\n");
 		return;
 	}
-- 
2.25.1

