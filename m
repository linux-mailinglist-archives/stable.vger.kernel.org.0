Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5E44D879F
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 16:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242332AbiCNPCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 11:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242311AbiCNPB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 11:01:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF08419AF;
        Mon, 14 Mar 2022 08:00:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D445FB80E2A;
        Mon, 14 Mar 2022 15:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2011C340EC;
        Mon, 14 Mar 2022 15:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647270045;
        bh=TYhiBrC14m4Ad4E1iYepcEh5UqxKOLKQ/jszH2k2vNU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IfI5NEUHZ9MnYcv/aEYl2ohIRe3rJ8o1opGh29GdmnNyJerbeHFejBuaM/s0mk1fK
         6N5fHBqHv/hwJIiX/DCOrO803EJ2Gv/8KEb1g0MTvrgMyIRvwteMPOZJ19Vf9ApVAH
         JMRbeKTDaC4CvfpbQzAOymFdX8v0fFphRYbZoR9k=
Date:   Mon, 14 Mar 2022 16:00:42 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Jon Hunter <jonathanh@nvidia.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 4.19 00/30] 4.19.235-rc1 review
Message-ID: <Yi9Ymvmu09seXAD5@kroah.com>
References: <20220314112731.785042288@linuxfoundation.org>
 <0ac87017-362d-33e2-eace-3407e0891a94@nvidia.com>
 <Yi9LlP+x2swdsrbE@kroah.com>
 <CA+G9fYuwyUPMBRuBL10Z0r1MRt0sZ-MqvC6ySHBtpqdSp8UcDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYuwyUPMBRuBL10Z0r1MRt0sZ-MqvC6ySHBtpqdSp8UcDQ@mail.gmail.com>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 14, 2022 at 08:02:21PM +0530, Naresh Kamboju wrote:
> > > > or in the git tree and branch at:
> > > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > > >
> > > > -------------
> > > > Pseudo-Shortlog of commits:
> > >
> > > ...
> > >
> > > > James Morse <james.morse@arm.com>
> > > >      KVM: arm64: Reset PMC_EL0 to avoid a panic() on systems with no PMU
> > >
> > >
> > > The above is causing the following build error for ARM64 ...
> > >
> > > arch/arm64/kvm/sys_regs.c: In function ‘reset_pmcr’:
> > > arch/arm64/kvm/sys_regs.c:624:3: error: implicit declaration of function ‘vcpu_sys_reg’ [-Werror=implicit-function-declaration]
> > >    vcpu_sys_reg(vcpu, PMCR_EL0) = 0;
> > >    ^~~~~~~~~~~~
> > > arch/arm64/kvm/sys_regs.c:624:32: error: lvalue required as left operand of assignment
> > >    vcpu_sys_reg(vcpu, PMCR_EL0) = 0;
> > >
> >
> > Is this also broken in Linus's tree?
> 
> nope.
> It is also only on 4.19.

Thanks.  I've pushed out -rc2 releases with this commit dropped.

greg k-h
