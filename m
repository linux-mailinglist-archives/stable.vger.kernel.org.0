Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACFB65FC1D
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 18:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbfGDQyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 12:54:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:42728 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725865AbfGDQyw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Jul 2019 12:54:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3D1F0AD2A;
        Thu,  4 Jul 2019 16:54:51 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id D0EFC1E3F56; Thu,  4 Jul 2019 18:54:50 +0200 (CEST)
Date:   Thu, 4 Jul 2019 18:54:50 +0200
From:   Jan Kara <jack@suse.cz>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Boaz Harrosh <openosd@gmail.com>,
        stable <stable@vger.kernel.org>,
        Robert Barror <robert.barror@intel.com>,
        Seema Pandit <seema.pandit@intel.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dax: Fix missed PMD wakeups
Message-ID: <20190704165450.GH31037@quack2.suse.cz>
References: <156213869409.3910140.7715747316991468148.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190703121743.GH1729@bombadil.infradead.org>
 <CAPcyv4jgs5LTtTXR+2CyfbjJE85B_eoPFuXQsGBDnVMo41Jawg@mail.gmail.com>
 <20190703195302.GJ1729@bombadil.infradead.org>
 <CAPcyv4iPNz=oJyc_EoE-mC11=gyBzwMKbmj1ZY_Yna54=cC=Mg@mail.gmail.com>
 <20190704032728.GK1729@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190704032728.GK1729@bombadil.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 03-07-19 20:27:28, Matthew Wilcox wrote:
> On Wed, Jul 03, 2019 at 02:28:41PM -0700, Dan Williams wrote:
> > On Wed, Jul 3, 2019 at 12:53 PM Matthew Wilcox <willy@infradead.org> wrote:
> > > @@ -211,7 +215,8 @@ static void *get_unlocked_entry(struct xa_state *xas)
> > >         for (;;) {
> > >                 entry = xas_find_conflict(xas);
> > >                 if (!entry || WARN_ON_ONCE(!xa_is_value(entry)) ||
> > > -                               !dax_is_locked(entry))
> > > +                               !dax_is_locked(entry) ||
> > > +                               dax_entry_order(entry) < xas_get_order(xas))
> > 
> > Doesn't this potentially allow a locked entry to be returned for a
> > caller that expects all value entries are unlocked?
> 
> It only allows locked entries to be returned for callers which pass in
> an xas which refers to a PMD entry.  This is fine for grab_mapping_entry()
> because it checks size_flag & is_pte_entry.
> 
> dax_layout_busy_page() only uses 0-order.
> __dax_invalidate_entry() only uses 0-order.
> dax_writeback_one() needs an extra fix:
> 
>                 /* Did a PMD entry get split? */
>                 if (dax_is_locked(entry))
>                         goto put_unlocked;
> 
> dax_insert_pfn_mkwrite() checks for a mismatch of pte vs pmd.
> 
> So I think we're good for all current users.

Agreed but it is an ugly trap. As I already said, I'd rather pay the
unnecessary cost of waiting for pte entry and have an easy to understand
interface. If we ever have a real world use case that would care for this
optimization, we will need to refactor functions to make this possible and
still keep the interfaces sane. For example get_unlocked_entry() could
return special "error code" indicating that there's no entry with matching
order in xarray but there's a conflict with it. That would be much less
error-prone interface.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
