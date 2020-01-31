Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6D914E923
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 08:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgAaHeW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 02:34:22 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46797 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728035AbgAaHeW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 02:34:22 -0500
Received: by mail-wr1-f65.google.com with SMTP id z7so7330715wrl.13
        for <stable@vger.kernel.org>; Thu, 30 Jan 2020 23:34:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fooishbar-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=owDgY2hN74svhwO6V6vESJaP7KSYIDvwh0UpgYJP8tc=;
        b=W5QRTWPq5V1gfy2LTbkoaVWqpWIoew8i2DeZXV+kuXCdSPClSdS8DrQsRlQaLiqrn7
         SabGhJ0iUS/0C9J+n+RaDAKKMwWFY6K5vb6OVMjFSFlUUU9UYeC80j6CVbXtvdWem14s
         IsH/Hjq9Oa5D0p7TSXPBQTztEm1Mcdgik97M1ALqmknH/s18LhzHAHlhoyE14iXhsW3W
         GiTb0w9nkasDAUls/iGZp+RyZP+T8wiYazTdY1DAVB4e7F6+Zeit+HobTIrVOuZbNaNp
         tbtcHlWhTEqviWnCbABW5hHpVC3tN9c40PnMngS1eOjUo5SqMFNmth405QeznNdb925G
         VSgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=owDgY2hN74svhwO6V6vESJaP7KSYIDvwh0UpgYJP8tc=;
        b=AjgNTlEu83neftFbVWYdwP+NeCEFygPh0mjVBUKuh24N4Gjl3Cbz6jwSwdyUhyPlu1
         8zkz+WJpOkg05zsERazRH52riAsac7IGGOUwN9lPVCUYhOVXH0iCWUGbODpZDCQkeA5o
         Mh+nY1LjjN/F0BZReUa1UKVyweIOuu+7vNnhKYZFowWzrYgQYdnBd3h4Oo/Ce0QXG6FC
         R+8kgOVopF1tNDa7sr5Hxjdp36xgvLIIGb5L+sbLXzbue3Eb8ShuGtSzcvKOYM1AjrGu
         BwYy8y7ufUk+WhpBnfRENeNlmgAywz0Fm3Dze7pyAg8owcVwsgIStIUD3E7iYGqVVEHx
         XW3A==
X-Gm-Message-State: APjAAAXLQN0k3xTmQNXjb96X+IPLU45UmX36jgZ2VRgYkpA0hWHe0Aig
        Nb9oiwNDbucg0aOl63+YhD9lPwVg7PtQoUlTSFHkqJ6B
X-Google-Smtp-Source: APXvYqxE2D1GUZqbFQ7juYd6KtGB0wWZIYc2Q/xIq23fGh/WL0GBK5zKH9bzu3lOwV9+kWP54Y3iKcuDHp21ot8TOJQ=
X-Received: by 2002:a5d:6445:: with SMTP id d5mr8923297wrw.244.1580456059067;
 Thu, 30 Jan 2020 23:34:19 -0800 (PST)
MIME-Version: 1.0
References: <20180705101043.4883-1-daniel.vetter@ffwll.ch> <20180705102121.5091-1-daniel.vetter@ffwll.ch>
In-Reply-To: <20180705102121.5091-1-daniel.vetter@ffwll.ch>
From:   Daniel Stone <daniel@fooishbar.org>
Date:   Fri, 31 Jan 2020 07:34:00 +0000
Message-ID: <CAPj87rN48S8+pLd0ksOX4pdCTqtO=bDgjhkPxpWr_AnpVvgaSQ@mail.gmail.com>
Subject: Re: [PATCH] drm: avoid spurious EBUSY due to nonblocking atomic modesets
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Pekka Paalanen <pekka.paalanen@collabora.co.uk>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 5 Jul 2018 at 11:21, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> When doing an atomic modeset with ALLOW_MODESET drivers are allowed to
> pull in arbitrary other resources, including CRTCs (e.g. when
> reconfiguring global resources).
>
> But in nonblocking mode userspace has then no idea this happened,
> which can lead to spurious EBUSY calls, both:
> - when that other CRTC is currently busy doing a page_flip the
>   ALLOW_MODESET commit can fail with an EBUSY
> - on the other CRTC a normal atomic flip can fail with EBUSY because
>   of the additional commit inserted by the kernel without userspace's
>   knowledge
>
> For blocking commits this isn't a problem, because everyone else will
> just block until all the CRTC are reconfigured. Only thing userspace
> can notice is the dropped frames without any reason for why frames got
> dropped.
>
> Consensus is that we need new uapi to handle this properly, but no one
> has any idea what exactly the new uapi should look like. As a stop-gap
> plug this problem by demoting nonblocking commits which might cause
> issues by including CRTCs not in the original request to blocking
> commits.

Thanks for writing this up Daniel, and for reminding me about it some
time later as well ...

Reviewed-by: Daniel Stone <daniels@collabora.com>

Cheers,
Daniel
