Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3EE40C5D7
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 15:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbhIONER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 09:04:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229670AbhIONEQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 09:04:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86F2D6113E;
        Wed, 15 Sep 2021 13:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631710978;
        bh=mnxu1K2mZoREbcWOOsXdU8spR0L/pfVu2GBwk350gyA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vv1xJsQUHbbhIsreFwqMA9lj1gdVLj6csnk5xfnMTQlg8f/qdr/2vCDPBNILK7oLm
         27Jhk47pXIglGDOLN9P712s9ncAx7K0aYaXpZ7hZIUZbaROh4zyTC1b4CHrhWZt7+R
         MhU0MMznRBocF9Fezo5p1QLZTB/Kcg16He/czmM0=
Date:   Wed, 15 Sep 2021 15:02:55 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, stable@vger.kernel.org
Subject: Re: 5.13 stable backports
Message-ID: <YUHu/wdJg2hXq1tJ@kroah.com>
References: <14bc2778-6ec6-f794-64b1-d89fd1ba0296@kernel.dk>
 <YUHWwWvmAup4ZU6i@kroah.com>
 <cf2be99e-7b9b-c057-5248-202f610256e2@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf2be99e-7b9b-c057-5248-202f610256e2@kernel.dk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 15, 2021 at 06:34:55AM -0600, Jens Axboe wrote:
> On 9/15/21 5:19 AM, Greg Kroah-Hartman wrote:
> > On Mon, Sep 13, 2021 at 09:49:53AM -0600, Jens Axboe wrote:
> >> >From eda6d3d1acf23f63e8e29219b1379e479cf90d7d Mon Sep 17 00:00:00 2001
> >> From: Pavel Begunkov <asml.silence@gmail.com>
> >> Date: Mon, 13 Sep 2021 09:13:30 -0600
> >> Subject: [PATCH 1/6] io_uring: place fixed tables under memcg limits
> >>
> >> commit 0bea96f59ba40e63c0ae93ad6a02417b95f22f4d upstream.
> >>
> >> Fixed tables may be large enough, place all of them together with
> >> allocated tags under memcg limits.
> >>
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> >> Link: https://lore.kernel.org/r/b3ac9f5da9821bb59837b5fe25e8ef4be982218c.1629451684.git.asml.silence@gmail.com
> >> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >> ---
> >>  fs/autofs/modules.builtin          |  1 +
> >>  fs/btrfs/modules.builtin           |  1 +
> >>  fs/configfs/modules.builtin        |  1 +
> >>  fs/crypto/modules.builtin          |  0
> >>  fs/debugfs/modules.builtin         |  0
> >>  fs/devpts/modules.builtin          |  0
> >>  fs/ecryptfs/modules.builtin        |  1 +
> >>  fs/efivarfs/modules.builtin        |  1 +
> >>  fs/exportfs/modules.builtin        |  1 +
> >>  fs/ext2/modules.builtin            |  1 +
> >>  fs/ext4/modules.builtin            |  1 +
> >>  fs/fat/modules.builtin             |  2 ++
> >>  fs/fuse/modules.builtin            |  1 +
> >>  fs/hugetlbfs/modules.builtin       |  0
> >>  fs/io-wq.h.rej                     | 25 +++++++++++++++++++++++++
> >>  fs/io_uring.c                      |  8 ++++----
> >>  fs/iomap/modules.builtin           |  0
> >>  fs/isofs/modules.builtin           |  1 +
> >>  fs/jbd2/modules.builtin            |  1 +
> >>  fs/kernfs/modules.builtin          |  0
> >>  fs/lockd/modules.builtin           |  1 +
> >>  fs/modules.builtin                 |  9 +++++++++
> >>  fs/nfs/modules.builtin             |  4 ++++
> >>  fs/nfs_common/modules.builtin      |  2 ++
> >>  fs/nls/modules.builtin             |  1 +
> >>  fs/notify/dnotify/modules.builtin  |  0
> >>  fs/notify/fanotify/modules.builtin |  0
> >>  fs/notify/inotify/modules.builtin  |  0
> >>  fs/notify/modules.builtin          |  0
> >>  fs/proc/modules.builtin            |  0
> >>  fs/pstore/modules.builtin          |  1 +
> >>  fs/quota/modules.builtin           |  0
> >>  fs/ramfs/modules.builtin           |  0
> >>  fs/squashfs/modules.builtin        |  1 +
> >>  fs/sysfs/modules.builtin           |  0
> >>  fs/tracefs/modules.builtin         |  0
> >>  fs/xfs/modules.builtin             |  1 +
> >>  37 files changed, 62 insertions(+), 4 deletions(-)
> >>  create mode 100644 fs/autofs/modules.builtin
> >>  create mode 100644 fs/btrfs/modules.builtin
> >>  create mode 100644 fs/configfs/modules.builtin
> >>  create mode 100644 fs/crypto/modules.builtin
> >>  create mode 100644 fs/debugfs/modules.builtin
> >>  create mode 100644 fs/devpts/modules.builtin
> >>  create mode 100644 fs/ecryptfs/modules.builtin
> >>  create mode 100644 fs/efivarfs/modules.builtin
> >>  create mode 100644 fs/exportfs/modules.builtin
> >>  create mode 100644 fs/ext2/modules.builtin
> >>  create mode 100644 fs/ext4/modules.builtin
> >>  create mode 100644 fs/fat/modules.builtin
> >>  create mode 100644 fs/fuse/modules.builtin
> >>  create mode 100644 fs/hugetlbfs/modules.builtin
> >>  create mode 100644 fs/io-wq.h.rej
> >>  create mode 100644 fs/iomap/modules.builtin
> >>  create mode 100644 fs/isofs/modules.builtin
> >>  create mode 100644 fs/jbd2/modules.builtin
> >>  create mode 100644 fs/kernfs/modules.builtin
> >>  create mode 100644 fs/lockd/modules.builtin
> >>  create mode 100644 fs/modules.builtin
> >>  create mode 100644 fs/nfs/modules.builtin
> >>  create mode 100644 fs/nfs_common/modules.builtin
> >>  create mode 100644 fs/nls/modules.builtin
> >>  create mode 100644 fs/notify/dnotify/modules.builtin
> >>  create mode 100644 fs/notify/fanotify/modules.builtin
> >>  create mode 100644 fs/notify/inotify/modules.builtin
> >>  create mode 100644 fs/notify/modules.builtin
> >>  create mode 100644 fs/proc/modules.builtin
> >>  create mode 100644 fs/pstore/modules.builtin
> >>  create mode 100644 fs/quota/modules.builtin
> >>  create mode 100644 fs/ramfs/modules.builtin
> >>  create mode 100644 fs/squashfs/modules.builtin
> >>  create mode 100644 fs/sysfs/modules.builtin
> >>  create mode 100644 fs/tracefs/modules.builtin
> >>  create mode 100644 fs/xfs/modules.builtin
> >>
> >> diff --git a/fs/autofs/modules.builtin b/fs/autofs/modules.builtin
> >> new file mode 100644
> >> index 000000000000..3425a57879aa
> >> --- /dev/null
> >> +++ b/fs/autofs/modules.builtin
> >> @@ -0,0 +1 @@
> >> +fs/autofs/autofs4.ko
> > 
> > <snip>
> > 
> > Something went really wrong with this backport :(
> 
> Wow yes, I think it was my 'update what's new script'. Guess I didn't
> notice, sorry about that.
> 
> > Can you fix it up and resend these?
> 
> Here's the series again. The actual change was fine, just had to get
> rid of the garbage.

That worked, now queued up, thanks!

greg k-h
