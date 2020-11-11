Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A1E2AF3D6
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 15:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgKKOkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 09:40:13 -0500
Received: from imap2.colo.codethink.co.uk ([78.40.148.184]:59098 "EHLO
        imap2.colo.codethink.co.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727307AbgKKOkL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 09:40:11 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126] helo=xylophone)
        by imap2.colo.codethink.co.uk with esmtpsa  (Exim 4.92 #3 (Debian))
        id 1kcrHb-0003fe-DW; Wed, 11 Nov 2020 14:39:35 +0000
Message-ID: <b51433b08042307ddbbdcb818bc5eab0d4cb8bec.camel@codethink.co.uk>
Subject: Re: [PATCH 4.19 19/71] btrfs: extent_io: add proper error handling
 to lock_extent_buffer_for_io()
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Date:   Wed, 11 Nov 2020 14:39:34 +0000
In-Reply-To: <20201111124448.GA26508@amd>
References: <20201109125019.906191744@linuxfoundation.org>
         <20201109125020.811120362@linuxfoundation.org> <20201111124448.GA26508@amd>
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2020-11-11 at 13:44 +0100, Pavel Machek wrote:
> Hi!
> 
> > Thankfully it's handled by the only caller, btree_write_cache_pages(),
> > as later write_one_eb() call will trigger submit_one_bio().  So there
> > shouldn't be any problem.
> 
> This explains there should not be any problem in _the
> mainline_. AFAICT this talks about this code. Mainline version is:
> 
>  prev_eb = eb;
>  ret = lock_extent_buffer_for_io(eb, &epd);
>  if (!ret) {
>  	free_extent_buffer(eb);
>  	continue;
>  } else if (ret < 0) {
>  	done = 1;
>  	free_extent_buffer(eb);
>  	break;
>  }
> 
> But 4.19 has:
> 
>  ret = lock_extent_buffer_for_io(eb, fs_info, &epd);
>  if (!ret) {
>   	free_extent_buffer(eb);
>  	continue;
>  }

That was changed in mainline two releases after this commit, though.

> IOW missing the code mentioned in the changelog. Is 0607eb1d452d4
> prerequisite for this patch?

I think it's a separate fix, but probably worth picking too.

Ben.

> Best regards,
> 								Pavel
> 
> > +/*
> > + * Lock eb pages and flush the bio if we can't the locks
> > + *
> > + * Return  0 if nothing went wrong
> > + * Return >0 is same as 0, except bio is not submitted
> > + * Return <0 if something went wrong, no page is locked
> > + */
-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom

