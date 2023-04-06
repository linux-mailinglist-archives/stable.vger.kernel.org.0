Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 960676D8F81
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 08:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235498AbjDFGeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 02:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235480AbjDFGeT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 02:34:19 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D48FA24D
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 23:34:16 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 185so11988134pgc.10
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 23:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680762856;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ywRy2NXg/YzPGPsQQtseGk+ykosJNLGdFknAZq9oon8=;
        b=SAJGqK+/VO4Kto7Td+yYhsLmaOk7HrEBQbs3efgqgCbat5ZLAhp8+7A64Ttj+QL4Ol
         kMoPp46DeleCcru+sKESaaS4XM8ojsMov4kZwNlNa50x3yChuEl72k/EwiJTJSoZqyvu
         lQ+tanhKOzHQ57N5CyFVO/lPL4ioc+kZIXfDcRZP2Sn7RoWZZXcu8cVe8uYVotuX+vLH
         0lTtWjAVgfNB3YW+nlyP+cQ09U3HbvNmVPfL8Lu64z/oi02i4r26PbgHCxm496DzVioK
         mmTbSN81gjo2RmFNF0vgxkrm3vXkwoTucl/0hout5Ksx3y6KrzCJfT47HD/rPnQjyXcm
         VBSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680762856;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ywRy2NXg/YzPGPsQQtseGk+ykosJNLGdFknAZq9oon8=;
        b=Ap/NylpR4i2Tw9VxVA0uvtHRF/NrVt69ppqnRTMDlvwtCGlY6xYZi3rk/AfHnMpKI2
         3IqhpnaVSp+Gj19Wavkx8FNslHyfgxKO3B+4y1Lo1R+CXTEaa10U8OF+YPUtaFCEXiWG
         QLX0M3uqs26aFS3Jwry9BsqKfsCcNR+uM+EEjW+WIHrC9qZyftRIOI1V+Xaihwtwoqy5
         1TMUZNtRh+ekT82wiTfkJnIaD2OsQSbOqkAdiFHMK1f/qhefWY8RAxubMm36JY7TyoVy
         KA5qO1i/OMhPyWhHiC33BGuIsNhv21WwVIyfgOKtTUIZSR314494GqM7nY/8xvltLc/L
         As6Q==
X-Gm-Message-State: AAQBX9f/ujwepn3GCLLYDMrBlxd1YMLIFod197mmudnezNq86ss1kfi7
        7suT4aOAR+dcRV8q5dFMjWXp8HyDEPs+4tao8iq9Mw==
X-Google-Smtp-Source: AKy350ZIR5QFT05CqoEKBHsSl5AdBctVFfha1iZRBdPWiB2ybG0JLlr1rtZDtUXKC1sPXgDpQ9x/mOpGRV/wttLQXGw=
X-Received: by 2002:a63:e148:0:b0:503:7bbb:9a77 with SMTP id
 h8-20020a63e148000000b005037bbb9a77mr2897768pgk.8.1680762855762; Wed, 05 Apr
 2023 23:34:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230405093133.1858140-1-badhri@google.com> <56abca17-7240-4bd5-98db-ef48059ff315@rowland.harvard.edu>
In-Reply-To: <56abca17-7240-4bd5-98db-ef48059ff315@rowland.harvard.edu>
From:   Badhri Jagan Sridharan <badhri@google.com>
Date:   Wed, 5 Apr 2023 23:33:39 -0700
Message-ID: <CAPTae5KxVj_F_4Z0Dh00C-SvKRgJMfUPFOuoUU5ZDW87WgMRBA@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] usb: gadget: udc: core: Invoke usb_gadget_connect
 only when started
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     gregkh@linuxfoundation.org, colin.i.king@gmail.com,
        xuetao09@huawei.com, quic_eserrao@quicinc.com,
        water.zhangjiantao@huawei.com, peter.chen@freescale.com,
        balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> No blank line after cc: stable, and put the fixes above your
signed-off-by line please.

Fixed all commit message related concerns.

> Why a global lock?  Shouldn't this be a per-device lock?

Ack ! Addressed this in V2.

