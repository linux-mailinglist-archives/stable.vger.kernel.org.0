Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18FBD5E99CE
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 08:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbiIZGrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 02:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbiIZGrg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 02:47:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF6224BE0;
        Sun, 25 Sep 2022 23:47:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FB5061503;
        Mon, 26 Sep 2022 06:47:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D481C433D6;
        Mon, 26 Sep 2022 06:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664174854;
        bh=Y2sNyycpz3WfUGxxxwkrxUxDfizPmjY1zyzAphv6PIM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R01HPFGgQkDQRVV6X/B85xXIWfuTBp4FYgiRlfvicfMadW+sS9Aa4uveH3JqL9r23
         Ff6Sw3/AUKjIe4eR/Md3V2qY3UjWduTwexkEjHI2Udigby3+gkYfFqPtAt3lvzZ5yX
         uFPWzkAzYRCDL1i9yqqNN14LCX5p+qNGKO1nNU1M=
Date:   Mon, 26 Sep 2022 08:47:32 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Philipp Rudo <prudo@redhat.com>,
        Sasha Levin <sashal@kernel.org>, Baoquan He <bhe@redhat.com>,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        "open list:S390" <linux-s390@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" 
        <linuxppc-dev@lists.ozlabs.org>,
        "open list:KEXEC" <kexec@lists.infradead.org>,
        Coiby Xu <coxu@redhat.com>, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: Re: [PATCH 5.15 0/6] arm64: kexec_file: use more system keyrings to
 verify kernel image signature + dependencies
Message-ID: <YzFLBJukjDy7uNVl@kroah.com>
References: <cover.1663951201.git.msuchanek@suse.de>
 <Yy7Ll1QJ+u+nkic9@kroah.com>
 <20220924094521.GY28810@kitsune.suse.cz>
 <Yy7YTnJKkv1UtvWF@kroah.com>
 <20220924115523.GZ28810@kitsune.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220924115523.GZ28810@kitsune.suse.cz>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 24, 2022 at 01:55:23PM +0200, Michal Suchánek wrote:
> On Sat, Sep 24, 2022 at 12:13:34PM +0200, Greg Kroah-Hartman wrote:
> > On Sat, Sep 24, 2022 at 11:45:21AM +0200, Michal Suchánek wrote:
> > > On Sat, Sep 24, 2022 at 11:19:19AM +0200, Greg Kroah-Hartman wrote:
> > > > On Fri, Sep 23, 2022 at 07:10:28PM +0200, Michal Suchanek wrote:
> > > > > Hello,
> > > > > 
> > > > > this is backport of commit 0d519cadf751
> > > > > ("arm64: kexec_file: use more system keyrings to verify kernel image signature")
> > > > > to table 5.15 tree including the preparatory patches.
> > > > 
> > > > This feels to me like a new feature for arm64, one that has never worked
> > > > before and you are just making it feature-parity with x86, right?
> > > > 
> > > > Or is this a regression fix somewhere?  Why is this needed in 5.15.y and
> > > > why can't people who need this new feature just use a newer kernel
> > > > version (5.19?)
> > > 
> > > It's half-broken implementation of the kexec kernel verification. At the time
> > > it was implemented for arm64 we had the platform and secondary keyrings
> > > and x86 was using them but on arm64 the initial implementation ignores
> > > them.
> > 
> > Ok, so it's something that never worked.  Adding support to get it to
> > work doesn't really fall into the stable kernel rules, right?
> 
> Not sure. It was defective, not using the facilities available at the
> time correctly. Which translates to kernels that can be kexec'd on x86
> failing to kexec on arm64 without any explanation (signed with same key,
> built for the appropriate arch).

Feature parity across architectures is not a "regression", but rather a
"this feature is not implemented for this architecture yet" type of
thing.

> > Again, what's wrong with 5.19 for anyone who wants this?  Who does want
> > this?
> 
> Not sure, really.
> 
> The final patch was repeatedly backported to stable and failed to build
> because the prerequisites were missing.

That's because it was tagged, but now that you show the full set of
requirements, it's pretty obvious to me that this is not relevant for
going this far back.

thanks,

greg k-h
