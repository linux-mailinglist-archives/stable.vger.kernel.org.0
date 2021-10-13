Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B1F42C6B3
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 18:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhJMQud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 12:50:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229559AbhJMQuc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Oct 2021 12:50:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26FDA60EB4;
        Wed, 13 Oct 2021 16:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634143709;
        bh=BFqRpZywG1v6AlOtTl9eDc60gBxGssJVA2WVf3D5fJU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MSly2AE51VvcB17lwla5QIXwa6tuLgLQyeNxQLEmMIjAKaz0dSY3HiV5XkFFXgw9o
         gEDMpodSQXXdLkKTggs/E623NkPzM+LCfd9zVxehOmfbcYPOEHGioN/0bbgCuEG1cI
         KTFZKk3NWdAWUB55xjP7Hxz6IXUHp4I5yOmWVlto=
Date:   Wed, 13 Oct 2021 18:48:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: Use of "Fixes" tag for trivial fixes
Message-ID: <YWcN2+XZ8+h4Jrwr@kroah.com>
References: <19ffe0d6-f957-135c-cbae-14a0a46f3183@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19ffe0d6-f957-135c-cbae-14a0a46f3183@tessares.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 13, 2021 at 04:47:55PM +0200, Matthieu Baerts wrote:
> Hi Greg, Sasha,
> 
> First, thank you for your great job maintaining the stable versions!
> 
> In our work related to MPTCP, we were wondering if we should/can add the
> "Fixes" tag for trivial/stable fixes.
> 
> It is certainly easier to explain that with an example: we have a small
> patch [1] to stop exposing a function that is only used from one .c file
> and declared there too. So the signature is removed from the .h file and
> the 'static' keyword is added in the .c file. It should have been like
> that since the introduction of this function.
> 
> We don't know if we can/should add the "Fixes" tag for such cases: the
> "mistake" has been introduced by one specific commit so we could add the
> "Fixes" tag but we also know patches with such tags are certainly going
> to be automatically backported. The patch is not really fixing a bug,
> more a "cleaning". Does it make sense to backport these patches then?
> 
> On one hand, we might think it would be interesting to backport it to
> reduce the differences with the last version: if the idea is to backport
> simple fixes to ease future and maybe more complex backports later. But
> on the other hand, it is more work for you to backport it: if the idea
> is to backport only actual bug-fix patches. So what is the preferred policy?
> 
> We didn't find anything in the doc on "when not to add the 'Fixes' tag"
> but we know the Stable Kernel Rules doc mentions to avoid trivial fixes.
> Maybe this patch is not "trivial", it is not really a bug-fix either but
> that's not the real question here, more: does this rule -- and other
> ones from Stable Kernel doc -- apply to the "Fixes" tag as well?

Please use the Fixes: tag whenever you want to.  Having it there does
NOT mean the patch is automatically backported to stable releases, we
look at them all and choose if they are valid or not.

There are lots of tiny "Fixes:" commits that we do not backport for
obvious reasons that they do not fit the stable kernel requirements.

If you know a patch should be backported to a stable tree, then put the
 cc: stable on it, as documented.  Again, "Fixes:" is no guarantee that
a commit will be backported at all.

thanks,

greg k-h
