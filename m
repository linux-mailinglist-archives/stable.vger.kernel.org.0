Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD5CB652E2
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 10:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbfGKIKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 04:10:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:38512 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727929AbfGKIKg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jul 2019 04:10:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F3036AD4D;
        Thu, 11 Jul 2019 08:10:34 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id B5BB21E43B7; Wed, 10 Jul 2019 22:26:47 +0200 (CEST)
Date:   Wed, 10 Jul 2019 22:26:47 +0200
From:   Jan Kara <jack@suse.cz>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Boaz Harrosh <openosd@gmail.com>,
        stable <stable@vger.kernel.org>,
        Robert Barror <robert.barror@intel.com>,
        Seema Pandit <seema.pandit@intel.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dax: Fix missed PMD wakeups
Message-ID: <20190710202647.GA7269@quack2.suse.cz>
References: <20190703195302.GJ1729@bombadil.infradead.org>
 <CAPcyv4iPNz=oJyc_EoE-mC11=gyBzwMKbmj1ZY_Yna54=cC=Mg@mail.gmail.com>
 <20190704032728.GK1729@bombadil.infradead.org>
 <20190704165450.GH31037@quack2.suse.cz>
 <20190704191407.GM1729@bombadil.infradead.org>
 <CAPcyv4gUiDw8Ma9mvbW5BamQtGZxWVuvBW7UrOLa2uijrXUWaw@mail.gmail.com>
 <20190705191004.GC32320@bombadil.infradead.org>
 <CAPcyv4jVARa38Qc4NjQ04wJ4ZKJ6On9BbJgoL95wQqU-p-Xp_w@mail.gmail.com>
 <20190710190204.GB14701@quack2.suse.cz>
 <20190710201539.GN32320@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190710201539.GN32320@bombadil.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 10-07-19 13:15:39, Matthew Wilcox wrote:
> On Wed, Jul 10, 2019 at 09:02:04PM +0200, Jan Kara wrote:
> > +#define DAX_ENTRY_CONFLICT dax_make_entry(pfn_to_pfn_t(1), DAX_EMPTY)
> 
> I was hoping to get rid of DAX_EMPTY ... it's almost unused now.  Once
> we switch to having a single DAX_LOCK value instead of a single bit,
> I think it can go away, freeing up two bits.
> 
> If you really want a special DAX_ENTRY_CONFLICT, I think we can make
> one in the 2..4094 range.
> 
> That aside, this looks pretty similar to the previous patch I sent, so
> if you're now happy with this, let's add
> 
> #define XA_DAX_CONFLICT_ENTRY xa_mk_internal(258)
> 
> to xarray.h and do it that way?

Yeah, that would work for me as well. The chosen value for DAX_ENTRY_CONFLICT
was pretty arbitrary. Or we could possibly use:

#define DAX_ENTRY_CONFLICT XA_ZERO_ENTRY

so that we don't leak DAX-specific internal definition into xarray.h?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
