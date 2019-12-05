Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60746114023
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 12:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbfLELcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 06:32:01 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53188 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728735AbfLELcB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 06:32:01 -0500
Received: by mail-wm1-f66.google.com with SMTP id p9so3291393wmc.2;
        Thu, 05 Dec 2019 03:31:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JjJxU4HP6eaRRyFxsdouinTrpCEow/Z7i31krH2kwCs=;
        b=kZv7nmk+Oo+yT7euE/vMskqQ3z7iw/omRSYYBtuRQPWvgye2SGBAhdOs+c3V9qmnOX
         RcHXHX9narKM7amnmA6NvaE225rRWQJJyryXU5XtxhQujOqoyfnONznedvC0On+0P2Ub
         1GnCS0jPziFJ0mLPlPdEv8/bzRmKR6+B9uUF92/IXFiycm4JFFxnm3okv+2A5wuKwutJ
         YgqU5CeMWQ170EBVwUeilrfZu+13cVfjW9219ZG5CHlhXwtdSsHZdP++8TbhsAa5PevI
         okr2MALjPwOMZKcpQjVN6FmS4vTAnwqtla0Tyl00yZ2hNV3qiH767ltafdbecOnC4r7t
         FLAw==
X-Gm-Message-State: APjAAAW6gZ3AwjJQsaRsgz5SHzFsoXSrvAZgbKa7YSQejHFUfbbbsfq8
        vsalwUULJQ/gLAL8fGFkbKQ=
X-Google-Smtp-Source: APXvYqzpDPHksDnygy5Fg+9DCfEclhSTLYJunPk0DVHsHi1gH3jci6q0s1hvYgMua9JGOYKPgXNpXQ==
X-Received: by 2002:a1c:61d7:: with SMTP id v206mr4592095wmb.13.1575545518284;
        Thu, 05 Dec 2019 03:31:58 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id z11sm11966035wrt.82.2019.12.05.03.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 03:31:57 -0800 (PST)
Date:   Thu, 5 Dec 2019 12:31:56 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Yang Shi <yang.shi@linux.alibaba.com>
Cc:     fabecassis@nvidia.com, jhubbard@nvidia.com, cl@linux.com,
        vbabka@suse.cz, mgorman@techsingularity.net,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [v2 PATCH] mm: move_pages: return valid node id in status if the
 page is already on the target node
Message-ID: <20191205113156.GE28317@dhcp22.suse.cz>
References: <1575519678-86510-1-git-send-email-yang.shi@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1575519678-86510-1-git-send-email-yang.shi@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 05-12-19 12:21:18, Yang Shi wrote:
> Felix Abecassis reports move_pages() would return random status if the
> pages are already on the target node by the below test program:
> 
> ---8<---
> 
> int main(void)
> {
> 	const long node_id = 1;
> 	const long page_size = sysconf(_SC_PAGESIZE);
> 	const int64_t num_pages = 8;
> 
> 	unsigned long nodemask =  1 << node_id;
> 	long ret = set_mempolicy(MPOL_BIND, &nodemask, sizeof(nodemask));
> 	if (ret < 0)
> 		return (EXIT_FAILURE);
> 
> 	void **pages = malloc(sizeof(void*) * num_pages);
> 	for (int i = 0; i < num_pages; ++i) {
> 		pages[i] = mmap(NULL, page_size, PROT_WRITE | PROT_READ,
> 				MAP_PRIVATE | MAP_POPULATE | MAP_ANONYMOUS,
> 				-1, 0);
> 		if (pages[i] == MAP_FAILED)
> 			return (EXIT_FAILURE);
> 	}
> 
> 	ret = set_mempolicy(MPOL_DEFAULT, NULL, 0);
> 	if (ret < 0)
> 		return (EXIT_FAILURE);
> 
> 	int *nodes = malloc(sizeof(int) * num_pages);
> 	int *status = malloc(sizeof(int) * num_pages);
> 	for (int i = 0; i < num_pages; ++i) {
> 		nodes[i] = node_id;
> 		status[i] = 0xd0; /* simulate garbage values */
> 	}
> 
> 	ret = move_pages(0, num_pages, pages, nodes, status, MPOL_MF_MOVE);
> 	printf("move_pages: %ld\n", ret);
> 	for (int i = 0; i < num_pages; ++i)
> 		printf("status[%d] = %d\n", i, status[i]);
> }
> ---8<---
> 
> Then running the program would return nonsense status values:
> $ ./move_pages_bug
> move_pages: 0
> status[0] = 208
> status[1] = 208
> status[2] = 208
> status[3] = 208
> status[4] = 208
> status[5] = 208
> status[6] = 208
> status[7] = 208
> 
> This is because the status is not set if the page is already on the
> target node, but move_pages() should return valid status as long as it
> succeeds.  The valid status may be errno or node id.
> 
> We can't simply initialize status array to zero since the pages may be
> not on node 0.  Fix it by updating status with node id which the page is
> already on.  And, it looks we have to update the status inside
> add_page_for_migration() since the page struct is not available outside
> it.

