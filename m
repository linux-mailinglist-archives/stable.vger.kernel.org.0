Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5305B6D5F
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 14:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbiIMMgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 08:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbiIMMgf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 08:36:35 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960D529CA2
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 05:36:34 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id l14so27165043eja.7
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 05:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=sbb0BJfxSJ0bvHV5wkGwxNNxQE++mNh72PtFxZYdbyw=;
        b=fKbUU7RNxlQl+VA9rK9x6fuo4I5OHpjbBX6iooSmH8j2dhxcAOmNSE8zqOmavODS+m
         LuxcXt3P9JkKEwEVC1MiOt78KIlqAKdBtMugt8WZ8+Zhu/nr/u+MJoeUAV0iQdju4EET
         zR91JVo8I8Tz+zapJ5jTBrH5mexNnTqVyfEsY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=sbb0BJfxSJ0bvHV5wkGwxNNxQE++mNh72PtFxZYdbyw=;
        b=ZQNWdbjpxJ4oOp/aGf0d9tfZ5B1GtDBzncGoaJOjDBTNPJtyqewjewBAronXu9VOpE
         thjRd8tXVd/gxBrTYdNKdQXK1d8qHa88Dpkn5+8i3AWJOP5kTJZ1TZGkebbK+zjhGKb8
         +iTEyMi1JlSaazd1JTKqIHX0oTHsqmsMB+4TZ98mBnPZ8dIP9NLHbYbZdwU9nlyzxBMC
         Yq9cFK4eZTgS/Wyt/1UAblzR/9lOgeZkrsxQeH4pKt5mMNwTk6Trt1d6TPx768oacifP
         Rhr3HPOHQj5nJM3cDHR1V9g/WgSUEqNZyAmOBKUg0xQmH0Rg7Z9VAHjMpmxYN+V5Z0bq
         kXuQ==
X-Gm-Message-State: ACgBeo0Te0mzgfNgDAntK+c7G9kUkAoJUQ+ku2hl3gOxEmQP5rixu55n
        aqqYiZW6LGHdttIfPqRbaYGa1vtNzaqxDG0Y6ZM=
X-Google-Smtp-Source: AA6agR6D+s0NIanlv6e7Q/+KmAtFbOUHmnUcD2bzMoxwsVS5M9WAITwJln99zRX3iXAE7Jh1SuaDAg==
X-Received: by 2002:a17:907:74a:b0:77e:9455:b4e3 with SMTP id xc10-20020a170907074a00b0077e9455b4e3mr5424485ejb.471.1663072592948;
        Tue, 13 Sep 2022 05:36:32 -0700 (PDT)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com. [209.85.128.45])
        by smtp.gmail.com with ESMTPSA id r18-20020a1709061bb200b0076ff600bf2csm6030242ejg.63.2022.09.13.05.36.32
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Sep 2022 05:36:32 -0700 (PDT)
Received: by mail-wm1-f45.google.com with SMTP id bd26-20020a05600c1f1a00b003a5e82a6474so9395043wmb.4
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 05:36:32 -0700 (PDT)
X-Received: by 2002:a05:600c:4e8b:b0:3a5:f5bf:9c5a with SMTP id
 f11-20020a05600c4e8b00b003a5f5bf9c5amr2359963wmq.85.1663072581167; Tue, 13
 Sep 2022 05:36:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220913085320.8577-1-johan+linaro@kernel.org> <20220913085320.8577-7-johan+linaro@kernel.org>
In-Reply-To: <20220913085320.8577-7-johan+linaro@kernel.org>
From:   Doug Anderson <dianders@chromium.org>
Date:   Tue, 13 Sep 2022 13:36:09 +0100
X-Gmail-Original-Message-ID: <CAD=FV=XXCOgRwdsHxnH5DhoNb5QAT6n9m8iUNOQ5at4YAKd-cw@mail.gmail.com>
Message-ID: <CAD=FV=XXCOgRwdsHxnH5DhoNb5QAT6n9m8iUNOQ5at4YAKd-cw@mail.gmail.com>
Subject: Re: [PATCH v2 06/10] drm/msm/dp: fix aux-bus EP lifetime
To:     Johan Hovold <johan+linaro@kernel.org>
Cc:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@gmail.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Robert Foss <robert.foss@linaro.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, Sean Paul <sean@poorly.run>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Kuogee Hsieh <quic_khsieh@quicinc.com>,
        Steev Klimaszewski <steev@kali.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        freedreno <freedreno@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Tue, Sep 13, 2022 at 9:58 AM Johan Hovold <johan+linaro@kernel.org> wrote:
>
> Device-managed resources allocated post component bind must be tied to
> the lifetime of the aggregate DRM device or they will not necessarily be
> released when binding of the aggregate device is deferred.
>
> This can lead resource leaks or failure to bind the aggregate device
> when binding is later retried and a second attempt to allocate the
> resources is made.
>
> For the DP aux-bus, an attempt to populate the bus a second time will
> simply fail ("DP AUX EP device already populated").
>
> Fix this by tying the lifetime of the EP device to the DRM device rather
> than DP controller platform device.
>
> Fixes: c3bf8e21b38a ("drm/msm/dp: Add eDP support via aux_bus")
> Cc: stable@vger.kernel.org      # 5.19
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
>  drivers/gpu/drm/msm/dp/dp_display.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)

This seems fine to me as a short term fix until we get the DP AUX
populating moved to probe.

Reviewed-by: Douglas Anderson <dianders@chromium.org>
