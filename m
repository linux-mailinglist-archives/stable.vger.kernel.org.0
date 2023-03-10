Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 785E16B3F07
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 13:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbjCJMTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 07:19:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbjCJMTW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 07:19:22 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DA4EBDAA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 04:19:08 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id n6so5336559plf.5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 04:19:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1678450747;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RyYoshxZ3LsechZe9ZsTvEq5Q44AfdDhCOd4VA4FxSE=;
        b=cnI/2ZRUwaAJ0LnEXCgbdVMeWosFi/t6grF7JPSkFMj1l1UZHG9Eh17PuDiUk3HHGR
         WS2ACdkyy5/iLin2JuEX+AJpjg4sL3lmf+9cLTj3w3DuIoNGw3vWfuIAQYK/cZEALR3/
         nojaxZH8Ae7BJqI2ZGZfei9rMClfkKU3qJQow=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678450747;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RyYoshxZ3LsechZe9ZsTvEq5Q44AfdDhCOd4VA4FxSE=;
        b=EHjxNfVAYgaOoZWhSaqpP2nq6sNlDA2Pfyvljv7PZPCxUgRA909m/oHruZeC7ak9DI
         rt8dJah5yGuK60Pjdw/JgSWtN2R1bpMLSUYUJkohwNvFjXzAJXWdYm6CuM3bfiTvzoct
         ZOxZB8LvapOU/+oWWPcs94DuM2Pf0H9M0M8LxEkNT2Y71XUY8Z0VBdoVK/l3vwdPC/19
         0K7Z63+OT94FWRHOvQ/AllC22Ga43H2iUWzTWaSlFqa/vZfkvNCu8UmyMpmONQVwccXn
         BBRnJ79/S1JD8ZNa6U/MQ1/OsU0DT5l+Qp6WU1nA7cdgtDN21iDBTWv2LIaqk7HnWM0i
         LO4g==
X-Gm-Message-State: AO0yUKURu+EAbkB0JVSRIycgwnZyns2HCNcvOrMgewDjMwE7o9S5C+TD
        Yv1TLk3GIM6A1hFH2T0YKHvRu2llBDxMSQ20lAE=
X-Google-Smtp-Source: AK7set8S2N9b8IqtU6eZQpsy+OIms7YMCXRknnYR8HU0KnOBpanaFbFw3GuOcni5QKl11n967rNJrg==
X-Received: by 2002:a17:902:a70a:b0:19d:1898:5b89 with SMTP id w10-20020a170902a70a00b0019d18985b89mr20064054plq.7.1678450747669;
        Fri, 10 Mar 2023 04:19:07 -0800 (PST)
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com. [209.85.215.181])
        by smtp.gmail.com with ESMTPSA id jk18-20020a170903331200b0019adbef6a63sm1314419plb.235.2023.03.10.04.19.07
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Mar 2023 04:19:07 -0800 (PST)
Received: by mail-pg1-f181.google.com with SMTP id d10so2896740pgt.12
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 04:19:07 -0800 (PST)
X-Received: by 2002:a63:8c1a:0:b0:503:7be3:e81d with SMTP id
 m26-20020a638c1a000000b005037be3e81dmr8928160pgd.1.1678450746631; Fri, 10 Mar
 2023 04:19:06 -0800 (PST)
MIME-Version: 1.0
References: <16781002113959@kroah.com> <20230308133025.191306-1-ribalda@chromium.org>
 <ZAsaiH4YhwHSDHOO@kroah.com> <ZAsf6wksYtH9/Ura@kroah.com>
In-Reply-To: <ZAsf6wksYtH9/Ura@kroah.com>
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Fri, 10 Mar 2023 13:18:55 +0100
X-Gmail-Original-Message-ID: <CANiDSCu2MJpKJrL3BmEwWgKhMmUwrob-p0D7s7rLaOxQYsJrCw@mail.gmail.com>
Message-ID: <CANiDSCu2MJpKJrL3BmEwWgKhMmUwrob-p0D7s7rLaOxQYsJrCw@mail.gmail.com>
Subject: Re: [PATCH 6.2.y] media: uvcvideo: Fix race condition with usb_kill_urb
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, Yunke Cao <yunkec@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg



On Fri, 10 Mar 2023 at 13:17, Greg KH <greg@kroah.com> wrote:
>
> On Fri, Mar 10, 2023 at 12:54:48PM +0100, Greg KH wrote:
> > On Wed, Mar 08, 2023 at 02:30:25PM +0100, Ricardo Ribalda wrote:
> > > usb_kill_urb warranties that all the handlers are finished when it
> > > returns, but does not protect against threads that might be handling
> > > asynchronously the urb.
> > >
> > > For UVC, the function uvc_ctrl_status_event_async() takes care of
> > > control changes asynchronously.
> > >
> > > If the code is executed in the following order:
> > >
> > > CPU 0                                       CPU 1
> > > =====                                       =====
> > > uvc_status_complete()
> > >                                     uvc_status_stop()
> > > uvc_ctrl_status_event_work()
> > >                                     uvc_status_start() -> FAIL
> > >
> > > Then uvc_status_start will keep failing and this error will be shown:
> > >
> > > <4>[    5.540139] URB 0000000000000000 submitted while active
> > > drivers/usb/core/urb.c:378 usb_submit_urb+0x4c3/0x528
> > >
> > > Let's improve the current situation, by not re-submiting the urb if
> > > we are stopping the status event. Also process the queued work
> > > (if any) during stop.
> > >
> > > CPU 0                                       CPU 1
> > > =====                                       =====
> > > uvc_status_complete()
> > >                                     uvc_status_stop()
> > >                                     uvc_status_start()
> > > uvc_ctrl_status_event_work() -> FAIL
> > >
> > > Hopefully, with the usb layer protection this should be enough to cover
> > > all the cases.
> > >
> > > Cc: stable@vger.kernel.org
> > > Fixes: e5225c820c05 ("media: uvcvideo: Send a control event when a Control Change interrupt arrives")
> > > Reviewed-by: Yunke Cao <yunkec@chromium.org>
> > > Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> > > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > (cherry picked from commit 619d9b710cf06f7a00a17120ca92333684ac45a8)
> > > Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> > > ---
> > >  drivers/media/usb/uvc/uvc_ctrl.c   |  5 ++++
> > >  drivers/media/usb/uvc/uvc_status.c | 37 ++++++++++++++++++++++++++++++
> > >  drivers/media/usb/uvc/uvcvideo.h   |  1 +
> > >  3 files changed, 43 insertions(+)
> >
> > This fails to apply to the 6.2.y queue right now:
> >
> > checking file drivers/media/usb/uvc/uvc_ctrl.c
> > Hunk #1 FAILED at 6.
> > Hunk #2 succeeded at 1509 (offset 67 lines).
> > 1 out of 2 hunks FAILED
> > checking file drivers/media/usb/uvc/uvc_status.c
> > checking file drivers/media/usb/uvc/uvcvideo.h
> > Hunk #1 succeeded at 559 (offset -1 lines).
> >
> > Can you redo this?
>
> I got 5.15.y and newer to work here on my own, can you redo the older
> ones as well?

Sure thanks!

>
> thanks,
>
> greg k-h



-- 
Ricardo Ribalda
