Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59AC250A7E9
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 20:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391073AbiDUSSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 14:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242648AbiDUSSY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 14:18:24 -0400
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2588D13EA7;
        Thu, 21 Apr 2022 11:15:34 -0700 (PDT)
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-2ebf3746f87so61154487b3.6;
        Thu, 21 Apr 2022 11:15:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ll9RiONHC6ecqkUVPX4Bwn7OsJSalGQ2+DEVyJxjcMM=;
        b=k3cPRCzEJZgibwRKBPHXk/gT0wJUriuZ78x8RqPwl2taYAjVDeSplElw7OuyEOVD3J
         CaCqupQCrF8nAcrhOcmZ08Iq4Re6y5LHX2Qpkojcsmwp8CFAbng56pW0Y947AwtLzd4z
         rP8MUtNibaHuTOr7424yOt6WHK4Ady2kuaHy3Aw3jentM0L4dwosyl66gsKfu4J/mWNy
         vVoUbRj+krBDVmR25M+SToUvGD/jOODnQEr+GMjsHm/r7Np7TWXkro74fw8TWzAfuM1J
         u3NtQFkpKhlSE+QDqdgNXh91NaVMhVta5FnbBz/Plbf0C4Ln12lGhpkJQTEUVuzjtp1C
         t9eQ==
X-Gm-Message-State: AOAM532HpXWp7aDqr+EA6luk4Olx+qLvcePWFU0DCx8IXNi/P7F6qZ4b
        pXKpFWYrpbiZG7jNu3dqBD9dhHqkLfSC8GiGoGM=
X-Google-Smtp-Source: ABdhPJyaXa/pSh+pQ0m8rAF5rFqr3ho9+/BS4Jh4qfZXoe5jLLqB/C2heFmLZMRpvgUg9WBAY9TAV/5WuAYxLgp45wc=
X-Received: by 2002:a81:260a:0:b0:2f4:ca82:a42f with SMTP id
 m10-20020a81260a000000b002f4ca82a42fmr1024201ywm.149.1650564933352; Thu, 21
 Apr 2022 11:15:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220421165504.3173244-1-keescook@chromium.org>
In-Reply-To: <20220421165504.3173244-1-keescook@chromium.org>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 21 Apr 2022 20:15:22 +0200
Message-ID: <CAJZ5v0gw_KZS0ZrWP1rwnrxbUjNJbb-KtgChqutDyYkUZVAMQQ@mail.gmail.com>
Subject: Re: [PATCH] thermal: int340x: Fix attr.show callback prototype
To:     Kees Cook <keescook@chromium.org>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Joao Moreira <joao@overdrivepizza.com>,
        Stable <stable@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>,
        Matthew Garrett <mjg59@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 21, 2022 at 6:55 PM Kees Cook <keescook@chromium.org> wrote:
>
> Control Flow Integrity (CFI) instrumentation of the kernel noticed that
> the caller, dev_attr_show(), and the callback, odvp_show(), did not have
> matching function prototypes, which would cause a CFI exception to be
> raised. Correct the prototype by using struct device_attribute instead
> of struct kobj_attribute.
>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Amit Kucheria <amitk@kernel.org>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> Cc: linux-pm@vger.kernel.org
> Reported-and-tested-by: Joao Moreira <joao@overdrivepizza.com>
> Link: https://lore.kernel.org/lkml/067ce8bd4c3968054509831fa2347f4f@overdrivepizza.com/
> Fixes: 006f006f1e5c ("thermal/int340x_thermal: Export OEM vendor variables")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Applied as 5.18-rc material, thanks!

> ---
>  drivers/thermal/intel/int340x_thermal/int3400_thermal.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> index 4954800b9850..d97f496bab9b 100644
> --- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> +++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> @@ -68,7 +68,7 @@ static int evaluate_odvp(struct int3400_thermal_priv *priv);
>  struct odvp_attr {
>         int odvp;
>         struct int3400_thermal_priv *priv;
> -       struct kobj_attribute attr;
> +       struct device_attribute attr;
>  };
>
>  static ssize_t data_vault_read(struct file *file, struct kobject *kobj,
> @@ -311,7 +311,7 @@ static int int3400_thermal_get_uuids(struct int3400_thermal_priv *priv)
>         return result;
>  }
>
> -static ssize_t odvp_show(struct kobject *kobj, struct kobj_attribute *attr,
> +static ssize_t odvp_show(struct device *dev, struct device_attribute *attr,
>                          char *buf)
>  {
>         struct odvp_attr *odvp_attr;
> --
> 2.32.0
>
