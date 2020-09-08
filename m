Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB1626173B
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731760AbgIHR2Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:28:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730655AbgIHQQJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:16:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CACC524833;
        Tue,  8 Sep 2020 15:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579870;
        bh=KzG/T3Soqo1YupOU7YWJJa7dc0wh1hTNzVJEFlGPp1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MW7d5q0R/TEYJpu+z4TfjhSx/uVsfUamiKjVaO5n14TOLeUE4RcVBWrChCsqCZqV7
         DWVA0hMCjjG5E3Tj3qjA2m0J2zzY2Qu3Q3h6DRlPnOszQZR1CHav0wyOLU6+tEoQt1
         TPd/ZwDsIAiD87c2RXD6Tk95iIAq0pfMRdT/csZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 066/129] x86, fakenuma: Fix invalid starting node ID
Date:   Tue,  8 Sep 2020 17:25:07 +0200
Message-Id: <20200908152232.993279347@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

[ Upstream commit ccae0f36d500aef727f98acd8d0601e6b262a513 ]

Commit:

  cc9aec03e58f ("x86/numa_emulation: Introduce uniform split capability")

uses "-1" as the starting node ID, which causes the strange kernel log as
follows, when "numa=fake=32G" is added to the kernel command line:

    Faking node -1 at [mem 0x0000000000000000-0x0000000893ffffff] (35136MB)
    Faking node 0 at [mem 0x0000001840000000-0x000000203fffffff] (32768MB)
    Faking node 1 at [mem 0x0000000894000000-0x000000183fffffff] (64192MB)
    Faking node 2 at [mem 0x0000002040000000-0x000000283fffffff] (32768MB)
    Faking node 3 at [mem 0x0000002840000000-0x000000303fffffff] (32768MB)

And finally the kernel crashes:

    BUG: Bad page state in process swapper  pfn:00011
    page:(____ptrval____) refcount:0 mapcount:1 mapping:(____ptrval____) index:0x55cd7e44b270 pfn:0x11
    failed to read mapping contents, not a valid kernel address?
    flags: 0x5(locked|uptodate)
    raw: 0000000000000005 000055cd7e44af30 000055cd7e44af50 0000000100000006
    raw: 000055cd7e44b270 000055cd7e44b290 0000000000000000 000055cd7e44b510
    page dumped because: page still charged to cgroup
    page->mem_cgroup:000055cd7e44b510
    Modules linked in:
    CPU: 0 PID: 0 Comm: swapper Not tainted 5.9.0-rc2 #1
    Hardware name: Intel Corporation S2600WFT/S2600WFT, BIOS SE5C620.86B.02.01.0008.031920191559 03/19/2019
    Call Trace:
     dump_stack+0x57/0x80
     bad_page.cold+0x63/0x94
     __free_pages_ok+0x33f/0x360
     memblock_free_all+0x127/0x195
     mem_init+0x23/0x1f5
     start_kernel+0x219/0x4f5
     secondary_startup_64+0xb6/0xc0

Fix this bug via using 0 as the starting node ID.  This restores the
original behavior before cc9aec03e58f.

[ mingo: Massaged the changelog. ]

Fixes: cc9aec03e58f ("x86/numa_emulation: Introduce uniform split capability")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20200904061047.612950-1-ying.huang@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/numa_emulation.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/numa_emulation.c b/arch/x86/mm/numa_emulation.c
index abffa0be80da1..87282258d5bea 100644
--- a/arch/x86/mm/numa_emulation.c
+++ b/arch/x86/mm/numa_emulation.c
@@ -321,7 +321,7 @@ static int __init split_nodes_size_interleave(struct numa_meminfo *ei,
 					      u64 addr, u64 max_addr, u64 size)
 {
 	return split_nodes_size_interleave_uniform(ei, pi, addr, max_addr, size,
-			0, NULL, NUMA_NO_NODE);
+			0, NULL, 0);
 }
 
 int __init setup_emu2phys_nid(int *dfl_phys_nid)
-- 
2.25.1



