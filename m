Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD8E69F9D0
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 18:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjBVRRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 12:17:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232634AbjBVRRQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 12:17:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576073E616
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 09:16:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB938B81604
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 17:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894F4C433EF
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 17:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677086215;
        bh=hrUmLp1ongRcWuDKKNDJfhcSjmKjfLzniRaBA7/JBIM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bRbopBiyGqDuqXdek2o/lgOX+5XqsYF4oI112nqm6/KQuneaC3EBN2YQV8cmXL64W
         tOKwRoFfWdSSTsX31t4Tt+jlarWMpwdnaROmiN1bfZjOn0vPy9X42/HdMvSvCaaux5
         17s91pm0dTtpfKIeBu0VuUVtJAk+nATE6sFyNRjxGwbomC4tPtrVbyVkix2k8Y87+N
         xiihSKwklXcFTM9Oq5CeOK4EhVHqrPWCEeNOpw2ftlaJYGhovqROPmlwXZ3n+9CH5c
         ds1qqKcG4FuoffxtjQupy7sgclnYACyR/xG0+yRnila97aXD/+l/LGzSDtKcOR9fms
         Bux/g2Z71o8Yw==
Received: by mail-ed1-f50.google.com with SMTP id ec43so32837858edb.8
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 09:16:55 -0800 (PST)
X-Gm-Message-State: AO0yUKUq3OOxzA7jywtR/gXbtoeV5eyzdKi/5haa8Um3etnypVY+DUEd
        GEdHm9jR05uSK5FLlUy6YI7xrLWUFdkKzIcm13pKFA==
X-Google-Smtp-Source: AK7set+DybHw6otK+W5B3oVTKwQvIdsHNRWcJRAdtoU/CADQS4+k//kUCc9CsMPbeSD1AFrmu1eoewaXneQ2ql/lPnI=
X-Received: by 2002:a05:6402:5484:b0:4ad:739c:b38e with SMTP id
 fg4-20020a056402548400b004ad739cb38emr5459193edb.1.1677086192863; Wed, 22 Feb
 2023 09:16:32 -0800 (PST)
MIME-Version: 1.0
References: <20230221184908.2349578-1-kpsingh@kernel.org> <Y/YJisQdorH1aAKV@zn.tnic>
In-Reply-To: <Y/YJisQdorH1aAKV@zn.tnic>
From:   KP Singh <kpsingh@kernel.org>
Date:   Wed, 22 Feb 2023 09:16:21 -0800
X-Gmail-Original-Message-ID: <CACYkzJ4cSA5xFScgS=WTc6tPis-vUCtYkh3LyEr8EkXoDCm-uA@mail.gmail.com>
Message-ID: <CACYkzJ4cSA5xFScgS=WTc6tPis-vUCtYkh3LyEr8EkXoDCm-uA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] x86/speculation: Allow enabling STIBP with legacy IBRS
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-kernel@vger.kernel.org, pjt@google.com, evn@google.com,
        jpoimboe@kernel.org, tglx@linutronix.de, x86@kernel.org,
        hpa@zytor.com, peterz@infradead.org,
        pawan.kumar.gupta@linux.intel.com, kim.phillips@amd.com,
        alexandre.chartre@oracle.com, daniel.sneddon@linux.intel.com,
        corbet@lwn.net, bp@suse.de, linyujun809@huawei.com,
        jmattson@google.com,
        =?UTF-8?Q?Jos=C3=A9_Oliveira?= <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 22, 2023 at 4:24 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Tue, Feb 21, 2023 at 07:49:07PM +0100, KP Singh wrote:
