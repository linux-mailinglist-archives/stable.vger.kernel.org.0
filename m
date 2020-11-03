Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A742A44D4
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 13:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbgKCMNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 07:13:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:36974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727923AbgKCMNb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 07:13:31 -0500
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8818321D40;
        Tue,  3 Nov 2020 12:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604405610;
        bh=luWx/6jx47ZiEJeefvFyHfIO5/JRBC2XwbsWLHc+1lI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DbJDeZxfGYeFPGcYSsZY1ZUAyn6ZFAvMyQ2Iwfw8pCML7QjwwCi3HcC4NlSRYaXya
         gLjQ4zAf1l2k/FLeZqWnqayBa42hm9+KNpj5+6zKTdmespamQq6M59mKlbVIUIffV1
         hvgbzJ2fYHxe1NpcjtKScJIWQ+lXt8nH/FPP3ySc=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 426CA40452; Tue,  3 Nov 2020 09:13:28 -0300 (-03)
Date:   Tue, 3 Nov 2020 09:13:28 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>,
        Jin Yao <yao.jin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf: increase size of buf in perf_evsel__hists_browse()
Message-ID: <20201103121328.GC151027@kernel.org>
References: <20201030235431.534417-1-songliubraving@fb.com>
 <20201031202920.GC3380099@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201031202920.GC3380099@krava>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Em Sat, Oct 31, 2020 at 09:29:20PM +0100, Jiri Olsa escreveu:
> On Fri, Oct 30, 2020 at 04:54:31PM -0700, Song Liu wrote:
> > Making perf with gcc-9.1.1 generates the following warning:
> > 
> >   CC       ui/browsers/hists.o
> > ui/browsers/hists.c: In function 'perf_evsel__hists_browse':
> > ui/browsers/hists.c:3078:61: error: '%d' directive output may be \
> > truncated writing between 1 and 11 bytes into a region of size \
> > between 2 and 12 [-Werror=format-truncation=]
> > 
> >  3078 |       "Max event group index to sort is %d (index from 0 to %d)",
> >       |                                                             ^~
> > ui/browsers/hists.c:3078:7: note: directive argument in the range [-2147483648, 8]
> >  3078 |       "Max event group index to sort is %d (index from 0 to %d)",
> >       |       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > In file included from /usr/include/stdio.h:937,
> >                  from ui/browsers/hists.c:5:
> > 
> > IOW, the string in line 3078 might be too long for buf[] of 64 bytes.
> > 
> > Fix this by increasing the size of buf[] to 128.
> > 
> > Fixes: dbddf1747441  ("perf report/top TUI: Support hotkeys to let user select any event for sorting")
> > Cc: stable <stable@vger.kernel.org> # v5.7+
> > Cc: Jin Yao <yao.jin@linux.intel.com>
> > Cc: Jiri Olsa <jolsa@kernel.org>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> > Signed-off-by: Song Liu <songliubraving@fb.com>
> 
> Acked-by: Jiri Olsa <jolsa@kernel.org>



Thanks, applied.

- Arnaldo

