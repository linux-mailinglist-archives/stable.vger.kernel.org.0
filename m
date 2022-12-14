Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF4B64C3A4
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 06:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236626AbiLNF6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 00:58:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiLNF6M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 00:58:12 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930DC22B21
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 21:58:11 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id k88-20020a17090a4ce100b00219d0b857bcso5975128pjh.1
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 21:58:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2cMB0KTRPpjLcSDo8c2MJxYl9QQRsGS0i5AxHQ5wVxU=;
        b=X+3f/2N//f2ogGrUlxDgQQPWtFmf9HLeidf3mqGYExlvbzATxzZpUfe+Pj1WgYl8E0
         f+KBvvYaPqUBJt7SrV8gRwAfCxszKMvkAww4+semz/YCpSQ892hpaIGYGpP/0uyueHEE
         F5qczqJZ28cipo0XkeIB6iWk9aqWu73Xo0suk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2cMB0KTRPpjLcSDo8c2MJxYl9QQRsGS0i5AxHQ5wVxU=;
        b=YwT1eVruuO4vRQa/ZB6PYxeZtQjmnvz9Rg8FI/7Lw6xwJSVaWFY7WCSnqRAPeSvkym
         rDhlV8y4MGmHr6sX/OZy7IPmYyTOluvdUgyuJHk9FdUj5QyBWiCLGxKLc3LAjaCHMsjn
         aH+gFsmKPSdoidLc+tqwKD6eud96zQm6nSa9aEiauqHp/xAzManhYJSZyUNQwIv8Ep8l
         cQwFuEe6rJSM6qq2ptBWMtplEazSOF6P+MDoPMm9ovaDni9pkdsfxY+/ZLrJsLmUzbQz
         d2pnAyVYrGe/pgLIt4gblNT4t/C98d8oYp4kDBD26rXyvnd6q952WjW0zsf+ijTcT2S3
         jY5g==
X-Gm-Message-State: ANoB5plA4HbGrDwOjn52XXxrJd8piY3C4YjBu6pQhpezRdtvC6S11zmB
        n4rJlX/qdLglMttW37honve0YlF2Quud6PcZ
X-Google-Smtp-Source: AA0mqf5KCwAZ9Y3h5nH8FFGsWA2hY5gk2zc2utCRgIgpxYnIKS1gwM4fcnCyDvyPa6I2sXO05z6qXg==
X-Received: by 2002:a17:903:2687:b0:189:985c:849d with SMTP id jf7-20020a170903268700b00189985c849dmr26244619plb.1.1670997490979;
        Tue, 13 Dec 2022 21:58:10 -0800 (PST)
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com. [209.85.214.177])
        by smtp.gmail.com with ESMTPSA id m13-20020a170902db0d00b00186b3c3e2dasm876379plx.155.2022.12.13.21.58.09
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Dec 2022 21:58:09 -0800 (PST)
Received: by mail-pl1-f177.google.com with SMTP id d7so2270409pll.9
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 21:58:09 -0800 (PST)
X-Received: by 2002:a17:90a:eacb:b0:219:33a1:d05f with SMTP id
 ev11-20020a17090aeacb00b0021933a1d05fmr140491pjb.116.1670997488508; Tue, 13
 Dec 2022 21:58:08 -0800 (PST)
MIME-Version: 1.0
References: <20221212-uvc-race-v2-0-54496cc3b8ab@chromium.org>
 <20221212-uvc-race-v2-2-54496cc3b8ab@chromium.org> <Y5kbXt5lUqUiCmCi@google.com>
In-Reply-To: <Y5kbXt5lUqUiCmCi@google.com>
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Wed, 14 Dec 2022 06:57:56 +0100
X-Gmail-Original-Message-ID: <CANiDSCs4onzD-OBYubJpGfyfPGcpMEPfPT8OKd_Q3UtNN1XciA@mail.gmail.com>
Message-ID: <CANiDSCs4onzD-OBYubJpGfyfPGcpMEPfPT8OKd_Q3UtNN1XciA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] media: uvcvideo: Do not alloc dev->status
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     Max Staudt <mstaudt@google.com>, Yunke Cao <yunkec@chromium.org>,
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

Hi Sergey

Thanks for the review

On Wed, 14 Dec 2022 at 01:40, Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> On (22/12/13 15:35), Ricardo Ribalda wrote:
> [..]
> > +++ b/drivers/media/usb/uvc/uvcvideo.h
> > @@ -559,7 +559,7 @@ struct uvc_device {
> >       /* Status Interrupt Endpoint */
> >       struct usb_host_endpoint *int_ep;
> >       struct urb *int_urb;
> > -     u8 *status;
> > +     u8 status[UVC_MAX_STATUS_SIZE];
>
> Can we use `struct uvc_control_status status;` instead of open-coding it?
> Seems that this is what the code wants anyway:

It can also be a `struct uvc_streaming_status`

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/media/usb/uvc/uvc_status.c#n230

so we always need the casting :(

>
>         struct uvc_control_status *status =
>                                 (struct uvc_control_status *)dev->status;
>
> And then we can drop casts in uvc_status_complete().



-- 
Ricardo Ribalda
