Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5A8346076
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 14:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbhCWN5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 09:57:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:54272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231741AbhCWN4q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Mar 2021 09:56:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 774A061994;
        Tue, 23 Mar 2021 13:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616507806;
        bh=V3M2Dwm+0tFY5g4Ivpe5s7ILfl+D4bolXtaNcX5eTA0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=le8IZ6Ol3RW2ZmuZSIUdM8NL+6nfJVyv2ZMvELYIG49JOKkcwJ0PpPaj8wgOPsFaF
         6OEfzLI4pNQzlLIKPM53437m8DB3Ke3B7PGcI+9FPo5amtLHnncbJDMlIq8OmWOg7M
         fsj+nvD3pHpGZRGzqJvqQAQtJAJwLH4jhcRFHfwI=
Date:   Tue, 23 Mar 2021 14:50:21 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] scripts: stable: add script to validate backports
Message-ID: <YFnyHaVyvgYl/qWg@kroah.com>
References: <20210316213136.1866983-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316213136.1866983-1-ndesaulniers@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 16, 2021 at 02:31:33PM -0700, Nick Desaulniers wrote:
> A common recurring mistake made when backporting patches to stable is
> forgetting to check for additional commits tagged with `Fixes:`. This
> script validates that local commits have a `commit <sha40> upstream.`
> line in their commit message, and whether any additional `Fixes:` shas
> exist in the `master` branch but were not included. It can not know
> about fixes yet to be discovered, or fixes sent to the mailing list but
> not yet in mainline.
> 
> To save time, it avoids checking all of `master`, stopping early once
> we've reached the commit time of the earliest backport. It takes 0.5s to
> validate 2 patches to linux-5.4.y when master is v5.12-rc3 and 5s to
> validate 27 patches to linux-4.19.y. It does not recheck dependencies of
> found fixes; the user is expected to run this script to a fixed point.
> It depnds on pygit2 python library for working with git, which can be
> installed via:
> $ pip3 install pygit2
> 
> It's expected to be run from a stable tree with commits applied.  For
> example, consider 3cce9d44321e which is a fix for f77ac2e378be. Let's
> say I cherry picked f77ac2e378be into linux-5.4.y but forgot
> 3cce9d44321e (true story). If I ran:
> 
> $ ./scripts/stable/check_backports.py
> Checking 1 local commits for additional Fixes: in master
> Please consider backporting 3cce9d44321e as a fix for f77ac2e378be

While interesting, I don't use a git tree for the stable queue, so this
doesn't really fit into my workflow, sorry.

And we do have other "stable tree helper" scripts in the
stable-queue.git repo, perhaps that's a better place for this than the
main kernel repo?

thanks,

greg k-h
