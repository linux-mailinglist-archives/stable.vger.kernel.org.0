Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C24614FA3
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfEFPM4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 11:12:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:41614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727082AbfEFPMz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 11:12:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3E9521479;
        Mon,  6 May 2019 15:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557155574;
        bh=t8vKwFlI0bJLS5h2dD31IGjB9vHPflvMjtuqWataVgE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zp/FHHK69KnVw6FJoIY0+qmT20u56Ud5KTj1UbT0/sgJtv+vuS7wCrfY7+pCgNGiX
         wS4WWPW4HlweOLnXiKhTgbevvWyzvsWh63LhEZit/dYUO3WOym8435ft6j7T06kMcu
         tXz3VBexFyPWtE4sp3vLnUDqvjr/z+3Y+tgLeAUs=
Date:   Mon, 6 May 2019 17:10:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4.9 09/62] kasan: turn on
 -fsanitize-address-use-after-scope
Message-ID: <20190506151026.GA12193@kroah.com>
References: <20190506143051.102535767@linuxfoundation.org>
 <20190506143051.888762392@linuxfoundation.org>
 <6636d7cf-03fe-e253-f981-e07d75858b33@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6636d7cf-03fe-e253-f981-e07d75858b33@virtuozzo.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 06, 2019 at 05:55:54PM +0300, Andrey Ryabinin wrote:
> 
> 
> On 5/6/19 5:32 PM, Greg Kroah-Hartman wrote:
> > From: Andrey Ryabinin <aryabinin@virtuozzo.com>
> > 
> > commit c5caf21ab0cf884ef15b25af234f620e4a233139 upstream.
> > 
> > In the upcoming gcc7 release, the -fsanitize=kernel-address option at
> > first implied new -fsanitize-address-use-after-scope option.  This would
> > cause link errors on older kernels because they don't have two new
> > functions required for use-after-scope support.  Therefore, gcc7 changed
> > default to -fno-sanitize-address-use-after-scope.
> > 
> > Now the kernel has everything required for that feature since commit
> > 828347f8f9a5 ("kasan: support use-after-scope detection").  So, to make it
> > work, we just have to enable use-after-scope in CFLAGS.
> > 
> > Link: http://lkml.kernel.org/r/1481207977-28654-1-git-send-email-aryabinin@virtuozzo.com
> > Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
> > Acked-by: Dmitry Vyukov <dvyukov@google.com>
> > Cc: Alexander Potapenko <glider@google.com>
> > Cc: Andrey Konovalov <andreyknvl@google.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > ---
> >  scripts/Makefile.kasan |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > --- a/scripts/Makefile.kasan
> > +++ b/scripts/Makefile.kasan
> > @@ -29,6 +29,8 @@ else
> >      endif
> >  endif
> >  
> > +CFLAGS_KASAN += $(call cc-option, -fsanitize-address-use-after-scope)
> > +
> >  CFLAGS_KASAN_NOSANITIZE := -fno-builtin
> >  
> >  endif
> > 
> > 
> 
> This shouldn't be in the -stable.

Why not?  Does no one use gcc7 with this kernel and kasan?

thanks,

greg k-h
