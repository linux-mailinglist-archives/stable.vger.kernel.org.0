Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4049A69CB19
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 13:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbjBTMe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 07:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbjBTMeZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 07:34:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C92DCA0F
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 04:34:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9C71B80D08
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 12:34:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6504EC43444
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 12:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676896455;
        bh=MRGD6C97oGqHJUq1NJ1AkYGKb2QXoDyvfKCyskGWSow=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VbM/RqKQXq0iuwc1PP8GprIV151Qqtg5igTttuVloop9BdLRWDjSKWbrZFYCF494F
         yaZ2sK40KltThNOTwlXEIRkOWEFSq5NXJsSSkroycDOAHSikjd/eGEYku2K5qwCm7U
         IASFJ1UAGWKZpyTmrakHiD/ZS9NwqRH8bJb0HGgXNI7F9muIgS53plEayBULvYHuAp
         2OV9cvi8MCQPQivhUEwByrRpWso3mZPTEvy/B9RHZ1Qy1rQIMOkJClwoAeqZIZf4Uo
         mKNgLPUug+NQGcpQnMwGbS3QOnorsN3WDEiaPHNM7Vtvk5zyeZNzVcjDeKciPmrDIh
         7Ea31ldwSNS8A==
Received: by mail-ed1-f42.google.com with SMTP id s26so4037706edw.11
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 04:34:15 -0800 (PST)
X-Gm-Message-State: AO0yUKUS/3YnZMRlymH/pTe0qyf5SXpXa1dpmHpcRSa2kNzFH2ftxCv7
        0nt93mj4Mhqox2Q8gOT8F++IpR23fqFXLaUZr3BYkw==
X-Google-Smtp-Source: AK7set+xCDVVAckJjjUMCs427J9fU04gRObtFCMMYDLTvv6tT4At2DX9Sjaf9klrZSTCvALJ47jk43EddusApOzMw9Q=
X-Received: by 2002:a17:906:bce7:b0:8b1:28f6:8ab3 with SMTP id
 op7-20020a170906bce700b008b128f68ab3mr4281973ejb.15.1676896453502; Mon, 20
 Feb 2023 04:34:13 -0800 (PST)
MIME-Version: 1.0
References: <20230220120127.1975241-1-kpsingh@kernel.org> <20230220121350.aidsipw3kd4rsyss@treble>
 <CACYkzJ5L9MLuE5Jz+z5-NJCCrUqTbgKQkXSqnQnCfTD_WNA7_Q@mail.gmail.com>
In-Reply-To: <CACYkzJ5L9MLuE5Jz+z5-NJCCrUqTbgKQkXSqnQnCfTD_WNA7_Q@mail.gmail.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Mon, 20 Feb 2023 04:34:02 -0800
X-Gmail-Original-Message-ID: <CACYkzJ6n=-tobhX0ONQhjHSgmnNjWnNe_dZnEOGtD8Y6S3RHbA@mail.gmail.com>
Message-ID: <CACYkzJ6n=-tobhX0ONQhjHSgmnNjWnNe_dZnEOGtD8Y6S3RHbA@mail.gmail.com>
Subject: Re: [PATCH RESEND] x86/speculation: Fix user-mode spectre-v2
 protection with KERNEL_IBRS
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     linux-kernel@vger.kernel.org, pjt@google.com, evn@google.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        peterz@infradead.org, pawan.kumar.gupta@linux.intel.com,
        kim.phillips@amd.com, alexandre.chartre@oracle.com,
        daniel.sneddon@linux.intel.com,
        =?UTF-8?Q?Jos=C3=A9_Oliveira?= <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>,
        Jim Mattson <jmattson@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 20, 2023 at 4:20 AM KP Singh <kpsingh@kernel.org> wrote:
>
> On Mon, Feb 20, 2023 at 4:13 AM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> >
> > On Mon, Feb 20, 2023 at 01:01:27PM +0100, KP Singh wrote:
> > > +static inline bool spectre_v2_user_no_stibp(enum spectre_v2_mitigation mode)
> > > +{
> > > +     /* When IBRS or enhanced IBRS is enabled, STIBP is not needed.
> > > +      *
> > > +      * However, With KERNEL_IBRS, the IBRS bit is cleared on return
> > > +      * to user and the user-mode code needs to be able to enable protection
> > > +      * from cross-thread training, either by always enabling STIBP or
> > > +      * by enabling it via prctl.
> > > +      */
> > > +     return (spectre_v2_in_ibrs_mode(mode) &&
> > > +             !cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS));
> > > +}
> >
> > The comments and code confused me, they both seem to imply some
> > distinction between IBRS and KERNEL_IBRS, but in the kernel those are
> > functionally the same thing.  e.g., the kernel doesn't have a user IBRS
> > mode.
> >
> > And, unless I'm missing some subtlety here, it seems to be a convoluted
> > way of saying that eIBRS doesn't need STIBP in user space.

Actually, there is a subtlety, STIBP is not needed in IBRS and eIBRS
however, with KERNEL_IBRS we only enable IBRS (by setting and
unsetting the IBRS bit of SPEC_CTL) in the kernel context and this is
why we need to allow STIBP in userspace. If it were for pure IBRS, we
would not need it either (based on my reading). Now, with
spectre_v2_in_ibrs_mode, as per the current implementation implies
that KERNEL_IBRS is chosen, but this may change. Also, I would also
prefer to have it more readable in the sense that:

"If the kernel decides to write 0 to the IBRS bit on returning to the
user, STIBP needs to to be allowed in user space"

> >
> > It would be simpler to just call it spectre_v2_in_eibrs_mode().
>
> Thanks, yeah this would work too. I was just trying to ensure that, if
> somehow, KERNEL_IBRS gets enabled with SPECTRE_V2_EIBRS, but this does
> not seem to be the case currently. Maybe we should also add a BUG_ON
> to ensure that KERNEL_IBRS does not get enabled in EIBRS mode?
>
> >
> > static inline bool spectre_v2_in_eibrs_mode(enum spectre_v2_mitigation mode)
> > {
> >         return mode == SPECTRE_V2_EIBRS ||
> >                mode == SPECTRE_V2_EIBRS_RETPOLINE ||
> >                mode == SPECTRE_V2_EIBRS_LFENCE;
> > }
> >
> > And then spectre_v2_in_ibrs_mode() could be changed to call that:
> >
> > static inline bool spectre_v2_in_eibrs_mode(enum spectre_v2_mitigation mode)
> > {
> >         return spectre_v2_in_eibrs_mode(mode) || mode == SPECTRE_V2_IBRS;
> > }
> >
> > > @@ -1496,6 +1504,7 @@ static void __init spectre_v2_select_mitigation(void)
> > >               break;
> > >
> > >       case SPECTRE_V2_IBRS:
> > > +             pr_err("enabling KERNEL_IBRS");
> >
> > Why?
>
> Removed.
>
> >
> > > @@ -2327,7 +2336,7 @@ static ssize_t mmio_stale_data_show_state(char *buf)
> > >
> > >  static char *stibp_state(void)
> > >  {
> > > -     if (spectre_v2_in_ibrs_mode(spectre_v2_enabled))
> > > +     if (spectre_v2_user_no_stibp(spectre_v2_enabled))
> > >               return "";
> >
> > This seems like old cruft, can we just remove this check altogether?  In
> > the eIBRS case, spectre_v2_user_stibp will already have its default of
> > SPECTRE_V2_USER_NONE.
> >
> > --
> > Josh
