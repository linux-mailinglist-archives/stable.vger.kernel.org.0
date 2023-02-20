Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E4569CAB3
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 13:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjBTMUv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 07:20:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbjBTMUt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 07:20:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97671814E
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 04:20:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76BED60E00
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 12:20:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9642C4339E
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 12:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676895646;
        bh=AOiqBaz/1bpeBA/U6iAsQTlLT3G5oF8qSnpEs9TlY7Y=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RHN8saFbzrrKrkWJ7y8qDVIxW1qSBQm7envNiAitBu7FpMC0BuKlnud8bivJ0xn78
         uIinhRS8JkzVoaUbhNcecT3ZjLi4asiEG7tXNopRYevaBrU1fgtFY3qz8ViEEe9vcS
         QQlBhJH2vYhL3hVJ656QukcW6BFsszObcbXiUgw8+19mplvchWOshnTqurypfF/t5j
         5pYBMW7j+seKPf8ta5ODMeHUmTBn7DxLGNgsE/N9CKQaRaCVj9hk6BICJ3w4WzUrJM
         VYxTXhWFaMN5cmlFx1ARTg6x7VaOjTqU7a42Mg0WqnWDpgrsLJFbUow97BQYPG8k7H
         IM17GO0vJ6r+A==
Received: by mail-ed1-f48.google.com with SMTP id da10so5132754edb.3
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 04:20:46 -0800 (PST)
X-Gm-Message-State: AO0yUKXPwxtfWpbpgde5/cKGF/ssWi4LWZKSSyLXcvs12LHYZ/kd4o0H
        KFxTJazs1zLPyMhFuYZo91Vka25hVrkxZiE0JNSYDA==
X-Google-Smtp-Source: AK7set/fgpQc73FYf0piSSCiyvkWsRGgSNTloru9BpfVyE0k9at/KApLyDXJyBvWkrp6QGp20qQcoMlMyb4MvTT4OFo=
X-Received: by 2002:a17:906:f88f:b0:8b0:7e1d:f6fa with SMTP id
 lg15-20020a170906f88f00b008b07e1df6famr3893511ejb.15.1676895645061; Mon, 20
 Feb 2023 04:20:45 -0800 (PST)
MIME-Version: 1.0
References: <20230220120127.1975241-1-kpsingh@kernel.org> <20230220121350.aidsipw3kd4rsyss@treble>
In-Reply-To: <20230220121350.aidsipw3kd4rsyss@treble>
From:   KP Singh <kpsingh@kernel.org>
Date:   Mon, 20 Feb 2023 04:20:34 -0800
X-Gmail-Original-Message-ID: <CACYkzJ5L9MLuE5Jz+z5-NJCCrUqTbgKQkXSqnQnCfTD_WNA7_Q@mail.gmail.com>
Message-ID: <CACYkzJ5L9MLuE5Jz+z5-NJCCrUqTbgKQkXSqnQnCfTD_WNA7_Q@mail.gmail.com>
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 20, 2023 at 4:13 AM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>
> On Mon, Feb 20, 2023 at 01:01:27PM +0100, KP Singh wrote:
> > +static inline bool spectre_v2_user_no_stibp(enum spectre_v2_mitigation mode)
> > +{
> > +     /* When IBRS or enhanced IBRS is enabled, STIBP is not needed.
> > +      *
> > +      * However, With KERNEL_IBRS, the IBRS bit is cleared on return
> > +      * to user and the user-mode code needs to be able to enable protection
> > +      * from cross-thread training, either by always enabling STIBP or
> > +      * by enabling it via prctl.
> > +      */
> > +     return (spectre_v2_in_ibrs_mode(mode) &&
> > +             !cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS));
> > +}
>
> The comments and code confused me, they both seem to imply some
> distinction between IBRS and KERNEL_IBRS, but in the kernel those are
> functionally the same thing.  e.g., the kernel doesn't have a user IBRS
> mode.
>
> And, unless I'm missing some subtlety here, it seems to be a convoluted
> way of saying that eIBRS doesn't need STIBP in user space.
>
> It would be simpler to just call it spectre_v2_in_eibrs_mode().

Thanks, yeah this would work too. I was just trying to ensure that, if
somehow, KERNEL_IBRS gets enabled with SPECTRE_V2_EIBRS, but this does
not seem to be the case currently. Maybe we should also add a BUG_ON
to ensure that KERNEL_IBRS does not get enabled in EIBRS mode?

>
> static inline bool spectre_v2_in_eibrs_mode(enum spectre_v2_mitigation mode)
> {
>         return mode == SPECTRE_V2_EIBRS ||
>                mode == SPECTRE_V2_EIBRS_RETPOLINE ||
>                mode == SPECTRE_V2_EIBRS_LFENCE;
> }
>
> And then spectre_v2_in_ibrs_mode() could be changed to call that:
>
> static inline bool spectre_v2_in_eibrs_mode(enum spectre_v2_mitigation mode)
> {
>         return spectre_v2_in_eibrs_mode(mode) || mode == SPECTRE_V2_IBRS;
> }
>
> > @@ -1496,6 +1504,7 @@ static void __init spectre_v2_select_mitigation(void)
> >               break;
> >
> >       case SPECTRE_V2_IBRS:
> > +             pr_err("enabling KERNEL_IBRS");
>
> Why?

Removed.

>
> > @@ -2327,7 +2336,7 @@ static ssize_t mmio_stale_data_show_state(char *buf)
> >
> >  static char *stibp_state(void)
> >  {
> > -     if (spectre_v2_in_ibrs_mode(spectre_v2_enabled))
> > +     if (spectre_v2_user_no_stibp(spectre_v2_enabled))
> >               return "";
>
> This seems like old cruft, can we just remove this check altogether?  In
> the eIBRS case, spectre_v2_user_stibp will already have its default of
> SPECTRE_V2_USER_NONE.
>
> --
> Josh
