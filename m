Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC6C82A8B13
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 01:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730895AbgKFADR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 19:03:17 -0500
Received: from mail-vs1-f68.google.com ([209.85.217.68]:45805 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729784AbgKFADR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 19:03:17 -0500
Received: by mail-vs1-f68.google.com with SMTP id x11so1775677vsx.12;
        Thu, 05 Nov 2020 16:03:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/n5bGNWUgGwgtLJXyhksEsov5olwu/i3xw5cfFWm5Bw=;
        b=hq7vtnjDxqxry0VN884DF0K4q7MWGWCG9nxQgmGyjeVMAAtkogXYgJ9A5iezsF4u0J
         ZYIvdAnl9uibr088niIX7tWu6uwQmMgv3paDU/egNkP+6vyDSf6dEimoCGijI3BGXwv+
         nHqZNNJoIr9VTVL5g5McZxHTLTsKJ14nvAF9dy2MLVI+lsY5UdW03MET5x1PazXjCWGL
         9DRN2m7ezTc5AVmcXasxJXgrvE52fjbMQ6Gn/DtnysATTvUj9virfuoQTeoLEja4jYLP
         jhG5S44uLJEVNh6Cc2APceOVasQap2qk89g65AGNKKNQ3VEm1RKdWW4H1rTVHYJJoSCS
         HXHQ==
X-Gm-Message-State: AOAM530r7sri1LqauHRrmBev0CoKFjKgC5WVTjS7Xyoi2bnH9jIcRt84
        yURt4cu/Ba4+Sp27todiFNfAPVJErsZ/sjCuofM=
X-Google-Smtp-Source: ABdhPJxeu1wo+9SUw0cGWms8KkbE4h/4REgitgjq3ayBlwXKEc28MRmRP4pkpI7tt60lqqTAS22g3EG4J7GdRBbsjlI=
X-Received: by 2002:a67:f699:: with SMTP id n25mr3266271vso.52.1604620994955;
 Thu, 05 Nov 2020 16:03:14 -0800 (PST)
MIME-Version: 1.0
References: <20201105235703.1328115-1-lyude@redhat.com>
In-Reply-To: <20201105235703.1328115-1-lyude@redhat.com>
From:   Ilia Mirkin <imirkin@alum.mit.edu>
Date:   Thu, 5 Nov 2020 19:03:03 -0500
Message-ID: <CAKb7Uvi3xr9GbuNbyQLtow5THAh25jw0CGUVLmJUtdEnfYUgYg@mail.gmail.com>
Subject: Re: [PATCH v3] drm/edid: Fix uninitialized variable in drm_cvt_modes()
To:     Lyude Paul <lyude@redhat.com>
Cc:     dri-devel <dri-devel@lists.freedesktop.org>,
        "# 3.9+" <stable@vger.kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kalle Valo <kvalo@codeaurora.org>,
        Kees Cook <keescook@chromium.org>, Chao Yu <chao@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 5, 2020 at 6:57 PM Lyude Paul <lyude@redhat.com> wrote:
>
> Noticed this when trying to compile with -Wall on a kernel fork. We potentially
> don't set width here, which causes the compiler to complain about width
> potentially being uninitialized in drm_cvt_modes(). So, let's fix that.
>
> Changes since v1:
> * Don't emit an error as this code isn't reachable, just mark it as such
> Changes since v2:
> * Remove now unused variable
>
> Signed-off-by: Lyude Paul <lyude@redhat.com>
>
> Cc: <stable@vger.kernel.org> # v5.9+
> Fixes: 3f649ab728cd ("treewide: Remove uninitialized_var() usage")
> Signed-off-by: Lyude Paul <lyude@redhat.com>

For the very little it's worth,

Reviewed-by: Ilia Mirkin <imirkin@alum.mit.edu>

> ---
>  drivers/gpu/drm/drm_edid.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
> index 631125b46e04..b84efd538a70 100644
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
> 2.28.0
>
