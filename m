Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970751EAE97
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729809AbgFASzY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:55:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729792AbgFASB2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:01:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 650202077D;
        Mon,  1 Jun 2020 18:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034487;
        bh=htOHnD6PwjNM80sjCuQJsbau8w9KAO4lvJGG0CepkSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tXlHoD15h+fSkw/NrJYXvZzW0AcgbXNMnqANaRV6etHoBgMCwLBF5b9WPifS6hGZw
         uL9sq69CnHEa76AMEK9z+WjUKYIgGo9m6GqLBv9u8bhVXzu2XcuoHsyDsa+HGDUsCu
         jm3hT4CPHmMvcTYJhAJeEJm+i0hYfb6nWgOdhlAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 4.14 52/77] parisc: Fix kernel panic in mem_init()
Date:   Mon,  1 Jun 2020 19:53:57 +0200
Message-Id: <20200601174025.516529052@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174016.396817032@linuxfoundation.org>
References: <20200601174016.396817032@linuxfoundation.org>
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
@@ -608,7 +608,7 @@ void __init mem_init(void)
 			> BITS_PER_LONG);
 
 	high_memory = __va((max_pfn << PAGE_SHIFT));
-	set_max_mapnr(page_to_pfn(virt_to_page(high_memory - 1)) + 1);
+	set_max_mapnr(max_low_pfn);
 	free_all_bootmem();
 
 #ifdef CONFIG_PA11


