Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4E31D28A5
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 09:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbgENHSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 03:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgENHSc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 03:18:32 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1BDC061A0C
        for <stable@vger.kernel.org>; Thu, 14 May 2020 00:18:32 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id z72so21578108wmc.2
        for <stable@vger.kernel.org>; Thu, 14 May 2020 00:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fooishbar-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KwsrubFMdsohuVw3k+AW4SokzRCKruqC4RxMJbHellQ=;
        b=XeJZZXguWFmQdcxAWwRyIallPaF2na2dURhFnL3DvhTCKCHaML5FT5HkEikDsIBc/I
         UmnsskKAiRu1s8Vd3xwkEwzvjz6wtmQfQtrYifqjN8pibQzwWUCU9Q9gmAvkJgqHhkTJ
         H77ojThXWduDZzVSZ/F3qqUv2z5HcX4vk6vxnchzpwCSOQDuA166WzUcmNiTNXCnb7Ld
         131vwj9LsmWFIBbXqR0ltrfMjJdsbCujjwD15z25BkxoNIGd94AMzrM6UOiBXO6TPV0R
         rg87sGW8Vub3W7LVRBPHbjrvu7IyS2ZzU4J+hyWEi1LTzZeiKbJBNmZuJvpSkPLZvfYJ
         F53A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KwsrubFMdsohuVw3k+AW4SokzRCKruqC4RxMJbHellQ=;
        b=Gbi9qXtab4KJK2d7lSjkB39fO6gwV+l9/rO7T+AYB+tEI9nVCfEGtVj+pINcVNtdyb
         MKlDwMZB1LnMz4JNH0OgfAKzcDCQbeyNNfXkGxRlYCJ0Nj++rvyNgnB+2aSio3YQcoYO
         /7KNq30asxrDX84Hudmaewtp624tjR1dA23fA3boDzf2sfdMRZoQ9oFqqS3tvxOT5Z54
         jW01qAgQrK0OPrtbTqe/b9cN3NbfwoY4NMzoRbXCGkQGENLdF6nRB8YvoFE/RDjfoTTx
         vbRETrkWiju3jE+FJoUFLHUcL9/7Me+lizJF/fpAcY90+BtPFxUu7Cpn3YiGZjmeGr7O
         VK2A==
X-Gm-Message-State: AGi0PuZCS3a346hEomedwrU99IKJJ+c4gguumi3DBuWrxpm9m5kCPlI7
        XAViGBw9Lg8tIGof2W3VvVYsFyoLrW+3q0uTtGJpJg==
X-Google-Smtp-Source: APiQypItK+3Ag9iMlQsKLMwKNV7jEfzjuiS974Q1t1WWHMFMnl9AqF7tQz2yuugS4mvkbkdNZYo1ZbVOSLtkiy1MzBs=
X-Received: by 2002:a1c:2d02:: with SMTP id t2mr46769139wmt.98.1589440710998;
 Thu, 14 May 2020 00:18:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200408162403.3616785-1-daniel.vetter@ffwll.ch>
 <CAPj87rMJNwp0t4B0KxH7J_2__4eT7+ZJeG-=_juLSDhPc2hLHQ@mail.gmail.com> <CAKMK7uFU7ST9LWmpfhTuk1-_ES6VU-cUogMnPjA15BWFsEVacw@mail.gmail.com>
In-Reply-To: <CAKMK7uFU7ST9LWmpfhTuk1-_ES6VU-cUogMnPjA15BWFsEVacw@mail.gmail.com>
From:   Daniel Stone <daniel@fooishbar.org>
Date:   Thu, 14 May 2020 08:16:52 +0100
Message-ID: <CAPj87rNRLsGJcGEM3dYnitYMwjh7iMNjo9KT=xcDZ0hebRC9iw@mail.gmail.com>
Subject: Re: [PATCH] drm: avoid spurious EBUSY due to nonblocking atomic modesets
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Pekka Paalanen <pekka.paalanen@collabora.co.uk>,
        stable <stable@vger.kernel.org>,
        Daniel Stone <daniels@collabora.com>,
        =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Thu, 14 May 2020 at 08:08, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > Did anything happen with this?
>
> Nope. There's an igt now that fails with this, and I'm not sure
> whether changing the igt is the right idea or not.
>
> I'm kinda now thinking about changing this to instead document under
> which exact situations you can get a spurious EBUSY, and enforcing
> that in the code with some checks. Essentially only possible if you do
> a ALLOW_MODESET | NONBLOCKING on the other crtc. And then tell
> userspace you get to eat that. We've been shipping with this for so
> long by now that's defacto the uapi anyway :-/
>
> Thoughts? Too horrible?

I've been trying to avoid that, to be honest. Taking a random delay
because the kernel needs to do global things is fine. But making
userspace either do an expensive/complicated cross-CRTC
synchronisation is less easy; for some compositors, that means
reaching across threads to make sure all CRTCs are quiescent. Either
that, or deferring your ALLOW_MODESET to somewhere else, like an idle
handler, far away from where you were originally trying to do it,
which wouldn't be pleasant. The other option is that we teach people
to ignore EBUSY as random noise which can just sometimes happen and to
try again (when? how often? and you still have cross-CRTC
synchronisation issues), which doesn't scream compositor best practice
to me.

I'd be very much in favour of putting the blocking down in the kernel
at least until the kernel can give us a clear indication to tell us
what's going on, and ideally which other resources need to be dragged
in, in a way which is distinguishable from your compositor having
broken synchronisation.

Cheers,
Daniel
