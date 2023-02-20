Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC9269D405
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 20:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbjBTTTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 14:19:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232782AbjBTTTn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 14:19:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D49421B;
        Mon, 20 Feb 2023 11:19:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C49AF60ED4;
        Mon, 20 Feb 2023 19:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD95C433EF;
        Mon, 20 Feb 2023 19:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676920781;
        bh=FhzBPaQTni5fZj9kNa01otoHP++iDGtEwYpHAuLQaaA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jPCYgP0f+Wbtuv32WShtnkjSfXxOV4GU1BwA4WOarTwclmiFiKQzIdl8KaMHkyKEd
         JHlSEH1/dyiJOboW8RHLTFLJ7M2Qa+gUPy7/SmsUt2M3NczLhbA9hBdpQhnJ+X7hVa
         AqaM2zmUJs2VIDxXOgUdW4DhdvNNfiQdIOb653Sz/pNMCI90vvzfYnBxlE4H5TYq1k
         YkkkSgNVqjEFxYN35Uj9ZKYUlJj7RtfOtI+9uY4TM3uHaHKJOp07AmBOsZliYL9t9I
         DRiPdR6ismlbSpaEiJzMkt5Jnrc4RWhC17vw8MLKCXXzuYYlZEcQqgIT2snIi3NyF0
         Ppc5K2y4Emcmw==
Date:   Mon, 20 Feb 2023 11:19:38 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     KP Singh <kpsingh@kernel.org>
Cc:     Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        pjt@google.com, evn@google.com, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, peterz@infradead.org,
        pawan.kumar.gupta@linux.intel.com, kim.phillips@amd.com,
        alexandre.chartre@oracle.com, daniel.sneddon@linux.intel.com,
        =?utf-8?B?Sm9zw6k=?= Oliveira <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>,
        Jim Mattson <jmattson@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/bugs: Allow STIBP with IBRS
Message-ID: <20230220191938.hti3ktgh4idzx7iu@treble>
References: <CACYkzJ5L9MLuE5Jz+z5-NJCCrUqTbgKQkXSqnQnCfTD_WNA7_Q@mail.gmail.com>
 <CACYkzJ6n=-tobhX0ONQhjHSgmnNjWnNe_dZnEOGtD8Y6S3RHbA@mail.gmail.com>
 <20230220163442.7fmaeef3oqci4ee3@treble>
 <Y/Ox3MJZF1Yb7b6y@zn.tnic>
 <20230220175929.2laflfb2met6y3kc@treble>
 <CACYkzJ71xqzY6-wL+YShcL+d6ugzcdFHr6tbYWWE_ep52+RBZQ@mail.gmail.com>
 <20230220182717.uzrym2gtavlbjbxo@treble>
 <CACYkzJ5z3qLhkWqKLvP55HcjLACzAJbFjc4XjRzcft9ww40MaQ@mail.gmail.com>
 <20230220185957.yzjdnhcqpmkji2xs@treble>
 <CACYkzJ6p0+bTjbAyv6PD+ZKyyfjM9NyvtuMB-vwNHkeWm72B7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACYkzJ6p0+bTjbAyv6PD+ZKyyfjM9NyvtuMB-vwNHkeWm72B7A@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 20, 2023 at 11:04:56AM -0800, KP Singh wrote:
> On Mon, Feb 20, 2023 at 11:00 AM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> >
> > On Mon, Feb 20, 2023 at 10:33:56AM -0800, KP Singh wrote:
> > >  static char *stibp_state(void)
> > >  {
> > > -       if (spectre_v2_in_ibrs_mode(spectre_v2_enabled))
> > > +       if (!spectre_v2_user_needs_stibp(spectre_v2_enabled))
> > >                 return "";
> > >
> > >         switch (spectre_v2_user_stibp) {
> > >
> > > Also Josh, is it okay for us to have a discussion and have me write
> > > the patch as a v2? Your current patch does not even credit me at all.
> > > Seems a bit unfair, but I don't really care. I was going to rev up the
> > > patch with your suggestions.
> >
> > Well, frankly the patch needed a complete rewrite.  The patch
> > description was unclear about what the problem is and what's being
> 
> Josh, this is a complex issue, we are figuring it out together on the
> list. It's complex, that's why folks got it wrong in the first place.
> Calling the patch obtuse and unclear is unfair!
> 
> > fixed.  The code was obtuse and the comments didn't help.  I could tell
> > by the other replies that I wasn't the only one confused.
> 
> The patch you sent is not clear either, it implicitly ties in STIBP
> with eIBRS. There is no explanation anywhere that IBRS just means
> KERNEL_IBRS.

Ok, so something like this on top?

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index b97c0d28e573..fb3079445700 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1201,6 +1201,10 @@ spectre_v2_user_select_mitigation(void)
 	/*
 	 * If no STIBP, enhanced IBRS is enabled, or SMT impossible,
 	 * STIBP is not required.
+	 *
+	 * For legacy IBRS, STIBP may still be needed because IBRS is only
+	 * enabled in kernel space, so user space isn't protected from indirect
+	 * branch prediction attacks from a sibling CPU thread.
 	 */
 	if (!boot_cpu_has(X86_FEATURE_STIBP) ||
 	    !smt_possible ||
