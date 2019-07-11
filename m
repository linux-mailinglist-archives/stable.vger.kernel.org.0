Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB293669BA
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 11:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfGLJN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 05:13:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:54274 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726138AbfGLJN5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 05:13:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 93769AC63;
        Fri, 12 Jul 2019 09:13:55 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 3D21A1E43CB; Thu, 11 Jul 2019 17:41:11 +0200 (CEST)
Date:   Thu, 11 Jul 2019 17:41:11 +0200
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
Message-ID: <20190711154111.GA29284@quack2.suse.cz>
References: <20190704165450.GH31037@quack2.suse.cz>
 <20190704191407.GM1729@bombadil.infradead.org>
 <CAPcyv4gUiDw8Ma9mvbW5BamQtGZxWVuvBW7UrOLa2uijrXUWaw@mail.gmail.com>
 <20190705191004.GC32320@bombadil.infradead.org>
 <CAPcyv4jVARa38Qc4NjQ04wJ4ZKJ6On9BbJgoL95wQqU-p-Xp_w@mail.gmail.com>
 <20190710190204.GB14701@quack2.suse.cz>
 <20190710201539.GN32320@bombadil.infradead.org>
 <20190710202647.GA7269@quack2.suse.cz>
 <20190711141350.GS32320@bombadil.infradead.org>
 <20190711152550.GT32320@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711152550.GT32320@bombadil.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 11-07-19 08:25:50, Matthew Wilcox wrote:
> On Thu, Jul 11, 2019 at 07:13:50AM -0700, Matthew Wilcox wrote:
> > However, the XA_RETRY_ENTRY might be a good choice.  It doesn't normally
> > appear in an XArray (it may appear if you're looking at a deleted node,
> > but since we're holding the lock, we can't see deleted nodes).
> 
...

> @@ -254,7 +267,7 @@ static void wait_entry_unlocked(struct xa_state *xas, void *entry)
>  static void put_unlocked_entry(struct xa_state *xas, void *entry)
>  {
>  	/* If we were the only waiter woken, wake the next one */
> -	if (entry)
> +	if (entry && dax_is_conflict(entry))

This should be !dax_is_conflict(entry)...

>  		dax_wake_entry(xas, entry, false);
>  }

Otherwise the patch looks good to me so feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

once you fix this.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