The code is indeed more complex than I wanted but I couldn't figure an
easier way back then. I wanted to keep store_status at a single place
because the failure handling is quite complex already.

> Make add_page_for_migration() return 1 if store_status() is failed in
> order to not mix up the status value since -EFAULT is also a valid
> status.

Can we simply return 1 when there is something to migrate instead?
Something like
diff --git a/mm/migrate.c b/mm/migrate.c
index 4fe45d1428c8..f3730804b8d4 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1516,9 +1516,9 @@ static int do_move_pages_to_node(struct mm_struct *mm,
 /*
  * Resolves the given address to a struct page, isolates it from the LRU and
  * puts it to the given pagelist.
- * Returns -errno if the page cannot be found/isolated or 0 when it has been
- * queued or the page doesn't need to be migrated because it is already on
- * the target node
+ * Returns -errno if the page cannot be found/isolated or 0 when it doesn't have
+ * to be migrate or 1 dwhen it has been queued or the page doesn't need to be
+ * migrated because it is already on the target node
  */
 static int add_page_for_migration(struct mm_struct *mm, unsigned long addr,
 		int node, struct list_head *pagelist, bool migrate_all)
@@ -1557,7 +1557,7 @@ static int add_page_for_migration(struct mm_struct *mm, unsigned long addr,
 	if (PageHuge(page)) {
 		if (PageHead(page)) {
 			isolate_huge_page(page, pagelist);
-			err = 0;
+			err = 1;
 		}
 	} else {
 		struct page *head;
@@ -1567,7 +1567,7 @@ static int add_page_for_migration(struct mm_struct *mm, unsigned long addr,
 		if (err)
 			goto out_putpage;
 
-		err = 0;
+		err = 1;
 		list_add_tail(&head->lru, pagelist);
 		mod_node_page_state(page_pgdat(head),
 			NR_ISOLATED_ANON + page_is_file_cache(head),
@@ -1644,8 +1644,14 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
 		 */
 		err = add_page_for_migration(mm, addr, current_node,
 				&pagelist, flags & MPOL_MF_MOVE_ALL);
-		if (!err)
+		if (!err) {
+			err = store_status(status, i, current_node, 1);
+			if (err)
+				goto out_flush;
+			continue;
+		} else if (err > 0) {
 			continue;
+		}
 
 		err = store_status(status, i, err, 1);
 		if (err)

this would still keep store_status ugliness at a single place.

>
> Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
> Reported-by: Felix Abecassis <fabecassis@nvidia.com>
> Tested-by: Felix Abecassis <fabecassis@nvidia.com>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: <stable@vger.kernel.org> 4.17+
> Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
> ---
> v2: *Correted the return value when add_page_for_migration() returns 1.
> 
> John noticed another return value inconsistency between the implementation and
> the manpage.  The manpage says it should return -ENOENT if the page is already
> on the target node, but it doesn't.  It looks the original code didn't return
> -ENOENT either, I'm not sure if this is a document issue or not.  Anyway this
> is another issue, once we confirm it we can fix it later.

I do not remember all the details but my recollection is that there were
several inconsistencies present before I touched the code and I've
decided to not touch them without a clear usecase.
-- 
Michal Hocko
SUSE Labs
