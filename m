Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1719D62D2FF
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 06:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239123AbiKQFuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 00:50:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239298AbiKQFuK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 00:50:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A91A11813;
        Wed, 16 Nov 2022 21:49:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C19F462085;
        Thu, 17 Nov 2022 05:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1FEC433D6;
        Thu, 17 Nov 2022 05:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668664198;
        bh=qGKZERLnu8H566XOnqj6FLlWt0eOikd2hAvc/xFshHU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D9NNrD2fNtF7I72M6hrNhHhwkE2rhBXmwCdDK8zyAqTTmwRIFYD8KFuG7BWWnwbHO
         oWYhw9cBKohhzm1BSqMZa60ABglKr+cHH8E6/Kks2Pl8YyevoNX4FPKY196qp0r3a4
         cv8MWhjq/phiXboDHlQQVjm0Ujb5crZk7pYpUmNg=
Date:   Thu, 17 Nov 2022 06:49:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Roberto Sassu <roberto.sassu@huaweicloud.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, revest@chromium.org, jackmanb@chromium.org,
        jmorris@namei.org, serge@hallyn.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Subject: Re: [RFC][PATCH 3/4] lsm: Redefine LSM_HOOK() macro to add return
 value flags as argument
Message-ID: <Y3XLgrYbIEpdW0vy@kroah.com>
References: <20221115175652.3836811-1-roberto.sassu@huaweicloud.com>
 <20221115175652.3836811-4-roberto.sassu@huaweicloud.com>
 <CAHC9VhTA7SgFnTFGNxOGW38WSkWu7GSizBmNz=TuazUR4R_jUg@mail.gmail.com>
 <83cbff40f16a46e733a877d499b904cdf06949b6.camel@huaweicloud.com>
 <CAHC9VhRX0J8Z61_fH9T5O1ZpRQWSppQekxP8unJqStHuTwQkLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhRX0J8Z61_fH9T5O1ZpRQWSppQekxP8unJqStHuTwQkLQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 16, 2022 at 05:04:05PM -0500, Paul Moore wrote:
> On Wed, Nov 16, 2022 at 3:11 AM Roberto Sassu
> <roberto.sassu@huaweicloud.com> wrote:
> > On Tue, 2022-11-15 at 21:27 -0500, Paul Moore wrote:
> > > On Tue, Nov 15, 2022 at 12:58 PM Roberto Sassu
> > > <roberto.sassu@huaweicloud.com> wrote:
> > > > From: Roberto Sassu <roberto.sassu@huawei.com>
> > > >
> > > > Define four return value flags (LSM_RET_NEG, LSM_RET_ZERO, LSM_RET_ONE,
> > > > LSM_RET_GT_ONE), one for each interval of interest (< 0, = 0, = 1, > 1).
> > > >
> > > > Redefine the LSM_HOOK() macro to add return value flags as argument, and
> > > > set the correct flags for each LSM hook.
> > > >
> > > > Implementors of new LSM hooks should do the same as well.
> > > >
> > > > Cc: stable@vger.kernel.org # 5.7.x
> > > > Fixes: 9d3fdea789c8 ("bpf: lsm: Provide attachment points for BPF LSM programs")
> > > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > > > ---
> > > >  include/linux/bpf_lsm.h       |   2 +-
> > > >  include/linux/lsm_hook_defs.h | 779 ++++++++++++++++++++--------------
> > > >  include/linux/lsm_hooks.h     |   9 +-
> > > >  kernel/bpf/bpf_lsm.c          |   5 +-
> > > >  security/bpf/hooks.c          |   2 +-
> > > >  security/security.c           |   4 +-
> > > >  6 files changed, 466 insertions(+), 335 deletions(-)
> > >
> > > Just a quick note here that even if we wanted to do something like
> > > this, it is absolutely not -stable kernel material.  No way.
> >
> > I was unsure about that. We need a proper fix for this issue that needs
> > to be backported to some kernels. I saw this more like a dependency.
> > But I agree with you that it would be unlikely that this patch is
> > applied to stable kernels.
> >
> > For stable kernels, what it would be the proper way? We still need to
> > maintain an allow list of functions that allow a positive return value,
> > at least. Should it be in the eBPF code only?
> 
> Ideally the fix for -stable is the same as what is done for Linus'
> kernel (ignoring backport fuzzing), so I would wait and see how that
> ends up first.  However, if the patchset for Linus' tree is
> particularly large and touches a lot of code, you may need to work on
> something a bit more targeted to the specific problem.  I tend to be
> more conservative than most kernel devs when it comes to -stable
> patches, but if you can't backport the main upstream patchset, smaller
> (both in terms of impact and lines changed) is almost always better.

No, the mainline patch (what is in Linus's tree), is almost always
better and preferred for stable backports.  When you diverge, bugs
happen, almost every time, and it makes later fixes harder to backport
as well.

But first work on solving the problem in Linus's tree.  Don't worry
about stable trees until after the correct solution is merged.

thanks,

greg k-h
