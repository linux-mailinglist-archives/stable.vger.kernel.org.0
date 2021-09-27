Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF23419D7A
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236377AbhI0RwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235870AbhI0Rvz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 13:51:55 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BAD9C07E5F8
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 10:46:01 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id w206so26655267oiw.4
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 10:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t3kfBeHXWRfZBiWRf/PnTlqxU9mRTrfzhwKYnp/6N6U=;
        b=fJHX/CqI5GKmhGEd/8PMxvcbASoJiNG04iUYm/dPeWJmKjhQ80CKj5zbfHQkh3AI8c
         bxMGavGgFlQk5/srtivz+28SVRvj01isHjl9Phav3+BTXxIT/DG3qH/oip3y/spGFU1f
         hp2iG6SOXzowKCa6sUz9ufVpvZenXCTzPggHr/wyZ217bL7IGV5E2quDgw9zIxzWjNuE
         2Ki21uRev0J9o/ca4Rk0uKsgjL93vRtbbApraZYEMUoVeLGkqHAIuMcFayqoLT2J3jTF
         407HOsko2cHP8nNcvENQFDwWxMXhTxSeR1sh3QDUr5UO8Fby+mYsitZxgRSsjCoNPERO
         1J2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t3kfBeHXWRfZBiWRf/PnTlqxU9mRTrfzhwKYnp/6N6U=;
        b=GamDHTysYupRvQX/kFEdZxOSxdRm359C3DtQV4CERPi3DUQmroL5CAIZ4tStIln6YA
         qknIFQvSLvyVLeYauRGMy4bdz4T8aEcLM3JN2wGhyrmmgudBonVgMPp4wFPD+Z9mn08Q
         VfSWV5M1ezrI4zv4ur7mWRDlNWHauZ60bQ1l+rAd+1zuuHnueN7J9kQwlpXF1MTbTHle
         yzpmEab80OIqJeyn7uXxx3uVjvB4bwFZ5tYRNClzjkcegysKvV5plvXXqbKC5iQ8OHzC
         LXEzPzm51p0vC/Fm8TjGLYkyrKZ/rsZ4Dl4grqEn3vjbCLf/FZMit1GGyv399gvVQXAe
         0FBw==
X-Gm-Message-State: AOAM532SSqa5q+kurO7o1T2BalFm9UnR2YmLwtIQdn69NIqRbrzbGPzn
        auz/spvfRgPUAXFYd1B8sk/nkyoPC5hlDRPUxunCEA2wnqJSCA==
X-Google-Smtp-Source: ABdhPJytAF8/STDSBekRMIlX8B09lphHyRtB50P9AbP8CLk16u5zMLU+O5lbNzfhNR/DdxYhvFLletdF6++ZIyZSR4Y=
X-Received: by 2002:a54:418a:: with SMTP id 10mr243831oiy.13.1632764760257;
 Mon, 27 Sep 2021 10:46:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210927170225.702078779@linuxfoundation.org> <20210927170227.414776158@linuxfoundation.org>
In-Reply-To: <20210927170227.414776158@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 27 Sep 2021 23:15:49 +0530
Message-ID: <CA+G9fYs2a78_RXaqfE3WMjSOh=HhuS=OjVxh9Hswzrme+pqxqQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 048/103] s390/qeth: fix deadlock during failing recovery
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Following commit caused the build failures on s390,

