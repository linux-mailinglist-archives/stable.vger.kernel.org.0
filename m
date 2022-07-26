Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 035B35808AD
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 02:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbiGZAMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 20:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236042AbiGZAMk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 20:12:40 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3F927FFD
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 17:12:39 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id d124so5392130ybb.5
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 17:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9JSe3z9pGkzgL7xUiS8Yr/5UR7RYsGogFav7UDOeLH8=;
        b=E1wN9qXuZl7RNgnoeAdISeng0a2iXHtFQZCmOLLF1QHOR0tb0+irVqrji81HMAKTR3
         Rf8ApMLfd8zkYF+aepDEdAv42XMa3vj3isKbVJZqTnehX1P4HkgsVpBv6hKvWZcAEwBm
         Hl/H3J8Zm5ZW7dzJWQgoJ0S5qJCXEChcqnMyQFG6592BeeXaA1AxEB9dzoqdP3r7L/qa
         ovddjUVMA0LEMQeWNStbGGJTImVO2Iov35ysqKIjAekEQh3d47Xbg86FEkAIRKnAabQz
         pFzc7m+e5mhq8CoZJp9ccOTpUOgJ14j4Jpk0nIy9jdgFkK4kRvCLbRnSd/3qywUdGYbA
         CxhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9JSe3z9pGkzgL7xUiS8Yr/5UR7RYsGogFav7UDOeLH8=;
        b=EdWEfm+1uUS3of2MfiqSHpbYJymMCvZLU67EFYxiXHj+YcsfiKDkv+4qTPdO9lMJU3
         qnoMibfYjua5W1WL729fCj//lzEBLPNQ5rwTTxpzQw2Gb6BOdv9867DkWkiTAdL2P29Z
         594lq7ggofQPNJiyq2Np8i3LLhywMTV0mN/Q/L+D+R0ejvAyvfVsDfxrbFMVga5G/wyW
         NeG3Yq47vEkaabZZ/uyqq4FVQLgJv6nMv+g+lujrKdYIyKEXc0T02Oc1tWKZke0BHXOM
         2VGnvas3XGJeMWKWM2nYwPdWM67FlrqRx0ajxqaopHjnc1gFPI1dd5Db+UjLjLzVtsBr
         yYgA==
X-Gm-Message-State: AJIora+RsckeP0l47HqKDGubSIFxLGgkBUz3nTybtDK30bdhLQYBHQ0L
        m1APkZQ/q/ZmKQywNE9Cr3ZFtcXAMOdLiU9VY5F8Qg==
X-Google-Smtp-Source: AGRyM1vo0SJOssrzz1Zhq2nhkvNWvbLvRZXEWuEx3ZdKz1ghxpU2Qk4orNgieYmRo5PCLyR7iBSsnqME2JzCqF08st8=
X-Received: by 2002:a5b:cc6:0:b0:66e:45c6:2a25 with SMTP id
 e6-20020a5b0cc6000000b0066e45c62a25mr11461206ybr.304.1658794358302; Mon, 25
 Jul 2022 17:12:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220725233629.223223-1-nathan@kernel.org>
In-Reply-To: <20220725233629.223223-1-nathan@kernel.org>
From:   Sami Tolvanen <samitolvanen@google.com>
Date:   Mon, 25 Jul 2022 17:12:02 -0700
Message-ID: <CABCJKuf1gYZZb9U-zwjkvvRUUh9GvYsHF=8zub=pr9tG4BqtkA@mail.gmail.com>
Subject: Re: [PATCH] drm/simpledrm: Fix return type of simpledrm_simple_display_pipe_mode_valid()
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        dri-devel@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>, llvm@lists.linux.dev,
        "# 3.4.x" <stable@vger.kernel.org>,
        =?UTF-8?Q?Tomasz_Pawe=C5=82_Gajc?= <tpgxyz@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 25, 2022 at 4:37 PM Nathan Chancellor <nathan@kernel.org> wrote=
:
>
> When booting a kernel compiled with clang's CFI protection
> (CONFIG_CFI_CLANG), there is a CFI failure in
> drm_simple_kms_crtc_mode_valid() when trying to call
> simpledrm_simple_display_pipe_mode_valid() through ->mode_valid():
>
> [    0.322802] CFI failure (target: simpledrm_simple_display_pipe_mode_va=
lid+0x0/0x8):
> ...
> [    0.324928] Call trace:
> [    0.324969]  __ubsan_handle_cfi_check_fail+0x58/0x60
> [    0.325053]  __cfi_check_fail+0x3c/0x44
> [    0.325120]  __cfi_slowpath_diag+0x178/0x200
> [    0.325192]  drm_simple_kms_crtc_mode_valid+0x58/0x80
> [    0.325279]  __drm_helper_update_and_validate+0x31c/0x464
> ...
>
> The ->mode_valid() member in 'struct drm_simple_display_pipe_funcs'
> expects a return type of 'enum drm_mode_status', not 'int'. Correct it
> to fix the CFI failure.
>
> Cc: stable@vger.kernel.org
> Fixes: 11e8f5fd223b ("drm: Add simpledrm driver")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1647
> Reported-by: Tomasz Pawe=C5=82 Gajc <tpgxyz@gmail.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/gpu/drm/tiny/simpledrm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/tiny/simpledrm.c b/drivers/gpu/drm/tiny/simp=
ledrm.c
> index 768242a78e2b..5422363690e7 100644
> --- a/drivers/gpu/drm/tiny/simpledrm.c
> +++ b/drivers/gpu/drm/tiny/simpledrm.c
> @@ -627,7 +627,7 @@ static const struct drm_connector_funcs simpledrm_con=
nector_funcs =3D {
>         .atomic_destroy_state =3D drm_atomic_helper_connector_destroy_sta=
te,
>  };
>
> -static int
> +static enum drm_mode_status
>  simpledrm_simple_display_pipe_mode_valid(struct drm_simple_display_pipe =
*pipe,
>                                     const struct drm_display_mode *mode)
>  {

Thanks for fixing this, Nathan! The patch looks correct to me.

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami
