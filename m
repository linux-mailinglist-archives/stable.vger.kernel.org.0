Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 428CB6A9527
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 11:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjCCK0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 05:26:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjCCK0t (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 05:26:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E10D1A973;
        Fri,  3 Mar 2023 02:26:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 253E7B811FB;
        Fri,  3 Mar 2023 10:26:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EDE1C433D2;
        Fri,  3 Mar 2023 10:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677839204;
        bh=V00pRmRcuC8aIa/PFnWwUrJ6UZhk90VMutMMuOsX6g8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S2OubzhBn38d1gvoCA2XXfcKSS7N14HFYDgcsRXnbvR3WmxQq31L+aLQ9NcEMp8x4
         eWk7iM21Mb1qXfUimaNVz9uejpzFx19J5Kr7cn/4eYh3ETWO7GwcSuyOgSldsJR90j
         WRl497nkjFRCY2C+EPFmV4vZ+7JXpUW+ylXokhik=
Date:   Fri, 3 Mar 2023 11:26:42 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de, mptcp@lists.linux.dev,
        Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 6.1 00/42] 6.1.15-rc1 review
Message-ID: <ZAHLYvOPEYghRcJ1@kroah.com>
References: <20230301180657.003689969@linuxfoundation.org>
 <CA+G9fYtDGpgT4dckXD-y-N92nqUxuvue_7AtDdBcHrbOMsDZLg@mail.gmail.com>
 <ZAB6pP3MNy152f+7@kroah.com>
 <CA+G9fYsHbQyQFp+vMnmFKDSQxrmj-VKsexWq-aayxgrY+0O7KQ@mail.gmail.com>
 <CA+G9fYsn+AhWTFA+ZJmfFsM71WGLPOFemZp_vhFMMLUcgcAXKg@mail.gmail.com>
 <9586d0f99e27483b600d8eb3b5c6635b50905d82.camel@redhat.com>
 <CA+G9fYuLQEfeTjx52NxbXV5914YJQ2tVd8k4SJjrAryujPjnqA@mail.gmail.com>
 <ZAG8dla274kYfxoK@kroah.com>
 <3d92e773-896c-43c3-94ae-cb7851213c55@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3d92e773-896c-43c3-94ae-cb7851213c55@tessares.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 03, 2023 at 10:47:33AM +0100, Matthieu Baerts wrote:
> Hi Greg, Naresh, Paolo,
> 
> Thank you for the new version and for having reported the issue and running MPTCP selftests!
> 
> 3 Mar 2023 10:23:06 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> 
> > On Fri, Mar 03, 2023 at 02:34:05PM +0530, Naresh Kamboju wrote:
> >> On Fri, 3 Mar 2023 at 13:34, Paolo Abeni <pabeni@redhat.com> wrote:
> >>>
> >>> Hello,
> >>>
> >>> On Fri, 2023-03-03 at 01:32 +0530, Naresh Kamboju wrote:
> >>>> On Thu, 2 Mar 2023 at 16:30, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >>>>>
> >>>>> On Thu, 2 Mar 2023 at 16:00, Greg Kroah-Hartman
> >>>>> <gregkh@linuxfoundation.org> wrote:
> >>>>>> …
> >>>>>
> >>>>> ....
> >>>>>
> >>>>>> …
> >>>>>
> >>>>> Me either.
> >>>>> That is the reason I have shared "Assertion" above.
> >>>>>
> >>>>>> …
> >>>>>
> >>>>> We are running our bisection scripts.
> >>>>
> >>>> We have tested with 6.1.14 kselftests source again and it passes.
> >>>> Now that we have upgraded to 6.2.1 kselftests source, we find that
> >>>> there is this problem reported. so, not a kernel regression.
> >>>
> >>> I read the above as you are running self-tests from 6.2.1 on top of an
> >>> older (6.1) kernel. Is that correct?
> >>
> >> correct.
> >>
> >>> If so failures are expected;
> >
> > Shouldn't the test be able to know that "new features" are not present
> > and properly skip the test for when that happens?  Otherwise this feels
> > like a problem going forward as no one will know if this feature can be
> > used or not (assuming it is a new feature and not just a functional
> > change.)
> 
> All MPTCP selftests are designed to run on the same kernel version
> they are attached to. This allows us to do more checks knowing they
> are not supposed to fail on newer kernel versions and not being
> skipped if there is an error when trying to use the new feature. If
> there are fixes, we make sure the stable team is Cc'ed. If there are
> API changes, it would be visible because we would need to adapt
> existing selftests.

"Features" are not usually limited to specific kernel versions (think
about the mess that "enterprise" kernels create by backports).  And if
they are, running a userspace test should be able to detect if the
feature is present or not by the error returned to it, right?  If not,
then the feature is mis-designed.

> That's how we thought we should design MPTCP selftests. Maybe we need to change this design?

Yes, please "skip" tests for features that are just not present, do not
fail them.

> Is it a common practice to run selftests' latest version on older kernels?

Yes.

thanks,

greg k-h
