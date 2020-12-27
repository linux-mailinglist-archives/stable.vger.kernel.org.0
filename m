Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3BE92E32EF
	for <lists+stable@lfdr.de>; Sun, 27 Dec 2020 22:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgL0V0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Dec 2020 16:26:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgL0V0a (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Dec 2020 16:26:30 -0500
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F50C061794;
        Sun, 27 Dec 2020 13:25:50 -0800 (PST)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ktdXf-004aJq-IU; Sun, 27 Dec 2020 21:25:31 +0000
Date:   Sun, 27 Dec 2020 21:25:31 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: LXC broken with 5.10-stable?, ok with 5.9-stable (Re: Linux
 5.10.3)
Message-ID: <20201227212531.GD3579531@ZenIV.linux.org.uk>
References: <16089960203931@kroah.com>
 <5ab86253-7703-e892-52b7-e6a8af579822@iki.fi>
 <CAHk-=wgtU5+7jPuPtDEpwhTuUUkA3CBN=V92Jg0Ag0=3LhfKqA@mail.gmail.com>
 <b45f1065-2da9-08c0-26f2-e5b69e780bc6@iki.fi>
 <CAHk-=wgy6NQrTMwiEWpHUPvW-nfgX7XrBrsxQ6TkRy6NasSFQg@mail.gmail.com>
 <CAHk-=whF=+EzrxP=3zNMH-1L2Nfs7fNoSufqDwOdRQo5qyMwfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whF=+EzrxP=3zNMH-1L2Nfs7fNoSufqDwOdRQo5qyMwfw@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 27, 2020 at 12:12:00PM -0800, Linus Torvalds wrote:
> On Sun, Dec 27, 2020 at 11:05 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > On Sun, Dec 27, 2020 at 10:39 AM Jussi Kivilinna <jussi.kivilinna@iki.fi> wrote:
> > >
> > > 5.10.3 with patch compiles fine, but does not solve the issue.
> >
> > Duh. adding the read_iter only fixes kernel_read(). For splice, it also needs a
> >
> >         .splice_read = generic_file_splice_read,
> >
> > in the file operations, something like this...
> 
> Ok, I verified that patch with the test-case in the bugzilla, and it
> seems trivially fine.
> 
> So it's committed as 14e3e989f6a5 ("proc mountinfo: make splice
> available again") now.

Is there any point in not doing the same (scripted, obviously) for
all instances with .read == seq_read?  IIRC, Christoph even posted
something along those lines, but it went nowhere for some reason...
