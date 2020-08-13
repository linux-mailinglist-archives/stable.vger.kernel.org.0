Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B49243D9D
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 18:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbgHMQmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Aug 2020 12:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgHMQmJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Aug 2020 12:42:09 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B80FC061757
        for <stable@vger.kernel.org>; Thu, 13 Aug 2020 09:42:09 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id k4so6082893ilr.12
        for <stable@vger.kernel.org>; Thu, 13 Aug 2020 09:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m9BlMqUV6ljYxVac+By9qOQl8ybFvhfpvuPCuSEPo/4=;
        b=u6mzOeBzcpekDy8PnvQH7HLhgTufaWeBzWJ0ogxg1ZEgXTzPv/1DMpAanhV9af9YAT
         KWOW6RkWMSo7T/p1c4gI43ObQ1JR6vndBV/WTQQwsD3pkJk1YgYGri9Wo7kQGpW9NYV6
         3iiN5FUb7ojrDGSf2nVS7C5qtrRiIp2mOzeBmR/R9tREo9mucWZcEVc8H6xzaiX8juUs
         84/JqhA6QeXoNlpgCQJL935MbUuDBn6d1ZHk3FpyDuDl2qOIF+4VDaAdLCCLhszd4K7d
         jj42bSG0nm6aPfQADMEWwsvbsxChVRL99AmiQnpLXwMksSj8lqzTcJVcHjubLI0x0u41
         v6nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m9BlMqUV6ljYxVac+By9qOQl8ybFvhfpvuPCuSEPo/4=;
        b=scB0+U4PCAWrNpkTSIOH+dUiLKcHrtbBvCxUD++/Vs2TFTAt4zBGfIdHKZF8jONDSH
         M7lNE590VNvEkmY+xFALe4f+x544tHDU0HzqIJ1QulQ5G25K/GLNfhrpAueOajBPpPoA
         uHTVr9V7ocMbe0CiwMxbuS5NdPLI5iQCEEsGP/xo1Mw+UfONiGoxsSUeYZTYHMBb2Av+
         I36qx440kdwUMBUWCUipPIA9hagrxHWJDbR3C5dhdfk4CS9mFYIkEShQuqdju8LPy9bf
         auZ96hzYx7K10XkHHAnaa+QDVVkx02cNZl86+OwJGdCOgvWLNzwhsoUZfpklVU7MPZrA
         JadQ==
X-Gm-Message-State: AOAM530/msQFDGuiQB59nf6CIZhqZBWID+hzq/3GJtmmsN446sAqn+Or
        FxB1g2w3U6m016vH7pWR/wQ6+lECx7TeBIjA/1cDYi0F
X-Google-Smtp-Source: ABdhPJyDXzpdNJp1MF8agnX81+f9QhlfRbJtYW9nBtV5yrvY6GovGQIUVfXyICdawcSmNuUg9s4hGpiozVyrg6DxoWM=
X-Received: by 2002:a05:6e02:13ec:: with SMTP id w12mr5638435ilj.196.1597336928745;
 Thu, 13 Aug 2020 09:42:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200709121232.9827-1-aford173@gmail.com> <CAHCN7x+crwfE4pfufad_WEUhiJQXccSZHot+YNDZzZKvqhrmWA@mail.gmail.com>
 <86992356-b902-d7da-ffd7-e8b98f9252fd@ti.com> <20200805143328.GD2154236@kroah.com>
 <df411c41-2b75-725e-9f49-4ca6124f3d4e@ti.com>
In-Reply-To: <df411c41-2b75-725e-9f49-4ca6124f3d4e@ti.com>
From:   Adam Ford <aford173@gmail.com>
Date:   Thu, 13 Aug 2020 11:41:57 -0500
Message-ID: <CAHCN7x+Hhx=pNidpBpmsT2_J6Og4ioC9Dq_aYa7vy8j-D8-waw@mail.gmail.com>
Subject: Re: [PATCH] omapfb: dss: Fix max fclk divider for omap36xx
To:     Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc:     Greg KH <greg@kroah.com>, stable <stable@vger.kernel.org>,
        Adam Ford-BE <aford@beaconembedded.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 6, 2020 at 4:46 AM Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
>
> Hi Greg,
>
> On 05/08/2020 17:33, Greg KH wrote:
> > On Tue, Aug 04, 2020 at 04:19:54PM +0300, Tomi Valkeinen wrote:
> >> On 04/08/2020 16:13, Adam Ford wrote:
> >>>
> >>>
> >>> On Thu, Jul 9, 2020 at 7:12 AM Adam Ford <aford173@gmail.com <mailto:aford173@gmail.com>> wrote:
> >>>
> >>>     There appears to be a timing issue where using a divider of 32 breaks
> >>>     the DSS for OMAP36xx despite the TRM stating 32 is a valid
> >>>     number.  Through experimentation, it appears that 31 works.
> >>>
> >>>     This same fix was issued for kernels 4.5+.  However, between
> >>>     kernels 4.4 and 4.5, the directory structure was changed when the
> >>>     dss directory was moved inside the omapfb directory. That broke the
> >>>     patch on kernels older than 4.5, because it didn't permit the patch
> >>>     to apply cleanly for 4.4 and older.
> >>>
> >>>     A similar patch was applied to the 3.16 kernel already, but not to 4.4.
> >>>     Commit 4b911101a5cd ("drm/omap: fix max fclk divider for omap36xx") is
> >>>     on the 3.16 stable branch with notes from Ben about the path change.
> >>>
> >>>     Since this was applied for 3.16 already, this patch is for kernels
> >>>     3.17 through 4.4 only.
> >>>
> >>>     Fixes: f7018c213502 ("video: move fbdev to drivers/video/fbdev")
> >>>
> >>>     Cc: <stable@vger.kernel.org <mailto:stable@vger.kernel.org>> #3.17 - 4.4
> >>>     CC: <tomi.valkeinen@ti.com <mailto:tomi.valkeinen@ti.com>>
> >>>     Signed-off-by: Adam Ford <aford173@gmail.com <mailto:aford173@gmail.com>>
> >>>
> >>>
> >>> Tomi,
> >>>
> >>> Can you comment on this?  The 4.4 is still waiting for this fix.  The other branches are fixed.
> >>
> >> Looks good to me.
> >>
> >> Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> >
> > I don't seem to have the original of this anymore, can someone please
> > resend it?
>
> I have attached the original.

Greg,

Do you have what you need?  I see all the other kernels have been had
the corresponding patches pushed, but 4.4 needed something different
due to some path / naming changes.

adam
>
>  Tomi
>
> --
> Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
> Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
