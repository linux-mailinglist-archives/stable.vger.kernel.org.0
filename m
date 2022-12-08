Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFDF964694B
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 07:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiLHGeW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 01:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiLHGeU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 01:34:20 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5FEE9E46F;
        Wed,  7 Dec 2022 22:34:18 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id a19so559805ljk.0;
        Wed, 07 Dec 2022 22:34:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kvEzohbThjLf0h3wsatoxrFWAD5WOAdcVplnsmd6fDY=;
        b=fFAVrLZXrJJ1GBpBB/tQ1n7kV1X/9Rn46h7U8vz3M4Om+TzOIrlxezxc9JnM2rzDi+
         wou1Hwh2yqzdkZamzf1utI0RyT/0QbcWSBm9s6T4H+GLlse28qsMpKxI3Y4ATR8xT9Lq
         nYYhaB0M+g3mTMeE9FYzMMpEh+TQDm11JknZp5TyxnH6LC+nw0pYfZSLELeOMCoG9mLO
         WuELI6GBZHmYiDwIAYZosinwwxA4LrYa2d0AyXyyUu68qDy/ueuPzpL90RsW3dBoqTNh
         VF50j+4kWJ8gZEgKxEb/6ts6SxZRIl4aay7hWvm8sy+xeWz9kjNlBjLxa36Iv0u7FBfM
         V0Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kvEzohbThjLf0h3wsatoxrFWAD5WOAdcVplnsmd6fDY=;
        b=E9qg4huhu1svTNJNKTVmr30MylJkrL/GkduhxDLycqmYI+AFh5nvoHHTBQhDUuXbSt
         3rrbc5y7LV7fBpVgp5GhdwwtcfLlcwRrFpr0hAzmAj4vDnywNyp5fs1SoBw1ZmxXxOIj
         YiuyaTgV3B7vGWIfwKkeiShURRFD3pkIz6pquhbSpkKqM7oP/hQfe3mHMIFjtWyJ+B67
         qZ7wS/OIi64CScysOWWyEYnMwsM2j8cZA3rb8f7sXWO1qme+uporRH4h4+9YERmM9U0B
         qJV54X+ZrEKCrd5Qrti33EkdBoHyXITANWdqmXC5QpAsxyKfIe+YJ0bwr+psomjk5su6
         9WKw==
X-Gm-Message-State: ANoB5pkg3b1GaiNAuAyLaz88p8ApKzRu74zN5+oSPZ6DwQ0YnQPaTFG5
        hYefnUKtHVRLwtqx0i0tmDuyxbesIToySJYghg==
X-Google-Smtp-Source: AA0mqf5vx1cSAeMelmy7VQm+f5BVpQcnvI/NYkPrDeRiepDck4qrGlIf2FKqYQvII4OYK7sQ/CAbbqKB43TOLPq9NJg=
X-Received: by 2002:a2e:bf09:0:b0:279:6c82:3e9a with SMTP id
 c9-20020a2ebf09000000b002796c823e9amr21501858ljr.97.1670481256983; Wed, 07
 Dec 2022 22:34:16 -0800 (PST)
MIME-Version: 1.0
References: <20221208061037.24313-1-peter.wang@mediatek.com>
In-Reply-To: <20221208061037.24313-1-peter.wang@mediatek.com>
From:   Stanley Chu <chu.stanley@gmail.com>
Date:   Thu, 8 Dec 2022 14:34:05 +0800
Message-ID: <CAGaU9a_RCpoJggFUmtBmq-xx8EPAaabMK0ptA8y_nm5ahLTMUw@mail.gmail.com>
Subject: Re: [PATCH v5] ufs: core: wlun suspend SSU/enter hibern8 fail recovery
To:     peter.wang@mediatek.com
Cc:     stanley.chu@mediatek.com, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com,
        tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
        naomi.chu@mediatek.com, stable@vger.kernel.org
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

Hi Peter,

Please update the patch version and bring all tags (review, ack
...etc.) to your new patch : )

On Thu, Dec 8, 2022 at 2:17 PM <peter.wang@mediatek.com> wrote:
>
> From: Peter Wang <peter.wang@mediatek.com>
>
> When SSU/enter hibern8 fail in wlun suspend flow, trigger error
> handler and return busy to break the suspend.
> If not, wlun runtime pm status become error and the consumer will
> stuck in runtime suspend status.
>
> Fixes: b294ff3e3449 ("scsi: ufs: core: Enable power management for wlun")
> Cc: stable@vger.kernel.org
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
> ---
>  drivers/ufs/core/ufshcd.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index b1f59a5fe632..c91d58d1486a 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -106,6 +106,13 @@
>                        16, 4, buf, __len, false);                        =
\
>  } while (0)
>
> +#define ufshcd_force_error_recovery(hba) do {                           =
\
> +       spin_lock_irq(hba->host->host_lock);                            \
> +       hba->force_reset =3D true;                                       =
 \
> +       ufshcd_schedule_eh_work(hba);                                   \
> +       spin_unlock_irq(hba->host->host_lock);                          \
> +} while (0)
> +
>  int ufshcd_dump_regs(struct ufs_hba *hba, size_t offset, size_t len,
>                      const char *prefix)
>  {
> @@ -9049,6 +9056,15 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba=
, enum ufs_pm_op pm_op)
>
>                 if (!hba->dev_info.b_rpm_dev_flush_capable) {
>                         ret =3D ufshcd_set_dev_pwr_mode(hba, req_dev_pwr_=
mode);
> +                       if (ret && pm_op !=3D UFS_SHUTDOWN_PM) {
> +                               /*
> +                                * If return err in suspend flow, IO will=
 hang.
> +                                * Trigger error handler and break suspen=
d for
> +                                * error recovery.
> +                                */
> +                               ufshcd_force_error_recovery(hba);
> +                               ret =3D -EBUSY;
> +                       }
>                         if (ret)
>                                 goto enable_scaling;
>                 }
> @@ -9060,6 +9076,15 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba=
, enum ufs_pm_op pm_op)
>          */
>         check_for_bkops =3D !ufshcd_is_ufs_dev_deepsleep(hba);
>         ret =3D ufshcd_link_state_transition(hba, req_link_state, check_f=
or_bkops);
> +       if (ret && pm_op !=3D UFS_SHUTDOWN_PM) {
> +               /*
> +                * If return err in suspend flow, IO will hang.
> +                * Trigger error handler and break suspend for
> +                * error recovery.
> +                */
> +               ufshcd_force_error_recovery(hba);
> +               ret =3D -EBUSY;
> +       }
>         if (ret)
>                 goto set_dev_active;
>
> --
> 2.18.0
>


--=20
Yours truly,

=E6=9C=B1=E5=8E=9F=E9=99=9E (Stanley Chu)
