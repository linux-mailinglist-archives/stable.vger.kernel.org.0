Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 072A214B3CC
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 12:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgA1Lyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 06:54:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:42512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgA1Lyt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 06:54:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EECC221739;
        Tue, 28 Jan 2020 11:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580212488;
        bh=4Nez3qTNyrUdVuGakhGqSSveEJIsnd6q5ChZ1CYe9S0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HNdfjWghk3GaQEWKF8rozEiWAQZ77BJaNuSbMAM1r9jfuZIhSNnklg5NnUF6efUvC
         NbVNxJbkn7v6DTy6eohO1Df5z779/mgSPAy3AnJx4ikDQCm9DrR/p5GDg3czA7DDLI
         k3hHXJ4dei1g0U3XT9I/G6kXPyTUropvCe6XQhjo=
Date:   Tue, 28 Jan 2020 12:54:46 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: stable-rc 4.9.212-rc1/2e383da55e49: regressions detected in
 project stable v4.9.y on OE
Message-ID: <20200128115446.GA2680602@kroah.com>
References: <CA+G9fYs0hK+WaRwdD+64_15Un6fOdEb-RQH0=jZLwJ49nnKK6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYs0hK+WaRwdD+64_15Un6fOdEb-RQH0=jZLwJ49nnKK6A@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 28, 2020 at 05:14:33PM +0530, Naresh Kamboju wrote:
> stable-rc 4.9 build failed due to these build error,
> 
> drivers/md/bitmap.c:1702:13: error: conflicting types for 'bitmap_free'
>  static void bitmap_free(struct bitmap *bitmap)
>              ^~~~~~~~~~~
> include/linux/bitmap.h:94:13: note: previous declaration of
> 'bitmap_free' was here
>  extern void bitmap_free(const unsigned long *bitmap);
>              ^~~~~~~~~~~
> scripts/Makefile.build:304: recipe for target 'drivers/md/bitmap.o' failed
> 
> suspecting this patch causing this build failure on stable-rc 4.9
> 
> bitmap: Add bitmap_alloc(), bitmap_zalloc() and bitmap_free()
> commit c42b65e363ce97a828f81b59033c3558f8fa7f70 upstream.
> 
> A lot of code become ugly because of open coding allocations for bitmaps.
> 
> Introduce three helpers to allow users be more clear of intention
> and keep their code neat.
> 
> Note, due to multiple circular dependencies we may not provide
> the helpers as inliners. For now we keep them exported and, perhaps,
> at some point in the future we will sort out header inclusion and
> inheritance.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Sorry, my fault, am fixing this up for 4.9 and 4.4 and 4.14 right now...
Will push out new -rcs when working again.

greg k-h
