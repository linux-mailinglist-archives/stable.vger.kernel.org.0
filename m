Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15F2F63997A
	for <lists+stable@lfdr.de>; Sun, 27 Nov 2022 07:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiK0Goa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Nov 2022 01:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiK0Go3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Nov 2022 01:44:29 -0500
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0521CDF79;
        Sat, 26 Nov 2022 22:44:27 -0800 (PST)
Received: by mail-vk1-xa31.google.com with SMTP id u9so3865817vkk.4;
        Sat, 26 Nov 2022 22:44:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9YAtr1f3rNJDTWizS2487hu89IqSvvQkFyG9LJcuC2s=;
        b=ZzydsdnYFf/4lSPSjw25OYVJulSW0t61sJNgSlR9PtwT/D9ZXG93mCl9DOY8wyHwpO
         Bwap5HFCHMs25M5ugFeczcNovjzUB2XKlXpqOi6HX6JwFbfF/QNadz0RV1njLEmgc+wW
         iZNuzYc/vkpO3mt6+EBkZNPqHytFoin4z4diuG3nksxFAhnXWBbJHMynf5TTr5Ug17BJ
         8BJqE1pkbI1OCW7Z6YCrDB5x++eOcrFC1PmATFqxja2qOZXACPw+7LNGSyQ7GMenBDNv
         t6N7Kch4EJcaOxEwrCPFkbfkTzb0YNffk4yMM/vJYWAEeuhN+2a/UD+vFD2JzEkekQn1
         qruw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9YAtr1f3rNJDTWizS2487hu89IqSvvQkFyG9LJcuC2s=;
        b=e7edYeYchr7ovkGc9d51pPYnUbZ3hj6yQbXN4fZZN/Mb7EuIWzkWxmIhHdxGajvJZa
         YXjFH25htB8GkDx4OjJiWcU+D2VNQzJnhp0ThF3okH3nM0qfcJI52YJwAQAEE/NIdc+H
         yqFuuYAOW+RcvRVp6IYTmFktmppvLEAx8TaIpSJa3E7M1vclYFOdHv0vMPcYlZLpicHO
         sJ6R00vgNyPKlHWa2AOvK0LUzrRmMnhrYgDbq5yB1fXk/PS9J5XueMhrs9VaWGw4MKYK
         wAG21S379B2tEoJNH3ibFY/p3sS+/sWu7aP6QPEih9v7XFgzE8Wd2L58+8XcD0FAxhsq
         7pWQ==
X-Gm-Message-State: ANoB5pn5/5AImbsQDYCgalo14pJ0ZQzXfibo530wO33dgJ/mj4uW+5aT
        vdFBhupx5UB35keiUMlWQugzvaGWht0tD+a5m2/nP66a
X-Google-Smtp-Source: AA0mqf6ANzoWYoUxraYM/BDLBa02uJHpfX2DSQqRUvM/8oCxVyg5xVNrOJLONugRcmJJLFCIKZUNd8S/KvYD7B3q+oQ=
X-Received: by 2002:a1f:2586:0:b0:3bc:99b5:21b with SMTP id
 l128-20020a1f2586000000b003bc99b5021bmr12050263vkl.24.1669531465858; Sat, 26
 Nov 2022 22:44:25 -0800 (PST)
MIME-Version: 1.0
References: <20221122085138.332434-1-pawell@cadence.com>
In-Reply-To: <20221122085138.332434-1-pawell@cadence.com>
From:   Peter Chen <hzpeterchen@gmail.com>
Date:   Sun, 27 Nov 2022 14:44:14 +0800
Message-ID: <CAL411-remXzOE0JXy_j8ySOHYd=mk2hLXdr6d26yB9v6MFqYXA@mail.gmail.com>
Subject: Re: [PATCH] usb: cdnsp: fix lack of ZLP for ep0
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

On Tue, Nov 22, 2022 at 4:52 PM Pawel Laszczak <pawell@cadence.com> wrote:
>
> Patch implements the handling of ZLP for control transfer.
> To send the ZLP driver must prepare the extra TRB in TD with
> length set to zero and TRB type to TRB_NORMAL.
> The first TRB must have set TRB_CHAIN flag, TD_SIZE = 1
> and TRB type to TRB_DATA.
>
> cc: <stable@vger.kernel.org>
> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
> Signed-off-by: Pawel Laszczak <pawell@cadence.com>

