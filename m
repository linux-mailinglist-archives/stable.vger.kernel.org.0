Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCF338775C
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 13:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbhERLYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 07:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbhERLYB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 07:24:01 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37DC2C061756
        for <stable@vger.kernel.org>; Tue, 18 May 2021 04:22:43 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id c15so11081875ljr.7
        for <stable@vger.kernel.org>; Tue, 18 May 2021 04:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rdF8gyGM2Z+kErBHsZUshH2jdfE4Xe2DvLEUbreL60U=;
        b=1sVP6RY0xs/XVwcMfqv4WRnrwBmXXikMvu1TQJKiSO31kX9DZeKI57xT+5FL0EYx1x
         +3seia/Q7r5h7t6ZX35ELEdvGoxEQN2T+MqDHUIEWCv96cL1r+ib3Z0JLTGMluRQFJDL
         ZUAZWmEylF+8OtZq5QDeIdlekR4sGDmh+TZkuh7Q+mKEpenzoml7GtYeQPr4FvABvqN9
         WnDh7EvM+OCrxIH64AwUMxFQONX8SXJpO6PsaBP/1rl+B6T7zghl78igm41gBSQbVquJ
         5mXB/Jcm/wkOODAxd2CfZ33ptYVHR7L2HVg5ADTZa1YUH3mJ99LL3bg3d4tnMc2xWxZJ
         TKJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rdF8gyGM2Z+kErBHsZUshH2jdfE4Xe2DvLEUbreL60U=;
        b=mlWA98t6eFEpUCprFLTa4f0cAZhA2IFlny/EeXdCiwcwvNehx1ylTNPZyoZZrxRk8Q
         pusPJ2D6HqGwdO0eJgSn4I1kWYsFQOOnSdXGulWLAV0ZwLMM8DakVX7NbgxRjeaeqk3m
         qZfrhX+3SO+VOPj+6BMnjGOGgt+hdINDde+SyB9QFMQ7OR0TpnO33HVS/QcaJ9gpxiQw
         R+CvxU/Pj9zxcCBXla09KWGbxFyKXPdFYJI0bXJJwLqIA835CqHOHVkGwkzKUDHKDtIn
         IdaClnJmHqf4fdqpGz3sSVe/cie/dq1huGk1hj1DDihnXdBFy9SZMzH5eDOtaWHvkMqs
         h5pg==
X-Gm-Message-State: AOAM5326cULlqCpJTdskOoj7MyCW6Do5MuFocALONNPXaQDimkCT68Su
        fZGgDR+JrifuwtmKLTjwpr4tdM6RGcAadgcLe5Pu4g==
X-Google-Smtp-Source: ABdhPJxBW/CEWIJES064VALHXUE3Rx9StlZhCWBm/mjDDQH6cTQbrZrHxWnR9ESSztRpf6Wum7KRjECmh/vA1A7fvFI=
X-Received: by 2002:a05:651c:156:: with SMTP id c22mr3703525ljd.175.1621336961673;
 Tue, 18 May 2021 04:22:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210518090925.15480-1-pdk@semihalf.com> <YKOI9ndTg8s1uUvx@kroah.com>
In-Reply-To: <YKOI9ndTg8s1uUvx@kroah.com>
From:   Patryk Duda <pdk@semihalf.com>
Date:   Tue, 18 May 2021 13:22:30 +0200
Message-ID: <CAGOBvLq8hyRs7MZoZE0o0h0s9y1bL9eV3ex2A3FsmfjtofxsAg@mail.gmail.com>
Subject: Re: [PATCH] platform/chrome: cros_ec_proto: Send command again when
 timeout occurs
To:     Greg KH <greg@kroah.com>
Cc:     Benson Leung <bleung@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        linux-kernel@vger.kernel.org, upstream@semihalf.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

wt., 18 maj 2021 o 11:29 Greg KH <greg@kroah.com> napisa=C5=82(a):
>
> On Tue, May 18, 2021 at 11:09:25AM +0200, Patryk Duda wrote:
> > Sometimes kernel is trying to probe Fingerprint MCU (FPMCU) when it
> > hasn't initialized SPI yet. This can happen because FPMCU is restarted
> > during system boot and kernel can send message in short window
> > eg. between sysjump to RW and SPI initialization.
> >
> > Cc: <stable@vger.kernel.org> # 4.4+
> > Signed-off-by: Patryk Duda <pdk@semihalf.com>
> > ---
> > Fingerprint MCU is rebooted during system startup by AP firmware (coreb=
oot).
> > During cold boot kernel can query FPMCU in a window just after jump to =
RW
> > section of firmware but before SPI is initialized. The window was
> > shortened to <1ms, but it can't be eliminated completly.
> >
> > Communication with FPMCU (and all devices based on EC) is bi-directiona=
l.
> > When kernel sends message, EC will send EC_SPI* status codes. When EC i=
s
> > not able to process command one of bytes will be eg. EC_SPI_NOT_READY.
> > This mechanism won't work when SPI is not initailized on EC side. In fa=
ct,
> > buffer is filled with 0xFF bytes, so from kernel perspective device is =
not
> > responding. To avoid this problem, we can query device once again. We a=
re
> > already waiting EC_MSG_DEADLINE_MS for response, so we can send command
> > immediately.
> >
> > Best regards,
> > Patryk
> >  drivers/platform/chrome/cros_ec_proto.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > diff --git a/drivers/platform/chrome/cros_ec_proto.c b/drivers/platform=
/chrome/cros_ec_proto.c
> > index aa7f7aa77297..3384631d21e2 100644
> > --- a/drivers/platform/chrome/cros_ec_proto.c
> > +++ b/drivers/platform/chrome/cros_ec_proto.c
> > @@ -279,6 +279,18 @@ static int cros_ec_host_command_proto_query(struct=
 cros_ec_device *ec_dev,
> >       msg->insize =3D sizeof(struct ec_response_get_protocol_info);
> >
> >       ret =3D send_command(ec_dev, msg);
> > +     /*
> > +      * Send command once again when timeout occurred.
> > +      * Fingerprint MCU (FPMCU) is restarted during system boot which
> > +      * introduces small window in which FPMCU won't respond for any
> > +      * messages sent by kernel. There is no need to wait before next
> > +      * attempt because we waited at least EC_MSG_DEADLINE_MS.
> > +      */
> > +     if (ret =3D=3D -ETIMEDOUT) {
> > +             dev_warn(ec_dev->dev,
> > +                      "Timeout to get response from EC. Retrying.\n");
>
> If a user sees this, what can they do?  No need to spam the kernel logs,
> just retry.
User can do nothing about it. I will remove this in next version of patch.
>
> > +             ret =3D send_command(ec_dev, msg);
>
> But wait, why just retry once?  Why not 10 times?  100?  1000?  How
> about a simple loop here instead, with a "sane" number of retries as a
> max.
EC based devices are designed to respond always or return appropriate
status code
when they can't process command. But this assumes that SPI is always
ready to work.
It's true for Embedded Controller, but not for Fingerprint MCU. So we
can retry once,
in case of sending message, when FPMCU is in narrow window (~1ms) when SPI =
is
not initialized.

Every send_command() call can take about 200ms when device is not respondin=
g,
so next retry will happen after 200ms, at least. If 200ms is not
enough for FPMCU
to initialize SPI, it's definitely something wrong with FPMCU
>
> thanks,
>
> greg k-h

Best regards,
Patryk
