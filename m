Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC7AE652E0
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 10:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbfGKIKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 04:10:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:38514 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728055AbfGKIKh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jul 2019 04:10:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 039EBADEC;
        Thu, 11 Jul 2019 08:10:35 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 8129F1E43B9; Thu, 11 Jul 2019 10:06:49 +0200 (CEST)
Date:   Thu, 11 Jul 2019 10:06:49 +0200
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
Message-ID: <20190711080649.GB8727@quack2.suse.cz>
References: <20190703195302.GJ1729@bombadil.infradead.org>
 <CAPcyv4iPNz=oJyc_EoE-mC11=gyBzwMKbmj1ZY_Yna54=cC=Mg@mail.gmail.com>
 <20190704032728.GK1729@bombadil.infradead.org>
 <20190704165450.GH31037@quack2.suse.cz>
 <20190704191407.GM1729@bombadil.infradead.org>
 <CAPcyv4gUiDw8Ma9mvbW5BamQtGZxWVuvBW7UrOLa2uijrXUWaw@mail.gmail.com>
 <20190705191004.GC32320@bombadil.infradead.org>
 <CAPcyv4jVARa38Qc4NjQ04wJ4ZKJ6On9BbJgoL95wQqU-p-Xp_w@mail.gmail.com>
 <20190710190204.GB14701@quack2.suse.cz>
 <20190711033555.GP32320@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711033555.GP32320@bombadil.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 10-07-19 20:35:55, Matthew Wilcox wrote:
> On Wed, Jul 10, 2019 at 09:02:04PM +0200, Jan Kara wrote:
> > So how about the attached patch? That keeps the interface sane and passes a
> > smoketest for me (full fstest run running). Obviously it also needs a
> > proper changelog...
> 
> Changelog and slightly massaged version along the lines of my two comments
> attached.
> 

> From 57b63fdd38e7bea7eb8d6332f0163fb028570def Mon Sep 17 00:00:00 2001
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Date: Wed, 3 Jul 2019 23:21:25 -0400
> Subject: [PATCH] dax: Fix missed wakeup with PMD faults
> 
> RocksDB can hang indefinitely when using a DAX file.  This is due to
> a bug in the XArray conversion when handling a PMD fault and finding a
> PTE entry.  We use the wrong index in the hash and end up waiting on
> the wrong waitqueue.
> 
> There's actually no need to wait; if we find a PTE entry while looking
> for a PMD entry, we can return immediately as we know we should fall
> back to a PTE fault (which may not conflict with the lock held).
> 
> Cc: stable@vger.kernel.org
> Fixes: b15cd800682f ("dax: Convert page fault handlers to XArray")
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Just one nit below. Otherwise feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

> diff --git a/include/linux/xarray.h b/include/linux/xarray.h
> index 052e06ff4c36..fb25452bcfa4 100644
> --- a/include/linux/xarray.h
> +++ b/include/linux/xarray.h
> @@ -169,7 +169,9 @@ static inline bool xa_is_internal(const void *entry)
>  	return ((unsigned long)entry & 3) == 2;
>  }
>  
> +#define XA_RETRY_ENTRY		xa_mk_internal(256)
>  #define XA_ZERO_ENTRY		xa_mk_internal(257)
> +#define XA_DAX_CONFLICT_ENTRY	xa_mk_internal(258)
>  
>  /**
>   * xa_is_zero() - Is the entry a zero entry?

As I wrote in my previous email, won't it be nicer if we just defined
DAX_CONFLICT_ENTRY (or however we name it) inside dax code say to
XA_ZERO_ENTRY?  Generic xarray code just doesn't care about that value and
I can imagine in future there'll be other xarray user's who'd like to have
some special value(s) for use similarly to DAX and we don't want to clutter
xarray definitions with those as well. If you don't like XA_ZERO_ENTRY, I
could also imagine having XA_USER_RESERVED value that's guaranteed to be
unused by xarray and we'd define DAX_CONFLICT_ENTRY to it. Overall I don't
care too much so I can live even with what you have now but it would seem
cleaner that way to me.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
