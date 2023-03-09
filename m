Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8EC36B2FBF
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 22:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbjCIVlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 16:41:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjCIVlb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 16:41:31 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70AA2F865E;
        Thu,  9 Mar 2023 13:41:30 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id x3so12653473edb.10;
        Thu, 09 Mar 2023 13:41:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1678398089;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AR1b3GABOQLV0P4AFqJgRYAPV/jd6YPCXWJ10JJ7GQA=;
        b=bVV9zB4PWz/GixwLQd9wj07swwOT/5L8l7AYGlJV39XCgfm5cBj2R76j8n/krnPBNF
         e6HICDvbiaQ1x+XAwjDG08vSRQer/+wTj3q6MkzNMSS3saTFHaS1S2G6cRX2Utbv2eTh
         tWb/JB6UcF+rBSP568bMYcbPnQ2dtX4rPGjdmatlyv7z3GqmrqLzsZq1x3SirUPCsaHu
         LnmAjGvKRmkVtoqaSL09XqXrDe58MJ1OEVF6In8g1AEIakrXwIsRWGh7HbBFoPpaCO4W
         c/kYP+I4vqJB6PSZdBea/WNQx9UYjXpcAk2AfzMmwcdOGOGificFynYzuK2ISXl506in
         VU2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678398089;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AR1b3GABOQLV0P4AFqJgRYAPV/jd6YPCXWJ10JJ7GQA=;
        b=CJGXnowa2LD3G+VU8YEnivLx482evwBa2s8h8CdvMcizA+ghKjp8+zYThGkjF3rXYp
         6jtejzQ5abq6EIW0JmzQvAN9xX0vR4LcPRON+DOmvlPQtWHx8N1jgnbdguf/XGL8z8Pg
         LkMpV2erV/Wh+1dzQL5ZeVTfSj/tlIR/i/22hTNL2/5BLyypZgwYt7tarGyOZKUjh+Rh
         g6CE/EadqNt+93jC0II+FAAMHOjP2MIehiUoUlUPe52qYbOaKpMZpUqI9KH5W+ML16D5
         nugd57XGd4nvXaRuYrGIE7vkFWvSDqEk9C2p/ajAgNt6YFEylCeUxbZNXgeruYrgswsI
         kGCA==
X-Gm-Message-State: AO0yUKUlxZGNgl7QF/iD/qpfXHk2sTQhmsih8UROTDqntlHCmxNMF/8t
        USl4MgsADbtW9nMrHFvBstqRURUysrNXRMOZKMw=
X-Google-Smtp-Source: AK7set+iplnwVXlr7+v6coCIsyOhlACFhoeoFarKEw4JA1Y6NwVDADLB4DScaPTQyE9qNP613oIHrbUsSOajkyzvD+I=
X-Received: by 2002:a17:906:ce38:b0:8b1:30da:b585 with SMTP id
 sd24-20020a170906ce3800b008b130dab585mr12117490ejb.6.1678398088913; Thu, 09
 Mar 2023 13:41:28 -0800 (PST)
MIME-Version: 1.0
References: <20230306103533.4915-1-johan+linaro@kernel.org>
In-Reply-To: <20230306103533.4915-1-johan+linaro@kernel.org>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Thu, 9 Mar 2023 22:41:18 +0100
Message-ID: <CAFBinCBsC+P=zvh6RF3UKiPnferUYU0QZvZfnn1oS5xWX-65Jw@mail.gmail.com>
Subject: Re: [PATCH] drm/meson: fix missing component unbind on bind errors
To:     Johan Hovold <johan+linaro@kernel.org>,
        Neil Armstrong <neil.armstrong@linaro.org>
Cc:     David Airlie <airlied@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        dri-devel@lists.freedesktop.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Johan,

thanks for your patch!

On Mon, Mar 6, 2023 at 11:35=E2=80=AFAM Johan Hovold <johan+linaro@kernel.o=
rg> wrote:
[...]
> @@ -325,23 +325,23 @@ static int meson_drv_bind_master(struct device *dev=
, bool has_components)
>
>         ret =3D meson_encoder_hdmi_init(priv);
I'm wondering if component_bind_all() can be moved further down.
Right now it's between meson_encoder_cvbs_init() and
meson_encoder_hdmi_init(). So it seems that encoders don't rely on
component registration.

Unfortunately I am also not familiar with this and I'm hoping that
Neil can comment on this.


Best regards,
Martin
