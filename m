Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAB069EE7F
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 06:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjBVFuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 00:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjBVFuP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 00:50:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668D4311E1
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 21:50:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB7C6B811CF
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 05:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7673AC433A0
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 05:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677045010;
        bh=HyHnRWDCs3dh2VbKsgw8V6XZbBytcbTUxABHJr75Uls=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IudlILWA6UEqHtp2QHSlbmgqzh3Ed/HHu1V3EAmYvmcdI6HPeRFBWDSkMRu+Rj4AF
         OsVJn3NhnRN3buzI5rhADnLlxamEvRSRW7oEQtJIGbquaubgvbqdy9Kfwoga/Ofdm+
         Aq6faTAF5OXAPacwwM6zCqgnuQj2MNfEjSnz5zr6kVdnGhXwcCXbD42vYKkiwz21Mc
         PrWCJzQV03wNCxrcux5o8Uw80wsx2DqDN8ndgy9799zPXKmGVowje/TcnMnQxTwR31
         Vtbm7Z9fm5ax3B2BgLC5RGbh83GAMCWVr7Xkw0D8CvZ+M05RtUy6r7Z8Pm5P8HbDDu
         G/HNC9xCVg3ng==
Received: by mail-ed1-f50.google.com with SMTP id f13so25401393edz.6
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 21:50:10 -0800 (PST)
X-Gm-Message-State: AO0yUKVmyXG+g80SYSGXF6SnR37hucolgxxyOO7Kr21lMF4to5DnJDkB
        RoZGiPm0bsfIu5bqRz4GZ/+B+JRpA+9aLLK+JH7ySQ==
X-Google-Smtp-Source: AK7set/OX6J6GGDEHEMVX3y1z1pQ3sYoAKb9CmYNSKXJ7b/ygpewKkWEArAfkoV5tSfIjCBcdjzb8XommBcBnljyPHU=
X-Received: by 2002:a17:906:bce7:b0:8b1:28f6:8ab3 with SMTP id
 op7-20020a170906bce700b008b128f68ab3mr7153374ejb.15.1677045008619; Tue, 21
 Feb 2023 21:50:08 -0800 (PST)
MIME-Version: 1.0
References: <20230221184908.2349578-1-kpsingh@kernel.org> <20230222030728.v4ldlndtnx6gqd6x@desk>
In-Reply-To: <20230222030728.v4ldlndtnx6gqd6x@desk>
From:   KP Singh <kpsingh@kernel.org>
Date:   Tue, 21 Feb 2023 21:49:57 -0800
X-Gmail-Original-Message-ID: <CACYkzJ4efHx2oZUW82m3DGw7ssLq37EFOV57X=kT5fm=6Q7WbQ@mail.gmail.com>
Message-ID: <CACYkzJ4efHx2oZUW82m3DGw7ssLq37EFOV57X=kT5fm=6Q7WbQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] x86/speculation: Allow enabling STIBP with legacy IBRS
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, pjt@google.com, evn@google.com,
        jpoimboe@kernel.org, tglx@linutronix.de, x86@kernel.org,
        hpa@zytor.com, peterz@infradead.org, kim.phillips@amd.com,
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

On Tue, Feb 21, 2023 at 7:07 PM Pawan Gupta
<pawan.kumar.gupta@linux.intel.com> wrote:
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
> >
> > diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> > index 85168740f76a..5be6075d8e36 100644
> > --- a/arch/x86/kernel/cpu/bugs.c
> > +++ b/arch/x86/kernel/cpu/bugs.c
> > @@ -1124,14 +1124,30 @@ spectre_v2_parse_user_cmdline(void)
> >       return SPECTRE_V2_USER_CMD_AUTO;
> >  }
> >
> > -static inline bool spectre_v2_in_ibrs_mode(enum spectre_v2_mitigation =
mode)
> > +static inline bool spectre_v2_in_eibrs_mode(enum spectre_v2_mitigation=
 mode)
> >  {
> > -     return mode =3D=3D SPECTRE_V2_IBRS ||
> > -            mode =3D=3D SPECTRE_V2_EIBRS ||
> > +     return mode =3D=3D SPECTRE_V2_EIBRS ||
> >              mode =3D=3D SPECTRE_V2_EIBRS_RETPOLINE ||
> >              mode =3D=3D SPECTRE_V2_EIBRS_LFENCE;
> >  }
> >
> > +static inline bool spectre_v2_in_ibrs_mode(enum spectre_v2_mitigation =
mode)
> > +{
> > +     return spectre_v2_in_eibrs_mode(mode) || mode =3D=3D SPECTRE_V2_I=
BRS;
> > +}
> > +
> > +static inline bool spectre_v2_user_needs_stibp(enum spectre_v2_mitigat=
ion mode)
> > +{
> > +     /*
> > +      * enhanced IBRS also protects against user-mode attacks as the I=
BRS bit
>
> Maybe:
>          * Enhanced IBRS mode also protects against cross-thread user-to-=
user
>          * attacks as the IBRS bit

updated, thanks!

>
> > +      * remains always set which implicitly enables cross-thread prote=
ctions.
> > +      * However, In legacy IBRS mode, the IBRS bit is set only in kern=
el
> > +      * and cleared on return to userspace. This disables the implicit
> > +      * cross-thread protections and STIBP is needed.
> > +      */
> > +     return !spectre_v2_in_eibrs_mode(mode);
> > +}
> > +
> >  static void __init
> >  spectre_v2_user_select_mitigation(void)
> >  {
> > @@ -1193,13 +1209,8 @@ spectre_v2_user_select_mitigation(void)
> >                       "always-on" : "conditional");
> >       }
> >
> > -     /*
> > -      * If no STIBP, IBRS or enhanced IBRS is enabled, or SMT impossib=
le,
> > -      * STIBP is not required.
> > -      */
> > -     if (!boot_cpu_has(X86_FEATURE_STIBP) ||
> > -         !smt_possible ||
> > -         spectre_v2_in_ibrs_mode(spectre_v2_enabled))
> > +     if (!boot_cpu_has(X86_FEATURE_STIBP) || !smt_possible ||
> > +         !spectre_v2_user_needs_stibp(spectre_v2_enabled))
>
> As pointed out in other discussions, it will be great if can get rid of
> eIBRS check, and do what the user asked for; or atleast print a warning

I think I will keep it as pr_info as, with eIBRS, the user does not
really need STIBP and the mitigation is still effective.

> about not setting STIBP bit explicitly.

That is a bit more complicated as, for now, the user is not really
exposed to STIBP explicitly yet.

{ "auto", SPECTRE_V2_USER_CMD_AUTO, false },
{ "off", SPECTRE_V2_USER_CMD_NONE, false },
{ "on", SPECTRE_V2_USER_CMD_FORCE, true },
{ "prctl", SPECTRE_V2_USER_CMD_PRCTL, false },
{ "prctl,ibpb", SPECTRE_V2_USER_CMD_PRCTL_IBPB, false },
{ "seccomp", SPECTRE_V2_USER_CMD_SECCOMP, false },
{ "seccomp,ibpb", SPECTRE_V2_USER_CMD_SECCOMP_IBPB, false },

I would prefer to do it as a follow up and fix this bug first.

It's a bit gnarly and I think we really need to think about the
options that are exposed to the user [especially in light of Intel /
AMD subtelties].

With the current patch the userspace is still getting working V2
mitigations on both dimensions time (Process A followed by Process B
where A does BTI on the subsequent B that are flushed via an IBPB) and
space (i.e. cross-thread branch target injection) whenever necessary.




>
> >               return;
> >
> >       /*
> > @@ -2327,7 +2338,7 @@ static ssize_t mmio_stale_data_show_state(char *b=
uf)
> >
> >  static char *stibp_state(void)
> >  {
> > -     if (spectre_v2_in_ibrs_mode(spectre_v2_enabled))
> > +     if (!spectre_v2_user_needs_stibp(spectre_v2_enabled))
>
> Decoupling STIBP and eIBRS will also get rid of this check.
>
> >               return "";
