Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B94CA69C9FB
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 12:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjBTLil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 06:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbjBTLik (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 06:38:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 893F91027A
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 03:38:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2769C60DE2
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 11:38:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E99C433EF;
        Mon, 20 Feb 2023 11:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676893117;
        bh=Kv07rMmiMvKaYY20zVhN9e4y1rCB2E4d370s9axbAvo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nSNELm9ZuTIVf+brfR0qoJdVdwQuqCdfvKE8OutccfmMv8ZpMaIjFCNNXv+BjfP1K
         gWE2VCi/33SEWJLlgIlbKKt7+dAhf9TVtlLOY7z+M+GCsuNRjxed1c7CgWH6rLsISh
         emGfvQMwp2dSoDfA5LzvLfg6qnAdNw8X7mxoMF8o=
Date:   Mon, 20 Feb 2023 12:38:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     KP Singh <kpsingh@kernel.org>
Cc:     security@kernel.org, pjt@google.com, evn@google.com,
        jpoimboe@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, peterz@infradead.org,
        pawan.kumar.gupta@linux.intel.com, kim.phillips@amd.com,
        alexandre.chartre@oracle.com, daniel.sneddon@linux.intel.com,
        =?iso-8859-1?Q?Jos=E9?= Oliveira <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>,
        Jim Mattson <jmattson@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/speculation: Fix user-mode spectre-v2 protection
 with KERNEL_IBRS
Message-ID: <Y/Nbu2p9CGG/nwcW@kroah.com>
References: <20230220103930.1963742-1-kpsingh@kernel.org>
 <Y/NQ6w4UlEuBSTql@kroah.com>
 <CACYkzJ7Umq_XQEAHZyPE60zhbWsSF_i-vNa7u_qCeqBgGVfC4g@mail.gmail.com>
 <Y/NXbz9V840KnVYh@kroah.com>
 <CACYkzJ44dwK8HZFnLNOvGSS_Uo3U0NUP_a41+t6oc8d=UAqRwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACYkzJ44dwK8HZFnLNOvGSS_Uo3U0NUP_a41+t6oc8d=UAqRwA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 20, 2023 at 03:25:08AM -0800, KP Singh wrote:
> On Mon, Feb 20, 2023 at 3:20 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Feb 20, 2023 at 03:11:24AM -0800, KP Singh wrote:
> > > On Mon, Feb 20, 2023 at 2:52 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Mon, Feb 20, 2023 at 11:39:30AM +0100, KP Singh wrote:
> > > > > With the introduction of KERNEL_IBRS, STIBP is no longer needed
> > > > > to prevent cross thread training in the kernel space. When KERNEL_IBRS
> > > > > was added, it also disabled the user-mode protections for spectre_v2.
> > > > > KERNEL_IBRS does not mitigate cross thread training in the userspace.
> > > > >
> > > > > In order to demonstrate the issue, one needs to avoid syscalls in the
> > > > > victim as syscalls can shorten the window size due to
> > > > > a user -> kernel -> user transition which sets the
> > > > > IBRS bit when entering kernel space and clearing any training the
> > > > > attacker may have done.
> > > > >
> > > > > Allow users to select a spectre_v2_user mitigation (STIBP always on,
> > > > > opt-in via prctl) when KERNEL_IBRS is enabled.
> > > > >
> > > > > Reported-by: José Oliveira <joseloliveira11@gmail.com>
> > > > > Reported-by: Rodrigo Branco <rodrigo@kernelhacking.com>
> > > > > Reviewed-by: Alexandra Sandulescu <aesa@google.com>
> > > > > Reviewed-by: Jim Mattson <jmattson@google.com>
> > > > > Fixes: 7c693f54c873 ("x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS")
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
> > > https://www.kernel.org/doc/Documentation/admin-guide/security-bugs.rst,
> > > if you want folks to explicitly Cc maintainers with their fix or
> > > report, I think it's worth mentioning in the guidelines there as the
> > > current language seems to imply that the maintainers will be pulled in
> > > by the security team:
> > >
> > > "It is possible that the security team will bring in extra help from
> > > area maintainers to understand and fix the security vulnerability."
> >
> > Yes, but you already have a patch here, what "help" do you need?  You
> > didn't specify any help, you just sent us a patch with no context.  This
> > wasn't any sort of a "report" or "hey, I think we found a problem over
> > here, does this change look correct", right?
> >
> > So please be specific as to what you are asking for, otherwise we have
> > to guess (i.e. you cc:ed a seemingly random set of people but not the
> 
> I don't see how it matters who I cc on the list.

It gives us a hint as to who you are leaving out, right?

> Anyways, I am still
> not clear on what one is supposed to do in the case when one has a
> patch for an issue already. Should this not be send it to security@?

security@ is to take reports of potential security problems, triage
them, and drag in the respective people to fix the problem as soon as
possible by creating a patch and getting it merged.

You already had a patch, so you did all of the work that security@ would
normally do, so what did you need us to do here?

You also did not ask or request anything, you just sent a patch with no
context other than the changelog text.

So if you have a fix for a potential problem already, you either just
send it to get it merged as soon as possible, in which case security@ is
not needed.  Or if you want to ask questions "is this really an issue
and is this the fix", then send the patch and ask that question.

Again, as it is, this looks like any other normal patch sent to
subsystems for review, and there was no request for help or context at
all.  Then you sent the patch to a public mailing list, so security@ is
not needed at al, the normal development process applies as you
determined it's not a secret by doing so.

If you have questions, ask them, we can't read minds.

thanks,

greg k-h
