Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A056E2A29EA
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 12:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbgKBLs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 06:48:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:41302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728610AbgKBLs5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 06:48:57 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 385D821D91;
        Mon,  2 Nov 2020 11:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604317736;
        bh=+iwZp4hz8Ac+ih2R+PIMnjM3wfsZ6NHD+wtMijUtFSo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R5c5fWp8keTvEfGO5J6e9XUE0aaIT+pfFquuQdLSWzdeLc3rsCYkUYVSFuUw/egEx
         CJddh4EPYpUjJWmUynG0GdV8KVOcBhUvLQuVB553AZjJNTNA8QD5dlxEu0ULnXsx/R
         46bPSVVs9r0wymE9C+cTVJzkhusfHT7Oly3YtrvA=
Date:   Mon, 2 Nov 2020 12:49:52 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Salvatore Bonaccorso <carnil@debian.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/264] 4.19.153-rc1 review
Message-ID: <20201102114952.GA661633@kroah.com>
References: <20201027135430.632029009@linuxfoundation.org>
 <20201028171035.GD118534@roeck-us.net>
 <20201028195619.GC124982@roeck-us.net>
 <20201031094500.GA271135@eldamar.lan>
 <7608060e-f48b-1a7c-1a92-9c41d81d9a40@roeck-us.net>
 <20201102113648.GB9840@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201102113648.GB9840@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 02, 2020 at 12:36:48PM +0100, Pavel Machek wrote:
> Hi!
> 
> > >>> perf failures are as usual. powerpc:
> > > 
> > > Regarding the perf failures, do you plan to revert b801d568c7d8 ("perf
> > > cs-etm: Move definition of 'traceid_list' global variable from header
> > > file") included in 4.19.152 or is a bugfix underway?
> > > 
> > 
> > The problem is:
> > 
> > In file included from util/evlist.h:15:0,
> >                  from util/evsel.c:30:
> > util/evsel.c: In function ‘perf_evsel__exit’:
> > util/util.h:25:28: error: passing argument 1 of ‘free’ discards ‘const’ qualifier from pointer target type
> > /usr/include/stdlib.h:563:13: note: expected ‘void *’ but argument is of type ‘const char *’
> >  extern void free (void *__ptr) __THROW;
> > 
> > This is seen with older versions of gcc (6.5.0 in my case). I have no idea why
> > newer versions of gcc/glibc accept this (afaics free() still expects a char *,
> > not a const char *). The underlying problem is that pmu_name should not be
> > declared const char *, but char *, since it is allocated. The upstream version
> > of perf no longer uses the same definition of zfree(). It was changed from
> > 	#define zfree(ptr) ({ free(*ptr); *ptr = NULL; })
> > to
> > 	#define zfree(ptr) __zfree((void **)(ptr))
> > which does the necessary typecast. The fix would be to either change the definition
> > of zfree to add the typecast, or to change the definition of pmu_name to drop the const.
> > Both would only apply to v4.19.y. I don't know if either would be acceptable.
> 
> As the problem is already fixed in the mainline, either solution
> should be acceptable for -stable.
> 
> Probably the one adjusting the zfree() is more suitable, as that is
> the way it was solved in the mainline.

If you can provide the proper patches backported to 4.19, I will gladly
take them.  I tried to figure it out and couldn't, so good luck!

greg k-h
