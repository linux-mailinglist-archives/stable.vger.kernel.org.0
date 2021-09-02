Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD8333FF0D5
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 18:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346125AbhIBQMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 12:12:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346047AbhIBQMG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Sep 2021 12:12:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9F3D61211;
        Thu,  2 Sep 2021 16:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630599068;
        bh=1SIgbTHl3TWh3Oz1ABpRYB4HoSLhHO7T9v0BsHWdffk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p+A9q1wMeQDYnwBdBT1oZ62NIsS6cwi1tl6nk984SOmSA5s2MiLiSuLsG47NfV+dS
         zoUwlLbJgEDm0s3wSgh90YHacDq7j96FEIgUIr7qvhVVtccCTv4hZAxpdcjUOiNFtf
         UghD9TFbdc6uNESnX5KfF5GhwL3Wl2Giu9qDaMZY=
Date:   Thu, 2 Sep 2021 18:11:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Todd Kjos <tkjos@google.com>
Cc:     Martijn Coenen <maco@android.com>,
        Christian Brauner <christian@brauner.io>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        "open list:ANDROID DRIVERS" <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martijn Coenen <maco@google.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        kernel-team@android.com, stable <stable@vger.kernel.org>
Subject: Re: [PATCH] binder: make sure fd closes complete
Message-ID: <YTD3maFb22LIsh/U@kroah.com>
References: <20210830195146.587206-1-tkjos@google.com>
 <CAB0TPYFmUgPTONABLTJAdonK7fY7oqURKCpLp1-WqHLtyen7Zw@mail.gmail.com>
 <CAHRSSExONtUFu0Mb8uJeVKcyDYb8=1PO7a=aQ=DUEpA5kAcTQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHRSSExONtUFu0Mb8uJeVKcyDYb8=1PO7a=aQ=DUEpA5kAcTQA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 02, 2021 at 08:35:35AM -0700, Todd Kjos wrote:
> On Tue, Aug 31, 2021 at 12:24 AM Martijn Coenen <maco@android.com> wrote:
> >
> > On Mon, Aug 30, 2021 at 9:51 PM 'Todd Kjos' via kernel-team
> > <kernel-team@android.com> wrote:
> > >
> > > During BC_FREE_BUFFER processing, the BINDER_TYPE_FDA object
> > > cleanup may close 1 or more fds. The close operations are
> > > completed using the task work mechanism -- which means the thread
> > > needs to return to userspace or the file object may never be
> > > dereferenced -- which can lead to hung processes.
> > >
> > > Force the binder thread back to userspace if an fd is closed during
> > > BC_FREE_BUFFER handling.
> > >
> > > Signed-off-by: Todd Kjos <tkjos@google.com>
> > Reviewed-by: Martijn Coenen <maco@android.com>
> 
> Please also add to stable releases 5.4 and later.

I'll try to remember to tag this as-such after 5.15-rc1 is out and I can
apply it to my tree.  But in the future, it's best if you add the cc:
stable to the patch yourself so I don't have to do it "by hand" after
the fact.

thanks,

greg k-h
