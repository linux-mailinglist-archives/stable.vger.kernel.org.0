Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF3C226509
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731128AbgGTPuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:50:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731116AbgGTPuR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:50:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DC63206E9;
        Mon, 20 Jul 2020 15:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260216;
        bh=q64sLE5KM8tsbvF1NTx9fUgz7UsKdr5xL5orCqsm/jo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K6A90PGn9ZA1v7zhY1Y5MvIYgBFRToHlw1gx9ju7DosaV1Sf2cbFLa0gQTgjF2R17
         ockRb2FD8rRWbsJHaZReASf5afP+Yi6jpZBLir2/FcRvNt1cZJnnWX5HdX76L6mz2e
         3P1NgOUCgjN3TeAyn3MNa5DGqIFhOY7dIP8Dgh+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Rapoport <rppt@linux.ibm.com>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 022/133] m68k: nommu: register start of the memory with memblock
Date:   Mon, 20 Jul 2020 17:36:09 +0200
Message-Id: <20200720152804.797713455@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

[ Upstream commit d63bd8c81d8ab64db506ffde569cc8ff197516e2 ]

The m68k nommu setup code didn't register the beginning of the physical
memory with memblock because it was anyway occupied by the kernel. However,
commit fa3354e4ea39 ("mm: free_area_init: use maximal zone PFNs rather than
zone sizes") changed zones initialization to use memblock.memory to detect
the zone extents and this caused inconsistency between zone PFNs and the
actual PFNs:

BUG: Bad page state in process swapper  pfn:20165
page:41fe0ca0 refcount:0 mapcount:1 mapping:00000000 index:0x0 flags: 0x0()
raw: 00000000 00000100 00000122 00000000 00000000 00000000 00000000 00000000
page dumped because: nonzero mapcount
CPU: 0 PID: 1 Comm: swapper Not tainted 5.8.0-rc1-00001-g3a38f8a60c65-dirty #1
Stack from 404c9ebc:
        404c9ebc 4029ab28 4029ab28 40088470 41fe0ca0 40299e21 40299df1 404ba2a4
        00020165 00000000 41fd2c10 402c7ba0 41fd2c04 40088504 41fe0ca0 40299e21
        00000000 40088a12 41fe0ca0 41fe0ca4 0000020a 00000000 00000001 402ca000
        00000000 41fe0ca0 41fd2c10 41fd2c10 00000000 00000000 402b2388 00000001
        400a0934 40091056 404c9f44 404c9f44 40088db4 402c7ba0 00000001 41fd2c04
        41fe0ca0 41fd2000 41fe0ca0 40089e02 4026ecf4 40089e4e 41fe0ca0 ffffffff
Call Trace:
        [<40088470>] 0x40088470
 [<40088504>] 0x40088504
 [<40088a12>] 0x40088a12
 [<402ca000>] 0x402ca000
 [<400a0934>] 0x400a0934

Adjust the memory registration with memblock to include the beginning of
the physical memory and make sure that the area occupied by the kernel is
marked as reserved.

Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Greg Ungerer <gerg@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/kernel/setup_no.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/m68k/kernel/setup_no.c b/arch/m68k/kernel/setup_no.c
index cfd5475bfc315..4625acc1e7c4d 100644
--- a/arch/m68k/kernel/setup_no.c
+++ b/arch/m68k/kernel/setup_no.c
@@ -140,7 +140,8 @@ void __init setup_arch(char **cmdline_p)
 	pr_debug("MEMORY -> ROMFS=0x%p-0x%06lx MEM=0x%06lx-0x%06lx\n ",
 		 __bss_stop, memory_start, memory_start, memory_end);
 
-	memblock_add(memory_start, memory_end - memory_start);
+	memblock_add(_rambase, memory_end - _rambase);
+	memblock_reserve(_rambase, memory_start - _rambase);
 
 	/* Keep a copy of command line */
 	*cmdline_p = &command_line[0];
-- 
2.25.1



