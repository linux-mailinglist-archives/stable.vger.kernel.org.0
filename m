Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4FE040C5CD
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 15:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbhIONCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 09:02:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233238AbhIONCB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 09:02:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F314961355;
        Wed, 15 Sep 2021 13:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631710842;
        bh=HzmARJHOWjJAgObx4+6ScKwdV/y3UM/9zWgBL6v1qIE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TzSG5HT/nA0aV7qxqbla+EeVLteVr2gezG+jhL8aQdP+KK2aGP5mEJ6ibF+Nr3TMG
         IeA9UuSsfYESuOuRkQlV+Xw6nnlXhEOxMH97WmDxwuLTJBLB6jBYqAK+LCdoQ1FsXJ
         E+Y+QyvVbODvjET8sd7j5dpgUu5lgQZAbhXjRESE=
Date:   Wed, 15 Sep 2021 15:00:40 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yi Zhang <yi.zhang@redhat.com>
Cc:     Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>,
        linux-nvme@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [bug report] nvme0n1 node still exists after blktests
 nvme-tcp/014 on 5.13.16-rc1
Message-ID: <YUHueINHsFDRwHPa@kroah.com>
References: <CAHj4cs94pDUfSSfij=ENQxL-2PaGrHJSnhn_mHTC+hqSvPzBTQ@mail.gmail.com>
 <ca405578-5462-0ab9-91ab-de9d42ee0570@grimberg.me>
 <CAHj4cs8_382bLtbcR4F8RBJSmwMAdW22EiRycDjdLa0QtY2vnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHj4cs8_382bLtbcR4F8RBJSmwMAdW22EiRycDjdLa0QtY2vnw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 15, 2021 at 08:41:21PM +0800, Yi Zhang wrote:
> On Tue, Sep 14, 2021 at 10:28 PM Sagi Grimberg <sagi@grimberg.me> wrote:
> >
> >
> > > Hello
> > > I found this failure on stable 5.13.16-rc1[1] and cannot reproduce it
> > > on 5.14, seems we are missing commit[2] on 5.13.y, could anyone help
> > > check it?
> >
> > Was it picked up and didn't apply correctly?
> >
> 
> Hi Sagi
> I tried apply that patch to stable branch, but failed to do that,
> would you or Hannes mind help backport it, thanks.
> 
> [linux-stable-rc ((daeb634aa75f...))]$ git am
> 0001-nvme-fix-refcounting-imbalance-when-all-paths-are-do.patch
> Applying: nvme: fix refcounting imbalance when all paths are down
> error: patch failed: drivers/nvme/host/nvme.h:716
> error: drivers/nvme/host/nvme.h: patch does not apply
> Patch failed at 0001 nvme: fix refcounting imbalance when all paths are down
> hint: Use 'git am --show-current-patch' to see the failed patch
> When you have resolved this problem, run "git am --continue".
> If you prefer to skip this patch, run "git am --skip" instead.
> To restore the original branch and stop patching, run "git am --abort".
> 
> [linux-stable-rc ((daeb634aa75f...))]$ patch -p1 <
> 0001-nvme-fix-refcounting-imbalance-when-all-paths-are-do.patch
> patching file drivers/nvme/host/core.c
> Hunk #1 succeeded at 3761 (offset -46 lines).
> Hunk #2 succeeded at 3771 (offset -46 lines).
> Hunk #3 succeeded at 3790 (offset -46 lines).
> patching file drivers/nvme/host/multipath.c
> Hunk #1 succeeded at 757 (offset -3 lines).
> patching file drivers/nvme/host/nvme.h
> Hunk #1 FAILED at 716.
> Hunk #2 succeeded at 775 (offset 3 lines).
> 1 out of 2 hunks FAILED -- saving rejects to file drivers/nvme/host/nvme.h.rej

5.13 is only going to be around for a 2-3 more days, please move to
5.14.y at this point in time.  No need to do any extra work for 5.13.y
at this point in time as it is about to be end-of-life.

thanks,

greg k-h
