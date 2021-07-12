Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB0933C49B1
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237439AbhGLGqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:46:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239182AbhGLGox (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:44:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9D1D610F7;
        Mon, 12 Jul 2021 06:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072074;
        bh=y1dDtowXYmNngW7QfUiJrbLSrm7VBAyFVm3SWaHKEDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sV1uoL0aWI7LnTtmyUx0yjylZjg3WQcxed856RWKZgPQ2cWYeLoo40ShZNtyo57j2
         ASjr2xtCzJX7txFF0xWrRhFfZ0HFRmNg2yKM3SmkgwNJQ4LbOwDBcwbQ0CUn/muC8F
         7D8ZNe/1iaNinHnA+zoMRCNFsISpi5E9GWG4G95k=
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
Subject: [PATCH 5.10 290/593] dax: fix ENOMEM handling in grab_mapping_entry()
Date:   Mon, 12 Jul 2021 08:07:30 +0200
Message-Id: <20210712060916.288414946@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index df5485b4bddf..d5d7b9393bca 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -488,10 +488,11 @@ static void *grab_mapping_entry(struct xa_state *xas,
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



