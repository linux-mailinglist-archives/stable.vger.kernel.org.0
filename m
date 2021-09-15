Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4024340C64B
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 15:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbhIONXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 09:23:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46377 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233401AbhIONXt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 09:23:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631712150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N8XVIae35tL1jV2ZqP53lL8GffjmSTNBE3TsFycIEN4=;
        b=TeNbNl/vxcrv9cc1rilYyu0mNzRiWEl+qV0MwCNkNEyUT4c4tlqJwd/MXhvHmkQg5dgXSw
        29pbb553ESI8WhaDspGuw+6mSGvv/LjiIXCy5nxSpI0mYYKLUxqYuNR1NMCxk76bKI14kW
        zU+SAYxIdrd2gm44BLS364E1RgQ0x2M=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-p16GpTZiPs6ksbrtIWXhPA-1; Wed, 15 Sep 2021 09:22:29 -0400
X-MC-Unique: p16GpTZiPs6ksbrtIWXhPA-1
Received: by mail-yb1-f200.google.com with SMTP id m16-20020a25d410000000b005ab243aaaf4so3383396ybf.20
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 06:22:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N8XVIae35tL1jV2ZqP53lL8GffjmSTNBE3TsFycIEN4=;
        b=Hs5P/MGj0A5XHihQ5fWoaBLLF8KfjhAWLFpnaxiDvppt38jp15CtRcmcR3Xm2XdCGl
         yW3c9bKs/LgQf+NKp+FxBbfiWXh5hBLHdlGLzKF5HEL9Q7Io75DrphyyMYrC6GLBm8MP
         Xc7U5chfLKepJtLVmNvoL9j2DuIaC0nQUkXN79f/mgcQbYV1jIXdTdkr6jIqkVRYPsP4
         rhhmc+rSTIGW60BGv/k1GCjX+xbukPNM2Kqe05DrgNidPIJRthSkJSzK3LoClhbzgbw1
         Uq2Ct9qJW6v0V1woFr7b/PRX1GgampBE6x9LgFjwHkBKIXuK8Tiqm6JkyPDbSYEJny/Y
         kYWA==
X-Gm-Message-State: AOAM532L6qVG+j2LuqE9zk/XCnb5djcOub8sJlW7O5tLGtT/meWo2zYK
        uDggifGrqMrjh+KwxLXklEbn1ZdAzR0+kIWsrO7VWYIOvE2qLfiBlqbuiddVO+GjdzIO2ePCE0e
        nhu8rXMVOf7eBrVYG40VreKw5H7me8pW0
X-Received: by 2002:a25:6e05:: with SMTP id j5mr17476ybc.86.1631712148369;
        Wed, 15 Sep 2021 06:22:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzlFFW+PIYA/L9A4+NI1cWzq0l7OXoGX84sFvfGDI7OOVW5F2GclVm0ysvg4GFh2FICrY4eHPWAOssysD8Rdh0=
X-Received: by 2002:a25:6e05:: with SMTP id j5mr17454ybc.86.1631712148163;
 Wed, 15 Sep 2021 06:22:28 -0700 (PDT)
MIME-Version: 1.0
References: <CAHj4cs94pDUfSSfij=ENQxL-2PaGrHJSnhn_mHTC+hqSvPzBTQ@mail.gmail.com>
 <ca405578-5462-0ab9-91ab-de9d42ee0570@grimberg.me> <CAHj4cs8_382bLtbcR4F8RBJSmwMAdW22EiRycDjdLa0QtY2vnw@mail.gmail.com>
 <YUHueINHsFDRwHPa@kroah.com>
In-Reply-To: <YUHueINHsFDRwHPa@kroah.com>
From:   Yi Zhang <yi.zhang@redhat.com>
Date:   Wed, 15 Sep 2021 21:22:16 +0800
Message-ID: <CAHj4cs_c2a9CBfFhGDC8ciid1ShZhp9rEdTy_hxa87uAnG-QZg@mail.gmail.com>
Subject: Re: [bug report] nvme0n1 node still exists after blktests
 nvme-tcp/014 on 5.13.16-rc1
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>,
        linux-nvme@lists.infradead.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 15, 2021 at 9:00 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Sep 15, 2021 at 08:41:21PM +0800, Yi Zhang wrote:
> > On Tue, Sep 14, 2021 at 10:28 PM Sagi Grimberg <sagi@grimberg.me> wrote:
> > >
> > >
> > > > Hello
> > > > I found this failure on stable 5.13.16-rc1[1] and cannot reproduce it
> > > > on 5.14, seems we are missing commit[2] on 5.13.y, could anyone help
> > > > check it?
> > >
> > > Was it picked up and didn't apply correctly?
> > >
> >
> > Hi Sagi
> > I tried apply that patch to stable branch, but failed to do that,
> > would you or Hannes mind help backport it, thanks.
> >
> > [linux-stable-rc ((daeb634aa75f...))]$ git am
> > 0001-nvme-fix-refcounting-imbalance-when-all-paths-are-do.patch
> > Applying: nvme: fix refcounting imbalance when all paths are down
> > error: patch failed: drivers/nvme/host/nvme.h:716
> > error: drivers/nvme/host/nvme.h: patch does not apply
> > Patch failed at 0001 nvme: fix refcounting imbalance when all paths are down
> > hint: Use 'git am --show-current-patch' to see the failed patch
> > When you have resolved this problem, run "git am --continue".
> > If you prefer to skip this patch, run "git am --skip" instead.
> > To restore the original branch and stop patching, run "git am --abort".
> >
> > [linux-stable-rc ((daeb634aa75f...))]$ patch -p1 <
> > 0001-nvme-fix-refcounting-imbalance-when-all-paths-are-do.patch
> > patching file drivers/nvme/host/core.c
> > Hunk #1 succeeded at 3761 (offset -46 lines).
> > Hunk #2 succeeded at 3771 (offset -46 lines).
> > Hunk #3 succeeded at 3790 (offset -46 lines).
> > patching file drivers/nvme/host/multipath.c
> > Hunk #1 succeeded at 757 (offset -3 lines).
> > patching file drivers/nvme/host/nvme.h
> > Hunk #1 FAILED at 716.
> > Hunk #2 succeeded at 775 (offset 3 lines).
> > 1 out of 2 hunks FAILED -- saving rejects to file drivers/nvme/host/nvme.h.rej
>
> 5.13 is only going to be around for a 2-3 more days, please move to
> 5.14.y at this point in time.  No need to do any extra work for 5.13.y
> at this point in time as it is about to be end-of-life.

Got it, thanks for the update.

>
> thanks,
>
> greg k-h
>


-- 
Best Regards,
  Yi Zhang

