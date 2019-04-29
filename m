Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B827E56C
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 16:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbfD2Owv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 10:52:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728339AbfD2Owv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Apr 2019 10:52:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50693205F4;
        Mon, 29 Apr 2019 14:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556549570;
        bh=dmv/VXRxLhhAASRu93j/oRMntexS+CBhC9fOzX7ANGw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PkW5Ae+83WgYj93JZbzs3q7OL7b0ZJKs5G0DpEUa1E7nPteV1edEkv/pYznW0eQg2
         GokahGngNHxBkKYFAA+ODsF38s8Sn/6eNaeyQEeGb91jyVMWvxS5UQ1Y2TiSKp+ucz
         1ZyR3fj1omt8QUOn8TZpjGtY59FOl0cPYAZScucQ=
Date:   Mon, 29 Apr 2019 16:52:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nicolas Iooss <nicolas.iooss@m4x.org>
Subject: Re: scripts/selinux build error in 4.14 after glibc update
Message-ID: <20190429145248.GA7111@kroah.com>
References: <20190422210041.GA21711@archlinux-i9>
 <CAHC9VhTtz3OA3EchaZaAeg=DxoGoz_WFdj+Mi9nd9i+cmjmuJA@mail.gmail.com>
 <20190423132926.GK17719@sasha-vm>
 <CAHC9VhRcdY7G_ES2VqNVpkoU=CRJkJySb3m1sFdgKJwh3JQ2oA@mail.gmail.com>
 <20190429124002.GB31371@kroah.com>
 <CAHC9VhQxrtYJTOj=aOL4FY=myA4ZO-rcY7TdCeFbjVnCmgOxew@mail.gmail.com>
 <20190429140906.GA7412@kroah.com>
 <CAHC9VhRDoYd=vfz3Sm8NKpMW_QoX7t_VohumUxU5i6AjTwCRyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhRDoYd=vfz3Sm8NKpMW_QoX7t_VohumUxU5i6AjTwCRyQ@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 29, 2019 at 10:47:00AM -0400, Paul Moore wrote:
> On Mon, Apr 29, 2019 at 10:09 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Mon, Apr 29, 2019 at 10:02:29AM -0400, Paul Moore wrote:
> > > On Mon, Apr 29, 2019 at 8:40 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > > On Tue, Apr 23, 2019 at 09:43:09AM -0400, Paul Moore wrote:
> > > > > On Tue, Apr 23, 2019 at 9:29 AM Sasha Levin <sashal@kernel.org> wrote:
> > > > > > On Mon, Apr 22, 2019 at 09:59:47PM -0400, Paul Moore wrote:
> > > > > > >On Mon, Apr 22, 2019 at 5:00 PM Nathan Chancellor
> > > > > > ><natechancellor@gmail.com> wrote:
> > > > > > >> Hi all,
> > > > > > >>
> > > > > > >> After a glibc update to 2.29, my 4.14 builds started failing like so:
> > > > > > >
> > > > > > >...
> > > > > > >
> > > > > > >>   HOSTCC  scripts/selinux/genheaders/genheaders
> > > > > > >> In file included from scripts/selinux/genheaders/genheaders.c:19:
> > > > > > >> ./security/selinux/include/classmap.h:245:2: error: #error New address family defined, please update secclass_map.
> > > > > > >>  #error New address family defined, please update secclass_map.
> > > > > > >>   ^~~~~
> > > > > > >
> > > > > > >This is a known problem that has a fix in the selinux/next branch and
> > > > > > >will be going up to Linus during the next merge window.  The fix is
> > > > > > >quite small and should be relatively easy for you to backport to your
> > > > > > >kernel build if you are interested; the patch can be found at the
> > > > > > >archive link below:
> > > > > > >
> > > > > > >https://lore.kernel.org/selinux/20190225005528.28371-1-paulo@paulo.ac
> > > > > >
> > > > > > Why is it waiting for the next merge window? It fixes a build bug that
> > > > > > people hit.
> > > > >
> > > > > I place a reasonably high bar on patches that I send up to Linus
> > > > > outside of the merge window and I didn't feel this patch met that
> > > > > criteria.  Nathan is only the second person I've seen who has
> > > > > encountered this problem, the first being the original patch author.
> > > > > As far as I've seen, the problem is only seen by users building older
> > > > > kernels on very new userspaces (e.g. glibc v2.29 was released in
> > > > > February 2019, Linux v4.14 was released in 2017); this doesn't appear
> > > > > to be a large group of people and I didn't want to risk breaking the
> > > > > main kernel tree during the -rcX phase for such a small group.
> > > >
> > > > Ugh, this breaks my local builds, I would recommend getting it to Linus
> > > > sooner please.
> > >
> > > Well, we are at -rc7 right now and it looks like an -rc8 is unlikely
> > > so the question really comes down to can/do you want to wait a week?
> >
> > It's a regression in the 5.1-rc tree, that is hitting people now.  Why
> > do you want to have a 5.1-final that is known to be broken?
> 
> I believe I answered that in my reply to Sasha.  Can you answer the
> question I asked of you above?

If you don't submit it this week, I guess I can wait as I have no other
choice.

But note, this did break my build systems, and my main development
system this weekend.  So yes, the number of people being affected might
be "small", but that "small" number includes the people responsible for
maintaining those stable kernels :(

Anyway, it's your call, just letting you know I'm really annoyed at the
moment by this...

greg k-h
