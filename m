Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB2A25576
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 18:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbfEUQW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 12:22:26 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:38435 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727965AbfEUQW0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 May 2019 12:22:26 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-109.corp.google.com [104.133.0.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x4LGLhkx018523
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 May 2019 12:21:44 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id DDB01420481; Tue, 21 May 2019 12:21:42 -0400 (EDT)
Date:   Tue, 21 May 2019 12:21:42 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        linux-ext4@vger.kernel.org,
        Arthur Marsh <arthur.marsh@internode.on.net>,
        Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: ext4 regression (was Re: [PATCH 4.19 000/105] 4.19.45-stable
 review)
Message-ID: <20190521162142.GA2591@mit.edu>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Shuah Khan <shuah@kernel.org>,
        patches@kernelci.org, Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>, linux-ext4@vger.kernel.org,
        Arthur Marsh <arthur.marsh@internode.on.net>,
        Richard Weinberger <richard.weinberger@gmail.com>
References: <20190520115247.060821231@linuxfoundation.org>
 <20190520222342.wtsjx227c6qbkuua@xps.therub.org>
 <20190521085956.GC31445@kroah.com>
 <CA+G9fYvHmUimtwszwo=9fDQLn+MNh8Vq3UGPaPUdhH=dEKzqxg@mail.gmail.com>
 <20190521093849.GA9806@kroah.com>
 <CA+G9fYveeg_FMsL31aunJ2A9XLYk908Y1nSFw4kwkFk3h3uEiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYveeg_FMsL31aunJ2A9XLYk908Y1nSFw4kwkFk3h3uEiA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 21, 2019 at 03:58:15PM +0530, Naresh Kamboju wrote:
> > Ted, any ideas here?  Should I drop this from the stable trees, and you
> > revert it from Linus's?  Or something else?

It's safe to drop this from the stable trees while we investigate.  It
was always borderline for stable anyway.  (See below).

> >
> > Note, I do also have 170417c8c7bb ("ext4: fix block validity checks for
> > journal inodes using indirect blocks") in the trees, which was supposed
> > to fix the problem with this patch, am I missing another one as well?
> 
> FYI,
> I have applied fix patch 170417c8c7bb ("ext4: fix block validity checks for
>  journal inodes using indirect blocks") but did not fix this problem.

Hmm... are you _sure_?  This bug was reported to me versus the
mainline, and the person who reported it confirmed that it did fix the
problem, he was seeing, and the symptoms are identical to yours.  Can
you double check, please?  I can't reproduce it either with that patch applied.

> > (side note, it was mean not to mark 170417c8c7bb for stable, when the
> > patch it was fixing was marked for stable, I'm lucky I caught it...)

Sorry, I had forgotten that I had marked 345c0dbf3a30 for stable;
that's why I didn't mark 170417c8c7bb for stable.  345c0dbf3a30 fixes
a crash triggered by a specially crafted (corrupted) file system, and
I had thought I had decided it wasn't important enough for stable; I
think what happened is I shrugged and said, "oh well, Sasha's
automated ML system is going to pick it for stable anyway, so I might
just mark it for stable anyway" --- and I forgot I had landed that
way.

						- Ted
