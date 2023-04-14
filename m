Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E02AD6E2AEE
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 22:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbjDNUJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 16:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjDNUJn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 16:09:43 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5F3C019AA;
        Fri, 14 Apr 2023 13:09:42 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1112)
        id E6C7B217A940; Fri, 14 Apr 2023 13:09:41 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E6C7B217A940
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1681502981;
        bh=6uhXiJTN+AKVjrfHqRzBNpT9GlQSlUmzFKtHHg2mHb0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YXhL6fT2doVbtZNmQN/OTQhzDng2YAO8r09v/3Rrq7pQi9Zeyjv7mOPtzq5yVo57q
         mHTcE/rgVaCvgymO5IGHNeRmOGIuaubJV+9bP3L/6QRN1O4j9bSmRkzHgH87TNpadF
         7uEi8tzNMVbBnoNuTmZfbVPTBdcVlVWxn4AWV6+k=
Date:   Fri, 14 Apr 2023 13:09:41 -0700
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Mathias Krause <minipli@grsecurity.net>, Greg KH <greg@kroah.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v4 0/6] KVM: MMU: performance tweaks for heavy CR0.WP
 users
Message-ID: <20230414200941.GA6776@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20230322013731.102955-1-minipli@grsecurity.net>
 <167949641597.2215962.13042575709754610384.b4-ty@google.com>
 <190509c8-0f05-d05c-831c-596d2c9664ac@grsecurity.net>
 <ZB7oKD6CHa6f2IEO@kroah.com>
 <ZC4tocf+PeuUEe4+@google.com>
 <0c47acc0-1f13-ebe5-20e5-524e5b6930e3@grsecurity.net>
 <026dcbfe-a306-85c3-600e-17cae3d3b7c5@grsecurity.net>
 <ZDmEGM+CgYpvDLh6@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDmEGM+CgYpvDLh6@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 14, 2023 at 09:49:28AM -0700, Sean Christopherson wrote:
> +Jeremi
> 

Adding myself :)

> On Fri, Apr 14, 2023, Mathias Krause wrote:

...

> > OTOH, the backports give nice speed-ups, ranging from ~2.2 times faster
> > for pure EPT (legacy) MMU setups up to 18(!!!) times faster for TDP MMU
> > on v5.10.
> 
> Anyone that's enabling the TDP MMU on v5.10 is on their own, we didn't enable the
> TDP MMU by default until v5.14 for very good reasons.
> 
> > I backported the whole series down to v5.10 but left out the CR0.WP
> > guest owning patch+fix for v5.4 as the code base is too different to get
> > all the nuances right, as Sean already hinted. However, even this
> > limited backport provides a big performance fix for our use case!
> 
> As a compromise of sorts, I propose that we disable the TDP MMU by default on v5.15,
> and backport these fixes to v6.1.  v5.15 and earlier won't get "ludicrous speed", but
> I think that's perfectly acceptable since KVM has had the suboptimal behavior
> literally since EPT/NPT support was first added.
> 

Disabling TDP MMU for v5.15, and backporting things to v6.1 works for me.

> I'm comfortable backporting to v6.1 as that is recent enough, and there weren't
> substantial MMU changes between v6.1 and v6.3 in this area.  I.e. I have a decent
> level of confidence that we aren't overlooking some subtle dependency.
> 
> For v5.15, I am less confident in the safety of a backport, and more importantly,
> I think we should disable the TDP MMU by default to mitigate the underlying flaw
> that makes the 18x speedup possible.  That flaw is that KVM can end up freeing and
> rebuilding TDP MMU roots every time CR0.WP is toggled or a vCPU transitions to/from
> SMM.
> 

The interesting thing here is that these CR0.WP fixes seem to improve things
with legacy MMU as well, and legacy MMU is not affected/touched by [3].

So I think you can consider Mathias' ask independent of disabling TDP MMU. On the one
hand: there is no regression here. On the other: the gain is big and seems important
to him.

I didn't have time to review these patches so I can't judge risk-benefit, or
whether any single patch might be a silver bullet on its own.

> We mitigated the CR0.WP case between v5.15 and v6.1[1], which is why v6.1 doesn't
> exhibit the same pain as v5.10, but Jeremi discovered that the SMM case badly affects
> KVM-on-HyperV[2], e.g. when lauching KVM guests using WSL.  I posted a fix[3] to
> finally resolve the underlying bug, but as Jeremi discovered[4], backporting the fix
> to v5.15 is going to be gnarly, to say the least.  It'll be far worse than backporting
> these CR0.WP patches, and maybe even infeasible without a large scale rework (no thanks).
> 
> Anyone that will realize meaningful benefits from the TDP MMU is all but guaranteed
> to be rolling their own kernels, i.e. can do the backports themselves if they want
> to use a v5.15 based kernel.  The big selling point of the TDP MMU is that it scales
> better to hundreds of vCPUs, particularly when live migrating such VMs.  I highly
> doubt that anyone running a stock kernel is running 100+ vCPU VMs, let alone trying
> to live migrate them.
> 
> [1] https://lkml.kernel.org/r/20220209170020.1775368-1-pbonzini%40redhat.com
> [2] https://lore.kernel.org/all/959c5bce-beb5-b463-7158-33fc4a4f910c@linux.microsoft.com
> [3] https://lore.kernel.org/all/20230413231251.1481410-1-seanjc@google.com
> [4] https://lore.kernel.org/all/7332d846-fada-eb5c-6068-18ff267bd37f@linux.microsoft.com
