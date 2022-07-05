Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2AAA56745C
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 18:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiGEQbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 12:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbiGEQbm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 12:31:42 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7303A183A6;
        Tue,  5 Jul 2022 09:31:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 51C1ACE1C35;
        Tue,  5 Jul 2022 16:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B55C341CA;
        Tue,  5 Jul 2022 16:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657038697;
        bh=9iaIjTB6QH828vGInWWa01bZE4sAESoku2uPYuAZIAA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UwbGlo4Eud8EqRMTlivzhrJaUQ8FitBR6ZUTjqjyEbAOpIk+38VORhI8ajJJmJSmY
         LrH1dHe8sQd9xYgSnsxIa5AysohtNasCSWe+LS6VfZhlN0vbKYzR/98R4OAzANb7b3
         3ItThntjEeum9/lzg0ZMbvWjF8WGAY0kQDs6dQGA=
Date:   Tue, 5 Jul 2022 18:31:35 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        MPTCP Upstream <mptcp@lists.linux.dev>
Subject: Re: [PATCH 5.10 51/84] selftests: mptcp: add ADD_ADDR timeout test
 case
Message-ID: <YsRnZ/wmcqGiYzOt@kroah.com>
References: <20220705115615.323395630@linuxfoundation.org>
 <20220705115616.814163273@linuxfoundation.org>
 <a2260559-86af-74ff-ca95-d494688d5ea7@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2260559-86af-74ff-ca95-d494688d5ea7@tessares.net>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 05, 2022 at 05:59:22PM +0200, Matthieu Baerts wrote:
> Hi Greg, Sasha,
> 
> (+ MPTCP upstream ML)
> 
> First, thank you again for maintaining the stable branches!
> 
> On 05/07/2022 13:58, Greg Kroah-Hartman wrote:
> > From: Geliang Tang <geliangtang@gmail.com>
> > 
> > [ Upstream commit 8d014eaa9254a9b8e0841df40dd36782b451579a ]
> > 
> > This patch added the test case for retransmitting ADD_ADDR when timeout
> > occurs. It set NS1's add_addr_timeout to 1 second, and drop NS2's ADD_ADDR
> > echo packets.
> TL;DR: Could it be possible to drop all selftests MPTCP patches from
> v5.10 queue please?
> 
> 
> I was initially reacting on this patch because it looks like it depends on:
> 
>   93f323b9cccc ("mptcp: add a new sysctl add_addr_timeout")
> 
> and indirectly to:
> 
>   9ce7deff92e8 ("docs: networking: mptcp: Add MPTCP sysctl entries")
> 
> to have "net.mptcp.add_addr_timeout" sysctl knob needed for this new
> selftest.
> 
> But then I tried to understand why this current patch ("selftests:
> mptcp: add ADD_ADDR timeout test case") has been selected for 5.10. I
> guess it was to ease the backport of another one, right?
> Looking at the 'series' file in 5.10 queue, it seems the new
> "selftests-mptcp-more-stable-diag-tests" patch requires 5 other patches:
> 
> -> selftests-mptcp-more-stable-diag-tests.patch
>  -> selftests-mptcp-fix-diag-instability.patch
>   -> selftests-mptcp-launch-mptcp_connect-with-timeout.patch
>    -> selftests-mptcp-add-add_addr-ipv6-test-cases.patch
>     -> selftests-mptcp-add-link-failure-test-case.patch
>      -> selftests-mptcp-add-add_addr-timeout-test-case.patch
> 
> 
> When looking at these patches in more detail, it looks like "selftests:
> mptcp: add ADD_ADDR IPv6 test cases" depends on a new feature only
> available from v5.11: ADD_ADDR for IPv6.
> 
> 
> Could it be possible to drop all these patches from v5.10 then please?

Sure, but leave them in for 5.15.y and 5.18.y?

> The two recent fixes for the "diag" selftest mainly helps on slow / busy
> CI. I think it is not worth backporting them to v5.10.
> 
> 
> (Note that if we want "selftests: mptcp: fix diag instability" patch, we
> also need 2e580a63b5c2 ("selftests: mptcp: add cfg_do_w for cfg_remove")
> and the top part of 8da6229b9524 ("selftests: mptcp: timeout testcases
> for multi addresses"): the list starts to be long.)
> 
> 
> One last thing: it looks like when Sasha adds patches to a stable queue,
> a notification is sent to less people than when Greg adds patches. For
> example here, I have not been notified for this patch when added to the
> queue while I was one of the reviewers. I already got notifications from
> Greg when I was a reviewer on other patches.
> Is it normal? Do you only cc people who signed off on the patch?

I cc: everyone on the commit, Sasha should also do that but sometimes
his script acts up.

> It looks like you don't cc maintainers from the MAINTAINERS file but
> that's probably on purpose. I didn't get cc for all MPTCP patches of the
> series here but I guess I can always subscribe to 'stable' ML for that.

No, we don't use the MAINTAINERS file, that would just be too noisy as
ideally who ever the MAINTAINER was, they already saw this as the commit
is already in Linus's tree.

thanks,

greg k-h
