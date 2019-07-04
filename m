Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA90E5F1C5
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 05:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbfGDD1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 23:27:30 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59376 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbfGDD1a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jul 2019 23:27:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bfUuotpsA7QM4d+GD8HA3DqaH0YT4JnSqveOPEJHZmE=; b=DYj+iswCGfqMvh6Vcet5Evj0Y
        GsyD8CyUisYULDtQjbA5vGZ/hNXgspOgh006SQe1+qr7TZT1AYlYjAkdkiYkjFqTvS8LExPkDsSrr
        uw06xq/QsEuX5TQP7ma8p2d9Mx/iXMiWVC7aIfPC7vnXkkQD9TrdwQwkpdfYAkHIxKz2R1N70Z84l
        3xhXHDMy3VQY/86p5LEXocdyG1zM5kB6mQK24lQ51xK5okoPAGeaUuzjsH1kNEoroTvfk1i+U9esr
        G1GFk7RgJtLXqaHP8ZjaorampgpGJFFeAUoYwGLs6Y46p0O2fTKSxrdtPrKaMQi4oYQhBc4pdeaaj
        BiqQpmSNA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hisPA-0006Hf-Tn; Thu, 04 Jul 2019 03:27:28 +0000
Date:   Wed, 3 Jul 2019 20:27:28 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Boaz Harrosh <openosd@gmail.com>,
        stable <stable@vger.kernel.org>,
        Robert Barror <robert.barror@intel.com>,
        Seema Pandit <seema.pandit@intel.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dax: Fix missed PMD wakeups
Message-ID: <20190704032728.GK1729@bombadil.infradead.org>
References: <156213869409.3910140.7715747316991468148.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190703121743.GH1729@bombadil.infradead.org>
 <CAPcyv4jgs5LTtTXR+2CyfbjJE85B_eoPFuXQsGBDnVMo41Jawg@mail.gmail.com>
 <20190703195302.GJ1729@bombadil.infradead.org>
 <CAPcyv4iPNz=oJyc_EoE-mC11=gyBzwMKbmj1ZY_Yna54=cC=Mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4iPNz=oJyc_EoE-mC11=gyBzwMKbmj1ZY_Yna54=cC=Mg@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 03, 2019 at 02:28:41PM -0700, Dan Williams wrote:
> On Wed, Jul 3, 2019 at 12:53 PM Matthew Wilcox <willy@infradead.org> wrote:
> > @@ -211,7 +215,8 @@ static void *get_unlocked_entry(struct xa_state *xas)
> >         for (;;) {
> >                 entry = xas_find_conflict(xas);
> >                 if (!entry || WARN_ON_ONCE(!xa_is_value(entry)) ||
> > -                               !dax_is_locked(entry))
> > +                               !dax_is_locked(entry) ||
> > +                               dax_entry_order(entry) < xas_get_order(xas))
> 
> Doesn't this potentially allow a locked entry to be returned for a
> caller that expects all value entries are unlocked?

It only allows locked entries to be returned for callers which pass in
an xas which refers to a PMD entry.  This is fine for grab_mapping_entry()
because it checks size_flag & is_pte_entry.

dax_layout_busy_page() only uses 0-order.
__dax_invalidate_entry() only uses 0-order.
dax_writeback_one() needs an extra fix:

                /* Did a PMD entry get split? */
                if (dax_is_locked(entry))
                        goto put_unlocked;

dax_insert_pfn_mkwrite() checks for a mismatch of pte vs pmd.

So I think we're good for all current users.

> > +#ifdef CONFIG_XARRAY_MULTI
> > +       unsigned int sibs = xas->xa_sibs;
> > +
> > +       while (sibs) {
> > +               order++;
> > +               sibs /= 2;
> > +       }
> 
> Use ilog2() here?

Thought about it.  sibs is never going to be more than 31, so I don't
know that it's worth eliminating 5 add/shift pairs in favour of whatever
the ilog2 instruction is on a given CPU.  In practice, on x86, sibs is
going to be either 0 (PTEs) or 7 (PMDs).  We could also avoid even having
this function by passing PMD_ORDER or PTE_ORDER into get_unlocked_entry().

It's probably never going to be noticable in this scenario because it's
the very last thing checked before we put ourselves on a waitqueue and
go to sleep.
