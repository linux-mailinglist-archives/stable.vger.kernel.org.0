Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 549FE65895
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 16:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbfGKONw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 10:13:52 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59354 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfGKONw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jul 2019 10:13:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=A+M9EKycY4/Na49/3ZTutvW03nTdeCovAhe5sPEc738=; b=DWaYAaHL39mYbsCRqEJ3S1QQ7
        P02squV/NBUTgulBtI4yUhtjhZPbXviXwn5cZ64a18nBrxMDqHZ9sjyzYhy8rrWsIGViUL4cuiFNR
        13jc9CGjCkCg9vUQQobNtgkPofyl56m4PinPfQAT8yXfkSrKa7TQw4y6e8ow4U8TMK37DxOKX3CX3
        TtYqXc/uTk7W5yiypMbcKX93JyA6IotJW3FcTmtHuDWAS30qOioSZlpdonSH/3GJq3YRLQ3nWrWuK
        /tXAoQynuvEE2hyzve6v52C027MqCmg4zh1ItcUY/JouC54bRwId30BRrUhafL+gbKxIhAS5QCvkO
        4gn8QmF5Q==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hlZpW-0001Os-V6; Thu, 11 Jul 2019 14:13:50 +0000
Date:   Thu, 11 Jul 2019 07:13:50 -0700
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
Message-ID: <20190711141350.GS32320@bombadil.infradead.org>
References: <CAPcyv4iPNz=oJyc_EoE-mC11=gyBzwMKbmj1ZY_Yna54=cC=Mg@mail.gmail.com>
 <20190704032728.GK1729@bombadil.infradead.org>
 <20190704165450.GH31037@quack2.suse.cz>
 <20190704191407.GM1729@bombadil.infradead.org>
 <CAPcyv4gUiDw8Ma9mvbW5BamQtGZxWVuvBW7UrOLa2uijrXUWaw@mail.gmail.com>
 <20190705191004.GC32320@bombadil.infradead.org>
 <CAPcyv4jVARa38Qc4NjQ04wJ4ZKJ6On9BbJgoL95wQqU-p-Xp_w@mail.gmail.com>
 <20190710190204.GB14701@quack2.suse.cz>
 <20190710201539.GN32320@bombadil.infradead.org>
 <20190710202647.GA7269@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190710202647.GA7269@quack2.suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 10, 2019 at 10:26:47PM +0200, Jan Kara wrote:
> On Wed 10-07-19 13:15:39, Matthew Wilcox wrote:
> > On Wed, Jul 10, 2019 at 09:02:04PM +0200, Jan Kara wrote:
> > > +#define DAX_ENTRY_CONFLICT dax_make_entry(pfn_to_pfn_t(1), DAX_EMPTY)
> > 
> > I was hoping to get rid of DAX_EMPTY ... it's almost unused now.  Once
> > we switch to having a single DAX_LOCK value instead of a single bit,
> > I think it can go away, freeing up two bits.
> > 
> > If you really want a special DAX_ENTRY_CONFLICT, I think we can make
> > one in the 2..4094 range.
> > 
> > That aside, this looks pretty similar to the previous patch I sent, so
> > if you're now happy with this, let's add
> > 
> > #define XA_DAX_CONFLICT_ENTRY xa_mk_internal(258)
> > 
> > to xarray.h and do it that way?
> 
> Yeah, that would work for me as well. The chosen value for DAX_ENTRY_CONFLICT
> was pretty arbitrary. Or we could possibly use:
> 
> #define DAX_ENTRY_CONFLICT XA_ZERO_ENTRY
> 
> so that we don't leak DAX-specific internal definition into xarray.h?

I don't want to use the ZERO entry as our conflict marker because that
could legitimately appear in an XArray.  Not the i_pages XArray today,
but I hold out hope for using that in place of the DAX_ZERO_PAGE bit too.
That's going to be a bit more tricky since we currently distinguish
between DAX_ZERO_PAGE and DAX_ZERO_PAGE | DAX_PMD.

However, the XA_RETRY_ENTRY might be a good choice.  It doesn't normally
appear in an XArray (it may appear if you're looking at a deleted node,
but since we're holding the lock, we can't see deleted nodes).
