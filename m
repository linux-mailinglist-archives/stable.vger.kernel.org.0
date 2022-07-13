Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB1F572D79
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 07:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234314AbiGMFlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 01:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234315AbiGMFlU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 01:41:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFBD43E74B;
        Tue, 12 Jul 2022 22:35:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B2F4B81C13;
        Wed, 13 Jul 2022 05:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D31EC3411E;
        Wed, 13 Jul 2022 05:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657690507;
        bh=C6Qvmu8YGI/7zZ+PW9nfbi7sR3QFFcB/JWTbSIlVJFg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XqpAoqynsEuoTHKPzK+XyGdIWKe+7LwOpsOoLz0GOmgpMQt0yAIdlRHvR1/dz0gpL
         f1wM4YPqOe8Q45XvOqaqsBLBLObiEYHaMn3MGzSN6Anu69/mnWCc1y+6OwF0hxgOsi
         asY0eSNZbsKov8qKtbpNnfhOgwkmycFbKcbnl7ew=
Date:   Wed, 13 Jul 2022 07:35:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chuck Zmudzinski <brchuckz@netscape.net>
Cc:     linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jane Chu <jane.chu@oracle.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/PAT: Report PAT on CPUs that support PAT without MTRR
Message-ID: <Ys5ZhmRHvRtpFN6t@kroah.com>
References: <2885cdcaccffd287ef69c7509056ddf183a38a0e.1657647656.git.brchuckz.ref@aol.com>
 <2885cdcaccffd287ef69c7509056ddf183a38a0e.1657647656.git.brchuckz@aol.com>
 <Ys2/Lho9vQO33RZc@kroah.com>
 <a9efcbf3-3b34-53b7-0fa8-55a5ed3a17b4@netscape.net>
 <Ys3K0oS9QLx778Lb@kroah.com>
 <008ff24c-d059-8d39-5e57-6f5e9de0dcbf@netscape.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <008ff24c-d059-8d39-5e57-6f5e9de0dcbf@netscape.net>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 12, 2022 at 03:57:45PM -0400, Chuck Zmudzinski wrote:
> On 7/12/22 3:26 PM, Greg KH wrote:
> > On Tue, Jul 12, 2022 at 03:16:01PM -0400, Chuck Zmudzinski wrote:
> > > On 7/12/22 2:36 PM, Greg KH wrote:
> > > > On Tue, Jul 12, 2022 at 02:20:37PM -0400, Chuck Zmudzinski wrote:
> > > > > The commit 99c13b8c8896d7bcb92753bf
> > > > > ("x86/mm/pat: Don't report PAT on CPUs that don't support it")
> > > > > incorrectly failed to account for the case in init_cache_modes() when
> > > > > CPUs do support PAT and falsely reported PAT to be disabled when in
> > > > > fact PAT is enabled. In some environments, notably in Xen PV domains,
> > > > > MTRR is disabled but PAT is still enabled, and that is the case
> > > > > that the aforementioned commit failed to account for.
> > > > > 
> > > > > As an unfortunate consequnce, the pat_enabled() function currently does
> > > > > not correctly report that PAT is enabled in such environments. The fix
> > > > > is implemented in init_cache_modes() by setting pat_bp_enabled to true
> > > > > in init_cache_modes() for the case that commit 99c13b8c8896d7bcb92753bf
> > > > > ("x86/mm/pat: Don't report PAT on CPUs that don't support it") failed
> > > > > to account for.
> > > > > 
> > > > > This patch fixes a regression that some users are experiencing with
> > > > > Linux as a Xen Dom0 driving particular Intel graphics devices by
> > > > > correctly reporting to the Intel i915 driver that PAT is enabled where
> > > > > previously it was falsely reporting that PAT is disabled.
> > > > > 
> > > > > Fixes: 99c13b8c8896d7bcb92753bf ("x86/mm/pat: Don't report PAT on CPUs that don't support it")
> > > > > Cc: stable@vger.kernel.org
> > > > > Signed-off-by: Chuck Zmudzinski <brchuckz@aol.com>
> > > > > ---
> > > > > Reminder: This patch is a regression fix that is needed on stable
> > > > > versions 5.17 and later.
> > > >
> > > > Then why are you saying it fixes a commit that is in 4.4.y and newer?
> > > >
> > > > confused,
> > > >
> > > > greg k-h
> > > 
> > > It is true the erroneous reporting of PAT goes back to 4.4.y. But it
> > > was not until 5.17.y when the i915 driver was patched with a commit
> > > that started using pat_enabled() instead of boot_cpu_has(X86_FEATURE_PAT)
> > > and that is when a regression that started annoying users appeared
> > > in the kernel. I presume that we only backport patches to stable that
> > > fix regressions that are really bothering users, so even though the
> > > problem dates to 4.4.y, there is no need to backport before 5.17.y
> > > which is when the problem manifested in a way that started
> > > bothering users.
> >
> > If it needs to go back to 4.9.y or so, let's take it all the way back to
> > be consistent everywhere.
> >
> > thanks,
> >
> > greg k-h
> 
> I presume you want me to prepare the backport patches, or at
> least the ones that need the patch to be significantly modified to
> apply to those branches. I expect older versions will need the
> patch to be significantly modified to apply. If not, please let me know.

I will not know until it hits Linus's tree and the patch is backported
then.  If there are problems, you will get an email at that point in
time.

> Is 4.9.y the oldest version we are still supporting?

Yes, the front page of kernel.org lists the active kernel versions.

thanks,

greg k-h
