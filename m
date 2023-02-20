Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05CFE69C9CD
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 12:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbjBTL0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 06:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbjBTL0I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 06:26:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC2165AD
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 03:26:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5189DB808BE
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 11:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3ED4C433EF
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 11:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676892364;
        bh=8YHyWOI9arcbrMkNCffvejd7uopBmOet7tE3m6o69+s=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=vFqkjtGpp/EflHGkJm8ozbvKmkIlK1f40JLuw/rbrBuaye4q4gUlEWAxi3/waA/wm
         WFQDH0gWAeTEBjyrK1sELDdax2s5BBcY3OsHauUU3mvP2uAIxzL5gQgKa4sO26gs7/
         Rxn/gyIMk2Mxvtdl808hTb6gkSkbPCwCkKKLunxJLMvebnV5wsV0ExcGFe2aQobMJB
         RpaMbel99YT6AISf5Eqte5pYKB2/bpCJYFEIf2x09ZHo90mWGzqFvgg4ag6ts7HHdo
         1DzrlSKdo2MPAIrsGXGP/jfKCmCCiRD3WIe4gMIJ+ibx8FB26hoSGiXZ9vZngzIlT8
         mSds67feHueJQ==
Received: by mail-ed1-f51.google.com with SMTP id g1so3071606edz.7
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 03:26:03 -0800 (PST)
X-Gm-Message-State: AO0yUKUeFjuWdc0YarhhE+6aLlrduG4nQ27E6FVXgcofh5DC1h942D1H
        cenGSShIlUFEmACMoVT/iH8OhgPqgW5fev833uOucQ==
X-Google-Smtp-Source: AK7set/QnurPWLseKxeA3mBHscGFh5ir54lNBdj/2qXqihBlCqckhYdwFcZ1w6ApwdzrVqJIOwZkrK6Jrf9fdqT+eCM=
X-Received: by 2002:a17:907:6c14:b0:8ae:cb48:3c80 with SMTP id
 rl20-20020a1709076c1400b008aecb483c80mr9498953ejc.7.1676892341641; Mon, 20
 Feb 2023 03:25:41 -0800 (PST)
MIME-Version: 1.0
References: <20230220103930.1963742-1-kpsingh@kernel.org> <Y/NQ6w4UlEuBSTql@kroah.com>
 <CACYkzJ7Umq_XQEAHZyPE60zhbWsSF_i-vNa7u_qCeqBgGVfC4g@mail.gmail.com>
 <Y/NXbz9V840KnVYh@kroah.com> <CACYkzJ44dwK8HZFnLNOvGSS_Uo3U0NUP_a41+t6oc8d=UAqRwA@mail.gmail.com>
In-Reply-To: <CACYkzJ44dwK8HZFnLNOvGSS_Uo3U0NUP_a41+t6oc8d=UAqRwA@mail.gmail.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Mon, 20 Feb 2023 03:25:31 -0800
X-Gmail-Original-Message-ID: <CACYkzJ6ZuiGVSD_CmOJFUdHNLoKHSf3NzHGnvrGKt-=wuu=OQg@mail.gmail.com>
Message-ID: <CACYkzJ6ZuiGVSD_CmOJFUdHNLoKHSf3NzHGnvrGKt-=wuu=OQg@mail.gmail.com>
Subject: Re: [PATCH] x86/speculation: Fix user-mode spectre-v2 protection with KERNEL_IBRS
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     security@kernel.org, pjt@google.com, evn@google.com,
        jpoimboe@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, peterz@infradead.org,
        pawan.kumar.gupta@linux.intel.com, kim.phillips@amd.com,
        alexandre.chartre@oracle.com, daniel.sneddon@linux.intel.com,
        =?UTF-8?Q?Jos=C3=A9_Oliveira?= <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>,
        Jim Mattson <jmattson@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 20, 2023 at 3:25 AM KP Singh <kpsingh@kernel.org> wrote:
>
> On Mon, Feb 20, 2023 at 3:20 AM Greg KH <gregkh@linuxfoundation.org> wrot=
e:
> >
> > On Mon, Feb 20, 2023 at 03:11:24AM -0800, KP Singh wrote:
> > > On Mon, Feb 20, 2023 at 2:52 AM Greg KH <gregkh@linuxfoundation.org> =
wrote:
> > > >
> > > > On Mon, Feb 20, 2023 at 11:39:30AM +0100, KP Singh wrote:
> > > > > With the introduction of KERNEL_IBRS, STIBP is no longer needed
> > > > > to prevent cross thread training in the kernel space. When KERNEL=
_IBRS
> > > > > was added, it also disabled the user-mode protections for spectre=
_v2.
> > > > > KERNEL_IBRS does not mitigate cross thread training in the usersp=
ace.
> > > > >
> > > > > In order to demonstrate the issue, one needs to avoid syscalls in=
 the
> > > > > victim as syscalls can shorten the window size due to
> > > > > a user -> kernel -> user transition which sets the
> > > > > IBRS bit when entering kernel space and clearing any training the
> > > > > attacker may have done.
> > > > >
> > > > > Allow users to select a spectre_v2_user mitigation (STIBP always =
on,
> > > > > opt-in via prctl) when KERNEL_IBRS is enabled.
> > > > >
> > > > > Reported-by: Jos=C3=A9 Oliveira <joseloliveira11@gmail.com>
> > > > > Reported-by: Rodrigo Branco <rodrigo@kernelhacking.com>
> > > > > Reviewed-by: Alexandra Sandulescu <aesa@google.com>
> > > > > Reviewed-by: Jim Mattson <jmattson@google.com>
> > > > > Fixes: 7c693f54c873 ("x86/speculation: Add spectre_v2=3Dibrs opti=
on to support Kernel IBRS")
> > > > > Cc: stable@vger.kernel.org
> > > > > Signed-off-by: KP Singh <kpsingh@kernel.org>
> > > > > ---
> > > > >  arch/x86/kernel/cpu/bugs.c | 25 +++++++++++++++++--------
> > > > >  1 file changed, 17 insertions(+), 8 deletions(-)
> > > >
> > > > As this is posted publicly, there's no need to send it to
> > > > security@kernel.org, it doesn't need to be involved.
> > >
> > > Sure, it's okay. Please do note in my first patch, I did follow
> > > https://www.kernel.org/doc/Documentation/admin-guide/security-bugs.rs=
t,
> > > if you want folks to explicitly Cc maintainers with their fix or
> > > report, I think it's worth mentioning in the guidelines there as the
> > > current language seems to imply that the maintainers will be pulled i=
n
> > > by the security team:
> > >
> > > "It is possible that the security team will bring in extra help from
> > > area maintainers to understand and fix the security vulnerability."
> >
> > Yes, but you already have a patch here, what "help" do you need?  You
> > didn't specify any help, you just sent us a patch with no context.  Thi=
s
> > wasn't any sort of a "report" or "hey, I think we found a problem over
> > here, does this change look correct", right?
> >
> > So please be specific as to what you are asking for, otherwise we have
> > to guess (i.e. you cc:ed a seemingly random set of people but not the
>
> I don't see how it matters who I cc on the list. Anyways, I am still

Cc on my report, I mean.

> not clear on what one is supposed to do in the case when one has a
> patch for an issue already. Should this not be send it to security@?
>
> > x86 maintainers).  And then you resent it to a public list, so there's
> > no need for security@k.o to get involved in at all as it's a public
> > issue now.
>
> Agreed.
> >
> > thanks,
> >
> > greg k-h
