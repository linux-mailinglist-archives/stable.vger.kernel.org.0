Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFB3B145AE0
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 18:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgAVRfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 12:35:38 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38588 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgAVRfi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 12:35:38 -0500
Received: by mail-wr1-f67.google.com with SMTP id y17so8240608wrh.5;
        Wed, 22 Jan 2020 09:35:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9Pe/uYHnvD7wJ1+X4A+H8G503m8mWdzB/nxe1uw/mAQ=;
        b=cPny9QGG+qiY9urdA/wATYOk3CKhC3JlSeTXymy69lqgOSheNGOtJhIGjAd7bYIrN+
         7/W5W7XMGdKidr+iVlhB3DVruCc+AqckV8rtPgIOSr38HoNaTxkz9QM80ktTXyM76faH
         j8LocTMqfgOQ4r7uf9/gbbBz6ic9A4Pu2Ln5+LrY6qf2iidQ6MaH33q3a0xqKiYBDtJg
         LO7vZRpfWeZb/K8e+9yj5Q6IlwSr3x8X7ym4Pzm9MIRnWM3LECzKHlwG9oCGfqBNVF2m
         jQL+ygmJytXyp5HcJ/n29+UhMT1VBLdEtjGrI1wyG/H6GGbYO5ugr+NONPPoWpndeqZr
         ebWQ==
X-Gm-Message-State: APjAAAXNtIYWJ6oxis/WfVhEr6rv4IZ0osiPT50qXdcc0lboCdxOpf+c
        Dg7LChzUmBjZwpmiCGiobuKUwOX8
X-Google-Smtp-Source: APXvYqzg4A5jYG+OTYsXFOx3mFiR8QHqyAw7pd8bR5fs8YrtdTrdd3elR1SXpbXC3Bkkw1qPvLxDKA==
X-Received: by 2002:a5d:51c1:: with SMTP id n1mr11886367wrv.335.1579714535488;
        Wed, 22 Jan 2020 09:35:35 -0800 (PST)
Received: from localhost (ip-37-188-245-167.eurotel.cz. [37.188.245.167])
        by smtp.gmail.com with ESMTPSA id z123sm4893496wme.18.2020.01.22.09.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 09:35:33 -0800 (PST)
Date:   Wed, 22 Jan 2020 18:35:32 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Yang Shi <yang.shi@linux.alibaba.com>
Cc:     Wei Yang <richardw.yang@linux.intel.com>,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: move_pages: fix the return value if there are
 not-migrated pages
Message-ID: <20200122173532.GZ29276@dhcp22.suse.cz>
References: <1579325203-16405-1-git-send-email-yang.shi@linux.alibaba.com>
 <20200120130624.GD18451@dhcp22.suse.cz>
 <20200120131744.GE18451@dhcp22.suse.cz>
 <20200121014416.GC1567@richard>
 <20200121084040.GC29276@dhcp22.suse.cz>
 <27b993f4-cc50-d5a9-1cda-89dd022aea16@linux.alibaba.com>
 <20200122080651.GN29276@dhcp22.suse.cz>
 <17d51bf6-3cdf-bade-c32a-add30b8a7214@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17d51bf6-3cdf-bade-c32a-add30b8a7214@linux.alibaba.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 22-01-20 09:26:48, Yang Shi wrote:
