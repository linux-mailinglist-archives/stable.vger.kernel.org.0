Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 184A22E3D14
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439036AbgL1OKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:10:52 -0500
Received: from mail-vs1-f53.google.com ([209.85.217.53]:40502 "EHLO
        mail-vs1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439140AbgL1OKw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 09:10:52 -0500
Received: by mail-vs1-f53.google.com with SMTP id x4so5565613vsp.7;
        Mon, 28 Dec 2020 06:10:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kVDVcWWL6BrKWAViQNJ51zoi/mT+OBUb6BuJEL+vMoo=;
        b=pE4CTaRrZYjFplGHrWnQdEsl68KB7lK0M4s8XWTiGRuYAT6sW+RzYZQdLZJAcO4zu+
         pqn/oaceomlj59wTB7ZB4PPOgVVknq3jp4LBSfUbTaZO3rXHcxVw7Ab2pc1MpkjsgBmZ
         bxGlyauAfTRm2gk6n7p/2ohOJmweAjZm3aDRUv5IA4zbS4gnYiWKcwcrS7UeASihKPsn
         8PUVKsu+HTd9Ac58qS0Q0y5X+EeEVqR3ZWMkXzkaJxCeE5RFqHyVttQAYU+bKS2uIjnW
         h8Uk44fSw4EfkC/aJifP3aVn3vLevRw5ghdGJOEjwK4fznZrhm+/uBXb0idDBeM80Lb0
         6KYA==
X-Gm-Message-State: AOAM5330QSiltI+gY6MW3N+embluiTwUXfYi8Tr1C8bMfEEGts/VodDT
        sdEVeQV4ztt3hGPNkfP8oz2ZR2Xj+wwTGRt8kiOWlCjItTg=
X-Google-Smtp-Source: ABdhPJyMFLLyG19RShLswn1DSR8JZ58ywdALLa9LeyQVLy11CNG6bQXE6EcX/vDssohktYYfTRnABoFmZNKkk1D0UR4=
X-Received: by 2002:a67:f601:: with SMTP id k1mr28677791vso.46.1609164610688;
 Mon, 28 Dec 2020 06:10:10 -0800 (PST)
MIME-Version: 1.0
References: <20201228125020.963311703@linuxfoundation.org> <20201228125024.061845231@linuxfoundation.org>
In-Reply-To: <20201228125024.061845231@linuxfoundation.org>
From:   Ilia Mirkin <imirkin@alum.mit.edu>
Date:   Mon, 28 Dec 2020 09:09:59 -0500
Message-ID: <CAKb7UvhvjW+q+FXKoNaWUYm1QqzZ_o6FNjJQbwBJ+Lo9ybBcKQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 064/717] drm/edid: Fix uninitialized variable in drm_cvt_modes()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "# 3.9+" <stable@vger.kernel.org>, Lyude Paul <lyude@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Linus had to apply a fixup for this patch. Please ensure that it's in
your patch list:

commit d652d5f1eeeb06046009f4fcb9b4542249526916
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Dec 17 09:27:57 2020 -0800

    drm/edid: fix objtool warning in drm_cvt_modes()

It does not appear to have a Fixes tag, so may not have been picked up
by your automated tooling.

Cheers,

  -ilia

On Mon, Dec 28, 2020 at 9:01 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Lyude Paul <lyude@redhat.com>
>
> [ Upstream commit 991fcb77f490390bcad89fa67d95763c58cdc04c ]
>
> Noticed this when trying to compile with -Wall on a kernel fork. We
> potentially don't set width here, which causes the compiler to complain
> about width potentially being uninitialized in drm_cvt_modes(). So, let's
> fix that.
>
> Changes since v1:
> * Don't emit an error as this code isn't reachable, just mark it as such
> Changes since v2:
> * Remove now unused variable
>
> Fixes: 3f649ab728cd ("treewide: Remove uninitialized_var() usage")
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Reviewed-by: Ilia Mirkin <imirkin@alum.mit.edu>
> Link: https://patchwork.freedesktop.org/patch/msgid/20201105235703.1328115-1-lyude@redhat.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/drm_edid.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
> index 631125b46e04c..b84efd538a702 100644
> --- a/drivers/gpu/drm/drm_edid.c
> +++ b/drivers/gpu/drm/drm_edid.c
> @@ -3114,6 +3114,8 @@ static int drm_cvt_modes(struct drm_connector *connector,
>                 case 0x0c:
>                         width = height * 15 / 9;
>                         break;
> +               default:
> +                       unreachable();
>                 }
>
>                 for (j = 1; j < 5; j++) {
> --
> 2.27.0
>
>
>