> > Setting the IBRS bit implicitly enables STIBP to protect against
> > cross-thread branch target injection. With enhanced IBRS, the bit it se=
t
> > once and is not cleared again. However, on CPUs with just legacy IBRS,
> > IBRS bit set on user -> kernel and cleared on kernel -> user (a.k.a
> > KERNEL_IBRS). Clearing this bit also disables the implicitly enabled
> > STIBP, thus requiring some form of cross-thread protection in userspace=
.
> >
> > Enable STIBP, either opt-in via prctl or seccomp, or always on dependin=
g
> > on the choice of mitigation selected via spectre_v2_user.
> >
> > Reported-by: Jos=C3=A9 Oliveira <joseloliveira11@gmail.com>
> > Reported-by: Rodrigo Branco <rodrigo@kernelhacking.com>
> > Reviewed-by: Alexandra Sandulescu <aesa@google.com>
> > Fixes: 7c693f54c873 ("x86/speculation: Add spectre_v2=3Dibrs option to =
support Kernel IBRS")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: KP Singh <kpsingh@kernel.org>
> > ---
> >  arch/x86/kernel/cpu/bugs.c | 33 ++++++++++++++++++++++-----------
> >  1 file changed, 22 insertions(+), 11 deletions(-)
>
> Below is what I'd like to see. Holler if something's wrong.

Thanks for iterating. I think your commit description and rewrite
omits a few key subtleties which I have tried to reinforce in both the
commit log and the comments.

Q: What does STIBP have to do with IBRS?
A: Setting the IBRS bit implicitly enables STIBP / some form of cross
thread protection.

Q: Why does it work with eIBRS?
A: Because we set the IBRS bit once and leave it set when using eIBRS

I think this subtlety should be reinforced in the commit description
and code comments so that we don't get it wrong again. Your commit
does answer this one (thanks!)

Q: Why does it not work with the way the kernel currently implements
legacy IBRS?
A: Because the kernel clears the bit on returning to user space.

>
> It is totally untested ofc.
>
> ---
> From: KP Singh <kpsingh@kernel.org>
> Date: Tue, 21 Feb 2023 19:49:07 +0100
> Subject: [PATCH] x86/speculation: Allow enabling STIBP with legacy IBRS
> MIME-Version: 1.0
> Content-Type: text/plain; charset=3DUTF-8
> Content-Transfer-Encoding: 8bit
>
> When plain IBRS is enabled (not enhanced IBRS), the logic in
> spectre_v2_user_select_mitigation() determines that STIBP is not needed.
>
> However, on return to userspace, the IBRS bit is cleared for performance
> reasons. That leaves userspace threads vulnerable to cross-thread
> predictions influence against which STIBP protects.
>
> Exclude IBRS from the spectre_v2_in_ibrs_mode() check to allow for
> enabling STIBP through seccomp/prctl().
>
>   [ bp: Rewrite commit message and massage. ]
>
> Fixes: 7c693f54c873 ("x86/speculation: Add spectre_v2=3Dibrs option to su=
pport Kernel IBRS")
> Reported-by: Jos=C3=A9 Oliveira <joseloliveira11@gmail.com>
> Reported-by: Rodrigo Branco <rodrigo@kernelhacking.com>
> Signed-off-by: KP Singh <kpsingh@kernel.org>
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/20230221184908.2349578-1-kpsingh@kernel.o=
rg
> ---
>  arch/x86/kernel/cpu/bugs.c | 25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index cf81848b72f4..9a969ab0e62a 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -1133,14 +1133,18 @@ spectre_v2_parse_user_cmdline(void)
>         return SPECTRE_V2_USER_CMD_AUTO;
>  }
>
> -static inline bool spectre_v2_in_ibrs_mode(enum spectre_v2_mitigation mo=
de)
> +static inline bool spectre_v2_in_eibrs_mode(enum spectre_v2_mitigation m=
ode)
>  {
> -       return mode =3D=3D SPECTRE_V2_IBRS ||
> -              mode =3D=3D SPECTRE_V2_EIBRS ||
> +       return mode =3D=3D SPECTRE_V2_EIBRS ||
>                mode =3D=3D SPECTRE_V2_EIBRS_RETPOLINE ||
>                mode =3D=3D SPECTRE_V2_EIBRS_LFENCE;
>  }
>
> +static inline bool spectre_v2_in_ibrs_mode(enum spectre_v2_mitigation mo=
de)
> +{
> +       return spectre_v2_in_eibrs_mode(mode) || mode =3D=3D SPECTRE_V2_I=
BRS;
> +}
> +
>  static void __init
>  spectre_v2_user_select_mitigation(void)
>  {
> @@ -1203,12 +1207,19 @@ spectre_v2_user_select_mitigation(void)
>         }
>
>         /*
> -        * If no STIBP, IBRS or enhanced IBRS is enabled, or SMT impossib=
le,
> -        * STIBP is not required.
> +        * If no STIBP, enhanced IBRS is enabled, or SMT impossible, STIB=
P
> +        * is not required.
> +        *
> +        * Enhanced IBRS protects also against user-mode attacks as the I=
BRS bit
> +        * remains always set which implicitly enables cross-thread prote=
ctions.
> +        * However, in legacy IBRS mode, the IBRS bit is set only on kern=
el
> +        * entry and cleared on return to userspace. This disables the im=
plicit
> +        * cross-thread protections so allow for STIBP to be selected in =
that
> +        * case.
>          */
>         if (!boot_cpu_has(X86_FEATURE_STIBP) ||
>             !smt_possible ||
> -           spectre_v2_in_ibrs_mode(spectre_v2_enabled))
> +           spectre_v2_in_eibrs_mode(spectre_v2_enabled))
>                 return;
>
>         /*
> @@ -2340,7 +2351,7 @@ static ssize_t mmio_stale_data_show_state(char *buf=
)
>
>  static char *stibp_state(void)
>  {
> -       if (spectre_v2_in_ibrs_mode(spectre_v2_enabled))
> +       if (spectre_v2_in_eibrs_mode(spectre_v2_enabled))

The reason why I refactored this into a separate helper was to
document the subtleties I mentioned above and anchor them to one place
as the function is used in 2 places. But this is a maintainer's
choice, so it's your call :)

I do agree with Pawan that it's worth adding a pr_info about what the
kernel is doing about STIBP.

- KP

>                 return "";
>
>         switch (spectre_v2_user_stibp) {
> --
> 2.35.1
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette
