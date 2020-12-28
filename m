Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2827A2E64B2
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404392AbgL1PwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:52:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:38024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391238AbgL1NiH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:38:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00262207B2;
        Mon, 28 Dec 2020 13:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162672;
        bh=3Ku1exm3oifOE+kIg3IY0sg0h+z+D1d6ddVtEEIglvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AJGJiyhShWlIgRccwySS6Z/eyoL+6w3g3Q7ZKuse2kXvQFt8Q0ouDmz8eoXamAixI
         OG0do0nQjuz98suav5bTl8YXkuMgGw9oCqUZmL2VBwdWuYN6bke1ndX/YbcZFlde5Z
         6UY/dLxUPkKCU0N/mJ5dxzyKNhK38VN9GMaQk1eI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Li RongQing <lirongqing@baidu.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 032/453] i40e: optimise prefetch page refcount
Date:   Mon, 28 Dec 2020 13:44:28 +0100
Message-Id: <20201228124938.808023257@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 1fa5cef283420b3dad93cd6ab04d7125bc1562de ]

refcount of rx_buffer page will be added here originally, so prefetchw
is needed, but after commit 1793668c3b8c ("i40e/i40evf: Update code to
better handle incrementing page count"), and refcount is not added
every time, so change prefetchw as prefetch.

Now it mainly services page_address(), but which accesses struct page
only when WANT_PAGE_VIRTUAL or HASHED_PAGE_VIRTUAL is defined otherwise
it returns address based on offset, so we prefetch it conditionally.

Jakub suggested to define prefetch_page_address in a common header.

Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 2 +-
 include/linux/prefetch.h                    | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 7f7f02bc2b794..89a3be41d6d83 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1971,7 +1971,7 @@ static struct i40e_rx_buffer *i40e_get_rx_buffer(struct i40e_ring *rx_ring,
 	struct i40e_rx_buffer *rx_buffer;
 
 	rx_buffer = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
-	prefetchw(rx_buffer->page);
+	prefetch_page_address(rx_buffer->page);
 
 	/* we are reusing so sync this buffer for CPU use */
 	dma_sync_single_range_for_cpu(rx_ring->dev,
diff --git a/include/linux/prefetch.h b/include/linux/prefetch.h
index 13eafebf3549a..b83a3f944f287 100644
--- a/include/linux/prefetch.h
+++ b/include/linux/prefetch.h
@@ -15,6 +15,7 @@
 #include <asm/processor.h>
 #include <asm/cache.h>
 
+struct page;
 /*
 	prefetch(x) attempts to pre-emptively get the memory pointed to
 	by address "x" into the CPU L1 cache. 
@@ -62,4 +63,11 @@ static inline void prefetch_range(void *addr, size_t len)
 #endif
 }
 
+static inline void prefetch_page_address(struct page *page)
+{
+#if defined(WANT_PAGE_VIRTUAL) || defined(HASHED_PAGE_VIRTUAL)
+	prefetch(page);
+#endif
+}
+
 #endif
-- 
2.27.0



