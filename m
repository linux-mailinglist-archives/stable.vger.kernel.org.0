Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324DA4D2E81
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 12:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbiCIL6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 06:58:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbiCIL6u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 06:58:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E0226C7;
        Wed,  9 Mar 2022 03:57:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 206AD618E6;
        Wed,  9 Mar 2022 11:57:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33E5C340EE;
        Wed,  9 Mar 2022 11:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646827069;
        bh=f4O5J6jHrGpyWRckAD+pP6EOMS6/H2OF0+nhLhBMFXo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U9NXIkiLLVdRGICP2UhJGpSCTbv0Yw2+qOsgCAyPoG4fNJdW/3KFgv+qRD3WEQb3S
         N3tOejg8v79qBtt2OfJw33nR7nlXHwkz4QqkavV802EO8getLBumgwtnzvsiJnBLMO
         vagxfyIABj/lFJnzenDP0T7XdWhaDQIdKArnNWiA=
Date:   Wed, 9 Mar 2022 12:57:46 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Huang Pei <huangpei@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/256] 5.15.27-rc2 review
Message-ID: <YiiWOovHhWzbxOJV@kroah.com>
References: <20220307162207.188028559@linuxfoundation.org>
 <Yid4BNbLm3mStBi2@debian>
 <CADVatmPdzXRU2aTeh-8dfZVmW6YPJwntSDCO8gcGDUJn-qzzAg@mail.gmail.com>
 <CA+G9fYv74gGWQLkEZ4idGYri+F9BFV1+9=bz5L0+aophSzDdVA@mail.gmail.com>
 <YifFMPFMp9gPnjPc@kroah.com>
 <ab0b668c-e321-e1d9-3cc3-a609111b828d@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab0b668c-e321-e1d9-3cc3-a609111b828d@roeck-us.net>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 08, 2022 at 02:45:50PM -0800, Guenter Roeck wrote:
> On 3/8/22 13:05, Greg Kroah-Hartman wrote:
> > On Tue, Mar 08, 2022 at 11:08:10PM +0530, Naresh Kamboju wrote:
> 
> 
> [ ... ]
> 
> > > > 
> > > > Reverting 4778338032b3 ("MIPS: fix local_{add,sub}_return on MIPS64")
> > > > has fixed all the 3 build failures.
> > > 
> > > MIPS: fix local_{add,sub}_return on MIPS64
> > > [ Upstream commit 277c8cb3e8ac199f075bf9576ad286687ed17173 ]
> > > 
> > > Use "daddu/dsubu" for long int on MIPS64 instead of "addu/subu"
> > > 
> > > Fixes: 7232311ef14c ("local_t: mips extension")
> > > Signed-off-by: Huang Pei <huangpei@loongson.cn>
> > > Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > 
> > Ah, I'll queue up the revert for that in the morning, thanks for finding
> > it.  Odd it doesn't trigger the same issue in 5.16.y.
> > 
> 
> If you don't want to revert: the fix needs the following two patches:
> 
> e5b40668e93 ("slip: fix macro redefine warning")
> b81e0c2372e ("block: drop unused includes in <linux/genhd.h>")
> 
> Both are in v5.16, so you won't see the problem there.

Thanks, both now added to the queue.

greg k-h
