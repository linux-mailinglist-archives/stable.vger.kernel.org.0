Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 951BA69D2C6
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 19:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbjBTSeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 13:34:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBTSeL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 13:34:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362461ADD0
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 10:34:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C205360EF6
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 18:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29188C433A4
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 18:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676918049;
        bh=ML0XSezZThmCiOdnlVOEMpzsr/qbxHQAgJCHOaHbrCw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=F5RZc/Ig7XAtHu59VGUTeogGyySOvBm8vxP78Ii3shAprAl3fIUkGSbeP6Dkrc275
         T11OWj2l9Ep+BjJV8Z4TF8JwPoa3uecc4AbVowRpkAFH6frw4rOOBhxAESHRbrnckC
         bFTFdR6vmheoh0nrOqGqfiy7FUSr4lc0AdYNSRd92oEzeH/uKdPFSA/PXBN4em+7AO
         jCujhCH06Jkj3VoO2cfVElFxjScfUyXp3wWz302V+OWHiUnsfylV+pi0btw9nC8Qq6
         SCasAIIpkM1+FATOykJKRfBcp/T304au4LWloKSIgm5emXx6U4kdCQljrHcu+0xibt
         Yg843dDjHKPXQ==
Received: by mail-ed1-f49.google.com with SMTP id h32so8344449eda.2
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 10:34:09 -0800 (PST)
X-Gm-Message-State: AO0yUKUmtAOcydJQYa2ebr1D/05uR15N9pz+2rQnkZh74mKpPXplwWRW
        DSxfbeI024oFlFixcJ8eggsKBUYbg+52OluoR52fxw==
X-Google-Smtp-Source: AK7set++l6WhW3jqunTFWtDZBiAztOICYs2Y5cD99FEKVPnkbf9ufoRp0MvyVe9VX0ZW0D/duAge/Kxm3j7mjJrw7RU=
X-Received: by 2002:a50:baa4:0:b0:4aa:a4f1:3edc with SMTP id
 x33-20020a50baa4000000b004aaa4f13edcmr494488ede.7.1676918047317; Mon, 20 Feb
 2023 10:34:07 -0800 (PST)
MIME-Version: 1.0
References: <20230220120127.1975241-1-kpsingh@kernel.org> <20230220121350.aidsipw3kd4rsyss@treble>
 <CACYkzJ5L9MLuE5Jz+z5-NJCCrUqTbgKQkXSqnQnCfTD_WNA7_Q@mail.gmail.com>
 <CACYkzJ6n=-tobhX0ONQhjHSgmnNjWnNe_dZnEOGtD8Y6S3RHbA@mail.gmail.com>
 <20230220163442.7fmaeef3oqci4ee3@treble> <Y/Ox3MJZF1Yb7b6y@zn.tnic>
 <20230220175929.2laflfb2met6y3kc@treble> <CACYkzJ71xqzY6-wL+YShcL+d6ugzcdFHr6tbYWWE_ep52+RBZQ@mail.gmail.com>
 <20230220182717.uzrym2gtavlbjbxo@treble>
In-Reply-To: <20230220182717.uzrym2gtavlbjbxo@treble>
From:   KP Singh <kpsingh@kernel.org>
Date:   Mon, 20 Feb 2023 10:33:56 -0800
X-Gmail-Original-Message-ID: <CACYkzJ5z3qLhkWqKLvP55HcjLACzAJbFjc4XjRzcft9ww40MaQ@mail.gmail.com>
Message-ID: <CACYkzJ5z3qLhkWqKLvP55HcjLACzAJbFjc4XjRzcft9ww40MaQ@mail.gmail.com>
Subject: Re: [PATCH] x86/bugs: Allow STIBP with IBRS
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        pjt@google.com, evn@google.com, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
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

On Mon, Feb 20, 2023 at 10:27 AM Josh Poimboeuf <jpoimboe@kernel.org> wrote=
:
>
> IBRS is only enabled in kernel space.  Since it's not enabled in user
> space, user space isn't protected from indirect branch prediction
> attacks from a sibling CPU thread.
>
> Allow STIBP to be enabled to protect against such attacks.
>
> Fixes: 7c693f54c873 ("x86/speculation: Add spectre_v2=3Dibrs option to su=
pport Kernel IBRS")
> Reported-by: Jos=C3=A9 Oliveira <joseloliveira11@gmail.com>
> Reported-by: Rodrigo Branco <rodrigo@kernelhacking.com>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  arch/x86/kernel/cpu/bugs.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index 85168740f76a..b97c0d28e573 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -1124,14 +1124,19 @@ spectre_v2_parse_user_cmdline(void)
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

There are no comments here, this code is in dire need for some
comments and explanation, I was trying something like:

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index bca0bd8f4846..3e04f9fa68a8 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1124,14 +1124,31 @@ spectre_v2_parse_user_cmdline(void)
        return SPECTRE_V2_USER_CMD_AUTO;
 }

