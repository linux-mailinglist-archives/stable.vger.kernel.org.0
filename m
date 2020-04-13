Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9421A66D4
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 15:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbgDMNTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 09:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729268AbgDMNTO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 09:19:14 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE6CC0A3BDC;
        Mon, 13 Apr 2020 06:19:13 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id i75so8384184ild.13;
        Mon, 13 Apr 2020 06:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BZzMZDGqgBwX4Xh7KHoiKVja3NDIa0mY3TIVJFbrBQY=;
        b=fJYKZ/XmwUlxghngbQncUbotyBqjvCuUw2LJVgWQ9jb3jOx+lm+N1xdJAtQhM3vxw/
         /5ezliLqrf7G6qxE+UmevZNoIm5mRLG7KqdHaMqVkP3OPuFQefozAdUHT44vGQwNaD/3
         dO+xR3VEELksN7X6CqKHHSbVhvhesiKQs+cNutrdrc3VKYk+xDokz4BjgktTz0cI3W8W
         slyUInVSN6vC9P+aEVNXOnznXVUi50vvhokf/FtLUxs0ewXWglLUGhIvlFEg14QroK1k
         asWmBJTxHYf3cibpHGBT8veXDXzuobFXk2Fcgae3z29OrMTLrbJNV+X7hEOoSskHwVrC
         xDvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BZzMZDGqgBwX4Xh7KHoiKVja3NDIa0mY3TIVJFbrBQY=;
        b=pK6m3/uGiZhh+GYbQWONcWSe+EcClunn1A2VeMahIHX3SWN31YPQuqq0W8Sd88A+z5
         GBkO2/iiNCg2qtaSLpbxV04fwytoFilA1T0Qn8dRV2gkXrsEYNafbzBVNe7Pgnch/J4/
         4FLVnQeJm2slt9n5NcqVcxPfiWE6vQGfSQNtuIL31f0vHPlBD2ARO9nRHAb8xKcMv6Sa
         mEfTOrq/dC5T/W3weFAuqHm5odwct7hpEW/2rYNVdPLA4Hhp56unsv2SjsL3xjeyw+k/
         TXJ2/Ur1kHHvk7n3Ns8AaAEdcQ0RHQtOr4WSdEPlGFLgV8nWSwA354jYlTuUKiAXOWeX
         vrJw==
X-Gm-Message-State: AGi0PuZJAOK44pBKVWcc+zg2Sbw0aPuUGo0mz+xoCu0poPLd1sJZJf9v
        W+DXwlrAepm4gURHOKQbLMQDqj8eaLYwGbe7iXI=
X-Google-Smtp-Source: APiQypLL2RO7vkWepX4zJfT3mg+ZZfFwS0tioHyqiE0a9rgOxbf+a264s0Uqh9dgtn1qb2Vwy6CnWJzlKoFypcpId+s=
X-Received: by 2002:a05:6e02:4ae:: with SMTP id e14mr4823031ils.190.1586783953013;
 Mon, 13 Apr 2020 06:19:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200412230122.5601-1-festevam@gmail.com> <9a59ecda-785e-1e26-110d-7951af650c89@roeck-us.net>
In-Reply-To: <9a59ecda-785e-1e26-110d-7951af650c89@roeck-us.net>
From:   Breno Matheus Lima <brenomatheus@gmail.com>
Date:   Mon, 13 Apr 2020 09:19:04 -0400
Message-ID: <CAC4tdFWo2dJQ_=W8U3dP-svOxuH2ygVxepKPCD0m0NnkBNNS6w@mail.gmail.com>
Subject: Re: [PATCH] watchdog: imx_sc_wdt: Fix reboot on crash
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Fabio Estevam <festevam@gmail.com>, wim@linux-watchdog.org,
        linux-imx@nxp.com, linux-watchdog@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Fabio,

Em dom., 12 de abr. de 2020 =C3=A0s 20:17, Guenter Roeck
<linux@roeck-us.net> escreveu:
>
> On 4/12/20 4:01 PM, Fabio Estevam wrote:
> > Currently when running the samples/watchdog/watchdog-simple.c
> > application and forcing a kernel crash by doing:
> >
> > # ./watchdog-simple &
> > # echo c > /proc/sysrq-trigger
> >
> > The system does not reboot as expected.
> >
> > Fix it by calling imx_sc_wdt_set_timeout() to configure the i.MX8QXP
> > watchdog with a proper timeout.
> >
> > Cc: <stable@vger.kernel.org>
> > Fixes: 986857acbc9a ("watchdog: imx_sc: Add i.MX system controller watc=
hdog support")
> > Reported-by: Breno Lima <breno.lima@nxp.com>
> > Signed-off-by: Fabio Estevam <festevam@gmail.com>
>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Thanks for the fix.

Tested-by: Breno Lima <breno.lima@nxp.com>
