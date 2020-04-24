Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421E11B7D0F
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 19:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbgDXRil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 13:38:41 -0400
Received: from mother.openwall.net ([195.42.179.200]:54078 "HELO
        mother.openwall.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726908AbgDXRik (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 13:38:40 -0400
Received: (qmail 12213 invoked from network); 24 Apr 2020 17:38:38 -0000
Received: from localhost (HELO pvt.openwall.com) (127.0.0.1)
  by localhost with SMTP; 24 Apr 2020 17:38:38 -0000
Received: by pvt.openwall.com (Postfix, from userid 503)
        id CF163AB5C7; Fri, 24 Apr 2020 19:38:28 +0200 (CEST)
Date:   Fri, 24 Apr 2020 19:38:28 +0200
From:   Solar Designer <solar@openwall.com>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Salvatore Mesoraca <s.mesoraca16@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.16 208/245] namei: allow restricted O_CREAT of FIFOs and regular files
Message-ID: <20200424173828.GA27528@openwall.com>
References: <lsq.1587683027.831233700@decadent.org.uk> <lsq.1587683028.722200761@decadent.org.uk> <20200424135205.GA27204@openwall.com> <8783c94cb802ade8a45cdf4233fe3b7341cca5c9.camel@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8783c94cb802ade8a45cdf4233fe3b7341cca5c9.camel@decadent.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 24, 2020 at 04:13:22PM +0100, Ben Hutchings wrote:
> On Fri, 2020-04-24 at 15:52 +0200, Solar Designer wrote:
> > On Fri, Apr 24, 2020 at 12:07:15AM +0100, Ben Hutchings wrote:
> > > 3.16.83-rc1 review patch.  If anyone has any objections, please let me know.
> > 
> > I do.  This patch is currently known-buggy, see this thread:
> > 
> > https://www.openwall.com/lists/oss-security/2020/01/28/2
> > 
> > It is (partially) fixed with these newer commits in 5.5 and 5.5.2:
> > 
> > commit d0cb50185ae942b03c4327be322055d622dc79f6
> > Author: Al Viro <viro@zeniv.linux.org.uk>
> > Date:   Sun Jan 26 09:29:34 2020 -0500
> > 
> >     do_last(): fetch directory ->i_mode and ->i_uid before it's too late
> >     
> >     may_create_in_sticky() call is done when we already have dropped the
> >     reference to dir.
> >     
> >     Fixes: 30aba6656f61e (namei: allow restricted O_CREAT of FIFOs and regular files)
> >     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > 
> > commit d76341d93dedbcf6ed5a08dfc8bce82d3e9a772b
> > Author: Al Viro <viro@zeniv.linux.org.uk>
> > Date:   Sat Feb 1 16:26:45 2020 +0000
> > 
> >     vfs: fix do_last() regression
> >     
> >     commit 6404674acd596de41fd3ad5f267b4525494a891a upstream.
> [...]
> > At least inclusion of the above fixes is mandatory for any backports.
> 
> I know, and those are the next 2 patches in the series.

Ah, then no objections from me.

> > Also, I think no one has fixed the logic of may_create_in_sticky() so
> > that it wouldn't unintentionally apply the "protection" when the file
> > is neither a FIFO nor a regular file (something I found and mentioned in
> > the oss-security posting above).
> [...]
> > I think the implementation of may_create_in_sticky() should be rewritten
> > such that it'd directly correspond to the textual description in the
> > comment above.  As we've seen, trying to write the code "more optimally"
> > resulted in its logic actually being different from the description.
> > 
> > Meanwhile, I think backporting known-so-buggy code is a bad idea.
> 
> I can see that it's not quite right, but does it matter in practice? 
> Directories and symlinks are handled separately; sockets can't be
> opened anyway; block and character devices wonn't normally appear in a
> sticky directory.

Clearly, it doesn't matter all that much in practice - I'm not aware of
anyone having complained about it causing issues on their system.

I think it primarily mattered as an attack vector on the issue fixed
with Al's commits above.

I think we should nevertheless fix the code to match its intent and the
comment, but meanwhile this isn't a blocker for the backport.

Alexander
