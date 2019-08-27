Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFFF79E5FF
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 12:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729387AbfH0KoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 06:44:04 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:41632 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfH0KoD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Aug 2019 06:44:03 -0400
Received: by mail-qk1-f193.google.com with SMTP id g17so16519711qkk.8;
        Tue, 27 Aug 2019 03:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=f9GeRCCR5SPjUrQ9jGrB+qKSFZMP69pNIGHH3g1yTjk=;
        b=bHRYz7z/a+G22RJLFz/56nZ/O2pmgXdi9tXILnjYPvuWQatkaRAkME+YPTHAF3Kxnv
         s89Jviwb//DGIwxdvs1smTzs21d8NdnJX8AeN8xhckwIcdw5s1u3lYg5wqOC6d2XYeCE
         iP+BTVrL6t8MxXPMiGZf8fAuD8VfnZjAHNuiYgezKqg3yt0ozJ5x28PjyzeZzxb16n2L
         QDiRMxfT/pQPuuBoqKlBIMpG3kWJ5hpRctmVIzD/+RNs+2J+SidcBsE7rDnKjmZLR9oY
         mjylrKc5nijSn9EQMuT/MEAliQXJu7tW9A8FcOCHzLon9eyM5u0GYd+Zs7tcMQ/Sit5x
         ipkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=f9GeRCCR5SPjUrQ9jGrB+qKSFZMP69pNIGHH3g1yTjk=;
        b=uO8hIweaOwjcfXABEvrc5BDz9fEEc7rW2x9/Amnykoth3RdYH/sJe8HCiIe9bZMmEa
         XrcMJkCkXiI8S5XekFBfXBoRQFXrPPoN42WRFTBBpJ3fnWsvwD5hE1gHa8t8hDGKTm3Q
         kGjC6EzW+BfT9KmIzHXirwaSTibRhubfYlDpNfNPM3z3z1S3cLD2GbbiXTRZz5GUoCEP
         eU6dHlS+5Ggh5IpN0MZSSNuCHPIjfVxqa/wmUpMZ1UqE3zd4mHuVsvXdmPGJFcK3/TN+
         tjm+CRS1KgwnvmzzvDvHfXU4p2jI7pxDHq3szJ4J4v72w4svXjgMgBhXUZhOhbm1gcc8
         3Htg==
X-Gm-Message-State: APjAAAXVMaMfoYKTThFdgfwUNMCaXPQh94EpYVlj3sKwAmJsN3PjXdGH
        elpvxomQ+q7A16PnkBdFImIg7HdRCCoXGSSF+7k0e+5nxEU=
X-Google-Smtp-Source: APXvYqzZDZf05Sas70kMvDsixqKd2t5xmSm25pG3LwXQoN2S0kMZ4h8RpZnO+9M8V7u/T1KtLsCqN0m4EBH/sxOkCiQ=
X-Received: by 2002:a05:620a:1413:: with SMTP id d19mr20194944qkj.341.1566902642595;
 Tue, 27 Aug 2019 03:44:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190816073742.26866-1-committed@heine.so>
In-Reply-To: <20190816073742.26866-1-committed@heine.so>
From:   Enric Balletbo Serra <eballetbo@gmail.com>
Date:   Tue, 27 Aug 2019 12:43:51 +0200
Message-ID: <CAFqH_52bMDedbRWkyevriYnCGSDRKHFs7UeygPqD00MpLOFobA@mail.gmail.com>
Subject: Re: [PATCH v2] power: supply: sbs-battery: use correct flags field
To:     Michael Nosthoff <committed@heine.so>
Cc:     Linux PM list <linux-pm@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        stable@vger.kernel.org, Sebastian Reichel <sre@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Michael,

I think that Sebastian is expected to be cc'ed, so adding him
(otherwise he can miss your patch)

Missatge de Michael Nosthoff <committed@heine.so> del dia dv., 16
d=E2=80=99ag. 2019 a les 9:38:
>
> the type flag is stored in the chip->flags field not in the
> client->flags field. This currently leads to never using the ti
> specific health function as client->flags doesn't use that bit.
> So it's always falling back to the general one.
>
> Fixes: 76b16f4cdfb8 ("power: supply: sbs-battery: don't assume
> MANUFACTURER_DATA formats")
>
> Signed-off-by: Michael Nosthoff <committed@heine.so>
> Reviewed-by: Brian Norris <briannorris@chromium.org>
> Cc: <stable@vger.kernel.org>

Found this patch while looking at another issue and LGTM, so in case
this helps the patch landing

Reviewed-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>

Thanks,
 Enric

> ---
> Changes since v1:
> * Changed comment according to Brian's suggestions
> * Added Fixes tag
> * Added reviewed and cc stable
>
>  drivers/power/supply/sbs-battery.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/power/supply/sbs-battery.c b/drivers/power/supply/sb=
s-battery.c
> index 048d205d7074..2e86cc1e0e35 100644
> --- a/drivers/power/supply/sbs-battery.c
> +++ b/drivers/power/supply/sbs-battery.c
> @@ -620,7 +620,7 @@ static int sbs_get_property(struct power_supply *psy,
>         switch (psp) {
>         case POWER_SUPPLY_PROP_PRESENT:
>         case POWER_SUPPLY_PROP_HEALTH:
> -               if (client->flags & SBS_FLAGS_TI_BQ20Z75)
> +               if (chip->flags & SBS_FLAGS_TI_BQ20Z75)
>                         ret =3D sbs_get_ti_battery_presence_and_health(cl=
ient,
>                                                                      psp,=
 val);
>                 else
> --
> 2.20.1
>
