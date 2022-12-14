Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 294CA64C3A9
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 07:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236681AbiLNGC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 01:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiLNGC0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 01:02:26 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2482314D
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 22:02:25 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id z8-20020a17090abd8800b00219ed30ce47so6038245pjr.3
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 22:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y3wvzNb4An2722lfkqh3fmBoY3mTWiD+rqY9yqhR0iE=;
        b=YhhTu7Uvdu+rr4vXHYvD+ZYLkeyMFty/eEKxZQ7IcEbDQgMh8BvFRrdYmklVkEl1mR
         GGPttQFfeBqkksbgnqF+Z2jp6AAUbsE1vDTUsAv9ThKkpOjueVWjGMkDO4FuSvNPhM8H
         Fow5FFfv9QSBQUNVaLaI3myXHOSUkIDbQuBkc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y3wvzNb4An2722lfkqh3fmBoY3mTWiD+rqY9yqhR0iE=;
        b=m4Rq2aIliT164nntJ9LM/7w29w7nD9kOsx8LPWHhgvXRNz1Gusx5muLCsbkQ5MyFKW
         YHIWF/h8t10XT2KjPeQzZ3NLeejrY48dxY3uLyoYaRmYX4cwhFiVOtqKv8pdjNgrlbBF
         HTk+kVbDPCRxEFj317ktwh1M32N1O9OIHq+sxJ8luPYqvs0to2OXm9otQswEBmuMKl+f
         bpgz2oZ7SmAxbryXNNuRukT/CksXaTMF12XAjgwjAYt4BvG2z1DakdnjlqTBevszQWlz
         kz5BMiNCj8nhm5Ygkd2XRAmHhgaJc/61Z5lqNxn0VEnxVDJDW+db6NWB6NC2pNdqNxAN
         bO1w==
X-Gm-Message-State: ANoB5plEsrsIc7TxJM8Gu+bRJCvNqyMgO/zCo+4BIHcXuSaHgGNvCS6D
        ytTY/ngk24gptGvwG8u+Rqhs5A==
X-Google-Smtp-Source: AA0mqf5OqwMBLdnTMOht2wu4zlBlEJL/mySt6yqYcnSTaLhWTSdRIVmWpPzKF9x739T9CqdyIXALQw==
X-Received: by 2002:a17:902:ef47:b0:187:1b7a:6930 with SMTP id e7-20020a170902ef4700b001871b7a6930mr28179454plx.6.1670997745203;
        Tue, 13 Dec 2022 22:02:25 -0800 (PST)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id z1-20020a170902d54100b0017f5ad327casm911215plf.103.2022.12.13.22.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 22:02:24 -0800 (PST)
Date:   Wed, 14 Dec 2022 15:02:20 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Ricardo Ribalda <ribalda@chromium.org>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Max Staudt <mstaudt@google.com>,
        Yunke Cao <yunkec@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] media: uvcvideo: Do not alloc dev->status
Message-ID: <Y5lm7EgpelHbZa8J@google.com>
References: <20221212-uvc-race-v2-0-54496cc3b8ab@chromium.org>
 <20221212-uvc-race-v2-2-54496cc3b8ab@chromium.org>
 <Y5kbXt5lUqUiCmCi@google.com>
 <CANiDSCs4onzD-OBYubJpGfyfPGcpMEPfPT8OKd_Q3UtNN1XciA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANiDSCs4onzD-OBYubJpGfyfPGcpMEPfPT8OKd_Q3UtNN1XciA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On (22/12/14 06:57), Ricardo Ribalda wrote:
> > On (22/12/13 15:35), Ricardo Ribalda wrote:
> > [..]
> > > +++ b/drivers/media/usb/uvc/uvcvideo.h
> > > @@ -559,7 +559,7 @@ struct uvc_device {
> > >       /* Status Interrupt Endpoint */
> > >       struct usb_host_endpoint *int_ep;
> > >       struct urb *int_urb;
> > > -     u8 *status;
> > > +     u8 status[UVC_MAX_STATUS_SIZE];
> >
> > Can we use `struct uvc_control_status status;` instead of open-coding it?
> > Seems that this is what the code wants anyway:
> 
> It can also be a `struct uvc_streaming_status`
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/media/usb/uvc/uvc_status.c#n230
> 
> so we always need the casting :(

Then perhaps we can put both of them into anon union in struct uvc_device
as stream_status and control_status?
