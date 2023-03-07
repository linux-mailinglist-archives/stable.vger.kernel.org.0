Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87E406AF555
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbjCGTYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:24:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbjCGTYA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:24:00 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3B2515FD
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:09:38 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id bn17so8217643pgb.10
        for <stable@vger.kernel.org>; Tue, 07 Mar 2023 11:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678216178;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XRRXK53jDGzKbqJ6qVuf5oPuz3OEKiwRmxooP50BqwU=;
        b=C95LyP/OCNgLMK2gkpE2Tq+GV5LS0ZzrUM5vHN14SSaIVFPDJcJDkaY8pmmL5KbLHa
         it523dGKZy/6Of9wX7Sk+aUqLP+9snIAyuvxDxibtDt9DsfMkvo65iNxlbjWpXdr69eD
         PYk1lvGvuNA463TonRhWYlHewtMoHVfJmJXvVqSgezGk4x8+pH2QtydFCYL4sg4N162c
         Fy5q4P2sU2b0pGpBJh3CUw/ekia1AXvns+GJP+WcRX9gqqIu2uB7RMNiIyFLEFNqEQk3
         GfhGyHE77ttvEuzntKC/nn++g5bkRZQ8/Sfj3CvAMyHD3mNxSrYi0kkoz8JT17MgPAuR
         B+BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678216178;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XRRXK53jDGzKbqJ6qVuf5oPuz3OEKiwRmxooP50BqwU=;
        b=YW6fPoANb2EfyJMsWhxoMPY15Ng7i/pLSSwZ81HURMKdAASV6pyKy8g0CiWduQVobv
         +lLdIIArWnHGdZglyKdAKb3fX7Yuxs6cSkq7T3Oj1vbzRaaO0V4plViNZSiO1+889GZV
         QBh1K11RrlvRnTx/arCl/WPF0TlMzqegWYq0EFUKFxjPTK4mLFyVPKf6x1KcgOpiMcGv
         gzMRj/O0IQDac1sKOtOHa7YKRszqxZiDGroxM2cWlnHc6Y2ML0hriAh9S/wieYJ2sKMJ
         iya5dbKBAkRAHhwqt7uEUWDzrdKIJoRbz1VuE8apuYmU11Akae5ABu7IQdrcqPNS2ASp
         e6Jw==
X-Gm-Message-State: AO0yUKVBWtZxihBMOrdQOnno2NzlMavL/eED8Z/3h3lo8q3GBNZhApFl
        Y3K459r4wH/HLxE0eWh3vV9OLy5iEZysBwnKxBSf8Q==
X-Google-Smtp-Source: AK7set/ujLaCC87ejtyPflmPHKLb1GCAa/9hnu7R3JDIfn6UfjhtH1nJ7GYgLehA51r1bZe2ytPOlGk+h6B0nfaflVM=
X-Received: by 2002:a62:8607:0:b0:619:46b3:7903 with SMTP id
 x7-20020a628607000000b0061946b37903mr5181811pfd.3.1678216177661; Tue, 07 Mar
 2023 11:09:37 -0800 (PST)
MIME-Version: 1.0
References: <20230307165905.838066027@linuxfoundation.org> <20230307165920.205338995@linuxfoundation.org>
In-Reply-To: <20230307165920.205338995@linuxfoundation.org>
From:   Saravana Kannan <saravanak@google.com>
Date:   Tue, 7 Mar 2023 11:09:01 -0800
Message-ID: <CAGETcx-sDPx3HySkP-8Rb7TZLZUVP8xTK97Hi2ZJ7PcRva5xkQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 330/567] driver core: fw_devlink: Add DL_FLAG_CYCLE
 support to device links
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Colin Foster <colin.foster@in-advantage.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Douglas Anderson <dianders@chromium.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>,
        Luca Weiss <luca.weiss@fairphone.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 7, 2023 at 11:02=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Saravana Kannan <saravanak@google.com>
