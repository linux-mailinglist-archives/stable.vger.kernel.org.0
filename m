Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF906400945
	for <lists+stable@lfdr.de>; Sat,  4 Sep 2021 04:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236224AbhIDCOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 22:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236120AbhIDCOL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 22:14:11 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65AAC061757;
        Fri,  3 Sep 2021 19:13:10 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id me10so1554590ejb.11;
        Fri, 03 Sep 2021 19:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/Yxd3tLdwA6axcDY2mcJ1N4bmyKI/tSiwpamDgl6Gsc=;
        b=EBm3Mrc/KHMZzBUaktxLe3RwEFcfcqbQXJoOhiNiRA0R5Ftc5cBYA20B5uGudCdyOE
         MMllLDqbdQ1KoH68wR2TNLupwk6jw+2sENeTJilRhQlRgIWKGJMb1ofj6nPnvWrAzypV
         htVAAR9Lb2aCod2V/wac4AUCwrh6ZiP2ehumiiaiMLl58zIOgFLhgKWyiXv7GEXiK4Gi
         H1qa/pywLXm6hPa6DL8M3agUYaEyEnlEwvpIua6QaxuKBd2K8uq9vuHTx1Io0FYoDcS2
         SsRRQF043fbg5oj8BaC4i15UPLni8mq8a5A2zg6rKChe0aJ/X5Y5Gui+/VYl7nE23Oin
         Wi/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/Yxd3tLdwA6axcDY2mcJ1N4bmyKI/tSiwpamDgl6Gsc=;
        b=F90ovZrqWIIOJng5Uea7YyOiVHoTi2rRpp5LqLZxplnQUi6X4aRR2wa33HjxJDaJFf
         O/q9eFTCgMvzct9B8CEjul93U/TNlQPrc7P20lFASdPVOaY5tWHZZFB39geObhoL0QWN
         HJZSgnOZlA6bOhEA6Db1Zc9QqVDuNObiIiYBHR5FI5WiBVQTmycpYyZdgJBwdT6HM5nK
         4/10W/cTcANRD6Edg9Dw0AkAyg0vTSvb2l+JTtVRzrRc1/2KJRzVy7t+/BSuv/9YFgcY
         t6Iu/ZUAlUdaLuVdqtvLYjku3youuPreY/3cDqSNwqFZaiiUbwLX2tlYMAoo84TFNIj7
         xDQQ==
X-Gm-Message-State: AOAM533//i4c5XpQAaqB3KOHt5bYIAlsrw3w1fplYg9R/6+OieAkjNUv
        GTPYxJEpx1eZ45dNWJFFnrJ//wQNz36yOfa2Hmo=
X-Google-Smtp-Source: ABdhPJz0X1b/YbEKKNLhcxMoCb87/9e/3f184cZJ+kqFRfrYc6dzaThaCuwn/x3Ad+qCblXYaajtCxLMzXHzs0wYopg=
X-Received: by 2002:a17:906:ce24:: with SMTP id sd4mr1981555ejb.329.1630721589217;
 Fri, 03 Sep 2021 19:13:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210902061048.1703559-1-mudongliangabcd@gmail.com> <YTIpXrJmJTasAGJU@kroah.com>
In-Reply-To: <YTIpXrJmJTasAGJU@kroah.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Sat, 4 Sep 2021 10:12:43 +0800
Message-ID: <CAD-N9QU4KBs=XwjPpqSM1T3i9r0Fsd+s64O6gbD0Cf5KFFf-ZQ@mail.gmail.com>
Subject: Re: [PATCH 4.19] fbmem: add margin check to fb_check_caps()
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        George Kennedy <george.kennedy@oracle.com>,
        syzbot+e5fd3e65515b48c02a30@syzkaller.appspotmail.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Dhaval Giani <dhaval.giani@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 3, 2021 at 9:55 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Sep 02, 2021 at 02:10:48PM +0800, Dongliang Mu wrote:
> > [ Upstream commit a49145acfb975d921464b84fe00279f99827d816 ]
> >
> > A fb_ioctl() FBIOPUT_VSCREENINFO call with invalid xres setting
> > or yres setting in struct fb_var_screeninfo will result in a
> > KASAN: vmalloc-out-of-bounds failure in bitfill_aligned() as
> > the margins are being cleared. The margins are cleared in
> > chunks and if the xres setting or yres setting is a value of
> > zero upto the chunk size, the failure will occur.
> >
> > Add a margin check to validate xres and yres settings.
> >
> > Note that, this patch needs special handling to backport it to linux
> > kernel 4.19, 4.14, 4.9, 4.4.
>
> Looks like this is already in the 4.4.283, 4.9.282, 4.14.246, and
> 4.19.206 kernel releases.  Can you check them to verify that it matches
> your backport as well?

Yes, I have seen them in these releases and they are fine to me.

>
> thanks,
>
> greg k-h
