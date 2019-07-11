Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2968657E3
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 15:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbfGKN2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 09:28:39 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49064 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727956AbfGKN2j (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jul 2019 09:28:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qQDTG34nBen/nM9O8f+a+MBGBH0+G5+6en1FIsdsBzQ=; b=W+v4En8WpGKHHhb5uk9cn5YEj
        gMBk1sMls9oDVSUMnffjOdYoC42wy0L2mrdb8o+2nRCt3WJcfJWdpJmZdwFH7zES2pWupJCUFZdpd
        +I0ZEZ52/7VuJmRzXFkuCHrqNnocufRvwVqTWFL84Zv2FBGtFMXone6sHQPuWsD3NHowMNRs2z0f7
        EEm1jKIO9RQ8O8rAIcVGKaJlZ7YjDe4dFqP6S38khRcqg/4f/fhU2/h5XGx35pJ4tyHd/WIhuiZAS
        fepWgCd+ombLf62ZVAnnAYieZTutsx+4AKG4jD7zCntmeAryEPk4KQ+vNqva9zXi8VGg4PP5+X3Ao
        VyIPQLmeg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hlZ7k-0002ft-Fx; Thu, 11 Jul 2019 13:28:36 +0000
Date:   Thu, 11 Jul 2019 06:28:36 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Jan Kara <jack@suse.cz>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Boaz Harrosh <openosd@gmail.com>,
        stable <stable@vger.kernel.org>,
        Robert Barror <robert.barror@intel.com>,
        Seema Pandit <seema.pandit@intel.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dax: Fix missed PMD wakeups
Message-ID: <20190711132836.GR32320@bombadil.infradead.org>
References: <CAPcyv4iPNz=oJyc_EoE-mC11=gyBzwMKbmj1ZY_Yna54=cC=Mg@mail.gmail.com>
 <20190704032728.GK1729@bombadil.infradead.org>
 <20190704165450.GH31037@quack2.suse.cz>
 <20190704191407.GM1729@bombadil.infradead.org>
 <CAPcyv4gUiDw8Ma9mvbW5BamQtGZxWVuvBW7UrOLa2uijrXUWaw@mail.gmail.com>
 <20190705191004.GC32320@bombadil.infradead.org>
 <CAPcyv4jVARa38Qc4NjQ04wJ4ZKJ6On9BbJgoL95wQqU-p-Xp_w@mail.gmail.com>
 <20190710190204.GB14701@quack2.suse.cz>
 <20190711030855.GO32320@bombadil.infradead.org>
 <20190711074859.GA8727@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711074859.GA8727@quack2.suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 11, 2019 at 09:48:59AM +0200, Jan Kara wrote:
> On Wed 10-07-19 20:08:55, Matthew Wilcox wrote:
> > On Wed, Jul 10, 2019 at 09:02:04PM +0200, Jan Kara wrote:
> > > @@ -848,7 +853,7 @@ static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
> > >  	if (unlikely(dax_is_locked(entry))) {
> > >  		void *old_entry = entry;
> > >  
> > > -		entry = get_unlocked_entry(xas);
> > > +		entry = get_unlocked_entry(xas, 0);
> > >  
> > >  		/* Entry got punched out / reallocated? */
> > >  		if (!entry || WARN_ON_ONCE(!xa_is_value(entry)))
> > 
> > I'm not sure about this one.  Are we sure there will never be a dirty
> > PMD entry?  Even if we can't create one today, it feels like a bit of
> > a landmine to leave for someone who creates one in the future.
> 
> I was thinking about this but dax_writeback_one() doesn't really care what
> entry it gets. Yes, in theory it could get a PMD when previously there was
> PTE or vice-versa but we check that PFN's match and if they really do
> match, there's no harm in doing the flushing whatever entry we got back...
> And the checks are simpler this way.

That's fair.  I'll revert this part to the way you had it.

I actually want to get rid of the PFN match check too; it doesn't really
buy us much.  We already check whether the TOWRITE bit is set, and that
should accomplish the same thing.
