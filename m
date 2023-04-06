Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07D986D8F71
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 08:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234979AbjDFGbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 02:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234582AbjDFGbs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 02:31:48 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E2B2127
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 23:31:47 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id j13so36393362pjd.1
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 23:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680762706;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=obqxU2mz+jsw4Hq+pdxHcftpRbpV6+H1hg2uFdKXnJg=;
        b=ptJ5Ich+H+NtwSCosTGyCsY/Pp8sDLBBsJO3lvmHJWFzVRghQY6PrLbGWedx3zug+q
         wSAXcIfZKbYI8+XSF4EtFioPbIG+l4U+P4n4GbbdLj2DUQZBpHOTn2K/AtKxAc79YakZ
         6Fzw/Zdad+E4P8kZ4z4AZwliiD7Jf04Hx9CUtIWhtkkDd12bdxiuiv7zknh/YMlnuMqx
         kfykzcr+Y+DK+HRFlA4++5JDf+LdXpA9olP5rj+AqMId4X1H566ZHEWgk6IJYvwJF8YD
         EQO8+qrAhPiWtTravKJwe8WwDGc6xdXJDJsTrTcxEqIMmT7gOcaG6uOHN0bpsebBEeaz
         0Dag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680762706;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=obqxU2mz+jsw4Hq+pdxHcftpRbpV6+H1hg2uFdKXnJg=;
        b=2BmM46EEmxknlIAhJHSO0zWY71nf0gQBcjb9RB/8rI4uhv16FlOnUtEHag+VYyCUvE
         4FclE8tVAOXD7lsD9/GZFhN9Y5cwPKtyCF7jHam9QLs2vh4Q7fSunWGoqfDXrYMSaa2j
         pp4hgZ2M0UKIDbkSZNG/i9sGjBZ/m/yq3oicr8VXuAm26K7nY46XADjMjupDUn6tRWxh
         +bSDIBWKqVYMr5bghKZ5krhoADYVaYNSS6PxPMqBvmhJZ6o3G/3MUvUyGsD+zPsxTMhm
         jURutrUfKlK+bDsU+qOV1+iL+lTTByrTZzeNrnVKV25D9pxWejB7AT0R6I1W/xhs/+zf
         AACg==
X-Gm-Message-State: AAQBX9fR7QO2Bvvqfemp/Iq4ARpL0fQ4wjfW9vhdMChGLc8gOIJmjJTF
        n6H+Ghs0ZSjBrSDjWpF0XJJCWrtmBqsdAzwcl90SQQ==
X-Google-Smtp-Source: AKy350bD/Y64vs0qD2MjbI2NJK9P6rHL4AOtwZ1mlHpfcDrjjo6HIcGlm9zSWVu5nF5ZmUVlW1s6jp7cSID+mqvlTXA=
X-Received: by 2002:a17:90b:1083:b0:244:9620:c114 with SMTP id
 gj3-20020a17090b108300b002449620c114mr318232pjb.1.1680762706468; Wed, 05 Apr
 2023 23:31:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230406061905.2460827-1-badhri@google.com> <ZC5m0onNYztT4Zbl@kroah.com>
In-Reply-To: <ZC5m0onNYztT4Zbl@kroah.com>
From:   Badhri Jagan Sridharan <badhri@google.com>
Date:   Wed, 5 Apr 2023 23:31:10 -0700
Message-ID: <CAPTae5J40pmziEk6k0iBEuJ7=NMeFdnk-hkzUCibqRj4aGbzjQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] usb: gadget: udc: core: Invoke usb_gadget_connect
 only when started
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stern@rowland.harvard.edu, colin.i.king@gmail.com,
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

On Wed, Apr 5, 2023 at 11:29=E2=80=AFPM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> On Thu, Apr 06, 2023 at 06:19:04AM +0000, Badhri Jagan Sridharan wrote:
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
> > ---
> >  drivers/usb/gadget/udc/core.c | 20 ++++++++++++++++----
> >  1 file changed, 16 insertions(+), 4 deletions(-)
>
> Why resend v1 when it's been reviewed already?

I just now sent a note.
Apologies resent V1 again instead of V2. Have sent V2 for real.
Sorry for the confusion.

>
> confused,
>
> greg k-h
