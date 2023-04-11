Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C488F6DDD2E
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 16:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjDKODy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 10:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjDKODw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 10:03:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2A7524B
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 07:03:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 444F761CD6
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 14:03:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29ECBC4339B;
        Tue, 11 Apr 2023 14:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681221827;
        bh=ky5ORB6vj5CDZSmVT1HWOh74K/8/BM6BrhWErcudyPc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m4s3RnxPUNSsareIqHGmgiFkKhI7Wm7Sc1k/Ed3/Sw2x3N+DDU4J3u2prG8tBL4TZ
         ug+OrAuGkumr7B7mM+nvdmdm8HxC3SXRt/y6jOhHarnbQZnBh93DnZIrSK06EPUiYW
         6/3Ra6BYNxA7iiL7xrqI1ussjcTmgMAnww9ClEts=
Date:   Tue, 11 Apr 2023 16:03:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Sasha Levin <sashal@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Reiji Watanabe <reijiw@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: Re: stable-rc / queue : 5.15: arm64 build failed
Message-ID: <2023041129-booting-uncorrupt-3457@gregkh>
References: <CA+G9fYsF4D7o1iNW6fMNMdX9fKqqrvJw5GHcbW5yGr9PLSWcrw@mail.gmail.com>
 <2023040343-sift-phonebook-dead@gregkh>
 <CA+G9fYs7nv16aP9q2Y7sgYAXMEwbnkYmzs7o21wRHGZRRrv=4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYs7nv16aP9q2Y7sgYAXMEwbnkYmzs7o21wRHGZRRrv=4g@mail.gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 11, 2023 at 07:26:41PM +0530, Naresh Kamboju wrote:
> Hi,
> 
> On Mon, 3 Apr 2023 at 18:35, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Apr 03, 2023 at 03:47:11PM +0530, Naresh Kamboju wrote:
> > > Following build warning noticed on arm64,
> > >
> > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > >
> 
> This patch is now in queue 5.15,
> 
> > > suspecting commit:
> > > KVM: arm64: PMU: Fix GET_ONE_REG for vPMC regs to return the current value
> > > commit 9228b26194d1cc00449f12f306f53ef2e234a55b upstream.
> >
> > Now dropped, thanks!
> 
> I have started noticing this build error again on queue 5.15.
> 
> arch/arm64/kvm/sys_regs.c:1671:43: error: initialization of 'int
> (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct
> kvm_one_reg *, void *)' from incompatible pointer type 'int (*)(struct
> kvm_vcpu *, const struct sys_reg_desc *, u64 *)' {aka 'int (*)(struct
> kvm_vcpu *, const struct sys_reg_desc *, long long unsigned int *)'}
> [-Werror=incompatible-pointer-types]
>  1671 |           .reg = PMCCNTR_EL0, .get_user = get_pmu_evcntr},
>       |                                           ^~~~~~~~~~~~~~
> arch/arm64/kvm/sys_regs.c:1671:43: note: (near initialization for
> 'sys_reg_descs[224].__get_user')
> arch/arm64/kvm/sys_regs.c:999:48: error: initialization of 'int
> (*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct
> kvm_one_reg *, void *)' from incompatible pointer type 'int (*)(struct
> kvm_vcpu *, const struct sys_reg_desc *, u64 *)' {aka 'int (*)(struct
> kvm_vcpu *, const struct sys_reg_desc *, long long unsigned int *)'}
> [-Werror=incompatible-pointer-types]
>   999 |           .reset = reset_pmevcntr, .get_user = get_pmu_evcntr,
>          \
>       |                                                ^~~~
> 
> 
> https://qa-reports.linaro.org/lkft/linux-stable-rc-queues-queue_5.15/build/v5.15.105-187-ga996798ba4fa/testrun/16173915/suite/build/test/gcc-11-defconfig-lkftconfig/history/

Thanks, I've dropped it from the queue now.

greg k-h
