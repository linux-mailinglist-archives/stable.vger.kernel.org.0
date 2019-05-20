Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9CC22D6C
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 09:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728958AbfETHwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 03:52:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:47656 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727733AbfETHwb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 03:52:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4247CAF31;
        Mon, 20 May 2019 07:52:30 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 5D54B1E3ED6; Mon, 20 May 2019 09:52:32 +0200 (CEST)
Date:   Mon, 20 May 2019 09:52:32 +0200
From:   Jan Kara <jack@suse.cz>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Kees Cook <keescook@chromium.org>, Jan Kara <jack@suse.cz>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        stable <stable@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Wilcox <willy@infradead.org>,
        Jeff Smits <jeff.smits@intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libnvdimm/pmem: Bypass CONFIG_HARDENED_USERCOPY overhead
Message-ID: <20190520075232.GA30972@quack2.suse.cz>
References: <155805321833.867447.3864104616303535270.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190517084739.GB20550@quack2.suse.cz>
 <CAPcyv4iZZCgcC657ZOysBP9=1ejp3jfFj=VETVBPrgmfg7xUEw@mail.gmail.com>
 <201905170855.8E2E1AC616@keescook>
 <CAPcyv4g9HpMaifC+Qe2RVbgL_qq9vQvjwr-Jw813xhxcviehYQ@mail.gmail.com>
 <201905171225.29F9564BA2@keescook>
 <CAPcyv4iSeUPWFeSZW-dmYz9TnWhqVCx1Y1VjtUv+125_ZSQaYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4iSeUPWFeSZW-dmYz9TnWhqVCx1Y1VjtUv+125_ZSQaYg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat 18-05-19 21:46:03, Dan Williams wrote:
> On Fri, May 17, 2019 at 12:25 PM Kees Cook <keescook@chromium.org> wrote:
> > On Fri, May 17, 2019 at 10:28:48AM -0700, Dan Williams wrote:
> > > It seems dax_iomap_actor() is not a path where we'd be worried about
> > > needing hardened user copy checks.
> >
> > I would agree: I think the proposed patch makes sense. :)
> 
> Sounds like an acked-by to me.

Yeah, if Kees agrees, I'm fine with skipping the checks as well. I just
wanted that to be clarified. Also it helped me that you wrote:

That routine (dax_iomap_actor()) validates that the logical file offset is
within bounds of the file, then it does a sector-to-pfn translation which
validates that the physical mapping is within bounds of the block device.

That is more specific than "dax_iomap_actor() takes care of necessary
checks" which was in the changelog. And the above paragraph helped me
clarify which checks in dax_iomap_actor() you think replace those usercopy
checks. So I think it would be good to add that paragraph to those
copy_from_pmem() functions as a comment just in case we are wondering in
the future why we are skipping the checks... Also feel free to add:

Acked-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