On Mon, 27 Sept 2021 at 22:43, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Alexandra Winter <wintera@linux.ibm.com>
>
> [ Upstream commit d2b59bd4b06d84a4eadb520b0f71c62fe8ec0a62 ]
>
> Commit 0b9902c1fcc5 ("s390/qeth: fix deadlock during recovery") removed
> taking discipline_mutex inside qeth_do_reset(), fixing potential
> deadlocks. An error path was missed though, that still takes
> discipline_mutex and thus has the original deadlock potential.
>
> Intermittent deadlocks were seen when a qeth channel path is configured
> offline, causing a race between qeth_do_reset and ccwgroup_remove.
> Call qeth_set_offline() directly in the qeth_do_reset() error case and
> then a new variant of ccwgroup_set_offline(), without taking
> discipline_mutex.
>
> Fixes: b41b554c1ee7 ("s390/qeth: fix locking for discipline setup / removal")
> Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
> Reviewed-by: Julian Wiedmann <jwi@linux.ibm.com>
> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/s390/include/asm/ccwgroup.h  |  2 +-
>  drivers/s390/cio/ccwgroup.c       | 10 ++++++++--
>  drivers/s390/net/qeth_core_main.c |  3 ++-
>  3 files changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/arch/s390/include/asm/ccwgroup.h b/arch/s390/include/asm/ccwgroup.h
> index ad3acb1e882b..8a22da9a735a 100644
> --- a/arch/s390/include/asm/ccwgroup.h
> +++ b/arch/s390/include/asm/ccwgroup.h
> @@ -58,7 +58,7 @@ struct ccwgroup_device *get_ccwgroupdev_by_busid(struct ccwgroup_driver *gdrv,
>                                                  char *bus_id);
>
>  extern int ccwgroup_set_online(struct ccwgroup_device *gdev);
> -extern int ccwgroup_set_offline(struct ccwgroup_device *gdev);
> +int ccwgroup_set_offline(struct ccwgroup_device *gdev, bool call_gdrv);
>
>  extern int ccwgroup_probe_ccwdev(struct ccw_device *cdev);
>  extern void ccwgroup_remove_ccwdev(struct ccw_device *cdev);
> diff --git a/drivers/s390/cio/ccwgroup.c b/drivers/s390/cio/ccwgroup.c
> index 483a9ecfcbb1..cfdc1c7825d0 100644
> --- a/drivers/s390/cio/ccwgroup.c
> +++ b/drivers/s390/cio/ccwgroup.c
> @@ -98,12 +98,13 @@ EXPORT_SYMBOL(ccwgroup_set_online);
>  /**
>   * ccwgroup_set_offline() - disable a ccwgroup device
>   * @gdev: target ccwgroup device
> + * @call_gdrv: Call the registered gdrv set_offline function
>   *
>   * This function attempts to put the ccwgroup device into the offline state.
>   * Returns:
>   *  %0 on success and a negative error value on failure.
>   */
> -int ccwgroup_set_offline(struct ccwgroup_device *gdev)
> +int ccwgroup_set_offline(struct ccwgroup_device *gdev, bool call_gdrv)
>  {
>         struct ccwgroup_driver *gdrv = to_ccwgroupdrv(gdev->dev.driver);
>         int ret = -EINVAL;
> @@ -112,11 +113,16 @@ int ccwgroup_set_offline(struct ccwgroup_device *gdev)
>                 return -EAGAIN;
>         if (gdev->state == CCWGROUP_OFFLINE)
>                 goto out;
> +       if (!call_gdrv) {
> +               ret = 0;
> +               goto offline;
> +       }
>         if (gdrv->set_offline)
>                 ret = gdrv->set_offline(gdev);
>         if (ret)
>                 goto out;
>
> +offline:
>         gdev->state = CCWGROUP_OFFLINE;
>  out:
>         atomic_set(&gdev->onoff, 0);
> @@ -145,7 +151,7 @@ static ssize_t ccwgroup_online_store(struct device *dev,
>         if (value == 1)
>                 ret = ccwgroup_set_online(gdev);
>         else if (value == 0)
> -               ret = ccwgroup_set_offline(gdev);
> +               ret = ccwgroup_set_offline(gdev, true);
>         else
>                 ret = -EINVAL;
>  out:
> diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
> index 7b0155b0e99e..15477bfb5bd8 100644
> --- a/drivers/s390/net/qeth_core_main.c
> +++ b/drivers/s390/net/qeth_core_main.c
> @@ -5406,7 +5406,8 @@ static int qeth_do_reset(void *data)
>                 dev_info(&card->gdev->dev,
>                          "Device successfully recovered!\n");
>         } else {
> -               ccwgroup_set_offline(card->gdev);
> +               qeth_set_offline(card, disc, true);
> +               ccwgroup_set_offline(card->gdev, false);

drivers/s390/net/qeth_core_main.c: In function 'qeth_close_dev_handler':
drivers/s390/net/qeth_core_main.c:83:9: error: too few arguments to
function 'ccwgroup_set_offline'
   83 |         ccwgroup_set_offline(card->gdev);
      |         ^~~~~~~~~~~~~~~~~~~~
In file included from drivers/s390/net/qeth_core.h:44,
                 from drivers/s390/net/qeth_core_main.c:46:
arch/s390/include/asm/ccwgroup.h:61:5: note: declared here
   61 | int ccwgroup_set_offline(struct ccwgroup_device *gdev, bool call_gdrv);
      |     ^~~~~~~~~~~~~~~~~~~~
make[3]: *** [scripts/Makefile.build:280:
drivers/s390/net/qeth_core_main.o] Error 1

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


Build url:
https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1626658768#L73


--
Linaro LKFT
https://lkft.linaro.org
