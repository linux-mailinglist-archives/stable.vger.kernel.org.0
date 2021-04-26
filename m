Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2365136B76A
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 19:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234657AbhDZRE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 13:04:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233736AbhDZRE0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 13:04:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB08C61077;
        Mon, 26 Apr 2021 17:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619456624;
        bh=8cSf3MkTCS+C8YlyRAEhNhPSXrEVyPLg6iskO89XY0k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GzNikSZlckoJqVVKtyY/YW92nd8CIoMKHkXGPoaAVglxhfh4BbuTSStHSmwMgLH7U
         J51NW1rQNgLQa+AaRBKfj2z4y7N2L2PeF3lLUDixDgedX9QkMCAiD+ZNXcMkdXW9WM
         MGdWf3cknIXrA2+XseHNwPcP+Fv4EeS1cAyZLvdI=
Date:   Mon, 26 Apr 2021 19:03:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 119/190] Revert "tty: mxs-auart: fix a potential NULL
 pointer dereference"
Message-ID: <YIbybarztHexS5Sy@kroah.com>
References: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
 <20210421130105.1226686-120-gregkh@linuxfoundation.org>
 <1af822a8-2a1b-9110-9832-ba0fe237a1c1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1af822a8-2a1b-9110-9832-ba0fe237a1c1@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 22, 2021 at 07:03:55AM +0200, Jiri Slaby wrote:
> On 21. 04. 21, 14:59, Greg Kroah-Hartman wrote:
> > This reverts commit 6734330654dac550f12e932996b868c6d0dcb421.
> > 
> > Commits from @umn.edu addresses have been found to be submitted in "bad
> > faith" to try to test the kernel community's ability to review "known
> > malicious" changes.  The result of these submissions can be found in a
> > paper published at the 42nd IEEE Symposium on Security and Privacy
> > entitled, "Open Source Insecurity: Stealthily Introducing
> > Vulnerabilities via Hypocrite Commits" written by Qiushi Wu (University
> > of Minnesota) and Kangjie Lu (University of Minnesota).
> > 
> > Because of this, all submissions from this group must be reverted from
> > the kernel tree and will need to be re-reviewed again to determine if
> > they actually are a valid fix.  Until that work is complete, remove this
> > change to ensure that no problems are being introduced into the
> > codebase.
> > 
> > Cc: Kangjie Lu <kjlu@umn.edu>
> > Cc: stable <stable@vger.kernel.org>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >   drivers/tty/serial/mxs-auart.c | 4 ----
> >   1 file changed, 4 deletions(-)
> > 
> > diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
> > index f414d6acad69..edad6ebbdfd5 100644
> > --- a/drivers/tty/serial/mxs-auart.c
> > +++ b/drivers/tty/serial/mxs-auart.c
> > @@ -1644,10 +1644,6 @@ static int mxs_auart_probe(struct platform_device *pdev)
> >   	s->port.mapbase = r->start;
> >   	s->port.membase = ioremap(r->start, resource_size(r));
> > -	if (!s->port.membase) {
> > -		ret = -ENOMEM;
> > -		goto out_disable_clks;
> > -	}
> 
> I don't think this needs to be reverted -- the original fix is correct.
> 

Now dropped, thanks for the review!

greg k-h
