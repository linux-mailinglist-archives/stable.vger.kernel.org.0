Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7212745F5
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 18:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgIVQB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 12:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbgIVQB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 12:01:59 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FF6C061755
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 09:01:59 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id x14so21580060oic.9
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 09:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jzGx9lNDQDNvXf55+zZV1XJczdG5Tj1hGWl7xVKxg1M=;
        b=AbruHcePTxOWEF854e6hnz/8QaFNhQAY+slB4rUkja6Zj6kCCbk3umIijEqzQanieU
         yeIQ1xS/LWBxCCGI5gpPR66Oa8uZl/04jVVfDBb0GtWtUkxkz1CcbrmWQ3Qwvl31mzpp
         BL8DTdMQ49vHk7PU5rBIHpBnBg4g3ZlYD3v3Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jzGx9lNDQDNvXf55+zZV1XJczdG5Tj1hGWl7xVKxg1M=;
        b=QqvPhEHNoGmeSoeNYA/QLJKN+iBT+rzwGnFlnodgIeJyGkivrYWrzSIwBW4FMSnfE+
         zuNOamSNdbJY1sYY4aBTWQUBIvmD2qK9ubroDKB5Q1K6Zf+iXD7Tqwi3NxnZsX3l9W/t
         d+ioskAooOmKkkKtExsJZY8iq2BG/jZ8z83u853t/t5n9naDgPy+PAZ7sKQnc0+y++LW
         IcZ4dh+hFsTKk555hOCCyHcopOtzIbSWJ/sktikV7KncPE9NXOE7MwZ7LFn1NScwfMkw
         7lJWdvGnIFIEjxmiVgPhiGw4mv0z9k7hBqp2Nhmhwigliv0PZZThXkpU19NDq7BY3z/A
         pfBg==
X-Gm-Message-State: AOAM531WwvQ8FRO8wTz/KOZRwXoO3H7OlGNpcDGfgXeD8qlAC/40+biC
        TpxGEccWtLKH8bxoCraIXH5tS1Pj2ZgeH6Sr8N1AMQ==
X-Google-Smtp-Source: ABdhPJxUCOo0K3uccb6V78Xey0Gvm3PTUf1Xm+2P+JTQizT3twxEF7VlbI4OYn7TQy4fV9tVym4U9rJE/5W8CN474ZY=
X-Received: by 2002:aca:49c2:: with SMTP id w185mr2629161oia.101.1600790518782;
 Tue, 22 Sep 2020 09:01:58 -0700 (PDT)
MIME-Version: 1.0
References: <20180705101043.4883-1-daniel.vetter@ffwll.ch> <20180705102121.5091-1-daniel.vetter@ffwll.ch>
 <CAPj87rN48S8+pLd0ksOX4pdCTqtO=bDgjhkPxpWr_AnpVvgaSQ@mail.gmail.com>
 <20200922133636.GA2369@xpredator> <CAKMK7uHCeFan4+agMn0sr-z9UDyZwEJv0_dL-K-gA1n0=m+A2w@mail.gmail.com>
 <CAPj87rNLzFjn7xyePmEBEY8teL7TnL-HrQHXbp7C1tXDdWgeUA@mail.gmail.com>
In-Reply-To: <CAPj87rNLzFjn7xyePmEBEY8teL7TnL-HrQHXbp7C1tXDdWgeUA@mail.gmail.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue, 22 Sep 2020 18:01:47 +0200
Message-ID: <CAKMK7uEyt0d0LidUCQL4oHZRYZdDEFhy=DnRF7WwD1S1+ackFQ@mail.gmail.com>
Subject: Re: [PATCH] drm: avoid spurious EBUSY due to nonblocking atomic modesets
To:     Daniel Stone <daniel@fooishbar.org>
Cc:     Marius Vlad <marius.vlad@collabora.com>,
        Pekka Paalanen <pekka.paalanen@collabora.co.uk>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        stable <stable@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 22, 2020 at 4:14 PM Daniel Stone <daniel@fooishbar.org> wrote:
>
> On Tue, 22 Sep 2020 at 15:04, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > On Tue, Sep 22, 2020 at 3:36 PM Marius Vlad <marius.vlad@collabora.com> wrote:
> > > Gentle ping. I've tried out Linus's master tree and, and like Pekka,
> > > I've noticed this isn't integrated/added.
> >
> > Defacto the uapi we have now is that userspace needs to ignore "spurious" EBUSY.
>
> This really, really, really, bites.
>
> I think we need a guarantee that this never happens if ALLOW_MODESET
> is always used in blocking mode, plus in future a cap we can use to
> detect that we won't be getting spurious EBUSY events.
>
> I really don't want to ever paper over this, because it's one of the
> clearest indications that userspace has its timing/signalling wrong.

Ok so the hang-up last time around iirc was that I broke igt by making
a few things more synchronous. Let's hope I'm not also breaking stuff
with the WARN_ON ...

New plan:
- make this patch here only document existing behaviour and enforce it
with the WARN_ON
- new uapi would be behind a flag or something, with userspace and
everything hanging off it.

Thoughts?

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
