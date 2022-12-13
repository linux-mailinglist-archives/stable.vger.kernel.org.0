Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB7964BA23
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 17:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236105AbiLMQrp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 11:47:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235817AbiLMQrd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 11:47:33 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE3E360C5
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 08:47:32 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id s186so322564oia.5
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 08:47:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qSpFPtYtqwbwgpaDfxY9bLElKawGst3mkzumQCRtMZA=;
        b=wIx4THjTYQlEWvPxkWO+P3LDsGYG4ruw+vvWGQUALXmocOx0dFmaxHmpWsSyhfqF4j
         BLUoMsmXXhxOHM3/EKYxEHMN1VS6IZbZDejmkxkWCI29/Xn+2Jvt+00oJVrYzP0jXqQY
         If+RdOBdAfIiRqQyOZVPwBe9ucM7lkUBxrFQqNZi8Y6fxyOsp5LSg5rIxecI0hDNWVzX
         xjWcfbo2stwN3mao7J0SZCmpEUsBpbs1IJ9M8E+dru5YbIxa9KXFZySmG4STMiis30UV
         UvGT15tzZmbmecAMOGfyM9Bfsh488bKi/MgcdjAEqX5lqpPl8UlLeBNfUkKn9qj4Wde8
         50aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qSpFPtYtqwbwgpaDfxY9bLElKawGst3mkzumQCRtMZA=;
        b=k3RvlVI7FiOAkK9Jr+xg/4IRfZaUgY7ULBU5JUv5nWTel48hwWleIvdEANXEeVyR7X
         83s0bxmzIjIcsNfanDbZVMUyWgeHDLxpZUCAbWTaeMsco2tUlQCYAGLVdRbq1uqYRhlJ
         8bNWsE+2gvXigXu4P9gDcQspeStQ3ACEXEg+nZkNWcooomQsuKeFT7bkWvOz5jIwUbmD
         LPqvKMtC7da3a2Wr0EgrsOiTmOB+PVgKkuyv7fePtsJLZT4jy2G44MtOwmQ+sytk7Qdz
         rzP62Zs6jWLya/YqT+4RrUhYlMuleQSyLSQd/9w/iSRit6epApL9u1r2nkmWBdfxhNdf
         mSfA==
X-Gm-Message-State: ANoB5pm5DZiVpmhbFAaaumJhcIhtRcLJmzN+At44yJfPJpuiJI3jKnY0
        enO5NX1/PtJ++FbikGbV9oTiZUOPo7QEZBU50B3JWQ==
X-Google-Smtp-Source: AA0mqf6jtP/Q7Vai7aVv/JUuh7ElYcHVEWWCl+v9EAaFTC3NMUdDiFEkCdNpneIMvVEwl8DQasl6+DXuTdTgKXwAvIc=
X-Received: by 2002:a54:4018:0:b0:35c:3e72:94b7 with SMTP id
 x24-20020a544018000000b0035c3e7294b7mr259644oie.67.1670950052019; Tue, 13 Dec
 2022 08:47:32 -0800 (PST)
MIME-Version: 1.0
References: <20221213150304.4189760-1-robert.foss@linaro.org>
In-Reply-To: <20221213150304.4189760-1-robert.foss@linaro.org>
From:   Amit Pundir <amit.pundir@linaro.org>
Date:   Tue, 13 Dec 2022 22:16:55 +0530
Message-ID: <CAMi1Hd1Ei5SbT8DHacFq6sJXCsjWdeY3OyeE_RnWnkxNp6i9Qw@mail.gmail.com>
Subject: Re: [PATCH v1] drm/bridge: lt9611: Fix PLL being unable to lock
To:     Robert Foss <robert.foss@linaro.org>
Cc:     stable <stable@vger.kernel.org>, andrzej.hajda@intel.com,
        neil.armstrong@linaro.org, Laurent.pinchart@ideasonboard.com,
        jonas@kwiboo.se, jernej.skrabec@gmail.com, airlied@gmail.com,
        daniel@ffwll.ch, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 13 Dec 2022 at 20:33, Robert Foss <robert.foss@linaro.org> wrote:
>
> This fixes PLL being unable to lock, and is derived from an equivalent
> downstream commit.
>
> Available LT9611 documentation does not list this register, neither does
> LT9611UXC (which is a different chip).
>
> This commit has been confirmed to fix HDMI output on DragonBoard 845c.
>

Cc: <stable@vger.kernel.org>    [v5.10+]
Reviewed-by: Amit Pundir <amit.pundir@linaro.org>

> Suggested-by: Amit Pundir <amit.pundir@linaro.org>
> Signed-off-by: Robert Foss <robert.foss@linaro.org>
> ---
>  drivers/gpu/drm/bridge/lontium-lt9611.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/gpu/drm/bridge/lontium-lt9611.c b/drivers/gpu/drm/bridge/lontium-lt9611.c
> index ffcdc8dba3798..3ce4e495aee50 100644
> --- a/drivers/gpu/drm/bridge/lontium-lt9611.c
> +++ b/drivers/gpu/drm/bridge/lontium-lt9611.c
> @@ -259,6 +259,7 @@ static int lt9611_pll_setup(struct lt9611 *lt9611, const struct drm_display_mode
>                 { 0x8126, 0x55 },
>                 { 0x8127, 0x66 },
>                 { 0x8128, 0x88 },
> +               { 0x812a, 0x20 },
>         };
>
>         regmap_multi_reg_write(lt9611->regmap, reg_cfg, ARRAY_SIZE(reg_cfg));
> --
> 2.34.1
>
