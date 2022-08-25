Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3E75A1C28
	for <lists+stable@lfdr.de>; Fri, 26 Aug 2022 00:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244359AbiHYWVE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 18:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244332AbiHYWVC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 18:21:02 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7009DC5787
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 15:21:00 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-31f445bd486so576738017b3.13
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 15:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=YLpy2xCVK51CZcFB6zrbiai4Ndy7eOAyjwmsLFCvyjU=;
        b=RuNF59UtgFixO6ATvPnw/me6kowb8cK+ihIPiN9YGvyGWowPWv82QGFElwUvI5+DKh
         4bM5mWzcBhtKOSRx+2dmqP7D/25ANqTEvkNgxLoZ03wM+hqSBilKjjVQnTGCMzQRJvrf
         7OmD4R3ZcaS+JouPbNz1nqMeUivjrGYpAJO8ghMB+GXoorGZxcOVY6c5N0xxdBtmHwFb
         rHW5lKM/+QFvdViqOupzGWdox6T1quWhzvQDszZN+5ppKABtqYAVc6ogO2655g3uO5Un
         hCeyKkvFIbcG4AOPpY0aWraEDTbF1LJtJDlAcDlsGMIQ8GNjJyqD7u1NEhxtgTZWs3Mh
         zQWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=YLpy2xCVK51CZcFB6zrbiai4Ndy7eOAyjwmsLFCvyjU=;
        b=xuiIOJFDkPmrGzOHNuZwivNms8U9RsH4aFfdaSRrAcY/m+H3Ck5IhEaPWoizurl8k7
         HwPSabnC3TNKlw3/p2cd7jpHLqnd3ZLv45tCQxrFUhAnHSCIjyYgnYjIEgZQ47g3KYRs
         cTtyAabMvwN/eCMLGRAL/UW6PBZP9l2A7z0K8LXbOD+G1KIizOBFiuh0ZwqxQ/YfJMAl
         RA/BnYHKTxOFi/DKK3+M6oM+qAizl1RqqVk9PdW1N3MBeqTqnSKUwmFaV9KPdyxzBa/4
         W0BrhvHIxZ2blvhutgqmUwMmV7Zog3QZ8hyK00vK1LR85INg3jZF8lXOUmC00uU1vz9A
         inwA==
X-Gm-Message-State: ACgBeo33r4wmw3HS52ZnxbOntiXYs683Ne9QBZsS6ySfyvv842SlOJLg
        uqzsFn7hs3hwJOnT3QHHo0oHbzpY8IM1MMu2yLTqGg==
X-Google-Smtp-Source: AA6agR5WDTHEn0f5fI43Fn0xyIo60iYiherkxssOJTh4YNKt09fcyH+CjvifzWu3aG86BQ/39tXWDS0RiuFFuEIyC9g=
X-Received: by 2002:a25:bd4d:0:b0:696:489a:3a86 with SMTP id
 p13-20020a25bd4d000000b00696489a3a86mr3142761ybm.447.1661466059351; Thu, 25
 Aug 2022 15:20:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220817184026.3468620-1-isaacmanjarres@google.com>
In-Reply-To: <20220817184026.3468620-1-isaacmanjarres@google.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 25 Aug 2022 15:20:23 -0700
Message-ID: <CAGETcx9U_tKjnQnymNussM+Qm8vJ_vYpPp_QHY3NDkW7BBuVag@mail.gmail.com>
Subject: Re: [PATCH v3] driver core: Don't probe devices after
 bus_type.match() probe deferral
To:     "Isaac J. Manjarres" <isaacmanjarres@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        kernel-team@android.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 17, 2022 at 11:40 AM Isaac J. Manjarres
<isaacmanjarres@google.com> wrote:
>
> Both __device_attach_driver() and __driver_attach() check the return
> code of the bus_type.match() function to see if the device needs to be
> added to the deferred probe list. After adding the device to the list,
> the logic attempts to bind the device to the driver anyway, as if the
> device had matched with the driver, which is not correct.
>
> If __device_attach_driver() detects that the device in question is not
> ready to match with a driver on the bus, then it doesn't make sense for
> the device to attempt to bind with the current driver or continue
> attempting to match with any of the other drivers on the bus. So, update
> the logic in __device_attach_driver() to reflect this.
>
> If __driver_attach() detects that a driver tried to match with a device
> that is not ready to match yet, then the driver should not attempt to bind
> with the device. However, the driver can still attempt to match and bind
> with other devices on the bus, as drivers can be bound to multiple
> devices. So, update the logic in __driver_attach() to reflect this.
>
> Cc: stable@vger.kernel.org
> Cc: Saravana Kannan <saravanak@google.com>
> Fixes: 656b8035b0ee ("ARM: 8524/1: driver cohandle -EPROBE_DEFER from bus_type.match()")
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> Reviewed-by: Saravana Kannan <saravanak@google.com>
> ---
>  drivers/base/dd.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> v1 -> v2:
> - Fixed the logic in __driver_attach() to allow a driver to continue
>   attempting to match and bind with devices in case of any error, not
>   just probe deferral.
>
> v2 -> v3:
> - Restored the patch back to v1.
> - Added Guenter's Tested-by tag.
> - Added Saravana's Reviewed-by tag.
> - Cc'd stable@vger.kernel.org
>
> Greg,
>
> This is the final version of this patch. Can you please pick this up?
>
> Thanks,
> Isaac
>
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 70f79fc71539..90b31fb141a5 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -881,6 +881,11 @@ static int __device_attach_driver(struct device_driver *drv, void *_data)
>                 dev_dbg(dev, "Device match requests probe deferral\n");
>                 dev->can_match = true;
>                 driver_deferred_probe_add(dev);
> +               /*
> +                * Device can't match with a driver right now, so don't attempt
> +                * to match or bind with other drivers on the bus.
> +                */
> +               return ret;
>         } else if (ret < 0) {
>                 dev_dbg(dev, "Bus failed to match device: %d\n", ret);
>                 return ret;
> @@ -1120,6 +1125,11 @@ static int __driver_attach(struct device *dev, void *data)
>                 dev_dbg(dev, "Device match requests probe deferral\n");
>                 dev->can_match = true;
>                 driver_deferred_probe_add(dev);
> +               /*
> +                * Driver could not match with device, but may match with
> +                * another device on the bus.
> +                */
> +               return 0;
>         } else if (ret < 0) {
>                 dev_dbg(dev, "Bus failed to match device: %d\n", ret);
>                 return ret;
> --
> 2.37.1.595.g718a3a8f04-goog
>

Greg,

Can you pull this in for 6.0-rcX please? This is fixing a long
standing bug that was exposed by my amba code cleanup.

-Saravana
