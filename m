Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4825D48476E
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 19:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236089AbiADSFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 13:05:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbiADSFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 13:05:55 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6596C061761;
        Tue,  4 Jan 2022 10:05:54 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id d201so86432115ybc.7;
        Tue, 04 Jan 2022 10:05:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tdQRUgSgwsJVMjTD8lJCE4WTI/seShOy5LEi4PlhXsI=;
        b=PEtJpc0TB8gaBqgbOB/30nIwuGEJTxTljt+0TexaMKgIbcaUIbd0h0W0JVsMtUzaYR
         6LUhIleBYN9P4uSm10Fh7LQk3xrHKEX/6I1sZ9UnOES6PD5jIJ9jh+kzT8sKvjvRzn4Z
         siscCNd/Cdq0IYhF/SrGt7zz/4rDp7n7V8nnH8a+uFNm9EtSr08p0a7nYKCUqDE3t3Rr
         HFHSsSjt5qzCOWG3L7ng/1QovhZ9siEDOp//y6Yex4AKjxOpL7iKmAPO2mRDJFOmoe2+
         QLYcWrFyfSQxzodquUAovS/BFWVe8xu7z/0LJqiZ1V3GHI1kQJn9IHA0oZhieVn4rRml
         VqZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tdQRUgSgwsJVMjTD8lJCE4WTI/seShOy5LEi4PlhXsI=;
        b=t5m894TP41kSBFJwAxAyKoBAftSqj46ukq0CmMZOdr185bn00ZzzlnVkzqDizk1nr7
         Mf/NtUmZ490E9sARhCPW0ZdZS90/urWUqp2oVav8ls+1NKcflRdvTCOZVfgIXpdjeODh
         kfve7h8TvcPHGC+xhM4jrTmNApyROEGysZFtcc2Bkf02L0OOTQ9asuvmk+2BBp2sF/U3
         Le43ihFQCUdf5Yfv2TH+LzmmWFWnjnwCNp9ds1Yx7uZHQ9ZwkQ4dxVDElne00FoJHJYN
         A8ISMkwfL6soHsRPSnCTrU6Flil4cITyNySxuruYNHESuDRjr8nakDYml6cwFJbqPdxx
         4sAA==
X-Gm-Message-State: AOAM530VJFqtweKjLkudos70j46lEsWsiR5CYweleRxKnMv6UbwNtKQc
        6t1hq9VS+ZoM35HdceqPlXJTKZxMxdJA+aUr0F4=
X-Google-Smtp-Source: ABdhPJzEn0oYHHUiQctltIZAAad1QnBbXX+3LxQKurnei0B9hpH3oKTFCM+zlB/ZVSWmyRaJMUaN/IuchKiZNU7923s=
X-Received: by 2002:a5b:bc1:: with SMTP id c1mr40734301ybr.669.1641319554084;
 Tue, 04 Jan 2022 10:05:54 -0800 (PST)
MIME-Version: 1.0
References: <20211222142025.30364-1-johan@kernel.org> <20211222142025.30364-2-johan@kernel.org>
In-Reply-To: <20211222142025.30364-2-johan@kernel.org>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Tue, 4 Jan 2022 18:05:28 +0000
Message-ID: <CA+V-a8vS6O8YDVutH_df+v3B093aSVqpeXv4FAoChxjOjEQkkg@mail.gmail.com>
Subject: Re: [PATCH 1/4] media: davinci: vpif: fix unbalanced runtime PM get
To:     Johan Hovold <johan@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Lad@xi.lan
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Johan,

Thank you for the patch.

On Wed, Dec 22, 2021 at 2:20 PM Johan Hovold <johan@kernel.org> wrote:
>
> Make sure to balance the runtime PM usage counter on driver unbind.
>
> Fixes: 407ccc65bfd2 ("[media] davinci: vpif: add pm_runtime support")
> Cc: stable@vger.kernel.org      # 3.9
> Cc: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/media/platform/davinci/vpif.c | 1 +
>  1 file changed, 1 insertion(+)
>
Reviewed-by: Lad Prabhakar <prabhakar.csengg@gmail.com>

> diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
> index 5a89d885d0e3..9752a5ec36f7 100644
> --- a/drivers/media/platform/davinci/vpif.c
> +++ b/drivers/media/platform/davinci/vpif.c
> @@ -495,6 +495,7 @@ static int vpif_probe(struct platform_device *pdev)
>
>  static int vpif_remove(struct platform_device *pdev)
>  {
> +       pm_runtime_put(&pdev->dev);
>         pm_runtime_disable(&pdev->dev);
>         return 0;
>  }
> --
> 2.32.0
>

Cheers,
Prabhakar
