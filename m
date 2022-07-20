Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B515157BFDE
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 00:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiGTWAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 18:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiGTWAc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 18:00:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3722B18E12;
        Wed, 20 Jul 2022 15:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FiZLfbIHMEm5bs2l9a0O1tE0/R/MU//G5wqi4u7xynA=; b=UEqYJftgqJBF0z+MKxvXZRo8NX
        ppYxh/pP5a/Tn6On9z3mIURCgdZa6jsVZcbyRqYabMmvuMST3uOmKGrtJk0G3LSgwbEBGs0o42E77
        +rBWTcE31Gy2gJ6oiJoCsWHY/TM5LTHL+IB51mwLYjtV9lVYpTC0RyhxctZSbQlEAfH0txtJKy9Zm
        EgWnt6BbhzmHBB4Z09/CF6W0s7huui2t+RF6rBeS7UxTHpu3XBpO1aOplKWVcW9l2zKV2zo23/U23
        C6MG9NYo+4wSteHYbhzzleXizWeohaCLVfQtlDgBDX+Cs4+3/E77fiTfy9KZjIMRTfsZS0lgiinUs
        KYaUsO1Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oEHjp-00Epie-SM; Wed, 20 Jul 2022 22:00:14 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 76B29980BBE; Thu, 21 Jul 2022 00:00:13 +0200 (CEST)
Date:   Thu, 21 Jul 2022 00:00:13 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Justin Forbes <jforbes@fedoraproject.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Slade Watkins <slade@sladewatkins.com>,
        John Harrison <John.C.Harrison@intel.com>,
        Tejas Upadhyay <tejas.upadhyay@intel.com>,
        Anusha Srivatsa <anusha.srivatsa@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Subject: Re: [PATCH 5.18 000/231] 5.18.13-rc1 review
Message-ID: <Yth67Ubo7PatL0AR@worktop.programming.kicks-ass.net>
References: <20220719114714.247441733@linuxfoundation.org>
 <CA+G9fYsCL48P5zFMKUxoJ-1vwUJSWhcn17rUx=1rxOdzdw_Mmg@mail.gmail.com>
 <CAHk-=wjo-u8=yJQJQnaP41FkQw7we9A-zJH3UELx5x_1ynPDfw@mail.gmail.com>
 <YtgvLUMuz+1zpQHR@fedora64.linuxtx.org>
 <CAHk-=wiu=yk=3xzXk18o5yU6v1wn27rcrOD=vmKm_aLNz=zJ+w@mail.gmail.com>
 <YthCBl4SORA2BfDv@fedora64.linuxtx.org>
 <Yth31qsO1nDN4WLB@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yth31qsO1nDN4WLB@worktop.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 20, 2022 at 11:47:02PM +0200, Peter Zijlstra wrote:
> On Wed, Jul 20, 2022 at 12:57:26PM -0500, Justin Forbes wrote:
> > On Wed, Jul 20, 2022 at 10:28:33AM -0700, Linus Torvalds wrote:
> > > [ Adding PeterZ and Jiri to the participants. ]
> > > 
> > > Looks like 5.18.13 added that commit 9bb2ec608a20 ("objtool: Update
> > > Retpoline validation") but I don't see 3131ef39fb03 ("x86/asm/32: Fix
> > > ANNOTATE_UNRET_SAFE use on 32-bit") in that list.
> > 
> > It should be noted that the build doesn't fail, it just warns.
> > I am guessing the 32bit failure is what promoted someone to look at
> > the logs to begin with and notice the warn initially. I just verified
> > that it exists in our builds of 5.18.13-rc1, but not on mainline builds.
> > I am gueesing it is because commit 9bb2ec608a20 ("objtool: Update Retpoline
> > validation") should be followed up with at least commit f43b9876e857c
> > ("x86/retbleed: Add fine grained Kconfig knobs")
> 
> Still updateing the stable repro to see what the actual code looks like,
> but that warning seems to suggest the -mfunction-return=thunk-extern
> compiler argument went missing.
> 
> For all the files objtool complains about, does the V=1 build output
> show that option?

Ok, I'm now looking at stable-rc/linux-5.18.y which reports itself as:

VERSION = 5
PATCHLEVEL = 18
SUBLEVEL = 13
EXTRAVERSION = -rc1

and I'm most terribly confused... it has the objtool patch to validate
return thunks, *however*, I'm not seeing any actual retbleed mitigations
*anywhere*.

How, what, why!?
