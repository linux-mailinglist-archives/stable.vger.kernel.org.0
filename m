Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B9B34687B
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 20:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbhCWTFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 15:05:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:58910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232374AbhCWTFY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Mar 2021 15:05:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA89761574;
        Tue, 23 Mar 2021 19:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616526324;
        bh=Uhy2P2EqVs/4M/q2S01XoB6cn9gDfHkYiGACVvIbusE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mTr0sTAzSkrSLcwhAjnKCCQaPQzzLFBQUMFxKJQAb40E4SfN8+nKjBv5257LzLA0t
         M4lBUIWn7DgAHg1i49Lt8Of9rIURHKjGIhMdiJRNRGLtLPFGy+5d1pTCv84OFY5cGl
         cpeJ6aDsWwGlrok8NX6LjcrsFVjtt76f+p5D453Q=
Date:   Tue, 23 Mar 2021 20:05:21 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH] scripts: stable: add script to validate backports
Message-ID: <YFo78StZ6Tq82hHJ@kroah.com>
References: <20210316213136.1866983-1-ndesaulniers@google.com>
 <YFnyHaVyvgYl/qWg@kroah.com>
 <CAKwvOd=9HwLcTD8GaMsbEWiTPfZ+fj=vgFOefqBxDYkFiv_6YQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOd=9HwLcTD8GaMsbEWiTPfZ+fj=vgFOefqBxDYkFiv_6YQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 23, 2021 at 11:52:26AM -0700, Nick Desaulniers wrote:
> On Tue, Mar 23, 2021 at 6:56 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Mar 16, 2021 at 02:31:33PM -0700, Nick Desaulniers wrote:
> > > A common recurring mistake made when backporting patches to stable is
> > > forgetting to check for additional commits tagged with `Fixes:`. This
> > > script validates that local commits have a `commit <sha40> upstream.`
> > > line in their commit message, and whether any additional `Fixes:` shas
> > > exist in the `master` branch but were not included. It can not know
> > > about fixes yet to be discovered, or fixes sent to the mailing list but
> > > not yet in mainline.
> > >
> > > To save time, it avoids checking all of `master`, stopping early once
> > > we've reached the commit time of the earliest backport. It takes 0.5s to
> > > validate 2 patches to linux-5.4.y when master is v5.12-rc3 and 5s to
> > > validate 27 patches to linux-4.19.y. It does not recheck dependencies of
> > > found fixes; the user is expected to run this script to a fixed point.
> > > It depnds on pygit2 python library for working with git, which can be
> > > installed via:
> > > $ pip3 install pygit2
> > >
> > > It's expected to be run from a stable tree with commits applied.  For
> > > example, consider 3cce9d44321e which is a fix for f77ac2e378be. Let's
> > > say I cherry picked f77ac2e378be into linux-5.4.y but forgot
> > > 3cce9d44321e (true story). If I ran:
> > >
> > > $ ./scripts/stable/check_backports.py
> > > Checking 1 local commits for additional Fixes: in master
> > > Please consider backporting 3cce9d44321e as a fix for f77ac2e378be
> >
> > While interesting, I don't use a git tree for the stable queue, so this
> > doesn't really fit into my workflow, sorry.
> 
> Well, what is your workflow?

Look at the stable-queue.git tree.  It's a set of quilt-managed patches
on top of a solid base (i.e. the last released kernel version.).

The only time git gets involved is when we do a -rc release or when we
do a "real" release, and then we use 'git quiltimport' on the whole
stack.

Here's a script that I use (much too slow, I know), for checking this
type of thing and I try to remember to run it before every cycle of -rc
releases:
	https://github.com/gregkh/commit_tree/blob/master/find_fixes_in_queue

It's a hack, and picks up more things than is really needed, but I would
rather it error on that side than the other.

thanks,

greg k-h
