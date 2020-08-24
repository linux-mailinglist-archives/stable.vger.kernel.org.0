Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFBF24F55C
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728571AbgHXIsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:48:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729513AbgHXIr7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:47:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9362206F0;
        Mon, 24 Aug 2020 08:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258878;
        bh=88Xw40YC1QnjNuLG/+6YqfiY2ut1djo/oaUujd9yOWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G1F7lANRjdHiMGrw1ZmotJ076q4vwmzLXN7EIBPAAlFbqha0+7gScn8qbqV187nTF
         8qAQual7B0qR1JGdtId0UXNmSruO6zgRwwo+RZKKocePhLJROeru2wI5RJBBucwvul
         VeWojVaftOhaTHhcnZEMtOZBsmyDBCRmKZlXROTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jinyang He <hejinyang@loongson.cn>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 047/107] MIPS: Fix unable to reserve memory for Crash kernel
Date:   Mon, 24 Aug 2020 10:30:13 +0200
Message-Id: <20200824082407.463082027@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082405.020301642@linuxfoundation.org>
References: <20200824082405.020301642@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7b06e6ee6817d..b8884de89c81e 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -494,7 +494,7 @@ static void __init mips_parse_crashkernel(void)
 	if (ret != 0 || crash_size <= 0)
 		return;
 
-	if (!memblock_find_in_range(crash_base, crash_base + crash_size, crash_size, 0)) {
+	if (!memblock_find_in_range(crash_base, crash_base + crash_size, crash_size, 1)) {
 		pr_warn("Invalid memory region reserved for crash kernel\n");
 		return;
 	}
-- 
2.25.1



