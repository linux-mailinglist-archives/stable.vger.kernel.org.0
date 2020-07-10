Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36D521AD50
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 05:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgGJDPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 23:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbgGJDPE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jul 2020 23:15:04 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A139C08C5DD
        for <stable@vger.kernel.org>; Thu,  9 Jul 2020 20:15:04 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id s20so2242310vsq.5
        for <stable@vger.kernel.org>; Thu, 09 Jul 2020 20:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0xK96ZEj03BYxsiwTCEC7aLn5QyV2i1PW83BHZdlgiE=;
        b=iz5+7TZuV43ycSJaAM7QXsHXHZMrqwe1VHhvH7nzaLRNqyuSzRIKsTm9ZY6hcyT6xL
         rUeURvW6GTpfMb+6hgPG7XBznhNpcnfnoWcODmOEsJARCaoCb5xul+H0TsOjwz8m0Gpt
         8etFgsVIuVEHJxU8FqnuyA13ZWtKyl5k05Cmg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0xK96ZEj03BYxsiwTCEC7aLn5QyV2i1PW83BHZdlgiE=;
        b=a74woxa5OfEhy61WIOEwTHSn9VwCUuMdrbQefp7GEIpNTK4KrulAc+72WRxLPFJ8Ea
         cARY7gF+ihxTbjO+MGOURcTa/CIKIQ/Z0PtW9UMMrtF7UMaL/dwf2xhc+Wq95NhGjhDI
         jVLu0Sak+7EVmwgXz6JqBArRgvuZMD7GHcxiKYX4tb1+YMT6lnsM/wZY2U+eSU6l/NUb
         v8brVTQXeYEtiWBMRIGHK/ESAgNTBBE0Fl6jr8cUMtYlau5OSXemYqyfI/KxRS31WR0d
         hmBBVQdDGLTwg0DGu2mUgERoQX1OioRjuSNsak0mJrDjrJbItQeYs8JU2BYDQDKtU/US
         U7gQ==
X-Gm-Message-State: AOAM530CyJudwIVS+k5RP2xFEp56Hw+n2Nk02oDiK1HJ8V9sy+Lf7zMW
        aWql+YjmABRyTF3oMQssLP8o9GnonOK4NcswuK/6CQ==
X-Google-Smtp-Source: ABdhPJwwWTRG9i6cMBcyGYThfNXEyr1KpiR5j0/N7lIP76+Rz5QR86zchLcWA1ir6x7GGNOpx8rJ1ZOQxoECbAD4Myo=
X-Received: by 2002:a67:e0c3:: with SMTP id m3mr52687562vsl.1.1594350903351;
 Thu, 09 Jul 2020 20:15:03 -0700 (PDT)
MIME-Version: 1.0
References: <1594348182-431-1-git-send-email-chunfeng.yun@mediatek.com>
In-Reply-To: <1594348182-431-1-git-send-email-chunfeng.yun@mediatek.com>
From:   Nicolas Boichat <drinkcat@chromium.org>
Date:   Fri, 10 Jul 2020 11:14:52 +0800
Message-ID: <CANMq1KA2kT1yLGqhJFBKt4sRzzE6r=ABkSX59S-Mjr8Dg8sTOQ@mail.gmail.com>
Subject: Re: [PATCH] usb: xhci-mtk: fix the failure of bandwidth allocation
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc:     Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Ikjoon Jang <ikjn@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 10, 2020 at 10:30 AM Chunfeng Yun <chunfeng.yun@mediatek.com> wrote:
>
> The wMaxPacketSize field of endpoint descriptor may be zero
> as default value in alternate interface, and they are not
> actually selected when start stream, so skip them when try to
> allocate bandwidth.
>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>

Add this?
Fixes: 0cbd4b34cda9dfd ("xhci: mediatek: support MTK xHCI host controller")

> ---
>  drivers/usb/host/xhci-mtk-sch.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/usb/host/xhci-mtk-sch.c b/drivers/usb/host/xhci-mtk-sch.c
> index fea5555..45c54d56 100644
> --- a/drivers/usb/host/xhci-mtk-sch.c
> +++ b/drivers/usb/host/xhci-mtk-sch.c
> @@ -557,6 +557,10 @@ static bool need_bw_sch(struct usb_host_endpoint *ep,
>         if (is_fs_or_ls(speed) && !has_tt)
>                 return false;
>
> +       /* skip endpoint with zero maxpkt */
> +       if (usb_endpoint_maxp(&ep->desc) == 0)
> +               return false;
> +
>         return true;
>  }
>
> --
> 1.9.1
> _______________________________________________
> Linux-mediatek mailing list
> Linux-mediatek@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-mediatek
