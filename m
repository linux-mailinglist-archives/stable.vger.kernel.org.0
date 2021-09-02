Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F183FEEB0
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 15:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345185AbhIBNcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 09:32:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234416AbhIBNcE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Sep 2021 09:32:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4052A60525;
        Thu,  2 Sep 2021 13:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630589465;
        bh=2gddQhq/+9fbES1mIIJRgMVIOZKUidsgyvi7ZWiKsaQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kHhn2gix/pXpS0oLsbkQJ//mKo7Z7T6N6PRpvnikGjRoqIrvgMlfE0c1+g23dHCNw
         yNzx8m4e9QvhQNUPMj2fhZ8FopZ9/Z6PKG3g2Sh5QrkEQMD6Fx0qFWjGnCqLWvj4wF
         vf4PF/7NEw6ioxg5eZiM10JlFQkVXh+bQN4r0WSQ=
Date:   Thu, 2 Sep 2021 15:31:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH 5.13 126/127] fs: warn about impending deprecation of
 mandatory locks
Message-ID: <YTDSFr52yweeAkSa@kroah.com>
References: <20210824165607.709387-1-sashal@kernel.org>
 <20210824165607.709387-127-sashal@kernel.org>
 <CA+G9fYveOoHUydWRjRWtKcF3smTXt3F3ChxuZuDSoxCkDA1rPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYveOoHUydWRjRWtKcF3smTXt3F3ChxuZuDSoxCkDA1rPw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 02, 2021 at 06:50:48PM +0530, Naresh Kamboju wrote:
> On Tue, 24 Aug 2021 at 22:35, Sasha Levin <sashal@kernel.org> wrote:
> >
> > From: Jeff Layton <jlayton@kernel.org>
> >
> > [ Upstream commit fdd92b64d15bc4aec973caa25899afd782402e68 ]
> >
> > We've had CONFIG_MANDATORY_FILE_LOCKING since 2015 and a lot of distros
> > have disabled it. Warn the stragglers that still use "-o mand" that
> > we'll be dropping support for that mount option.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  fs/namespace.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/namespace.c b/fs/namespace.c
> > index caad091fb204..03770bae9dd5 100644
> > --- a/fs/namespace.c
> > +++ b/fs/namespace.c
> > @@ -1716,8 +1716,12 @@ static inline bool may_mount(void)
> >  }
> >
> >  #ifdef CONFIG_MANDATORY_FILE_LOCKING
> > -static inline bool may_mandlock(void)
> > +static bool may_mandlock(void)
> >  {
> > +       pr_warn_once("======================================================\n"
> > +                    "WARNING: the mand mount option is being deprecated and\n"
> > +                    "         will be removed in v5.15!\n"
> > +                    "======================================================\n");
> 
> We are getting this error on all devices while running LTP syscalls
> ftruncate test cases
> on all the stable-rc branches.

It's not an "error", it's a warning that the test should be fixed :)

thanks,

greg k-h
