Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860BD451057
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237192AbhKOSqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:46:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242724AbhKOSo0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 13:44:26 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6E3C04F57F
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 09:50:14 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id z34so45647876lfu.8
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 09:50:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=990AaCrkFvEwNKbdHczTMONTidL9IixJu0dILVKA4h0=;
        b=qn1czP8XrkmYXW2lyoEG1rV3I5NL9XtY0ya437nWEWNy6AbsYwfwZJnFYGCpug2ra3
         3ZnMuHmKNvwDKsJnba3vXV4brICXAK8UdJoV87Ix2HOCmryAvC17SktR9Ohf4wYDoEwd
         9OP2jcM/5A0BvWlz6DjRUdMGEMVGuZT/Q+0g+nzGXkiRWAeV3DUVlCFw3zmPPUTzVQcE
         hE8+oVxq/zmvjieUM+m/Fsp/KKnc6xVUvr9CepKJhpoMASCqsdXdD2PQg7Z7PWkg//4b
         ZzOEh/FLg81/XrV1WEJbeaJka6+OUSu/JmUlQ2e5Y6vHbpE2vXrNN5kZdCHMl6iHBobC
         Unyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=990AaCrkFvEwNKbdHczTMONTidL9IixJu0dILVKA4h0=;
        b=NVUaHw5hFTy33UEYbkwphzWzQwsBjK/orN8JyIDUpGL5B9YzmbTW+wHkPB70BnEPVJ
         LZ113cRV8sJdTvj0ZD3HcSaxaEw3R2XhkHOW6v8ogHdSnhplFAC3GqAn+hEQS3WAshf8
         nkF18zhzGsFbWSx0mDSa5M68h2rL+yMHMirG9oMapdmqqKF4KHZEITCT6BIY33Y32qdK
         gNpKtAT2qTuv+xRbbPzJZ29ShpGCY9L9dU000kAbeiKUxrl/9G4x4wUxI8gjnh6Jy6xb
         H1tMvEba8jNINtS+cUaJcWexi8xYCQmaLGO7x+/ReA3bRqyru2zDiEWHDlGfqcZOLWqx
         /PhA==
X-Gm-Message-State: AOAM530No5K8saZ3T1n6c6r63ei94zbqxfR0vPkY72vyn9vcGxv9q34o
        1I/+rgqgD/GkFYhsK5l8wCyDesSlzAhIAaR261rRYg==
X-Google-Smtp-Source: ABdhPJwQ/pvHn4xkM7aH1r8xA1I6GLGk+z3V7rVOFAGiuFLj9fADLmccEiVCZ3iAdPeLla82Oivde2V/Nu6t4DAhcN8=
X-Received: by 2002:a05:6512:b29:: with SMTP id w41mr470237lfu.240.1636998612743;
 Mon, 15 Nov 2021 09:50:12 -0800 (PST)
