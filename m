Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C02B82E9501
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 13:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbhADMio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 07:38:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:57220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726612AbhADMin (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 07:38:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A53A20770;
        Mon,  4 Jan 2021 12:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609763882;
        bh=YFyxuG7ZCAHOWy07xspj4tV3y2moP86wc3mkEOK4OO4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nC9KUT3h7s8E7meCacXGBBdEiM00503KBX2cSXk1XrdARuv3cv3N9n9Gz532B9+iP
         Q6hOysVHQMkxBHp/FFn54uNJrHaRzDGFudZcr/UN5F1rvlOggbyDUmB5IunQT4GYqh
         t/j7Jw5G4PR9iVgD3dD/3+srzdYK9id85lQxd1gg=
Date:   Mon, 4 Jan 2021 13:39:28 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.2 00/20] 5.2.6-stable review
Message-ID: <X/MMgPChJ2C+85Tf@kroah.com>
References: <20190802092055.131876977@linuxfoundation.org>
 <20190802172105.18999-1-thierry.reding@gmail.com>
 <20190803070932.GB24334@kroah.com>
 <20190805114821.GA24378@ulmo>
 <20190809085253.GA25046@kroah.com>
 <20190809130449.GA27957@ulmo>
 <20190809154959.GD22879@kroah.com>
 <20190812090553.GA8903@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812090553.GA8903@ulmo>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 12, 2019 at 11:05:53AM +0200, Thierry Reding wrote:
