Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5408529645B
	for <lists+stable@lfdr.de>; Thu, 22 Oct 2020 20:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368800AbgJVSE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Oct 2020 14:04:57 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:45671 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2508483AbgJVSE5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Oct 2020 14:04:57 -0400
Received: by mail-vs1-f68.google.com with SMTP id r1so1390878vsi.12;
        Thu, 22 Oct 2020 11:04:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F2WaCG/dYdFJ11nkOsm0t4JOBwXNWT6cncqbDXaSdgI=;
        b=tLzPA6zAzAbCaU3e+VV/LqzDvLfhVgb+Lru781OjLVLVTeBwr9TmTrtxCn9n8P4551
         2KgR5enYJV1wcHRnUGrHHKEeCc8PdfJNKBpbipNjqH7J06l3z6dK/hc4UYaoonSgzHUB
         yrzOixHbPfPDqnn9xxjLDNNjMlxmqfkY49RSEAtovev1xdaDS0uCBlV7MimSqm5SvzLo
         uFPzTlxODqeVMrfoEWTvfNeAnvPJC9QK2Uc6qJ5bWdYuiDjwqkeHjNX1bUc1bIotFnl0
         oBSeveftk7QLNhcPR3UiJYH4kZkxqQONb5SVDIL22aL9qEmD7LA4cds0ymbE2UKcSvsq
         G4iw==
X-Gm-Message-State: AOAM533/3ZeHlHH9Ea0JiiNjwnU/dwgfd5DqHQIMBsH1BUG7ktEuLEoL
        Sd94LlaiEr0csf0OkTFRsZwSDWhp4ZYW9b5lPOk=
X-Google-Smtp-Source: ABdhPJz/FfN9kqeD9Yru3eUPJX0l1B8dOWo9/182fA56Mbh5zE4f9yy6Wa4Th9GlE+1q8+8c9jkPhsldcPjshjYo1kI=
X-Received: by 2002:a67:f3c3:: with SMTP id j3mr2962798vsn.52.1603389896042;
 Thu, 22 Oct 2020 11:04:56 -0700 (PDT)
MIME-Version: 1.0
References: <20201022165450.682571-1-lyude@redhat.com>
In-Reply-To: <20201022165450.682571-1-lyude@redhat.com>
From:   Ilia Mirkin <imirkin@alum.mit.edu>
Date:   Thu, 22 Oct 2020 14:04:45 -0400
Message-ID: <CAKb7UvhfWA6ijoQnq2Mvrx8jfn57EC-P5KBkYR3HmrBUrntJhg@mail.gmail.com>
Subject: Re: [PATCH] drm/edid: Fix uninitialized variable in drm_cvt_modes()
To:     Lyude Paul <lyude@redhat.com>
Cc:     dri-devel <dri-devel@lists.freedesktop.org>,
        Leon Romanovsky <leon@kernel.org>,
        David Airlie <airlied@linux.ie>, Chao Yu <chao@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "# 3.9+" <stable@vger.kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 22, 2020 at 12:55 PM Lyude Paul <lyude@redhat.com> wrote:
>
> Noticed this when trying to compile with -Wall on a kernel fork. We potentially
> don't set width here, which causes the compiler to complain about width
> potentially being uninitialized in drm_cvt_modes(). So, let's fix that.
>
> Signed-off-by: Lyude Paul <lyude@redhat.com>
>
> Cc: <stable@vger.kernel.org> # v5.9+
> Fixes: 3f649ab728cd ("treewide: Remove uninitialized_var() usage")
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> ---
>  drivers/gpu/drm/drm_edid.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
> index 631125b46e04..2da158ffed8e 100644
> --- a/drivers/gpu/drm/drm_edid.c
> +++ b/drivers/gpu/drm/drm_edid.c
> @@ -3094,6 +3094,7 @@ static int drm_cvt_modes(struct drm_connector *connector,
>
>         for (i = 0; i < 4; i++) {
>                 int width, height;
> +               u8 cvt_aspect_ratio;
>
>                 cvt = &(timing->data.other_data.data.cvt[i]);
>
> @@ -3101,7 +3102,8 @@ static int drm_cvt_modes(struct drm_connector *connector,
>                         continue;
>
>                 height = (cvt->code[0] + ((cvt->code[1] & 0xf0) << 4) + 1) * 2;
> -               switch (cvt->code[1] & 0x0c) {
> +               cvt_aspect_ratio = cvt->code[1] & 0x0c;
> +               switch (cvt_aspect_ratio) {
>                 case 0x00:
>                         width = height * 4 / 3;
>                         break;
> @@ -3114,6 +3116,10 @@ static int drm_cvt_modes(struct drm_connector *connector,
>                 case 0x0c:
>                         width = height * 15 / 9;
>                         break;
> +               default:

What value would cvt->code[1] have such that this gets hit?

Or is this a "compiler is broken, so let's add more code" situation?
If so, perhaps the code added could just be enough to silence the
compiler (unreachable, etc)?

  -ilia