-static inline bool spectre_v2_in_ibrs_mode(enum spectre_v2_mitigation mode=
)
+static inline bool spectre_v2_in_eibrs_mode(enum spectre_v2_mitigation mod=
e)
 {
-       return mode =3D=3D SPECTRE_V2_IBRS ||
-              mode =3D=3D SPECTRE_V2_EIBRS ||
+       return mode =3D=3D SPECTRE_V2_EIBRS ||
               mode =3D=3D SPECTRE_V2_EIBRS_RETPOLINE ||
               mode =3D=3D SPECTRE_V2_EIBRS_LFENCE;
 }

+/*
+ * In IBRS mode, the spectre_v2 mitigation is enabled only in kernel space=
 with
+ * the IBRS bit being cleared on return to userspace due to performance
+ * overhead.
+ */
+static inline bool spectre_v2_in_ibrs_mode(enum spectre_v2_mitigation mode=
)
+{
+       return spectre_v2_in_eibrs_mode(mode) || mode =3D=3D SPECTRE_V2_IBR=
S;
+}
+
+/*
+ * User mode protections are only available in eIBRS mode.
+ */
+static inline bool spectre_v2_user_needs_stibp(enum spectre_v2_mitigation =
mode)
+{
+       return !spectre_v2_in_eibrs_mode(mode);
+}
+
 static void __init
 spectre_v2_user_select_mitigation(void)
 {
@@ -1193,13 +1210,8 @@ spectre_v2_user_select_mitigation(void)
                        "always-on" : "conditional");
        }

-       /*
-        * If no STIBP, IBRS or enhanced IBRS is enabled, or SMT impossible=
,
-        * STIBP is not required.
-        */
-       if (!boot_cpu_has(X86_FEATURE_STIBP) ||
-           !smt_possible ||
-           spectre_v2_in_ibrs_mode(spectre_v2_enabled))
+       if (!boot_cpu_has(X86_FEATURE_STIBP) || !smt_possible ||
+           !spectre_v2_user_needs_stibp(spectre_v2_enabled))
                return;

        /*
@@ -2327,7 +2339,7 @@ static ssize_t mmio_stale_data_show_state(char *buf)

 static char *stibp_state(void)
 {
-       if (spectre_v2_in_ibrs_mode(spectre_v2_enabled))
+       if (!spectre_v2_user_needs_stibp(spectre_v2_enabled))
                return "";

        switch (spectre_v2_user_stibp) {

Also Josh, is it okay for us to have a discussion and have me write
the patch as a v2? Your current patch does not even credit me at all.
Seems a bit unfair, but I don't really care. I was going to rev up the
patch with your suggestions.

>
> +static inline bool spectre_v2_in_ibrs_mode(enum spectre_v2_mitigation mo=
de)
> +{
> +       return spectre_v2_in_eibrs_mode(mode) ||
> +              mode =3D=3D SPECTRE_V2_IBRS;
> +}
> +
>  static void __init
>  spectre_v2_user_select_mitigation(void)
>  {
> @@ -1194,12 +1199,12 @@ spectre_v2_user_select_mitigation(void)
>         }
>
>         /*
> -        * If no STIBP, IBRS or enhanced IBRS is enabled, or SMT impossib=
le,
> +        * If no STIBP, enhanced IBRS is enabled, or SMT impossible,
>          * STIBP is not required.
>          */
>         if (!boot_cpu_has(X86_FEATURE_STIBP) ||
>             !smt_possible ||
> -           spectre_v2_in_ibrs_mode(spectre_v2_enabled))
> +           spectre_v2_in_eibrs_mode(spectre_v2_enabled))
>                 return;
>
>         /*
> @@ -2327,9 +2332,6 @@ static ssize_t mmio_stale_data_show_state(char *buf=
)
>
>  static char *stibp_state(void)
>  {
> -       if (spectre_v2_in_ibrs_mode(spectre_v2_enabled))
> -               return "";
> -
>         switch (spectre_v2_user_stibp) {
>         case SPECTRE_V2_USER_NONE:
>                 return ", STIBP: disabled";
> --
> 2.39.1
>
