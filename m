Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45AF260BAF
	for <lists+stable@lfdr.de>; Fri,  5 Jul 2019 21:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfGETKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jul 2019 15:10:06 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35942 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbfGETKG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jul 2019 15:10:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=EGciiAfUZu4b3fEglw6XcqsQQG6KIsG3g+Abpu+FGcc=; b=q6cuV4FVyerS5GtL9eE2t1Nrc
        NCb2xvPEOSjtUeGat2omaXxzniC8otZYUiJ9T6jRU2MInCad8e2nCezr03HZfIJelfo3jpGz7yiV7
        Ug0wR2FkRVL5Hg1ZhkNSPfsnDvpKTFFgSMArsoma17ZgsW6sWCtFV1xJR15S9amNN/VPb16jbY/t1
        Bg0J94kosDhKMjvKhCx6IxrJpsIWWd7+iQn5oU/NUUtibo5cRF+FgoGxkF3dBdSBALUDwVgS82S/t
        a7ynl4PnoHLGfG7p4FojGP3dmOSKJG3z3z6sXM9rKcBADT+PVdxthlzletU8vfazaMoQX9p68L7sn
        NkmNoa+vg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hjTau-0001Z3-OR; Fri, 05 Jul 2019 19:10:04 +0000
Date:   Fri, 5 Jul 2019 12:10:04 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Jan Kara <jack@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Boaz Harrosh <openosd@gmail.com>,
        stable <stable@vger.kernel.org>,
        Robert Barror <robert.barror@intel.com>,
        Seema Pandit <seema.pandit@intel.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dax: Fix missed PMD wakeups
Message-ID: <20190705191004.GC32320@bombadil.infradead.org>
References: <156213869409.3910140.7715747316991468148.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190703121743.GH1729@bombadil.infradead.org>
 <CAPcyv4jgs5LTtTXR+2CyfbjJE85B_eoPFuXQsGBDnVMo41Jawg@mail.gmail.com>
 <20190703195302.GJ1729@bombadil.infradead.org>
 <CAPcyv4iPNz=oJyc_EoE-mC11=gyBzwMKbmj1ZY_Yna54=cC=Mg@mail.gmail.com>
 <20190704032728.GK1729@bombadil.infradead.org>
 <20190704165450.GH31037@quack2.suse.cz>
 <20190704191407.GM1729@bombadil.infradead.org>
 <CAPcyv4gUiDw8Ma9mvbW5BamQtGZxWVuvBW7UrOLa2uijrXUWaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gUiDw8Ma9mvbW5BamQtGZxWVuvBW7UrOLa2uijrXUWaw@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 04, 2019 at 04:27:14PM -0700, Dan Williams wrote:
> On Thu, Jul 4, 2019 at 12:14 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Thu, Jul 04, 2019 at 06:54:50PM +0200, Jan Kara wrote:
> > > On Wed 03-07-19 20:27:28, Matthew Wilcox wrote:
> > > > So I think we're good for all current users.
> > >
> > > Agreed but it is an ugly trap. As I already said, I'd rather pay the
> > > unnecessary cost of waiting for pte entry and have an easy to understand
> > > interface. If we ever have a real world use case that would care for this
> > > optimization, we will need to refactor functions to make this possible and
> > > still keep the interfaces sane. For example get_unlocked_entry() could
> > > return special "error code" indicating that there's no entry with matching
> > > order in xarray but there's a conflict with it. That would be much less
> > > error-prone interface.
> >
> > This is an internal interface.  I think it's already a pretty gnarly
> > interface to use by definition -- it's going to sleep and might return
> > almost anything.  There's not much scope for returning an error indicator
> > either; value entries occupy half of the range (all odd numbers between 1
> > and ULONG_MAX inclusive), plus NULL.  We could use an internal entry, but
> > I don't think that makes the interface any easier to use than returning
> > a locked entry.
> >
> > I think this iteration of the patch makes it a little clearer.  What do you
> > think?
> >
> 
> Not much clearer to me. get_unlocked_entry() is now misnamed and this

misnamed?  You'd rather it was called "try_get_unlocked_entry()"?

> arrangement allows for mismatches of @order argument vs @xas
> configuration.

> Can you describe, or even better demonstrate with
> numbers, why it's better to carry this complication than just
> converging the waitqueues between the types?

You've got the reproducer ;-)  It seems quite wrong to make a page fault
stall just because another task is working on a different page in the
same 2MB chunk.
