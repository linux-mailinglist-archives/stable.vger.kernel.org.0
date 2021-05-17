Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 050283831B8
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238038AbhEQOkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:40:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240996AbhEQOhT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:37:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABDB8613F1;
        Mon, 17 May 2021 14:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261056;
        bh=ElAI1XIwd537DNiT1qmQQpEfJEPAdz4B6MeTU+xLgvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0NyejkzW2wMU9tM/b5aGF/gTFpjmN7jtpC34XwCcbxGIQxAixGm1x0zVBbPNd1w5f
         QeFuDyxs7ghJPvdFtKlJ073a4k+JvHqZF/ICPm0So0myz4vbyKJJ+Nh+2TlluWGww/
         JZVZs+tfJiq+Y/sypuJqyS2Am9Zf+Y/1XGBWN4vo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greg Kurz <groug@kaod.org>,
        Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 281/363] dax: Add a wakeup mode parameter to put_unlocked_entry()
Date:   Mon, 17 May 2021 16:02:27 +0200
Message-Id: <20210517140312.115071359@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

[ Upstream commit 4c3d043d271d4d629aa2328796cdfc96b37d3b3c ]

As of now put_unlocked_entry() always wakes up next waiter. In next
patches we want to wake up all waiters at one callsite. Hence, add a
parameter to the function.

This patch does not introduce any change of behavior.

Reviewed-by: Greg Kurz <groug@kaod.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Link: https://lore.kernel.org/r/20210428190314.1865312-3-vgoyal@redhat.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dax.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 5ecee51c44ee..56eb1c759ca5 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -275,11 +275,11 @@ static void wait_entry_unlocked(struct xa_state *xas, void *entry)
 	finish_wait(wq, &ewait.wait);
 }
 
-static void put_unlocked_entry(struct xa_state *xas, void *entry)
+static void put_unlocked_entry(struct xa_state *xas, void *entry,
+			       enum dax_wake_mode mode)
 {
-	/* If we were the only waiter woken, wake the next one */
 	if (entry && !dax_is_conflict(entry))
-		dax_wake_entry(xas, entry, WAKE_NEXT);
+		dax_wake_entry(xas, entry, mode);
 }
 
 /*
@@ -633,7 +633,7 @@ struct page *dax_layout_busy_page_range(struct address_space *mapping,
 			entry = get_unlocked_entry(&xas, 0);
 		if (entry)
 			page = dax_busy_page(entry);
-		put_unlocked_entry(&xas, entry);
+		put_unlocked_entry(&xas, entry, WAKE_NEXT);
 		if (page)
 			break;
 		if (++scanned % XA_CHECK_SCHED)
@@ -675,7 +675,7 @@ static int __dax_invalidate_entry(struct address_space *mapping,
 	mapping->nrexceptional--;
 	ret = 1;
 out:
-	put_unlocked_entry(&xas, entry);
+	put_unlocked_entry(&xas, entry, WAKE_NEXT);
 	xas_unlock_irq(&xas);
 	return ret;
 }
@@ -954,7 +954,7 @@ static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
 	return ret;
 
  put_unlocked:
-	put_unlocked_entry(xas, entry);
+	put_unlocked_entry(xas, entry, WAKE_NEXT);
 	return ret;
 }
 
@@ -1695,7 +1695,7 @@ dax_insert_pfn_mkwrite(struct vm_fault *vmf, pfn_t pfn, unsigned int order)
 	/* Did we race with someone splitting entry or so? */
 	if (!entry || dax_is_conflict(entry) ||
 	    (order == 0 && !dax_is_pte_entry(entry))) {
-		put_unlocked_entry(&xas, entry);
+		put_unlocked_entry(&xas, entry, WAKE_NEXT);
 		xas_unlock_irq(&xas);
 		trace_dax_insert_pfn_mkwrite_no_entry(mapping->host, vmf,
 						      VM_FAULT_NOPAGE);
-- 
2.30.2



