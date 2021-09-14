Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7BE640A701
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 09:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240397AbhINHDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 03:03:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240413AbhINHDE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Sep 2021 03:03:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FB46604AC;
        Tue, 14 Sep 2021 07:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631602905;
        bh=Zb+voASq3Qg2txFsgmexeKqywne8/1IybgvG7QZQMFQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I8k5IDN7xvjaEbxYQSsN4ZqLVuoCL86UVLYfaAQg9o6PNQDmBCIl2bZ+WeH5aBLHF
         JEW2mIPQz9d/Fw9bXdbdKjnnq/owUhQCFK9Adc1aqgMGHXVJzwGXyqELrmXfT6qZao
         TxTYzsCHHgjVK5FuMpNwViLyr7I7yEigmI24kS5A=
Date:   Tue, 14 Sep 2021 09:01:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Todd Kjos <tkjos@google.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Martijn Coenen <maco@android.com>,
        "open list:ANDROID DRIVERS" <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Martijn Coenen <maco@google.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        kernel-team@android.com, Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH] binder: make sure fd closes complete
Message-ID: <YUBI1wmzXpJCH3ZS@kroah.com>
References: <20210830195146.587206-1-tkjos@google.com>
 <CAB0TPYFmUgPTONABLTJAdonK7fY7oqURKCpLp1-WqHLtyen7Zw@mail.gmail.com>
 <CAHRSSExONtUFu0Mb8uJeVKcyDYb8=1PO7a=aQ=DUEpA5kAcTQA@mail.gmail.com>
 <20210903080617.GA1957@kadam>
 <CAHRSSEyDDmGRrc_paxJ2-Gkx=qMhKKhTr_Mpj-DiL8L1gcm5VA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHRSSEyDDmGRrc_paxJ2-Gkx=qMhKKhTr_Mpj-DiL8L1gcm5VA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 03, 2021 at 12:38:26PM -0700, Todd Kjos wrote:
> On Fri, Sep 3, 2021 at 1:06 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
> >
> > On Thu, Sep 02, 2021 at 08:35:35AM -0700, Todd Kjos wrote:
> > > On Tue, Aug 31, 2021 at 12:24 AM Martijn Coenen <maco@android.com> wrote:
> > > >
> > > > On Mon, Aug 30, 2021 at 9:51 PM 'Todd Kjos' via kernel-team
> > > > <kernel-team@android.com> wrote:
> > > > >
> > > > > During BC_FREE_BUFFER processing, the BINDER_TYPE_FDA object
> > > > > cleanup may close 1 or more fds. The close operations are
> > > > > completed using the task work mechanism -- which means the thread
> > > > > needs to return to userspace or the file object may never be
> > > > > dereferenced -- which can lead to hung processes.
> > > > >
> > > > > Force the binder thread back to userspace if an fd is closed during
> > > > > BC_FREE_BUFFER handling.
> > > > >
> > > > > Signed-off-by: Todd Kjos <tkjos@google.com>
> > > > Reviewed-by: Martijn Coenen <maco@android.com>
> > >
> > > Please also add to stable releases 5.4 and later.
> >
> > It would be better if this had a fixes tag so we knew which is the first
> > buggy commit.
> >
> > There was a long Project Zero article about the Bad Binder exploit
> > because commit f5cb779ba163 ("ANDROID: binder: remove waitqueue when
> > thread exits.") was marked as # 4.14 but it didn't have a Fixes tag and
> > the actual buggy commit was in 4.9.
> 
> Good point Dan. I should have included a Fixes tag. Here is the tag
> (issue introduced in 4.20):
> 
> Fixes: 80cd795630d6 ("binder: fix use-after-free due to ksys_close()
> during fdget()")
> 
> Greg- would you like me to send a v2 with the Fixes tag and CC'ing
> stable appropriately?

I've added it to the commit when I added it to my tree, no need to
resend.

thanks,

greg k-h