> 
> 
> On 1/22/20 12:06 AM, Michal Hocko wrote:
> > On Tue 21-01-20 11:01:30, Yang Shi wrote:
> > > 
> > > On 1/21/20 12:40 AM, Michal Hocko wrote:
> > > > On Tue 21-01-20 09:44:16, Wei Yang wrote:
> > > > > On Mon, Jan 20, 2020 at 02:17:44PM +0100, Michal Hocko wrote:
> > > > > > On Mon 20-01-20 14:06:26, Michal Hocko wrote:
> > > > > > > On Sat 18-01-20 13:26:43, Yang Shi wrote:
> > > > > > > > The do_move_pages_to_node() might return > 0 value, the number of pages
> > > > > > > > that are not migrated, then the value will be returned to userspace
> > > > > > > > directly.  But, move_pages() syscall would just return 0 or errno.  So,
> > > > > > > > we need reset the return value to 0 for such case as what pre-v4.17 did.
> > > > > > > The patch is wrong. migrate_pages returns the number of pages it
> > > > > > > _hasn't_ migrated or -errno. Yeah that semantic sucks but...
> > > > > > > So err != 0 is always an error. Except err > 0 doesn't really provide
> > > > > > > any useful information to the userspace. I cannot really remember what
> > > > > > > was the actual behavior before my rework because there were some gotchas
> > > > > > > hidden there.
> > > > > > OK, so I've double checked. do_move_page_to_node_array would carry the
> > > > > > error code over to do_pages_move and it would store the status stored
> > > > > > in the pm array. It contains page_to_nid(page) so the resulting code
> > > > > > indeed behaves properly before my change and this is a regression. I
> > > > > Thanks, I see the change.
> > > > > 
> > > > > > have a very vague recollection that this has been brought up already.
> > > > > > <...looks in notes...>
> > > > > > Found it! The report is
> > > > > > http://lkml.kernel.org/r/0329efa0984b9b0252ef166abb4498c0795fab36.1535113317.git.jstancek@redhat.com
> > > > > > and my proposed workaround was http://lkml.kernel.org/r/20180829145537.GZ10223@dhcp22.suse.cz
> > > > > Well, the above two links return 404.
> > > > You are right. They are not archived for some reason. Anyway, the patch
> > > > I was proposing back then is below:
> > > > 
> > > > commit cfb88c266b645197135cde2905c2bfc82f6d82a9
> > > > Author: Michal Hocko <mhocko@suse.com>
> > > > Date:   Wed Nov 14 12:19:09 2018 +0100
> > > > 
> > > >       mm: fix do_pages_move error reporting
> > > >       a49bd4d71637 ("mm, numa: rework do_pages_move") has changed the way how
> > > >       we report error to layers above. As the changelog mentioned the semantic
> > > >       was quite unclear previously because the return 0 could mean both
> > > >       success and failure.
> > > >       The above mentioned commit didn't get all the way down to fix this
> > > >       completely because it doesn't report pages that we even haven't
> > > >       attempted to migrate and therefore we cannot simply say that the
> > > >       semantic is:
> > > >       - err < 0 - errno
> > > >       - err >= 0 number of non-migrated pages.
> > > >       Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
> > > >       Signed-off-by: Michal Hocko <mhocko@suse.com>
> > > Thanks, Michal. But, it looks this patch still could return > 0 value (the
> > > total number of non-migrated pages, including not even attempted pages) too,
> > > but the problem we are trying to fix is to make do_pages_move() return <= 0
> > > value only since the man page of move_pages() doesn't allow return > 0
> > > value.
> > Yes this patch just lives with the changed semantic and tries to make it
> > sensible. So if some page cannot be migrated then we just stop and
> > return the number of non migrated pages at the tail of the given array.
> > This would make error handling slightly easier because you know that
> > count - ret pages of the array can be skipped if ret >= 0.
> 
> OK, I see. Returning > 0 value sounds more straightforward for userspace
> error handling.
> 
> BTW, we should update manpage to reflect the semantic change to indicate > 0
> return value as an error case.

Absolutely. 
 
> > > And, by looking into the old code (v4.16), I spotted another problem. The
> > > migrate_pages() would store the migration failure error code into
> > > page_to_node->status. So, When do_move_page_to_node_array() returns > 0
> > > value, the return value would be reset to 0 and the migration error codes
> > > for non-migrated pages would be stored into status to return to userspace.
> > > But, the rework removed this.
> > > 
> > > I didn't dig into the intention of the rework, is it expected?
> > I have tried to preserve the original semantic as possible. As explained
> > in the changelog there were quite some discrepancies even before. This
> > new one was not really intentional. We have effectively two options
> > here. Either somebody really depend on the former semantic and we have
> > to fix this or we can relax the semantic as the above patch attempts.
> > 
> > I would be more inclined for the second option as nobody has complained
> > about the new semantic except for few ltp tests which do not represent
> > real workload. If you have a real usecase then speak up please.
> 
> No, I don't have any real usecase. And, I tend to agree the most users may
> not care the reason of migration failure at all. Returning the number of
> non-migrated pages seems more straightforward.
> 
> I agree we could stick with the new semantic and fix the return value as
> what your patch did. I'm going to rebase your patch on top of Wei Yang's
> cleanup if you don't mind.
 
Go ahead. Thanks a lot!

-- 
Michal Hocko
SUSE Labs
