Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA40AF9679
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 18:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfKLRBv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 12:01:51 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:36733 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726896AbfKLRBu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 12:01:50 -0500
Received: by mail-io1-f68.google.com with SMTP id s3so19527896ioe.3;
        Tue, 12 Nov 2019 09:01:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vni8rys6ZklkTBMHKTTW6jcdNhCX0bfUBFLTk67Zs9E=;
        b=e8ar+oq0GDEo7IaX6MH6RqIH3QsQFxZVBJQIFnqucTGzfX9WAuCsGamP/KjECKigFW
         TZoUR7HmmxTO6MQetBUtHNxSYfrB/I9wlIMriEBsNfko/8cOQCn8q0lq35KpUOh0f9GY
         TZncq19vNpOB9pYO2D2BbeUoYIau2NyksmBlh/Z/S1Nmx/EaedO6H81V+7k4WaOryztx
         mWrLXdtH24XL5fhSHJU5GbDL1k6lZ5aRvX9Fmc2fDFlMh+yvMPdfHlq1QGf/sg/i9M5K
         AdlWnjU9VaLKOXxq74f8wsqlbeRKteHN9vaGoLp91oNggNKqHVBVVQEj/WRLBBpXEQQW
         cJLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vni8rys6ZklkTBMHKTTW6jcdNhCX0bfUBFLTk67Zs9E=;
        b=iev3UBy3y/bTuc/uzeuj0NazuUzkO72a9d5X/uU2Yd894nePYA1K234RfnPWHzzCWv
         HPgFDGlf65rfKInqY6i5ITHOVmPPyl8yzWBU13luya2w+vQ0G6E00epnnem7fmsGSTe2
         /UXhdRALsUKkMxUYZK589JS6Bc8lSE9mIe6uWwSdGZXxYiYL4ONb2Z0ijGSKGjT1gOJH
         QDi3Vc77YhLHIhjS92C8sH5OBxrD//rbSkkSMRL5wROkQKXvNUnNlOyHnxQtQKYN76kO
         nn6MVOv1bVhAbYRoNruaTVUxb+FXgV1zV1CJPVihxepXJ/Jhp/NpAMjxO6uBN7+r7ALx
         vRdQ==
X-Gm-Message-State: APjAAAWD0rr7NndOZBmOv+R/xorSCSzWuuGeWSvzFyEAX2ktbLry4LIc
        4MH8C0ORJ4YanJgaY+JHryM/v6x1mMUFr4t7DfI38Q==
X-Google-Smtp-Source: APXvYqxBVtW6LRqSJQc0/Lj51xsGUFxCMeucmANELSomPYdSxtS3JOUFeagPtUQt3YLgqoMfrKoXDkYknusFnw8I6oI=
X-Received: by 2002:a6b:f60f:: with SMTP id n15mr6392824ioh.263.1573578109461;
 Tue, 12 Nov 2019 09:01:49 -0800 (PST)
MIME-Version: 1.0
References: <20191109004033.1496871-1-bjorn.andersson@linaro.org> <20191109004033.1496871-2-bjorn.andersson@linaro.org>
In-Reply-To: <20191109004033.1496871-2-bjorn.andersson@linaro.org>
From:   Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Date:   Tue, 12 Nov 2019 10:01:38 -0700
Message-ID: <CAOCk7NrkpwyuZnq7C3CgLDBHoCXM=SMxvt_iv+nQzS9atT3B9A@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] remoteproc: qcom_q6v5_mss: Don't reassign mpss
 region on shutdown
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Ohad Ben-Cohen <ohad@wizery.com>,
        Avaneesh Kumar Dwivedi <akdwived@codeaurora.org>,
        MSM <linux-arm-msm@vger.kernel.org>,
        linux-remoteproc@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Sibi Sankar <sibis@codeaurora.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 8, 2019 at 5:40 PM Bjorn Andersson
<bjorn.andersson@linaro.org> wrote:
>
> Trying to reclaim mpss memory while the mba is not running causes the
> system to crash on devices with security fuses blown, so leave it
> assigned to the remote on shutdown and recover it on a subsequent boot.
>
> Fixes: 6c5a9dc2481b ("remoteproc: qcom: Make secure world call for mem ownership switch")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Stuff still works on the laptop, and I don't hit the access violation
with the crash dump scenario on the mtp.

Reviewed-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Tested-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>

> ---
>
> Changes since v1:
> - Assign memory back to Linux in coredump case
>
>  drivers/remoteproc/qcom_q6v5_mss.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
> index de919f2e8b94..efab574b2e12 100644
> --- a/drivers/remoteproc/qcom_q6v5_mss.c
> +++ b/drivers/remoteproc/qcom_q6v5_mss.c
> @@ -875,11 +875,6 @@ static void q6v5_mba_reclaim(struct q6v5 *qproc)
>                 writel(val, qproc->reg_base + QDSP6SS_PWR_CTL_REG);
>         }
>
> -       ret = q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm,
> -                                     false, qproc->mpss_phys,
> -                                     qproc->mpss_size);
> -       WARN_ON(ret);
> -
>         q6v5_reset_assert(qproc);
>
>         q6v5_clk_disable(qproc->dev, qproc->reset_clks,
> @@ -969,6 +964,10 @@ static int q6v5_mpss_load(struct q6v5 *qproc)
>                         max_addr = ALIGN(phdr->p_paddr + phdr->p_memsz, SZ_4K);
>         }
>
> +       /* Try to reset ownership back to Linux */
> +       q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm, false,
> +                               qproc->mpss_phys, qproc->mpss_size);
> +
>         mpss_reloc = relocate ? min_addr : qproc->mpss_phys;
>         qproc->mpss_reloc = mpss_reloc;
>         /* Load firmware segments */
> @@ -1058,9 +1057,14 @@ static void qcom_q6v5_dump_segment(struct rproc *rproc,
>         void *ptr = rproc_da_to_va(rproc, segment->da, segment->size);
>
>         /* Unlock mba before copying segments */
> -       if (!qproc->dump_mba_loaded)
> +       if (!qproc->dump_mba_loaded) {
>                 ret = q6v5_mba_load(qproc);
>
> +               /* Try to reset ownership back to Linux */
> +               q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm, false,
> +                                       qproc->mpss_phys, qproc->mpss_size);
> +       }
> +
>         if (!ptr || ret)
>                 memset(dest, 0xff, segment->size);
>         else
> @@ -1111,10 +1115,6 @@ static int q6v5_start(struct rproc *rproc)
>         return 0;
>
>  reclaim_mpss:
> -       xfermemop_ret = q6v5_xfer_mem_ownership(qproc, &qproc->mpss_perm,
> -                                               false, qproc->mpss_phys,
> -                                               qproc->mpss_size);
> -       WARN_ON(xfermemop_ret);
>         q6v5_mba_reclaim(qproc);
>
>         return ret;
> --
> 2.23.0
>
