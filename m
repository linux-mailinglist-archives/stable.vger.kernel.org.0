Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B16445CBFA
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 19:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350429AbhKXSXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 13:23:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:35424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242520AbhKXSXX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 13:23:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E9C860F55;
        Wed, 24 Nov 2021 18:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637778011;
        bh=o3mwUHfq8TGjhb04K4hca4kuWvTialNsqFcyzncpkw8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vb0FP20dRZeqUWCx6u2mSqkmhh7Npp6unTT2UrFqyUY1WyeWPQb7kxwSHco93BtaY
         AViUCOqGeYCRxUNuEzyG25RGYH2MnFvj6amiU2GFKGhueP8mrilFn94FipUsWvskcj
         zDUG+J1N1AuoWvhmj9KvekMuXGCtzHbWSOAdYAcM=
Date:   Wed, 24 Nov 2021 19:20:09 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Frank Dinoff <fdinoff@google.com>
Subject: Re: [PATCH 4.4 109/162] fuse: fix page stealing
Message-ID: <YZ6CWRtO/OLgbao6@kroah.com>
References: <20211124115658.328640564@linuxfoundation.org>
 <20211124115701.855204038@linuxfoundation.org>
 <CAOssrKd=XAvCKW9t0gk9g_FBqFs6pPNJFsP7pc2EF6Dcj-se7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOssrKd=XAvCKW9t0gk9g_FBqFs6pPNJFsP7pc2EF6Dcj-se7w@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 05:21:26PM +0100, Miklos Szeredi wrote:
> On Wed, Nov 24, 2021 at 1:04 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Miklos Szeredi <mszeredi@redhat.com>
> >
> > commit 712a951025c0667ff00b25afc360f74e639dfabe upstream.
> >
> > It is possible to trigger a crash by splicing anon pipe bufs to the fuse
> > device.
> >
> > The reason for this is that anon_pipe_buf_release() will reuse buf->page if
> > the refcount is 1, but that page might have already been stolen and its
> > flags modified (e.g. PG_lru added).
> >
> > This happens in the unlikely case of fuse_dev_splice_write() getting around
> > to calling pipe_buf_release() after a page has been stolen, added to the
> > page cache and removed from the page cache.
> >
> > Fix by calling pipe_buf_release() right after the page was inserted into
> > the page cache.  In this case the page has an elevated refcount so any
> > release function will know that the page isn't reusable.
> >
> > Reported-by: Frank Dinoff <fdinoff@google.com>
> > Link: https://lore.kernel.org/r/CAAmZXrsGg2xsP1CK+cbuEMumtrqdvD-NKnWzhNcvn71RV3c1yw@mail.gmail.com/
> > Fixes: dd3bb14f44a6 ("fuse: support splice() writing to fuse device")
> > Cc: <stable@vger.kernel.org> # v2.6.35
> > Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> 
> Hi Greg,
> 
> This patch turned out to have a bug, so stable releases that didn't
> yet have it released might be better off backing it out for now and
> releasing only together with the fix to avoid regressions.

Good idea, now dropped from all of those queues.

greg k-h
