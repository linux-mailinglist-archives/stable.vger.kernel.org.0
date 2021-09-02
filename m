Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA6F3FEEA6
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 15:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345112AbhIBN2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 09:28:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:58026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345033AbhIBN2q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Sep 2021 09:28:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAE2260525;
        Thu,  2 Sep 2021 13:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630589268;
        bh=do/fDww6sgdWV/W986/c6UAnHMCoHd+IHCgtE+5+8dE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=n+y0vtkNPBB4LpFz5h8umcnfxSQKnRPTMPmbgREGQGQIw2ktx+NG1nI2oh4bvzibZ
         yEJ7ucJmKL2PdViE3ilbM7uA/uBzwMJtFYK0IGQ5yqWrG3Ud9ZAcC5a42sdyv7cXeE
         IVlzjxnZCAWTzZ9Yn+4jvSV2GB1gX3rO8CS9dmLfB6/iWAym08g9VTmKYTvd1inHug
         +1Qu/SN4bimSjGnof4K849D5m3aKyb5266AmcoT3y5qn7vBeUq4PqqQxVvMSIjlzyS
         edZgH7m/xv4NU2nWbbMQ0P7ZL67Q+bYzw1Bkg0Bjmo++veKOwPJz747Dt+9Kfy73RY
         U/W0fIT8a/4Ng==
Message-ID: <329ccdd224e763f1fe53f2ad88b8c835d76f55f0.camel@kernel.org>
Subject: Re: [PATCH 5.13 126/127] fs: warn about impending deprecation of
 mandatory locks
From:   Jeff Layton <jlayton@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>
Date:   Thu, 02 Sep 2021 09:27:46 -0400
In-Reply-To: <CA+G9fYveOoHUydWRjRWtKcF3smTXt3F3ChxuZuDSoxCkDA1rPw@mail.gmail.com>
References: <20210824165607.709387-1-sashal@kernel.org>
         <20210824165607.709387-127-sashal@kernel.org>
         <CA+G9fYveOoHUydWRjRWtKcF3smTXt3F3ChxuZuDSoxCkDA1rPw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2021-09-02 at 18:50 +0530, Naresh Kamboju wrote:
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
> 

You really don't want to run those tests anymore then. The "mand" mount
option no longer works, so any tests that require mandatory locking
won't function correctly.

-- 
Jeff Layton <jlayton@kernel.org>

