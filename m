Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B131EAEF3
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729215AbgFAS61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:58:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728552AbgFAR6t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:58:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B78242073B;
        Mon,  1 Jun 2020 17:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034329;
        bh=SGiAv6shdVOKpwPOvW00N1lm9ZHiO/y4bOuCN+rRr/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pj6XKEyMob0BtvsRozDMl7SXBry83mIdCcq8k2RzQkbl9x9Bpcl8eShwQWZt3QL9r
         6x0Edmv6KCTzIv15BhnPUq16SDpdinwSaq8OvtHy6NCbkanaLNuA5JVBU6pXe0U6XF
         ZvLpYhXHUNrkJOx2PXXMNwA5LIV/GJkUQgYISvwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 4.9 42/61] parisc: Fix kernel panic in mem_init()
Date:   Mon,  1 Jun 2020 19:53:49 +0200
Message-Id: <20200601174019.401534628@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174010.316778377@linuxfoundation.org>
References: <20200601174010.316778377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit bf71bc16e02162388808949b179d59d0b571b965 upstream.

The Debian kernel v5.6 triggers this kernel panic:

 Kernel panic - not syncing: Bad Address (null pointer deref?)
 Bad Address (null pointer deref?): Code=26 (Data memory access rights trap) at addr 0000000000000000
 CPU: 0 PID: 0 Comm: swapper Not tainted 5.6.0-2-parisc64 #1 Debian 5.6.14-1
  IAOQ[0]: mem_init+0xb0/0x150
  IAOQ[1]: mem_init+0xb4/0x150
  RP(r2): start_kernel+0x6c8/0x1190
 Backtrace:
  [<0000000040101ab4>] start_kernel+0x6c8/0x1190
  [<0000000040108574>] start_parisc+0x158/0x1b8

on a HP-PARISC rp3440 machine with this memory layout:
 Memory Ranges:
  0) Start 0x0000000000000000 End 0x000000003fffffff Size   1024 MB
  1) Start 0x0000004040000000 End 0x00000040ffdfffff Size   3070 MB

Fix the crash by avoiding virt_to_page() and similar functions in
mem_init() until the memory zones have been fully set up.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # v5.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 arch/parisc/mm/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -604,7 +604,7 @@ void __init mem_init(void)
 			> BITS_PER_LONG);
 
 	high_memory = __va((max_pfn << PAGE_SHIFT));
-	set_max_mapnr(page_to_pfn(virt_to_page(high_memory - 1)) + 1);
+	set_max_mapnr(max_low_pfn);
 	free_all_bootmem();
 
 #ifdef CONFIG_PA11