> On Fri, Aug 09, 2019 at 05:49:59PM +0200, Greg Kroah-Hartman wrote:
> > On Fri, Aug 09, 2019 at 03:04:49PM +0200, Thierry Reding wrote:
> > > On Fri, Aug 09, 2019 at 10:52:53AM +0200, Greg Kroah-Hartman wrote:
> > > > On Mon, Aug 05, 2019 at 01:48:21PM +0200, Thierry Reding wrote:
> > > > > Hi Greg,
> > > > 
> > > > Sorry for the delay, this got pushed down my queue...
> > > > 
> > > > > I stumbled across something as I was attempting to automate more parts
> > > > > of our process to generate these reports. The original test results were
> > > > > from a different version of the tree: 5.2.6-rc1-gdbc7f5c7df28. I suspect
> > > > > that's the same thing that you were discussing with Pavel regarding the
> > > > > IP tunnel patch that was added subsequent to the announcement.
> > > > > 
> > > > > Just for my understanding, does this mean that the patch still makes it
> > > > > into the 5.2.6 release, or was it supposed to go into 5.2.7?
> > > > > 
> > > > > One problem that I ran into was that when I tried to correlate the test
> > > > > results with your announcement email, there's no indication other than
> > > > > the branch name and the release candidate name (5.2.6-rc1 in this case),
> > > > > so there's no way to uniquely identify which test run belongs to the
> > > > > announcement. Given that there are no tags for the release candidates
> > > > > means that that's also not an option to uniquely associate with the
> > > > > builds and tests.
> > > > > 
> > > > > While the differences between the two builds are very minor here, I
> > > > > wonder if there could perhaps in the future be a problem where I report
> > > > > successful results for a test, but the same tests would be broken by a
> > > > > patch added to the stable-rc branch subsequent to the announcement. The
> > > > > test report would be misleading in that case.
> > > > > 
> > > > > I noticed that you do add a couple of X-KernelTest-* headers to your
> > > > > announcement emails, so I'm wondering if perhaps it was possible for you
> > > > > to add another one that contains the exact SHA1 that corresponds to the
> > > > > snapshot that's the release candidate. That would allow everyone to
> > > > > uniquely associate test results with a specific release candidate.
> > > > > 
> > > > > That said, perhaps I've just got this all wrong and there's already a
> > > > > way to connect all the dots that I'm not aware of. Or maybe I'm being
> > > > > too pedantic here?
> > > > 
> > > > You aren't being pedantic, I think you are missing exactly what the
> > > > linux-stable-rc tree is for and how it is created.
> > > > 
> > > > Granted, it's not really documented anywhere so it's not your fault :)
> > > > 
> > > > The linux-stable-rc tree is there ONLY for people who want to test the
> > > > -rc kernels and can not, or do not want to, use the quilt tree of
> > > > patches in the stable-queue.git tree on kernel.org.  I generate the
> > > > branches there from a script that throws away the current -rc branch and
> > > > rebuilds it "from scratch" by applying the patches that are in the
> > > > stable-quilt tree and then adds the -rc patch as well.  This tree is
> > > > generated multiple times when I am working on the queues and then when I
> > > > want to do a "real" -rc release.
> > > > 
> > > > The branches are constantly rebased, so you can not rely on 'git pull'
> > > > doing the right thing (unless you add --rebase to it), and are there for
> > > > testing only.
> > > > 
> > > > Yes, you will see different results of a "-rc1" release in the tree
> > > > depending on the time of day/week when I created the tree, and sometimes
> > > > I generate them multiple times a day just to have some of the
> > > > auto-builders give me results quickly (Linaro does pull from it and
> > > > sends me results within the hour usually).
> > > > 
> > > > So does that help?  Ideally everyone would just use the quilt trees from
> > > > stable-queue.git, but no everyone likes that, so the -rc git tree is
> > > > there to make automated testing "easier".  If that works with your
> > > > workflow, wonderful, feel free to use it.  If not, then go with the
> > > > stable-quilt.git tree, or the tarballs on kernel.org.
> > > 
> > > I'll have to look into that, to see if that'd work. I have to admit that
> > > having a git tree to point scripts at is rather convenient for
> > > automation.
> > > 
> > > > And as for the SHA1 being in the emails, that doesn't make all that much
> > > > sense as that SHA1 doesn't live very long.  When I create the trees
> > > > locally, I instantly delete them after pushing them to kernel.org so I
> > > > can't regenerate them or do anything with them.
> > > 
> > > Fair enough. I suppose the worst thing that could happen is that we may
> > > fail to test a couple of commits occasionally. In the rare case where
> > > this actually matters we'll likely end up reporting the failure for the
> > > stable release, in which case it can be fixed in the next one.
> > > 
> > > > DOes that help explain things better?
> > > 
> > > Yes, makes a lot more sense now. Thanks for taking the time to explain
> > > it. Do you want me to snapshot this and submit it as documentation
> > > somewhere for later reference?
> > 
> > It probably should go somewhere, but as the number of people that do
> > "test stable kernels in an automated way" is very low, so far I've been
> > doing ok with a one-by-one explaination.  I guess if it's more obvious,
> > more people would test, so sure, this should be cleaned up...
> 
> How about something like the below. It applies to the stable-queue.git
> repository.
> 
> Thierry
> 
> --- >8 ---
> From 4083add6ccb4a1c23edeba650170470bcc5d5205 Mon Sep 17 00:00:00 2001
> From: Thierry Reding <treding@nvidia.com>
> Date: Mon, 12 Aug 2019 10:58:35 +0200
> Subject: [PATCH] Describe the stable-queue release process
> 
> Add a README file that describes how release candidates for stable
> kernels are created and how users are expected to use them. This is
> reworded from Greg's reply here:
> 
> 	https://lore.kernel.org/stable/20190809085253.GA25046@kroah.com/
> ---
>  README | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>  create mode 100644 README
> 
> diff --git a/README b/README
> new file mode 100644
> index 000000000000..868469a73f68
> --- /dev/null
> +++ b/README
> @@ -0,0 +1,31 @@
> +This repository is the canonical source for patches that make up the stable
> +kernel releases. It consists of a set of directories for each of the stable
> +kernels, as well as a directory that contains a snapshot of the patches for
> +each stable release.
> +
> +The patches for each release can be found along with a complete tarball of
> +a release in the following location:
> +
> +	https://kernel.org/pub/linux/kernel/vX.Y/
> +
> +For each stable release candidate, a patch representing the diff of all the
> +patches in the stable queue is uploaded here:
> +
> +	https://kernel.org/pub/linux/kernel/vX.Y/stable-review/
> +
> +As a convenience for people that want to test release candidates of stable
> +releases, a branch of the kernel git tree is created containing all of the
> +patches in the given stable queue. These branches are available in the
> +following repository:
> +
> +	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> +
> +A branch exists for each of the stable releases. Note, though, that these
> +branches are recreated from scratch by applying the queued stable patches
> +on top of the prior release. As a consequence, the branches are not fast-
> +forward and can change after a release candidate has been announced. The
> +contents of the branch may therefore not match exactly what was released
> +as the release candidate, depending on when you fetch it. No tags are
> +created to track individual release candidates. If you're interested in
> +exact reproducibility of a stable release candidate, please use the patches
> +from the location mentioned above.
> -- 

Sorry for the very long delay, cleaning out old emails...

This looks really good, thanks for writing it up, I've now applied it to
the stable-queue tree.

greg k-h
