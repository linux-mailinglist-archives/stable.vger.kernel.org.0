Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7207E2A5A06
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730310AbgKCWV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 17:21:56 -0500
Received: from mail-vs1-f65.google.com ([209.85.217.65]:39252 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730264AbgKCWV4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 17:21:56 -0500
Received: by mail-vs1-f65.google.com with SMTP id y78so10376248vsy.6;
        Tue, 03 Nov 2020 14:21:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ystGsVRRSLNIp7DU6AxtzDMYZFgSTFYVKgOF4oPJhUs=;
        b=Ioj5MN+NTJ/3Qed/d3naiDBpcBe6jjwHMescqsZj5cMiNEIaX2LTlmSgu6G9t4CMhw
         wMwIFKrp1XD9pl3efnWb40Yu5GMg5XiWyVyxfSHz1CE3TKR0kLT5BbfSWx3BuHg3/Nmh
         XQI/lTuwIMtL/JhQfaK7IWCCyubWee5pfws6E+Ugh+xEDeQBmZgZN8q2vy3eGdfCddOS
         TTQtVqltKA1can/GT5/UPSdB5ACp9Gsv/INP9u6hE1VlxznBdmP+a1hcxq1zm+D9YPcr
         sMUWrpG9bHWCwpkIs3op5xvP7sx5q3MM19gSTxmF9GEDYQq8WTLkc6RowJqBnfk/j1gg
         X3bw==
X-Gm-Message-State: AOAM530+7woV6LHL0uOwctXH9kfFmJtVYI6NSkOHHV5zid47ByUM5VVL
        iSEpCjqNZZ6lBJCe9IBixpBMZwUpqqeGIldxXHY=
X-Google-Smtp-Source: ABdhPJx+6wzHKdabHgncagBkljWabHvhFprI3xGnbyk5I/SRAbasPwnXsBl4ELjrlBl2/q+vZ8AkpOF/VPVeRiX/WEE=
X-Received: by 2002:a67:2883:: with SMTP id o125mr20678367vso.46.1604442114870;
 Tue, 03 Nov 2020 14:21:54 -0800 (PST)
MIME-Version: 1.0
References: <20201103221510.575827-1-lyude@redhat.com>
In-Reply-To: <20201103221510.575827-1-lyude@redhat.com>
From:   Ilia Mirkin <imirkin@alum.mit.edu>
Date:   Tue, 3 Nov 2020 17:21:43 -0500
Message-ID: <CAKb7Uvhr8Cvd+kfw0Rcee-Nrtdg9y3JhGPeNsJjVEDcWXnVxxw@mail.gmail.com>
Subject: Re: [PATCH v2] drm/edid: Fix uninitialized variable in drm_cvt_modes()
To:     Lyude Paul <lyude@redhat.com>
Cc:     dri-devel <dri-devel@lists.freedesktop.org>,
        "# 3.9+" <stable@vger.kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Kees Cook <keescook@chromium.org>,
        Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Chao Yu <chao@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 3, 2020 at 5:15 PM Lyude Paul <lyude@redhat.com> wrote:
>
> Noticed this when trying to compile with -Wall on a kernel fork. We potentially
> don't set width here, which causes the compiler to complain about width
> potentially being uninitialized in drm_cvt_modes(). So, let's fix that.
>
> Changes since v1:
> * Don't emit an error as this code isn't reachable, just mark it as such
>
> Signed-off-by: Lyude Paul <lyude@redhat.com>
>
> Cc: <stable@vger.kernel.org> # v5.9+
> Fixes: 3f649ab728cd ("treewide: Remove uninitialized_var() usage")
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> ---
>  drivers/gpu/drm/drm_edid.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
> index 631125b46e04..0643b98c6383 100644
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

The temp var doesn't do anything now right? Previously you were using
it in the print, but now you can drop these two hunks, I think?

  -ilia

> +               switch (cvt_aspect_ratio) {
>                 case 0x00:
>                         width = height * 4 / 3;
>                         break;
> @@ -3114,6 +3116,8 @@ static int drm_cvt_modes(struct drm_connector *connector,
>                 case 0x0c:
>                         width = height * 15 / 9;
>                         break;
> +               default:
> +                       unreachable();
>                 }
>
>                 for (j = 1; j < 5; j++) {
> --
> 2.28.0
>
