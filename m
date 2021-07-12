Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B575F3C456B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbhGLGZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:25:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235222AbhGLGYh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:24:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C39E4611C0;
        Mon, 12 Jul 2021 06:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070887;
        bh=0ZgqDbap0sN27fyUlPAxtjKydY5/6ishADhKBLSLIpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O4DCVfxmwTUPq1Zi+PBFXa2SLPpClQukI9hCIohPtU/yRcHlncCFH31Sz1lMV62n2
         TsjN3l68mdpq0bFf50/1dJP34Szd8n6aERei0cZy4y/zmCSGOK4wYh9uupqSGUd1fW
         iO6DytPbJYxW0jw0kf12DY1rHyAfxhCCk7uAcdp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 183/348] dax: fix ENOMEM handling in grab_mapping_entry()
Date:   Mon, 12 Jul 2021 08:09:27 +0200
Message-Id: <20210712060725.204331095@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 1a14e3779dd58c16b30e56558146e5cc850ba8b0 ]

grab_mapping_entry() has a bug in handling of ENOMEM condition.  Suppose
we have a PMD entry at index i which we are downgrading to a PTE entry.
grab_mapping_entry() will set pmd_downgrade to true, lock the entry, clear
the entry in xarray, and decrement mapping->nrpages.  The it will call:

	entry = dax_make_entry(pfn_to_pfn_t(0), flags);
	dax_lock_entry(xas, entry);

which inserts new PTE entry into xarray.  However this may fail allocating
the new node.  We handle this by:

	if (xas_nomem(xas, mapping_gfp_mask(mapping) & ~__GFP_HIGHMEM))
		goto retry;

however pmd_downgrade stays set to true even though 'entry' returned from
get_unlocked_entry() will be NULL now.  And we will go again through the
downgrade branch.  This is mostly harmless except that mapping->nrpages is
decremented again and we temporarily have an invalid entry stored in
xarray.  Fix the problem by setting pmd_downgrade to false each time we
lookup the entry we work with so that it matches the entry we found.

Link: https://lkml.kernel.org/r/20210622160015.18004-1-jack@suse.cz
Fixes: b15cd800682f ("dax: Convert page fault handlers to XArray")
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dax.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 3b0e5da96d54..12953e892bb2 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -477,10 +477,11 @@ static void *grab_mapping_entry(struct xa_state *xas,
 		struct address_space *mapping, unsigned int order)
 {
 	unsigned long index = xas->xa_index;
-	bool pmd_downgrade = false; /* splitting PMD entry into PTE entries? */
+	bool pmd_downgrade;	/* splitting PMD entry into PTE entries? */
 	void *entry;
 
 retry:
+	pmd_downgrade = false;
 	xas_lock_irq(xas);
 	entry = get_unlocked_entry(xas, order);
 
-- 
2.30.2



