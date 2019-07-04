Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8465FBFF
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 18:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbfGDQki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 12:40:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:40190 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726880AbfGDQki (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Jul 2019 12:40:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F0586AEF5;
        Thu,  4 Jul 2019 16:40:36 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 936671E3F56; Thu,  4 Jul 2019 18:40:36 +0200 (CEST)
Date:   Thu, 4 Jul 2019 18:40:36 +0200
From:   Jan Kara <jack@suse.cz>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>,
        Seema Pandit <seema.pandit@intel.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Robert Barror <robert.barror@intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] filesystem-dax: Disable PMD support
Message-ID: <20190704164036.GG31037@quack2.suse.cz>
References: <CAPcyv4h6HgNE38RF5TxO3C268ZvrxgcPNrPWOt94MnO5gP_pjw@mail.gmail.com>
 <CAPcyv4gwd1_VHk_MfHeNSxyH+N1=aatj9WkKXqYNPkSXe4bFDg@mail.gmail.com>
 <20190627195948.GB4286@bombadil.infradead.org>
 <CAPcyv4iB3f1hDdCsw=Cy234dP-RXpxGyXDoTwEU8nt5qUDEVQg@mail.gmail.com>
 <20190629160336.GB1180@bombadil.infradead.org>
 <CAPcyv4ge3Ht1k_v=tSoVA6hCzKg1N3imhs_rTL3oTB+5_KC8_Q@mail.gmail.com>
 <CAA9_cmcb-Prn6CnOx-mJfb9CRdf0uG9u4M1Vq1B1rKVemCD-Vw@mail.gmail.com>
 <20190630152324.GA15900@bombadil.infradead.org>
 <20190701121119.GE31621@quack2.suse.cz>
 <20190703154700.GI1729@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703154700.GI1729@bombadil.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 03-07-19 08:47:00, Matthew Wilcox wrote:
> On Mon, Jul 01, 2019 at 02:11:19PM +0200, Jan Kara wrote:
> > BTW, looking into the xarray code, I think I found another difference
> > between the old radix tree code and the new xarray code that could cause
> > issues. In the old radix tree code if we tried to insert PMD entry but
> > there was some PTE entry in the covered range, we'd get EEXIST error back
> > and the DAX fault code relies on this. I don't see how similar behavior is
> > achieved by xas_store()...
> 
> Are you referring to this?
> 
> -               entry = dax_make_locked(0, size_flag | DAX_EMPTY);
> -
> -               err = __radix_tree_insert(&mapping->i_pages, index,
> -                               dax_entry_order(entry), entry);
> -               radix_tree_preload_end();
> -               if (err) {
> -                       xa_unlock_irq(&mapping->i_pages);
> -                       /*
> -                        * Our insertion of a DAX entry failed, most likely
> -                        * because we were inserting a PMD entry and it
> -                        * collided with a PTE sized entry at a different
> -                        * index in the PMD range.  We haven't inserted
> -                        * anything into the radix tree and have no waiters to
> -                        * wake.
> -                        */
> -                       return ERR_PTR(err);
> -               }

Mostly yes.

> If so, that can't happen any more because we no longer drop the i_pages
> lock while the entry is NULL, so the entry is always locked while the
> i_pages lock is dropped.

Ah, I have misinterpretted what xas_find_conflict() does. I'm sorry for the
noise. I find it somewhat unfortunate that xas_find_conflict() will not
return in any way the index where it has found the conflicting entry. We
could then use it for the wait logic as well and won't have to resort to
some masking tricks...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
