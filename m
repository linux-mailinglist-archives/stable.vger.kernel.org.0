Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D72447BDE3
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 11:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbhLUKIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 05:08:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231777AbhLUKIP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 05:08:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DF4C061574;
        Tue, 21 Dec 2021 02:08:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDECE614E8;
        Tue, 21 Dec 2021 10:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF4FC36AE7;
        Tue, 21 Dec 2021 10:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640081294;
        bh=8AahsyAAdbIIs+LjbWgpR4ejk9iJEuNEWcPUIzojxBM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z20uJ1tMGoHzR+wy8jlwrdVumtQs6mhmN7asH7LPz70xQwichsTexF+7oKVHL91mB
         wfvnlul/SYAVtRnWtOmEOUyfdbYTtMU1MK96Qs+u5AHpyMlmx6K7X6i7YCNKXbYooI
         VuLNCWG+Z9QtdMVdlB1Jto3yqTdyO3+U0QJFd28U=
Date:   Tue, 21 Dec 2021 11:08:11 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Todd Kjos <tkjos@google.com>
Cc:     christian@brauner.io, arve@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, maco@google.com,
        joel@joelfernandes.org, kernel-team@android.com,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] binder: fix async_free_space accounting for empty parcels
Message-ID: <YcGnizJKAQ9pxGBY@kroah.com>
References: <20211220190150.2107077-1-tkjos@google.com>
 <CAHRSSExTHHOdqEnRF0g435BrO5L-X6M3pxPg3OmLz8xUWDuNKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHRSSExTHHOdqEnRF0g435BrO5L-X6M3pxPg3OmLz8xUWDuNKA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 20, 2021 at 11:06:09AM -0800, Todd Kjos wrote:
> On Mon, Dec 20, 2021 at 11:02 AM Todd Kjos <tkjos@google.com> wrote:
> >
> > In 4.13, commit 74310e06be4d ("android: binder: Move buffer out of area shared with user space")
> > fixed a kernel structure visibility issue. As part of that patch,
> > sizeof(void *) was used as the buffer size for 0-length data payloads so
> > the driver could detect abusive clients sending 0-length asynchronous
> > transactions to a server by enforcing limits on async_free_size.
> >
> > Unfortunately, on the "free" side, the accounting of async_free_space
> > did not add the sizeof(void *) back. The result was that up to 8-bytes of
> > async_free_space were leaked on every async transaction of 8-bytes or
> > less.  These small transactions are uncommon, so this accounting issue
> > has gone undetected for several years.
> >
> > The fix is to use "buffer_size" (the allocated buffer size) instead of
> > "size" (the logical buffer size) when updating the async_free_space
> > during the free operation. These are the same except for this
> > corner case of asynchronous transactions with payloads < 8 bytes.
> >
> > Fixes: 74310e06be4d ("android: binder: Move buffer out of area shared with user space")
> > Signed-off-by: Todd Kjos <tkjos@google.com>
> 
> I forgot to CC stable. This applies to all stable branches back to 4.14.
> Cc: stable@vger.kernel.org # 4.14+

Thanks, I've added that to the patch when committing it.

greg k-h
