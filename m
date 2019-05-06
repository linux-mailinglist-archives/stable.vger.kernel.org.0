Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1933715079
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfEFPmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 11:42:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726413AbfEFPmE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 11:42:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECAEB205C9;
        Mon,  6 May 2019 15:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557157323;
        bh=+YHeFNqCK/5U0tlr+IeuSEUFN3ecIaKPcoM27J6rAhw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cx1qRw1HZDSbf4Ilvwj4EbMDs+rhawm/ZXJi75zdTrCCaCDN6AfuVvzjHn1Vce/En
         ep8clwz5pYSZfjSvJXEhqBXURT8BDeHmkiRkU9GluLLt1gabZ+237+jyjQCBq0H1iv
         6aFdB3wivtAEk2wF1OPHBqJWHULfW6m2+QcN5228=
Date:   Mon, 6 May 2019 17:42:00 +0200
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
Message-ID: <20190506154200.GA14919@kroah.com>
References: <20190506143051.102535767@linuxfoundation.org>
 <20190506143051.888762392@linuxfoundation.org>
 <6636d7cf-03fe-e253-f981-e07d75858b33@virtuozzo.com>
 <20190506151026.GA12193@kroah.com>
 <e3ea0e86-581e-a0e4-ea3a-c7a9322143b8@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3ea0e86-581e-a0e4-ea3a-c7a9322143b8@virtuozzo.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 06, 2019 at 06:36:45PM +0300, Andrey Ryabinin wrote:
> 
> 
> On 5/6/19 6:10 PM, Greg Kroah-Hartman wrote:
> > On Mon, May 06, 2019 at 05:55:54PM +0300, Andrey Ryabinin wrote:
> >>
> >>
> >> On 5/6/19 5:32 PM, Greg Kroah-Hartman wrote:
> >>> From: Andrey Ryabinin <aryabinin@virtuozzo.com>
> >>>
> >>> commit c5caf21ab0cf884ef15b25af234f620e4a233139 upstream.
> >>>
> >>> In the upcoming gcc7 release, the -fsanitize=kernel-address option at
> >>> first implied new -fsanitize-address-use-after-scope option.  This would
> >>> cause link errors on older kernels because they don't have two new
> >>> functions required for use-after-scope support.  Therefore, gcc7 changed
> >>> default to -fno-sanitize-address-use-after-scope.
> >>>
> >>> Now the kernel has everything required for that feature since commit
> >>> 828347f8f9a5 ("kasan: support use-after-scope detection").  So, to make it
> >>> work, we just have to enable use-after-scope in CFLAGS.
> >>>
> >>> Link: http://lkml.kernel.org/r/1481207977-28654-1-git-send-email-aryabinin@virtuozzo.com
> >>> Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
> >>> Acked-by: Dmitry Vyukov <dvyukov@google.com>
> >>> Cc: Alexander Potapenko <glider@google.com>
> >>> Cc: Andrey Konovalov <andreyknvl@google.com>
> >>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >>> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> >>> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> >>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >>>
> >>> ---
> >>>  scripts/Makefile.kasan |    2 ++
> >>>  1 file changed, 2 insertions(+)
> >>>
> >>> --- a/scripts/Makefile.kasan
> >>> +++ b/scripts/Makefile.kasan
> >>> @@ -29,6 +29,8 @@ else
> >>>      endif
> >>>  endif
> >>>  
> >>> +CFLAGS_KASAN += $(call cc-option, -fsanitize-address-use-after-scope)
> >>> +
> >>>  CFLAGS_KASAN_NOSANITIZE := -fno-builtin
> >>>  
> >>>  endif
> >>>
> >>>
> >>
> >> This shouldn't be in the -stable.
> > 
> > Why not?  Does no one use gcc7 with this kernel and kasan?
> > 
> 
> You don't need this patch to use kasan on this kernel with gcc7.
> This patch only enables detection of use-after-scope bugs. This feature appeared to be useless,
> hence it disabled recently by commit 7771bdbbfd3d ("kasan: remove use after scope bugs detection.")

Ah, didn't notice that, nice!

Ok, I'll go drop this, thanks for letting me know.

> The link errors mentioned in changelog was the problem only for some period of time in the development branch of GCC 7.
> The released GCC7 version doesn't have this problem.

Also good to know, thanks!

greg k-h
