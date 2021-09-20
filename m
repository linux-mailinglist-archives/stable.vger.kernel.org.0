Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6741A411B12
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242254AbhITQzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:55:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245387AbhITQxJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:53:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83C1F611ED;
        Mon, 20 Sep 2021 16:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156611;
        bh=faO3FdE5clD/PqC7Oe5fqJAwQaksY0pubEw8Y/foOpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h1KCk94LNxlDoIWo9OF4B2AWQ7K/vQi0uEF2fed2aE+/bnPRpC1Xk1zxxCoUO959/
         7cJc3u+IMbufIimMlvAwst4sZS4/778VW49IOtdBWRm2tIJ+OqoX+E3r825t5QDK7R
         hrc++T8vooHDljtlheEsCXf8G4rKwL4S5RtzDy+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-snps-arc@lists.infradead.org,
        Vineet Gupta <vgupta@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 131/133] ARC: export clear_user_page() for modules
Date:   Mon, 20 Sep 2021 18:43:29 +0200
Message-Id: <20210920163916.907549425@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 6b5ff0405e4190f23780362ea324b250bc495683 ]

0day bot reports a build error:
  ERROR: modpost: "clear_user_page" [drivers/media/v4l2-core/videobuf-dma-sg.ko] undefined!
so export it in arch/arc/ to fix the build error.

In most ARCHes, clear_user_page() is a macro. OTOH, in a few
ARCHes it is a function and needs to be exported.
PowerPC exported it in 2004. It looks like nds32 and nios2
still need to have it exported.

Fixes: 4102b53392d63 ("ARC: [mm] Aliasing VIPT dcache support 2/4")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: linux-snps-arc@lists.infradead.org
Signed-off-by: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/mm/cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arc/mm/cache.c b/arch/arc/mm/cache.c
index 017fb440bba4..f425405a8a76 100644
--- a/arch/arc/mm/cache.c
+++ b/arch/arc/mm/cache.c
@@ -904,7 +904,7 @@ void clear_user_page(void *to, unsigned long u_vaddr, struct page *page)
 	clear_page(to);
 	clear_bit(PG_dc_clean, &page->flags);
 }
-
+EXPORT_SYMBOL(clear_user_page);
 
 /**********************************************************************
  * Explicit Cache flush request from user space via syscall
-- 
2.30.2