On Wed, Apr 5, 2023 at 6:29=E2=80=AFPM Alan Stern <stern@rowland.harvard.ed=
u> wrote:
>
> On Wed, Apr 05, 2023 at 09:31:32AM +0000, Badhri Jagan Sridharan wrote:
> > usb_udc_connect_control does not check to see if the udc
> > has already been started. This causes gadget->ops->pullup
> > to be called through usb_gadget_connect when invoked
> > from usb_udc_vbus_handler even before usb_gadget_udc_start
> > is called. Guard this by checking for udc->started in
> > usb_udc_connect_control before invoking usb_gadget_connect.
> >
> > Guarding udc_connect_control, udc->started and udc->vbus
> > with its own mutex as usb_udc_connect_control_locked
> > can be simulataneously invoked from different code paths.
> >
> > Cc: stable@vger.kernel.org
> >
> > Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
> > Fixes: 628ef0d273a6 ("usb: udc: add usb_udc_vbus_handler")
>
> There's a problem with this patch.
>
> > ---
> >  drivers/usb/gadget/udc/core.c | 20 ++++++++++++++++----
> >  1 file changed, 16 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/cor=
e.c
> > index 3dcbba739db6..890f92cb6344 100644
> > --- a/drivers/usb/gadget/udc/core.c
> > +++ b/drivers/usb/gadget/udc/core.c
>
> > @@ -1140,14 +1145,18 @@ static inline int usb_gadget_udc_start(struct u=
sb_udc *udc)
> >  {
> >       int ret;
> >
> > +     mutex_lock(&udc_connect_control_lock);
> >       if (udc->started) {
> >               dev_err(&udc->dev, "UDC had already started\n");
> > +             mutex_unlock(&udc_connect_control_lock);
> >               return -EBUSY;
> >       }
> >
> >       ret =3D udc->gadget->ops->udc_start(udc->gadget, udc->driver);
> >       if (!ret)
> >               udc->started =3D true;
> > +     usb_udc_connect_control_locked(udc);
> > +     mutex_unlock(&udc_connect_control_lock);
>
> You moved the connect_control call up here, into usb_gadget_udc_start().

Have moved it back into gadget_bind_driver.

>
> >       return ret;
> >  }
> > @@ -1165,13 +1174,17 @@ static inline int usb_gadget_udc_start(struct u=
sb_udc *udc)
> >   */
> >  static inline void usb_gadget_udc_stop(struct usb_udc *udc)
> >  {
> > +     mutex_lock(&udc_connect_control_lock);
> >       if (!udc->started) {
> >               dev_err(&udc->dev, "UDC had already stopped\n");
> > +             mutex_unlock(&udc_connect_control_lock);
> >               return;
> >       }
> >
> >       udc->gadget->ops->udc_stop(udc->gadget);
> >       udc->started =3D false;
> > +     usb_udc_connect_control_locked(udc);
> > +     mutex_unlock(&udc_connect_control_lock);
> >  }
> >
> >  /**
> > @@ -1527,7 +1540,6 @@ static int gadget_bind_driver(struct device *dev)
> >       if (ret)
> >               goto err_start;
> >       usb_gadget_enable_async_callbacks(udc);
> > -     usb_udc_connect_control(udc);
>
> This is where it used to be.
>
> The problem is that in the gadget_bind_driver pathway,
> usb_gadget_enable_async_callbacks() has to run _before_ the gadget
> connects.  Maybe you can fix this by leaving the function call in its
> original location and protecting it with the new mutex?
>
> There may be a similar problem with disconnecting and the
> gadget_unbind_driver pathway (usb_gadget_disable_async_callbacks() has to
> run _after_ the disconnect occurs).  I haven't tried to follow the patch
> in enough detail to see whether that's an issue.

Thanks for explaining what's the expectation here. I have incorporated
the feedback in v2.
The new lock now additionally guards  gadget->connect and gadget->deactivat=
e as
well. Guarding all with the new lock as they are related to one another.
I have made sure that the gadget_bind_driver and gadget_unbind_driver
sequence remains unaltered.

>
> Alan Stern
>
> >
> >       kobject_uevent(&udc->dev.kobj, KOBJ_CHANGE);
> >       return 0;
> >
> > base-commit: d629c0e221cd99198b843d8351a0a9bfec6c0423
> > --
> > 2.40.0.348.gf938b09366-goog
> >
