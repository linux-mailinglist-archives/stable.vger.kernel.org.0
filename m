Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA2C514D4BB
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 01:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgA3Aju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 19:39:50 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:45075 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726671AbgA3Ajt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 19:39:49 -0500
Received: from callcc.thunk.org (guestnat-104-133-9-100.corp.google.com [104.133.9.100] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 00U0dUWM002779
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Jan 2020 19:39:31 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id E45AD420324; Wed, 29 Jan 2020 19:39:39 -0500 (EST)
Date:   Wed, 29 Jan 2020 19:39:39 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Noah Meyerhans <noahm@debian.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: Please apply 50ee7529ec45 ("random: try to actively add entropy
 rather than passively wait for it") to 4.19.y
Message-ID: <20200130003939.GC303030@mit.edu>
References: <20200127230214.GC25530@morgul.net>
 <20200128075223.GD2105706@kroah.com>
 <20200128193437.GA18426@morgul.net>
 <CAHk-=wiqQcpwh6iC0RpAQHOksSVQiq0SOU30DMecOJn_wrXzPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiqQcpwh6iC0RpAQHOksSVQiq0SOU30DMecOJn_wrXzPg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 28, 2020 at 11:59:28AM -0800, Linus Torvalds wrote:
> On Tue, Jan 28, 2020 at 11:34 AM Noah Meyerhans <noahm@debian.org> wrote:
> >
> > Added torvalds and tytso to the CC list.  Linus and Ted, what do you
> > think of the idea of applying 50ee7529ec45 ("random: try to actively add
> > entropy rather than passively wait for it") to the 4.19.y and 4.14.y
> > kernels?
> 
> By now I suspect it's the right thing to do. Nobody has complained
> about it, and it fixed real issues during boot.
> 
> Some of those real issues may have ended up being just unnecessary
> delays rather than complete lockups, but still..

FWIW, at $WORK we backported the patch, but we also added an out of
tree patch to disable it on non-x86 systems.  That's mainly because
I'm still hesitant about the safety of relying on this on non-x86
architectures that may have a much simpler micro-archtecture, and
which don't have RDRAND.  But we also have a much more stringent
(paranoid?) philosophy where if there is a risk that our kernels might
be penetrated by a nation-state (viz. Operation Aurora), booting
lockups so we know that we might have a problem that should be
examined by a human being is actually *preferable*.

But note that we work in a world where if there is a risk of exposure
to attacks that can be carried out by a nation state, we'd much rather
solve the problem in hardware (viz., a Titan Chip).

This is ultimately a security philosophy problem about what is more
important.  I'm not terribly worried about doing this for x86,
especially the more modern CPU's that have RDRAND.  I'm more worried
about doing this for say, ARM and RISC-V.  The RISC-V folks haven't
returned my queries; I haven't had the time to try to find some ARM
experts, although the real problem is there are so many different
implementations of the ARM architecture, that what might be applicable
for one architecture might not be for another.

So I'm not super-enthusiastic about backporting the commit to the
stable kernels, but I'm not going to object, either.

Cheers,
						- Ted

P.S.  And for VM's, the real right answer is virtio-rng (since if you
don't trust the hypervisor or the entity running the host OS, you have
no business using a VM in the first place), but I've had this
discussion with Noah on another forum.  :-)