Reviewed-by: Peter Chen <peter.chen@kernel.org>

Peter

> ---
>  drivers/usb/cdns3/cdnsp-ring.c | 42 ++++++++++++++++++++++++++--------
>  1 file changed, 32 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
> index 86e1141e150f..fa1fa9b2ff38 100644
> --- a/drivers/usb/cdns3/cdnsp-ring.c
> +++ b/drivers/usb/cdns3/cdnsp-ring.c
> @@ -2006,10 +2006,11 @@ int cdnsp_queue_bulk_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq)
>
>  int cdnsp_queue_ctrl_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq)
>  {
> -       u32 field, length_field, remainder;
> +       u32 field, length_field, zlp = 0;
>         struct cdnsp_ep *pep = preq->pep;
>         struct cdnsp_ring *ep_ring;
>         int num_trbs;
> +       u32 maxp;
>         int ret;
>
>         ep_ring = cdnsp_request_to_transfer_ring(pdev, preq);
> @@ -2019,26 +2020,33 @@ int cdnsp_queue_ctrl_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq)
>         /* 1 TRB for data, 1 for status */
>         num_trbs = (pdev->three_stage_setup) ? 2 : 1;
>
> +       maxp = usb_endpoint_maxp(pep->endpoint.desc);
> +
> +       if (preq->request.zero && preq->request.length &&
> +           (preq->request.length % maxp == 0)) {
> +               num_trbs++;
> +               zlp = 1;
> +       }
> +
>         ret = cdnsp_prepare_transfer(pdev, preq, num_trbs);
>         if (ret)
>                 return ret;
>
>         /* If there's data, queue data TRBs */
> -       if (pdev->ep0_expect_in)
> -               field = TRB_TYPE(TRB_DATA) | TRB_IOC;
> -       else
> -               field = TRB_ISP | TRB_TYPE(TRB_DATA) | TRB_IOC;
> -
>         if (preq->request.length > 0) {
> -               remainder = cdnsp_td_remainder(pdev, 0, preq->request.length,
> -                                              preq->request.length, preq, 1, 0);
> +               field = TRB_TYPE(TRB_DATA);
>
> -               length_field = TRB_LEN(preq->request.length) |
> -                               TRB_TD_SIZE(remainder) | TRB_INTR_TARGET(0);
> +               if (zlp)
> +                       field |= TRB_CHAIN;
> +               else
> +                       field |= TRB_IOC | (pdev->ep0_expect_in ? 0 : TRB_ISP);
>
>                 if (pdev->ep0_expect_in)
>                         field |= TRB_DIR_IN;
>
> +               length_field = TRB_LEN(preq->request.length) |
> +                              TRB_TD_SIZE(zlp) | TRB_INTR_TARGET(0);
> +
>                 cdnsp_queue_trb(pdev, ep_ring, true,
>                                 lower_32_bits(preq->request.dma),
>                                 upper_32_bits(preq->request.dma), length_field,
> @@ -2046,6 +2054,20 @@ int cdnsp_queue_ctrl_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq)
>                                 TRB_SETUPID(pdev->setup_id) |
>                                 pdev->setup_speed);
>
> +               if (zlp) {
> +                       field = TRB_TYPE(TRB_NORMAL) | TRB_IOC;
> +
> +                       if (!pdev->ep0_expect_in)
> +                               field = TRB_ISP;
> +
> +                       cdnsp_queue_trb(pdev, ep_ring, true,
> +                                       lower_32_bits(preq->request.dma),
> +                                       upper_32_bits(preq->request.dma), 0,
> +                                       field | ep_ring->cycle_state |
> +                                       TRB_SETUPID(pdev->setup_id) |
> +                                       pdev->setup_speed);
> +               }
> +
>                 pdev->ep0_stage = CDNSP_DATA_STAGE;
>         }
>
> --
> 2.25.1
>