MIME-Version: 1.0
References: <20211115164322.560965-1-nathan@kernel.org>
In-Reply-To: <20211115164322.560965-1-nathan@kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 15 Nov 2021 09:50:01 -0800
Message-ID: <CAKwvOdnXGSkh4VM9Frn_OHMvdMpaXAH9dVsap34mKv7PcurrZQ@mail.gmail.com>
Subject: Re: [PATCH 5.10] scripts/lld-version.sh: Rewrite based on upstream ld-version.sh
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 8:46 AM Nathan Chancellor <nathan@kernel.org> wrote:
>
> This patch is for linux-5.10.y only.
>
> When scripts/lld-version.sh was initially written, it did not account
> for the LLD_VENDOR cmake flag, which changes the output of ld.lld's
> --version flag slightly.
>
> Without LLD_VENDOR:
>
> $ ld.lld --version
> LLD 14.0.0 (compatible with GNU linkers)
>
> With LLD_VENDOR:
>
> $ ld.lld --version
> Debian LLD 14.0.0 (compatible with GNU linkers)
>
> As a result, CONFIG_LLD_VERSION is messed up and configuration values
> that are dependent on it cannot be selected:
>
> scripts/lld-version.sh: 20: printf: LLD: expected numeric value
> scripts/lld-version.sh: 20: printf: LLD: expected numeric value
> scripts/lld-version.sh: 20: printf: LLD: expected numeric value
> init/Kconfig:52:warning: 'LLD_VERSION': number is invalid
> .config:11:warning: symbol value '00000' invalid for LLD_VERSION
> .config:8800:warning: override: CPU_BIG_ENDIAN changes choice state
>
> This was fixed upstream by commit 1f09af062556 ("kbuild: Fix
> ld-version.sh script if LLD was built with LLD_VENDOR") in 5.12 but that
> was done to ld-version.sh after it was massively rewritten in
> commit 02aff8592204 ("kbuild: check the minimum linker version in
> Kconfig").
>
> To avoid bringing in that change plus its prerequisites and fixes, just
> modify lld-version.sh to make it similar to the upstream ld-version.sh,
> which handles ld.lld with or without LLD_VENDOR and ld.bfd without any
> errors.
>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks for the fix.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>
> Our CI caught this error with newer versions of Debian's ld.lld, which
> added LLD_VENDOR it seems:
>
> https://github.com/ClangBuiltLinux/continuous-integration2/runs/4206343929?check_suite_focus=true
>
> A similar change was done by me for Android, where it has seen no
> issues:
>
> https://android-review.googlesource.com/c/kernel/common/+/1744324
>
> I believe this is a safer change than backporting the fixes from
> upstream but if you guys feel otherwise, I can do so. This is only
> needed in 5.10 as CONFIG_LLD_VERSION does not exist in 5.4 and it was
> fixed in 5.12 upstream.
>
>  scripts/lld-version.sh | 35 ++++++++++++++++++++++++++---------
>  1 file changed, 26 insertions(+), 9 deletions(-)
>
> diff --git a/scripts/lld-version.sh b/scripts/lld-version.sh
> index d70edb4d8a4f..f1eeee450a23 100755
> --- a/scripts/lld-version.sh
> +++ b/scripts/lld-version.sh
> @@ -6,15 +6,32 @@
>  # Print the linker version of `ld.lld' in a 5 or 6-digit form
>  # such as `100001' for ld.lld 10.0.1 etc.
>
> -linker_string="$($* --version)"
> +set -e
>
> -if ! ( echo $linker_string | grep -q LLD ); then
> +# Convert the version string x.y.z to a canonical 5 or 6-digit form.
> +get_canonical_version()
> +{
> +       IFS=.
> +       set -- $1
> +
> +       # If the 2nd or 3rd field is missing, fill it with a zero.
> +       echo $((10000 * $1 + 100 * ${2:-0} + ${3:-0}))
> +}
> +
> +# Get the first line of the --version output.
> +IFS='
> +'
> +set -- $(LC_ALL=C "$@" --version)
> +
> +# Split the line on spaces.
> +IFS=' '
> +set -- $1
> +
> +while [ $# -gt 1 -a "$1" != "LLD" ]; do
> +       shift
> +done
> +if [ "$1" = LLD ]; then
> +       echo $(get_canonical_version ${2%-*})
> +else
>         echo 0
> -       exit 1
>  fi
> -
> -VERSION=$(echo $linker_string | cut -d ' ' -f 2)
> -MAJOR=$(echo $VERSION | cut -d . -f 1)
> -MINOR=$(echo $VERSION | cut -d . -f 2)
> -PATCHLEVEL=$(echo $VERSION | cut -d . -f 3)
> -printf "%d%02d%02d\\n" $MAJOR $MINOR $PATCHLEVEL
>
> base-commit: bd816c278316f20a5575debc64dde4422229a880
> --
> 2.34.0.rc0
>


-- 
Thanks,
~Nick Desaulniers
