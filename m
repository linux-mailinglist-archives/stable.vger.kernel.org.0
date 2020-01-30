Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C55E14DD45
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 15:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbgA3OuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 09:50:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:35854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726948AbgA3OuS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 09:50:18 -0500
Received: from localhost (unknown [84.241.198.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF53A206D3;
        Thu, 30 Jan 2020 14:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580395817;
        bh=/ffdteQgH+orYQfTLSroPUjA2xLK4PW07C4Ua1ADdnY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=epY6POtW6xjYPD7Paf/0Oplb6LthdAQnezQzbQ0hB4LyUpJ0iuRca7rP36gd9nOUb
         OA+p8GxhVhfQusRBUEyC+6PKsaeWfV3R35H6tWpt2sQXU6DrmS/y5pLBUmp/kDkHYk
         TsNT4TX+nLYeXjMexuDzInetf7QQcAswFFoKdc4c=
Date:   Thu, 30 Jan 2020 15:49:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Noah Meyerhans <noahm@debian.org>,
        stable <stable@vger.kernel.org>
Subject: Re: Please apply 50ee7529ec45 ("random: try to actively add entropy
 rather than passively wait for it") to 4.19.y
Message-ID: <20200130144935.GA994030@kroah.com>
References: <20200127230214.GC25530@morgul.net>
 <20200128075223.GD2105706@kroah.com>
 <20200128193437.GA18426@morgul.net>
 <CAHk-=wiqQcpwh6iC0RpAQHOksSVQiq0SOU30DMecOJn_wrXzPg@mail.gmail.com>
 <20200130003939.GC303030@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200130003939.GC303030@mit.edu>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 29, 2020 at 07:39:39PM -0500, Theodore Y. Ts'o wrote:
> On Tue, Jan 28, 2020 at 11:59:28AM -0800, Linus Torvalds wrote:
> > On Tue, Jan 28, 2020 at 11:34 AM Noah Meyerhans <noahm@debian.org> wrote:
> > >
> > > Added torvalds and tytso to the CC list.  Linus and Ted, what do you
> > > think of the idea of applying 50ee7529ec45 ("random: try to actively add
> > > entropy rather than passively wait for it") to the 4.19.y and 4.14.y
> > > kernels?
> > 
> > By now I suspect it's the right thing to do. Nobody has complained
> > about it, and it fixed real issues during boot.
> > 
> > Some of those real issues may have ended up being just unnecessary
> > delays rather than complete lockups, but still..
> 
> FWIW, at $WORK we backported the patch, but we also added an out of
> tree patch to disable it on non-x86 systems.  That's mainly because
> I'm still hesitant about the safety of relying on this on non-x86
> architectures that may have a much simpler micro-archtecture, and
> which don't have RDRAND.  But we also have a much more stringent
> (paranoid?) philosophy where if there is a risk that our kernels might
> be penetrated by a nation-state (viz. Operation Aurora), booting
> lockups so we know that we might have a problem that should be
> examined by a human being is actually *preferable*.

Ok, I've applied this to 4.19.y.  I'm guessing that anyone who had this
type of problem in 4.14.y has long upgraded their kernels, and that
kernel is pretty much only in already-shipping devices, not "new"
things.

Let's see what breaks :)

thanks,

greg k-h
