Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCAFB62D9F1
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 12:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239369AbiKQLyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 06:54:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239261AbiKQLyg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 06:54:36 -0500
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57076BE12;
        Thu, 17 Nov 2022 03:54:34 -0800 (PST)
Received: by mail-vk1-xa34.google.com with SMTP id j24so718849vkk.0;
        Thu, 17 Nov 2022 03:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5e4AcuEMP7yvOysd0NEXhxudfc+f8WZ6V1JAfJswNXw=;
        b=E2dPFAmiYEZh5zRjEK/hoN9bIJ7/ekJi6cw+fgcEJqkcjFdpWwR6klg0HfzhUhROIA
         fXoxVhWDk03F5z8v3UYeZwwAuoMNOrapOsa5Tcs7YhA5ZuPxY9XvLYWuBla4I/z02QWY
         hMNHU6WtSmtlICmiI1l41dALUuhm55pCF++SvqFJLKTiKknr+Z/xTmzSYqNczDUbVS7x
         5t57EXhJVg6Kmo1Z8Na9EssYaCl/w9WSjqVMJKpEzrIH+j17NOAivkoZ5/oRFuM4qjT6
         Y0e+vuvT8SZ4PyJVUIhqrW0oPDlaUtLVETEe3XFcXrSGp5ozDkIQAVSe6fO5zhVZdNy+
         YT7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5e4AcuEMP7yvOysd0NEXhxudfc+f8WZ6V1JAfJswNXw=;
        b=20YyKls8kJpukgvqo8lYJuLik9LdgZ+QCFdIaavoxUKrx4Pw8jlS1+n6XYmBAKPa57
         yV4BC4Znj2oQ+eE1LN7DTk+gGF64u4ZEa/vmncQGaSOZ4MRgpDfb/0mmZcpf8AFQGjx7
         GLbHImbA6YxoRO0ZBDY01MTeCSxnJAt2MCI7k1INNlj6qcF+YSwPhRHhPSf2QC2NIis8
         34D00p0rjOmWBH7q7Rx0zdqfXHjuTKRP533iOnBBgy3ZUCBiFeEPvNSnC+F+HL3/3Axz
         9V5oCrmVOLcemWgoY2pfuseo4ToTEkTW61Fvv1/vqYeYSJ2J4v4jjyllXee8p3afJu7P
         TNvg==
X-Gm-Message-State: ANoB5pnbTYyyEVr4RLX7PSa7+7R15eM7W7g6LOHEnsIqcliHz/Jb/9aZ
        joteFtJk3OZPqccAuwAVGXBzDQ+mxZIcU22xnJ4=
X-Google-Smtp-Source: AA0mqf4SVGJG1fjVY6q519qj4CzG3l+nHvRRVXzZGND2n/Mrg2xai1pGGcCovJClCR+6rsMOOlqQCeQvPSvn64EUFEY=
X-Received: by 2002:ac5:c38e:0:b0:3b7:25e2:6e1f with SMTP id
 s14-20020ac5c38e000000b003b725e26e1fmr942882vkk.19.1668686073386; Thu, 17 Nov
 2022 03:54:33 -0800 (PST)
MIME-Version: 1.0
References: <20221115092218.421267-1-pawell@cadence.com>
In-Reply-To: <20221115092218.421267-1-pawell@cadence.com>
From:   Peter Chen <hzpeterchen@gmail.com>
Date:   Thu, 17 Nov 2022 19:53:24 +0800
Message-ID: <CAL411-pcJZ4ER9KOQom0GoV6aDB6_Nnf0ujVAphoim0gNmp6tA@mail.gmail.com>
Subject: Re: [PATCH v3] usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     peter.chen@kernel.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 15, 2022 at 5:22 PM Pawel Laszczak <pawell@cadence.com> wrote:
>
> Patch modifies the TD_SIZE in TRB before ZLP TRB.
> The TD_SIZE in TRB before ZLP TRB must be set to 1 to force
> processing ZLP TRB by controller.
>
> cc: <stable@vger.kernel.org>
> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
> Signed-off-by: Pawel Laszczak <pawell@cadence.com>

Reviewed-by: Peter Chen <peter.chen@kernel.org>

Peter
> ---
> v2:
> - returned value for last TRB must be 0
> v3:
> - fix issue for request->length > 64KB
>
>  drivers/usb/cdns3/cdnsp-ring.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
> index 794e413800ae..86e1141e150f 100644
> --- a/drivers/usb/cdns3/cdnsp-ring.c
> +++ b/drivers/usb/cdns3/cdnsp-ring.c
> @@ -1763,10 +1763,15 @@ static u32 cdnsp_td_remainder(struct cdnsp_device *pdev,
>                               int trb_buff_len,
>                               unsigned int td_total_len,
>                               struct cdnsp_request *preq,
> -                             bool more_trbs_coming)
> +                             bool more_trbs_coming,
> +                             bool zlp)
>  {
>         u32 maxp, total_packet_count;
>
> +       /* Before ZLP driver needs set TD_SIZE = 1. */
> +       if (zlp)
> +               return 1;
> +
>         /* One TRB with a zero-length data packet. */
>         if (!more_trbs_coming || (transferred == 0 && trb_buff_len == 0) ||
>             trb_buff_len == td_total_len)
> @@ -1960,7 +1965,8 @@ int cdnsp_queue_bulk_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq)
>                 /* Set the TRB length, TD size, and interrupter fields. */
>                 remainder = cdnsp_td_remainder(pdev, enqd_len, trb_buff_len,
>                                                full_len, preq,
> -                                              more_trbs_coming);
> +                                              more_trbs_coming,
> +                                              zero_len_trb);
>
>                 length_field = TRB_LEN(trb_buff_len) | TRB_TD_SIZE(remainder) |
>                         TRB_INTR_TARGET(0);
> @@ -2025,7 +2031,7 @@ int cdnsp_queue_ctrl_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq)
>
>         if (preq->request.length > 0) {
>                 remainder = cdnsp_td_remainder(pdev, 0, preq->request.length,
> -                                              preq->request.length, preq, 1);
> +                                              preq->request.length, preq, 1, 0);
>
>                 length_field = TRB_LEN(preq->request.length) |
>                                 TRB_TD_SIZE(remainder) | TRB_INTR_TARGET(0);
> @@ -2225,7 +2231,7 @@ static int cdnsp_queue_isoc_tx(struct cdnsp_device *pdev,
>                 /* Set the TRB length, TD size, & interrupter fields. */
>                 remainder = cdnsp_td_remainder(pdev, running_total,
>                                                trb_buff_len, td_len, preq,
> -                                              more_trbs_coming);
> +                                              more_trbs_coming, 0);
>
>                 length_field = TRB_LEN(trb_buff_len) | TRB_INTR_TARGET(0);
>
> --
> 2.25.1
>
