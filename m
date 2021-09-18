Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032A5410691
	for <lists+stable@lfdr.de>; Sat, 18 Sep 2021 14:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236781AbhIRNA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Sep 2021 09:00:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236097AbhIRNA6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Sep 2021 09:00:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 864E961074;
        Sat, 18 Sep 2021 12:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631969975;
        bh=U3Tmg9ovJTMuJ7nzZuzMGCCVitJuB6lrsDLkyWr/4dE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u0IFNR0VEipH3IxVdQ7dOoVIYWRGupX9KhzwbX4P6yXMBoVUMd7dBJ+dC0TLMWYMO
         Mgd9ka+DQx+Y9U8UDb9d/ua9J9XLwjZ/ncA11LfbmOsUaZp7KR4dURg/kFRCep7jal
         BTRo3sBXj+cW/CkbQQbEZ6RcNgIi6Y0PapyzVyIE=
Date:   Sat, 18 Sep 2021 14:59:32 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     dmm@fb.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: allow retry for O_NONBLOCK if
 async is supported" failed to apply to 5.14-stable tree
Message-ID: <YUXitAkwde0qNmMH@kroah.com>
References: <1631968451106199@kroah.com>
 <0c9365f0-e471-066d-0ab2-faee3ca2d927@kernel.dk>
 <YUXf+11Pv7oiiDAy@kroah.com>
 <03bed564-b681-c1c1-03da-4bc9db9d3621@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <03bed564-b681-c1c1-03da-4bc9db9d3621@kernel.dk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 18, 2021 at 06:49:35AM -0600, Jens Axboe wrote:
> On 9/18/21 6:47 AM, Greg KH wrote:
> > On Sat, Sep 18, 2021 at 06:44:16AM -0600, Jens Axboe wrote:
> >> On 9/18/21 6:34 AM, gregkh@linuxfoundation.org wrote:
> >>>
> >>> The patch below does not apply to the 5.14-stable tree.
> >>> If someone wants it applied there, or to any other stable or longterm
> >>> tree, then please email the backport, including the original git commit
> >>> id to <stable@vger.kernel.org>.
> >>
> >> Just a trivial fuzz, here's a fixed version.
> > 
> > Sorry, no, the fuzz was easy, this breaks the build:
> > 
> > fs/io_uring.c: In function ‘io_prep_rw’:
> > fs/io_uring.c:2715:47: error: implicit declaration of function ‘io_file_supports_nowait’; did you mean ‘io_file_supports_async’? [-Werror=implicit-function-declaration]
> >  2715 |             ((file->f_flags & O_NONBLOCK) && !io_file_supports_nowait(req, rw)))
> >       |                                               ^~~~~~~~~~~~~~~~~~~~~~~
> >       |                                               io_file_supports_async
> >   CHK     kernel/kheaders_data.tar.xz
> > cc1: some warnings being treated as errors
> > 
> > 
> > Any hint as to what that function would be in 5.14.y?
> 
> Ah sorry I'm an idiot, it should be that io_file_supports_nowait() that
> also caused the fuzz in applying.

This version worked, thanks!

greg k-h
