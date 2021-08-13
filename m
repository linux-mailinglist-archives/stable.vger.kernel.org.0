Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3493EB39A
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 11:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238808AbhHMJzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 05:55:14 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:35214 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239392AbhHMJzO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 05:55:14 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 17D9sTDH021972;
        Fri, 13 Aug 2021 11:54:29 +0200
Date:   Fri, 13 Aug 2021 11:54:29 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        jason@jlekstrand.net, Jonathan Gray <jsg@jsg.id.au>
Subject: Re: Determining corresponding mainline patch for stable patches Re:
 [PATCH 5.10 125/135] drm/i915: avoid uninitialised var in eb_parse()
Message-ID: <20210813095429.GA21912@1wt.eu>
References: <20210810172955.660225700@linuxfoundation.org>
 <20210810173000.050147269@linuxfoundation.org>
 <20210811072843.GC10829@duo.ucw.cz>
 <YROARN2fMPzhFMNg@kroah.com>
 <20210811122702.GA8045@duo.ucw.cz>
 <YRPLbV+Dq2xTnv2e@kroah.com>
 <20210813093104.GA20799@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813093104.GA20799@duo.ucw.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Pavel,

On Fri, Aug 13, 2021 at 11:31:04AM +0200, Pavel Machek wrote:
> > > If we could agree on
> > > 
> > > Commit: (SHA)
> > > 
> > > in the beggining of body, that would be great.
> > > 
> > > Upstream: (SHA)
> > > 
> > > in sign-off area would be even better.
> > 
> > What exactly are you trying to do when you find a sha1?  For some reason
> > my scripts work just fine with a semi-free-form way that we currently
> > have been doing this for the past 17+ years.  What are you attempting to
> > do that requires such a fixed format?
> 
> Is there any problem having a fixed format? You are producing -stable
> kernels, so you are not the one needing such functionality.

When I was doing extended LTS in the past, I used to restart from
Greg's closest branch (e.g. 4.4.y for latest 3.10.y) and needed
exactly that. It was pretty easy in the end, as you'll essentially
find two formats (one form from net and the other for the rest of
the patches):

  - commit XXXX upstream
  - [ Upstream commit XXXX ]

I ended up writing this trivial script that did the job well for me
and also supported the "git cherry-pick -x" format that I was using
a lot. Feel free to reuse that as a starting point, here it comes, a
bit covered in dust :-)

Willy

#!/bin/bash

die() {
        [ "$#" -eq 0 ] || echo "$*" >&2
        exit 1
}

[ -n "$1" ] || die "Usage: ${0##*/} <commit>|<file>"

upstream=( )
if [ -s "$1" ]; then
        upstream=( $(sed -n -e '/^$/,/^./s/^commit \([0-9a-f]*\) upstream\.$/\1/p' \
                            -e 's/^\[ Upstream commit \([0-9a-f]*\) \]$/\1/p' \
                            -e 's/^(cherry picked from commit \([0-9a-f]*\))/\1/p' "$1") )
else
        upstream=( $(git log -1 --pretty --format=%B "$1" | \
                     sed -n -e '1,3s/^commit \([0-9a-f]*\) upstream\.$/\1/p' \
                            -e 's/^\[ Upstream commit \([0-9a-f]*\) \]$/\1/p' \
                            -e 's/^(cherry picked from commit \([0-9a-f]*\))/\1/p') )
fi

[ "${#upstream[@]}" -gt 0 ] || die "No upstream commit ID found."

echo "${upstream[0]}"
