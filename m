Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCD664D59
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 22:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfGJUPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 16:15:43 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56876 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727004AbfGJUPm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jul 2019 16:15:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=TneDxC5vwBl8tHPTt+hx98vFK0V+NjAtmdMURbie6aI=; b=QqvxyQ/jMxX71GYdnj31MmGR3
        gIeJSHz2uz8UcrOq92xcYenNrHWfTRttrl8uNx0ZY7g8+Mi6O6xNLYFgO6U+xPGX2Z3tLw27LrBFJ
        T2hi2lw1l7NolR2u0V2g6AIHX0/ntXI0IzAJr+3kRrvMvE4fRFIr+k5ALWRNkPqYpQ/4QWeSrgwRs
        kL7nQZOfsqMlSEhJnJ9JWLQOg44dVC2RR1CyJoj8Z3FoBUdzke07RP1i9jfFZv8cby6i0dO1JHT2r
        lNoRSvHeaGzI1GutlMvAtMFOCgnf+e3IAwlWb1XMvGcu8E9KqyqN3MhbPqJCcrCTekvfQUy2maHjs
        2LtCZGABg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hlJ07-0006Cj-UN; Wed, 10 Jul 2019 20:15:39 +0000
Date:   Wed, 10 Jul 2019 13:15:39 -0700
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
Message-ID: <20190710201539.GN32320@bombadil.infradead.org>
References: <CAPcyv4jgs5LTtTXR+2CyfbjJE85B_eoPFuXQsGBDnVMo41Jawg@mail.gmail.com>
 <20190703195302.GJ1729@bombadil.infradead.org>
 <CAPcyv4iPNz=oJyc_EoE-mC11=gyBzwMKbmj1ZY_Yna54=cC=Mg@mail.gmail.com>
 <20190704032728.GK1729@bombadil.infradead.org>
 <20190704165450.GH31037@quack2.suse.cz>
 <20190704191407.GM1729@bombadil.infradead.org>
 <CAPcyv4gUiDw8Ma9mvbW5BamQtGZxWVuvBW7UrOLa2uijrXUWaw@mail.gmail.com>
 <20190705191004.GC32320@bombadil.infradead.org>
 <CAPcyv4jVARa38Qc4NjQ04wJ4ZKJ6On9BbJgoL95wQqU-p-Xp_w@mail.gmail.com>
 <20190710190204.GB14701@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190710190204.GB14701@quack2.suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 10, 2019 at 09:02:04PM +0200, Jan Kara wrote:
> +#define DAX_ENTRY_CONFLICT dax_make_entry(pfn_to_pfn_t(1), DAX_EMPTY)

I was hoping to get rid of DAX_EMPTY ... it's almost unused now.  Once
we switch to having a single DAX_LOCK value instead of a single bit,
I think it can go away, freeing up two bits.

If you really want a special DAX_ENTRY_CONFLICT, I think we can make
one in the 2..4094 range.

That aside, this looks pretty similar to the previous patch I sent, so
if you're now happy with this, let's add

#define XA_DAX_CONFLICT_ENTRY xa_mk_internal(258)

to xarray.h and do it that way?
