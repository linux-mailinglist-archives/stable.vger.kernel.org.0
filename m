Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7615C41239B
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351810AbhITS0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:26:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:43182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351952AbhITSWV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:22:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 881CD632BB;
        Mon, 20 Sep 2021 17:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158652;
        bh=1Ba3KhtEOml4S43b/+tqGlRyZIVlN/+Kmc1slN5ZFSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FY5QgaYwQ80u0ueE8EqFFqbXWYT3OSV3lv0LOq6K5g3ZXFeZrEwuvSBaZFxpP7VKC
         ciS0mSUxCbR/6lx2aHFn0WbjLBacMCq7L1gU7EOpfkW3P04ADg8UxozdEKXumbLSyx
         kkFcI+DxMC6gUR4dV5P5rmanHUCFGTShzvx2gSRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-snps-arc@lists.infradead.org,
        Vineet Gupta <vgupta@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 253/260] ARC: export clear_user_page() for modules
Date:   Mon, 20 Sep 2021 18:44:31 +0200
Message-Id: <20210920163939.702656454@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
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
index a2fbea3ee07c..102418ac5ff4 100644
--- a/arch/arc/mm/cache.c
+++ b/arch/arc/mm/cache.c
@@ -1123,7 +1123,7 @@ void clear_user_page(void *to, unsigned long u_vaddr, struct page *page)
 	clear_page(to);
 	clear_bit(PG_dc_clean, &page->flags);
 }
-
+EXPORT_SYMBOL(clear_user_page);
 
 /**********************************************************************
  * Explicit Cache flush request from user space via syscall
-- 
2.30.2



