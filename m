Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62A39143878
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 09:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbgAUIko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 03:40:44 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:32847 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727255AbgAUIko (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jan 2020 03:40:44 -0500
Received: by mail-wm1-f66.google.com with SMTP id d139so1591605wmd.0;
        Tue, 21 Jan 2020 00:40:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mlOECQ7CcQkzAwbpkxm8GkUs0tDU/ThJ8gW1i6BlUtI=;
        b=GmESNmmxJe1Xalyt4uWbfMS8TvPJG4siJNsHMacKmFQRSnZc+WoL1J/Z4d7dDO7UIR
         38PpiXPnuTQqOEaZuDrswCtBBXHzoOYp11hXrVoABP4q6hs+qAj8vVMcJ9OICHHeNzag
         H/W8Em2Y1oVzTSXsf+uUn/NUExGYFaiV2rr0GuU5/AfINDvlIYPkgloehiFTidUDTPCQ
         ISkqESHQoZ7IGT8RT2KiuP7cepeNKREkcTNRx6OsyrnyZ15ILDaBJaq3nQEp6Z5D3XTQ
         rHl6oL7apaCXepW0RQ0VPN9iH7kJhRpF7+WvqirERaupMSHPT6vk60adJNVpmUNJZvhc
         UzUA==
X-Gm-Message-State: APjAAAX/srXfHU0OP+3vK1Bac1eJpLzDury7lgSkm+SAv/BE9waEaML+
        tf75td5pexHrfe8zNfgpR9M=
X-Google-Smtp-Source: APXvYqxmo87LjwWCnCYhoNAvperR/n4gqhmQOwBxDxX5GOh/KMVdsccSINDsGl9fzEDtrfht0x7yYw==
X-Received: by 2002:a7b:c8cd:: with SMTP id f13mr3116009wml.18.1579596042020;
        Tue, 21 Jan 2020 00:40:42 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id q3sm2855681wmc.47.2020.01.21.00.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 00:40:41 -0800 (PST)
Date:   Tue, 21 Jan 2020 09:40:40 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Wei Yang <richardw.yang@linux.intel.com>
Cc:     Yang Shi <yang.shi@linux.alibaba.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mm: move_pages: fix the return value if there are
 not-migrated pages
Message-ID: <20200121084040.GC29276@dhcp22.suse.cz>
References: <1579325203-16405-1-git-send-email-yang.shi@linux.alibaba.com>
 <20200120130624.GD18451@dhcp22.suse.cz>
 <20200120131744.GE18451@dhcp22.suse.cz>
 <20200121014416.GC1567@richard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200121014416.GC1567@richard>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 21-01-20 09:44:16, Wei Yang wrote:
> On Mon, Jan 20, 2020 at 02:17:44PM +0100, Michal Hocko wrote:
> >On Mon 20-01-20 14:06:26, Michal Hocko wrote:
> >> On Sat 18-01-20 13:26:43, Yang Shi wrote:
> >> > The do_move_pages_to_node() might return > 0 value, the number of pages
> >> > that are not migrated, then the value will be returned to userspace
> >> > directly.  But, move_pages() syscall would just return 0 or errno.  So,
> >> > we need reset the return value to 0 for such case as what pre-v4.17 did.
> >> 
> >> The patch is wrong. migrate_pages returns the number of pages it
> >> _hasn't_ migrated or -errno. Yeah that semantic sucks but...
> >> So err != 0 is always an error. Except err > 0 doesn't really provide
> >> any useful information to the userspace. I cannot really remember what
> >> was the actual behavior before my rework because there were some gotchas
> >> hidden there.
> >
> >OK, so I've double checked. do_move_page_to_node_array would carry the
> >error code over to do_pages_move and it would store the status stored
> >in the pm array. It contains page_to_nid(page) so the resulting code
> >indeed behaves properly before my change and this is a regression. I
> 
> Thanks, I see the change.
> 
> >have a very vague recollection that this has been brought up already.
> ><...looks in notes...>
> >Found it! The report is
> >http://lkml.kernel.org/r/0329efa0984b9b0252ef166abb4498c0795fab36.1535113317.git.jstancek@redhat.com
> >and my proposed workaround was http://lkml.kernel.org/r/20180829145537.GZ10223@dhcp22.suse.cz
> 
> Well, the above two links return 404.

You are right. They are not archived for some reason. Anyway, the patch
I was proposing back then is below:

commit cfb88c266b645197135cde2905c2bfc82f6d82a9
Author: Michal Hocko <mhocko@suse.com>
Date:   Wed Nov 14 12:19:09 2018 +0100

    mm: fix do_pages_move error reporting
    
    a49bd4d71637 ("mm, numa: rework do_pages_move") has changed the way how
    we report error to layers above. As the changelog mentioned the semantic
    was quite unclear previously because the return 0 could mean both
    success and failure.
    
    The above mentioned commit didn't get all the way down to fix this
    completely because it doesn't report pages that we even haven't
    attempted to migrate and therefore we cannot simply say that the
    semantic is:
    - err < 0 - errno
    - err >= 0 number of non-migrated pages.
    
    Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
    Signed-off-by: Michal Hocko <mhocko@suse.com>

diff --git a/mm/migrate.c b/mm/migrate.c
index f7e4bfdc13b7..aa53ebc523eb 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1615,8 +1615,16 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
 			goto out_flush;
 
 		err = do_move_pages_to_node(mm, &pagelist, current_node);
-		if (err)
+		if (err) {
+			/*
+			 * Possitive err means the number of failed pages to
+			 * migrate. Make sure to report the rest of the
+			 * nr_pages is not migrated as well.
+			 */
+			if (err > 0)
+				err += nr_pages - i - 1;
 			goto out;
+		}
 		if (i > start) {
 			err = store_status(status, start, current_node, i - start);
 			if (err)
-- 
Michal Hocko
SUSE Labs
