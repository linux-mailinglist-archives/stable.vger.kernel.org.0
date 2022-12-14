Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD14164C2FE
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 05:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237394AbiLNEE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 23:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237383AbiLNEEy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 23:04:54 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6CC26AE8
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 20:04:52 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id l10so2070421plb.8
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 20:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wx7mIQInd8F9awOuQhbgVjGvlIaXKEnGL5UrWxuNsQk=;
        b=ha97pxPv5fjgDvqCEl/5DHjEqCZb9feeBFOib4dYmuPGyGDCdLoRO+LqO34I8jb78G
         O+Gj6bTSiharTDObB1FxTncmYJkjM74jYLJZqPOM4IT+2/VhKw4OSshWgL1sTsfGrdZG
         2wbbjoxi5YGNEpz80g1+RzwN6QcX07R9R98FU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wx7mIQInd8F9awOuQhbgVjGvlIaXKEnGL5UrWxuNsQk=;
        b=xPvUku2Af8PUtxDsPjlZX19VJ8TP3jf/PNA+9RarI0Enqsph37udddZTskSXH2RDD1
         ukAO2kNtT9k2vOBQhqZ5DJ5IaIcqG+5C8fKyuFc2LptaD6cXb390cEbipQSfIjq1Oq46
         xP+4yObFTeCNC9yE/DCpdqi0yBSLjIaQGYhF3vlHeBYhWou+AROWL7DP3HRnlPkbiLXv
         XnhVVNL41lHqX6dAph6gqyeYtYr9tJgk+VH+oY/8Q3tGPAQIgTcecsRSZ8eNBw6BZu2V
         MnD7iSsPo/Y9AQzqxKC51d2FQikWJuQVF/IW44VtX3WTFsABIm7Hy5STquvaGaFV1m8q
         xKaA==
X-Gm-Message-State: AFqh2kre04OZIchCCdiAviTx5eq8rLW/b/wzYfOvYfvOopF41xQFIvjB
        UxOUO14Xm0jgK/n+vZMAvpCtJytSg5upCr4I5GEwKA==
X-Google-Smtp-Source: AMrXdXugtz/B4fcnA3n8EdJICjnDI1z5vkPnsndLNriA+ziXN3xsqyX7wRUa+38gN5Ju7un5x216VAh7DyIPsUsfFnA=
X-Received: by 2002:a17:90a:d781:b0:221:425b:736b with SMTP id
 z1-20020a17090ad78100b00221425b736bmr114434pju.17.1670990692315; Tue, 13 Dec
 2022 20:04:52 -0800 (PST)
MIME-Version: 1.0
References: <20221212-uvc-race-v2-0-54496cc3b8ab@chromium.org> <20221212-uvc-race-v2-1-54496cc3b8ab@chromium.org>
In-Reply-To: <20221212-uvc-race-v2-1-54496cc3b8ab@chromium.org>
From:   Yunke Cao <yunkec@chromium.org>
Date:   Wed, 14 Dec 2022 13:04:41 +0900
Message-ID: <CAEDqmY41RGc2eq6EE46cxA2qZOBimQQuR3anPovYd350pU8i4w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] media: uvcvideo: Fix race condition with usb_kill_urb
To:     Ricardo Ribalda <ribalda@chromium.org>
Cc:     Max Staudt <mstaudt@google.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 13, 2022 at 11:36 PM Ricardo Ribalda <ribalda@chromium.org> wrote:
>
> usb_kill_urb warranties that all the handlers are finished when it
> returns, but does not protect against threads that might be handling
> asynchronously the urb.
>
> For UVC, the function uvc_ctrl_status_event_async() takes care of
> control changes asynchronously.
>
>  If the code is executed in the following order:
>
> CPU 0                                   CPU 1
> =====                                   =====
> uvc_status_complete()
>                                         uvc_status_stop()
> uvc_ctrl_status_event_work()
>                                         uvc_status_start() -> FAIL
>
> Then uvc_status_start will keep failing and this error will be shown:
>
> <4>[    5.540139] URB 0000000000000000 submitted while active
> drivers/usb/core/urb.c:378 usb_submit_urb+0x4c3/0x528
>
> Let's improve the current situation, by not re-submiting the urb if
> we are stopping the status event. Also process the queued work
> (if any) during stop.
>
> CPU 0                                   CPU 1
> =====                                   =====
> uvc_status_complete()
>                                         uvc_status_stop()
>                                         uvc_status_start()
> uvc_ctrl_status_event_work() -> FAIL
>
> Hopefully, with the usb layer protection this should be enough to cover
> all the cases.
>
> Cc: stable@vger.kernel.org
> Fixes: e5225c820c05 ("media: uvcvideo: Send a control event when a Control Change interrupt arrives")
> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> ---
>  drivers/media/usb/uvc/uvc_ctrl.c   | 3 +++
>  drivers/media/usb/uvc/uvc_status.c | 6 ++++++
>  drivers/media/usb/uvc/uvcvideo.h   | 1 +
>  3 files changed, 10 insertions(+)
>
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
> index c95a2229f4fa..5160facc8e20 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -1442,6 +1442,9 @@ static void uvc_ctrl_status_event_work(struct work_struct *work)
>
>         uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
>
> +       if (dev->flush_status)
> +               return;
> +
>         /* Resubmit the URB. */
>         w->urb->interval = dev->int_ep->desc.bInterval;
>         ret = usb_submit_urb(w->urb, GFP_KERNEL);
> diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
> index 7518ffce22ed..09a5802dc974 100644
> --- a/drivers/media/usb/uvc/uvc_status.c
> +++ b/drivers/media/usb/uvc/uvc_status.c
> @@ -304,10 +304,16 @@ int uvc_status_start(struct uvc_device *dev, gfp_t flags)
>         if (dev->int_urb == NULL)
>                 return 0;
>
> +       dev->flush_status = false;
>         return usb_submit_urb(dev->int_urb, flags);
>  }
>
>  void uvc_status_stop(struct uvc_device *dev)
>  {
> +       struct uvc_ctrl_work *w = &dev->async_ctrl;
> +
> +       dev->flush_status = true;
>         usb_kill_urb(dev->int_urb);
> +       if (cancel_work_sync(&w->work))
> +               uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
>  }
> diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
> index df93db259312..6a9b72d6789e 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -560,6 +560,7 @@ struct uvc_device {
>         struct usb_host_endpoint *int_ep;
>         struct urb *int_urb;
>         u8 *status;
> +       bool flush_status;
>         struct input_dev *input;
>         char input_phys[64];
>
>
> --
> 2.39.0.rc1.256.g54fd8350bd-goog-b4-0.11.0-dev-696ae

Reviewed-by: Yunke Cao <yunkec@chromium.org>
