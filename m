Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7C487593
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 11:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406154AbfHIJSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 05:18:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406007AbfHIJSR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 05:18:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D74E321883;
        Fri,  9 Aug 2019 09:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565342296;
        bh=I2onxuiZzPQlEvu62Qn0wi0J7+6Ioif5Q/PVr82oRjE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fuhxK7wIzAD6AXUg9CEUvDxtxFD6K/5//hloBTuym5ecVXyIqSHFNuEgjhfS9R8Tc
         s3le4if5Mq/GLc2B1e74FSL26ZUXrKBBgQb49l6uq9sDwFlPajnylj8N9om8ScW0yh
         G5TNyC3aqwAD5932jtq8iC2jzCIlJbu9k7a3QOYI=
Date:   Fri, 9 Aug 2019 10:52:53 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.2 00/20] 5.2.6-stable review
Message-ID: <20190809085253.GA25046@kroah.com>
References: <20190802092055.131876977@linuxfoundation.org>
 <20190802172105.18999-1-thierry.reding@gmail.com>
 <20190803070932.GB24334@kroah.com>
 <20190805114821.GA24378@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805114821.GA24378@ulmo>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 05, 2019 at 01:48:21PM +0200, Thierry Reding wrote:
> Hi Greg,

Sorry for the delay, this got pushed down my queue...

> I stumbled across something as I was attempting to automate more parts
> of our process to generate these reports. The original test results were
> from a different version of the tree: 5.2.6-rc1-gdbc7f5c7df28. I suspect
> that's the same thing that you were discussing with Pavel regarding the
> IP tunnel patch that was added subsequent to the announcement.
> 
> Just for my understanding, does this mean that the patch still makes it
> into the 5.2.6 release, or was it supposed to go into 5.2.7?
> 
> One problem that I ran into was that when I tried to correlate the test
> results with your announcement email, there's no indication other than
> the branch name and the release candidate name (5.2.6-rc1 in this case),
> so there's no way to uniquely identify which test run belongs to the
> announcement. Given that there are no tags for the release candidates
> means that that's also not an option to uniquely associate with the
> builds and tests.
> 
> While the differences between the two builds are very minor here, I
> wonder if there could perhaps in the future be a problem where I report
> successful results for a test, but the same tests would be broken by a
> patch added to the stable-rc branch subsequent to the announcement. The
> test report would be misleading in that case.
> 
> I noticed that you do add a couple of X-KernelTest-* headers to your
> announcement emails, so I'm wondering if perhaps it was possible for you
> to add another one that contains the exact SHA1 that corresponds to the
> snapshot that's the release candidate. That would allow everyone to
> uniquely associate test results with a specific release candidate.
> 
> That said, perhaps I've just got this all wrong and there's already a
> way to connect all the dots that I'm not aware of. Or maybe I'm being
> too pedantic here?

You aren't being pedantic, I think you are missing exactly what the
linux-stable-rc tree is for and how it is created.

Granted, it's not really documented anywhere so it's not your fault :)

The linux-stable-rc tree is there ONLY for people who want to test the
-rc kernels and can not, or do not want to, use the quilt tree of
patches in the stable-queue.git tree on kernel.org.  I generate the
branches there from a script that throws away the current -rc branch and
rebuilds it "from scratch" by applying the patches that are in the
stable-quilt tree and then adds the -rc patch as well.  This tree is
generated multiple times when I am working on the queues and then when I
want to do a "real" -rc release.

The branches are constantly rebased, so you can not rely on 'git pull'
doing the right thing (unless you add --rebase to it), and are there for
testing only.

Yes, you will see different results of a "-rc1" release in the tree
depending on the time of day/week when I created the tree, and sometimes
I generate them multiple times a day just to have some of the
auto-builders give me results quickly (Linaro does pull from it and
sends me results within the hour usually).

So does that help?  Ideally everyone would just use the quilt trees from
stable-queue.git, but no everyone likes that, so the -rc git tree is
there to make automated testing "easier".  If that works with your
workflow, wonderful, feel free to use it.  If not, then go with the
stable-quilt.git tree, or the tarballs on kernel.org.

And as for the SHA1 being in the emails, that doesn't make all that much
sense as that SHA1 doesn't live very long.  When I create the trees
locally, I instantly delete them after pushing them to kernel.org so I
can't regenerate them or do anything with them.

DOes that help explain things better?

thanks,

greg k-h