>
> [ Upstream commit 67cad5c67019c38126b749621665b6723d3ae7e6 ]
>
> fw_devlink uses DL_FLAG_SYNC_STATE_ONLY device link flag for two
> purposes:
>
> 1. To allow a parent device to proxy its child device's dependency on a
>    supplier so that the supplier doesn't get its sync_state() callback
>    before the child device/consumer can be added and probed. In this
>    usage scenario, we need to ignore cycles for ensure correctness of
>    sync_state() callbacks.
>
> 2. When there are dependency cycles in firmware, we don't know which of
>    those dependencies are valid. So, we have to ignore them all wrt
>    probe ordering while still making sure the sync_state() callbacks
>    come correctly.
>
> However, when detecting dependency cycles, there can be multiple
> dependency cycles between two devices that we need to detect. For
> example:
>
> A -> B -> A and A -> C -> B -> A.
>
> To detect multiple cycles correct, we need to be able to differentiate
> DL_FLAG_SYNC_STATE_ONLY device links used for (1) vs (2) above.
>
> To allow this differentiation, add a DL_FLAG_CYCLE that can be use to
> mark use case (2). We can then use the DL_FLAG_CYCLE to decide which
> DL_FLAG_SYNC_STATE_ONLY device links to follow when looking for
> dependency cycles.
>
> Fixes: 2de9d8e0d2fe ("driver core: fw_devlink: Improve handling of cyclic=
 dependencies")
> Signed-off-by: Saravana Kannan <saravanak@google.com>
> Tested-by: Colin Foster <colin.foster@in-advantage.com>
> Tested-by: Sudeep Holla <sudeep.holla@arm.com>
> Tested-by: Douglas Anderson <dianders@chromium.org>
> Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Tested-by: Luca Weiss <luca.weiss@fairphone.com> # qcom/sm7225-fairphone-=
fp4
> Link: https://lore.kernel.org/r/20230207014207.1678715-6-saravanak@google=
.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

These fw_devlink patches weren't tested with 5.15. It's also an
extensive refactor. So I'm a little worried if it'll be finicky and
break things in a kernel that's a year old.

Unless someone specifically wants these patches in 5.15, I'd prefer we
don't pick it up in 5.15.

-Saravana

>  drivers/base/core.c    | 28 ++++++++++++++++++----------
>  include/linux/device.h |  1 +
>  2 files changed, 19 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index adf003a7e8d6a..178a21e985197 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -269,6 +269,12 @@ static bool device_is_ancestor(struct device *dev, s=
truct device *target)
>         return false;
>  }
>
> +static inline bool device_link_flag_is_sync_state_only(u32 flags)
> +{
> +       return (flags & ~(DL_FLAG_INFERRED | DL_FLAG_CYCLE)) =3D=3D
> +               (DL_FLAG_SYNC_STATE_ONLY | DL_FLAG_MANAGED);
> +}
> +
>  /**
>   * device_is_dependent - Check if one device depends on another one
>   * @dev: Device to check dependencies for.
> @@ -295,8 +301,7 @@ int device_is_dependent(struct device *dev, void *tar=
get)
>                 return ret;
>
>         list_for_each_entry(link, &dev->links.consumers, s_node) {
> -               if ((link->flags & ~DL_FLAG_INFERRED) =3D=3D
> -                   (DL_FLAG_SYNC_STATE_ONLY | DL_FLAG_MANAGED))
> +               if (device_link_flag_is_sync_state_only(link->flags))
>                         continue;
>
>                 if (link->consumer =3D=3D target)
> @@ -369,8 +374,7 @@ static int device_reorder_to_tail(struct device *dev,=
 void *not_used)
>
>         device_for_each_child(dev, NULL, device_reorder_to_tail);
>         list_for_each_entry(link, &dev->links.consumers, s_node) {
> -               if ((link->flags & ~DL_FLAG_INFERRED) =3D=3D
> -                   (DL_FLAG_SYNC_STATE_ONLY | DL_FLAG_MANAGED))
> +               if (device_link_flag_is_sync_state_only(link->flags))
>                         continue;
>                 device_reorder_to_tail(link->consumer, NULL);
>         }
> @@ -621,7 +625,8 @@ postcore_initcall(devlink_class_init);
>                                DL_FLAG_AUTOREMOVE_SUPPLIER | \
>                                DL_FLAG_AUTOPROBE_CONSUMER  | \
>                                DL_FLAG_SYNC_STATE_ONLY | \
> -                              DL_FLAG_INFERRED)
> +                              DL_FLAG_INFERRED | \
> +                              DL_FLAG_CYCLE)
>
>  #define DL_ADD_VALID_FLAGS (DL_MANAGED_LINK_FLAGS | DL_FLAG_STATELESS | =
\
>                             DL_FLAG_PM_RUNTIME | DL_FLAG_RPM_ACTIVE)
> @@ -690,8 +695,6 @@ struct device_link *device_link_add(struct device *co=
nsumer,
>         if (!consumer || !supplier || consumer =3D=3D supplier ||
>             flags & ~DL_ADD_VALID_FLAGS ||
>             (flags & DL_FLAG_STATELESS && flags & DL_MANAGED_LINK_FLAGS) =
||
> -           (flags & DL_FLAG_SYNC_STATE_ONLY &&
> -            (flags & ~DL_FLAG_INFERRED) !=3D DL_FLAG_SYNC_STATE_ONLY) ||
>             (flags & DL_FLAG_AUTOPROBE_CONSUMER &&
>              flags & (DL_FLAG_AUTOREMOVE_CONSUMER |
>                       DL_FLAG_AUTOREMOVE_SUPPLIER)))
> @@ -707,6 +710,10 @@ struct device_link *device_link_add(struct device *c=
onsumer,
>         if (!(flags & DL_FLAG_STATELESS))
>                 flags |=3D DL_FLAG_MANAGED;
>
> +       if (flags & DL_FLAG_SYNC_STATE_ONLY &&
> +           !device_link_flag_is_sync_state_only(flags))
> +               return NULL;
> +
>         device_links_write_lock();
>         device_pm_lock();
>
> @@ -1627,7 +1634,7 @@ static void fw_devlink_relax_link(struct device_lin=
k *link)
>         if (!(link->flags & DL_FLAG_INFERRED))
>                 return;
>
> -       if (link->flags =3D=3D (DL_FLAG_MANAGED | FW_DEVLINK_FLAGS_PERMIS=
SIVE))
> +       if (device_link_flag_is_sync_state_only(link->flags))
>                 return;
>
>         pm_runtime_drop_link(link);
> @@ -1695,8 +1702,8 @@ static int fw_devlink_relax_cycle(struct device *co=
n, void *sup)
>                 return ret;
>
>         list_for_each_entry(link, &con->links.consumers, s_node) {
> -               if ((link->flags & ~DL_FLAG_INFERRED) =3D=3D
> -                   (DL_FLAG_SYNC_STATE_ONLY | DL_FLAG_MANAGED))
> +               if (!(link->flags & DL_FLAG_CYCLE) &&
> +                   device_link_flag_is_sync_state_only(link->flags))
>                         continue;
>
>                 if (!fw_devlink_relax_cycle(link->consumer, sup))
> @@ -1705,6 +1712,7 @@ static int fw_devlink_relax_cycle(struct device *co=
n, void *sup)
>                 ret =3D 1;
>
>                 fw_devlink_relax_link(link);
> +               link->flags |=3D DL_FLAG_CYCLE;
>         }
>         return ret;
>  }
> diff --git a/include/linux/device.h b/include/linux/device.h
> index e270cb740b9e7..636ef7caa021d 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -326,6 +326,7 @@ enum device_link_state {
>  #define DL_FLAG_MANAGED                        BIT(6)
>  #define DL_FLAG_SYNC_STATE_ONLY                BIT(7)
>  #define DL_FLAG_INFERRED               BIT(8)
> +#define DL_FLAG_CYCLE                  BIT(9)
>
>  /**
>   * enum dl_dev_state - Device driver presence tracking information.
> --
> 2.39.2
>
>
>
