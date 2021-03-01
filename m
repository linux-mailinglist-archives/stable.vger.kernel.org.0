Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36EA328939
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239032AbhCARwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238546AbhCARqp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 12:46:45 -0500
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D6CC06178A
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 09:45:46 -0800 (PST)
Received: by mail-qv1-xf2f.google.com with SMTP id 2so8531651qvd.0
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 09:45:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PD3JMEGPBMAQ64FzulYdR1M5uBdrgMdbqrpY0r6PxbE=;
        b=Tb+Vlk0QlCwVJFToJ87JOngaMMv+ji6DZc7e5ZFG7GeUBZVJjVsviwrA3Icbt2It49
         b+lEbIhvlsmsEC22BJp5Tr3E0FOrWQqGSiNwVwYitmJ85kYrCSYjzNeRUwcgpzmMrRhf
         2BAqhxxTKLWn5EE9XxRnQyN8q+S02GiuVJjhQGsWQmW8CEumtNaIliPL7K0vyxC1fzXD
         Xsxf8uXkTKqar0dafQc8CdQDNJLNCpWVHzvRQg6U9fzB9bklS3rMNLXS6p4ASORha0r6
         ltXeli2TAwCBVF8xorWL+lRT+cu/LEt2G5a7+t/IpNYgIXAJx/xP8rlp3uHvCr0/9eSY
         K9jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PD3JMEGPBMAQ64FzulYdR1M5uBdrgMdbqrpY0r6PxbE=;
        b=dfTJW9kV28TnWzYBpyzAi/DV2E5YDbEwIO1l6oQJ5I2R8Ry2uXXd/Nh2pFZUhLORku
         VF0Ub9DrhMPNWODjkc/gqrJElJEzfu+LoEyhN4IrntPdGvjoL7LxMTJTsYHIYIMJMEkF
         JvJpYm4Ph7pNtJvXtaMmhwvPl3D/uyA1i2kybnRYRDgryc03oN73KsLWRWnQOoYiXs/S
         hs6MhICzORw60VnKRpDCkLiFyO8fMd9zdv2CM5zUf8szT5FLWk4EQMKpAL80XdocuVO9
         IWYKPdBsGsFy8/5EAYQjLl2r3bNmHUXltrf/0KSPO1pauWxYwf32RNzhRnjjXBlOtSJ5
         F3Nw==
X-Gm-Message-State: AOAM5324FECMuW4dfLOdL0E+qk4VotLDkpdB3RtPF+G0R1yE7Q3glC5s
        kr6j+xi2hGtXOUrc3U66VTycvzsI+0p3YRdJqowfmrFMfyc=
X-Google-Smtp-Source: ABdhPJztWkIjeVzpCchcDL6XSRsDhMDv4ku/6n6WKul9YqeLxjiUenf3mLa6vOSSBcg1UZWOFGlBLJjYuXt4o7py51M=
X-Received: by 2002:a0c:b912:: with SMTP id u18mr15823346qvf.2.1614620745294;
 Mon, 01 Mar 2021 09:45:45 -0800 (PST)
MIME-Version: 1.0
References: <20210212192658.3476137-1-dmitry.baryshkov@linaro.org>
 <YCeM+0JUEPQQkGsF@kroah.com> <CAA8EJpo-U74KAyoHY=9wutk=iCOBMv6T1Ez-MEogYdPE6X1yCQ@mail.gmail.com>
 <YD0M4JyBbUrYjFMD@kroah.com>
In-Reply-To: <YD0M4JyBbUrYjFMD@kroah.com>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date:   Mon, 1 Mar 2021 20:45:34 +0300
Message-ID: <CAA8EJprTwqFWfPMjLrA2T0rJ=D3btLFHwY33VVJka1Og-9UeAQ@mail.gmail.com>
Subject: Re: [PATCH v2] misc: fastrpc: restrict user apps from sending kernel
 RPC messages
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Jonathan Marek <jonathan@marek.ca>, stable@vger.kernel.org,
        Nicolas Dechesne <nicolas.dechesne@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 1 Mar 2021 at 18:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Mar 01, 2021 at 06:34:10PM +0300, Dmitry Baryshkov wrote:
> > On Sat, 13 Feb 2021 at 11:25, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Fri, Feb 12, 2021 at 10:26:58PM +0300, Dmitry Baryshkov wrote:
> > > > Verify that user applications are not using the kernel RPC message
> > > > handle to restrict them from directly attaching to guest OS on the
> > > > remote subsystem. This is a port of CVE-2019-2308 fix.
> > >
> > > A port of the fix of what to what?
> >
> > I'm sorry for the confusion. It is a port of the original
> > Qualcomm/CodeAurora fix to the upstream driver.
> >
> > See https://source.codeaurora.org/quic/la/kernel/msm-4.9/commit/?id=cc2e11eeb988964af72309f71b0fb21c11ed6ca9,
>
> So this is a fix from 2019 that you never submitted upstream causing all
> of these kernels to be vulnerable?

It seems there is some kind of confusion here.
Srinivas and Thierry have developed the fastrpc driver. It is not the
same as the driver developed by Qualcomm. However in this case it
suffers from the same problem as the original adsprpc driver..
We have submitted the fix as soon as we've noticed the issue.

> Shouldn't the porting process go the other way, upstream first and then
> backport?  That ensures we don't end up with 2 years old bugs like this
> :(
>
> Ugh.
>
> What's going to change in the development process of this code to
> prevent this from happening again?

-- 
With best wishes
Dmitry
