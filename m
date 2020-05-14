Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC701D2886
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 09:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbgENHIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 03:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgENHIh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 03:08:37 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF94C061A0C
        for <stable@vger.kernel.org>; Thu, 14 May 2020 00:08:36 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id x7so22813637oic.3
        for <stable@vger.kernel.org>; Thu, 14 May 2020 00:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=biA9r0T5Sv8YCx33FWjEpY/1dzcGIkDdNQS4u+MoouI=;
        b=RagWkUEEVxT3M0/6JygfpeHFqxjNSK9bLGwanXl+yLlMcDld9yavXpnYjhC9HsYTyt
         IpbbT6bHMaMd2f9vY6YNn+nUwDS2OMydKVzTrB2VzDs5z9m/uiV2W+qu69XkVhRE9U/D
         JCKPy6/hBAHyVbbUSJo1VFF3mcNxHW3TBhsy4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=biA9r0T5Sv8YCx33FWjEpY/1dzcGIkDdNQS4u+MoouI=;
        b=QlWfor33DMQlWvhJBN8kFv8EWFGCYSTnV5wPahRhs/G7KSs+x1ILJoFBP8aNgnQCY0
         oO30zv4mLD6p4GmlcLvsV1BRYt/NvPcup12kZEbw2UkGKBTXGr21qTYSBJlXYwk4Ehv3
         fAniUUSbcEUdOYi3UXpkH4rmWcWkrHRXX+ck+l3912GcM8fUJtQH6Sa/X9S1DhLGtFu7
         RtRjvmdAL38up9G4AVIYK5Ub9u98e+KHaydcrDgtO54VDnypnUlYdfQuD6gkcABl85L8
         weRVYg/WmxKXoMClVIcUXL0ZoSR4prtxcCIjPJirFe+tGfuy7NzBKuFPb6zCtGf68Gi6
         AnMw==
X-Gm-Message-State: AGi0PubQ7Q0mdO+ji+DmHBRDlp9NACpUb5l0u//Heq4qEaQoKBa6vncU
        cJYZO/sTY5bRBjjbhdwh9SbDb92eJy02I+ISru3wx28N
X-Google-Smtp-Source: APiQypKJ6btuyR96uWgPEvWVBRFi5eTdiYG7q16E+P138IuV2y8xg7pd1Cxf/tBRYAklxwLz52LrYL47V81D1ObHYgU=
X-Received: by 2002:aca:3b41:: with SMTP id i62mr11137374oia.101.1589440116176;
 Thu, 14 May 2020 00:08:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200408162403.3616785-1-daniel.vetter@ffwll.ch> <CAPj87rMJNwp0t4B0KxH7J_2__4eT7+ZJeG-=_juLSDhPc2hLHQ@mail.gmail.com>
In-Reply-To: <CAPj87rMJNwp0t4B0KxH7J_2__4eT7+ZJeG-=_juLSDhPc2hLHQ@mail.gmail.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Thu, 14 May 2020 09:08:24 +0200
Message-ID: <CAKMK7uFU7ST9LWmpfhTuk1-_ES6VU-cUogMnPjA15BWFsEVacw@mail.gmail.com>
Subject: Re: [PATCH] drm: avoid spurious EBUSY due to nonblocking atomic modesets
To:     Daniel Stone <daniel@fooishbar.org>
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

On Thu, May 14, 2020 at 8:42 AM Daniel Stone <daniel@fooishbar.org> wrote:
>
> On Wed, 8 Apr 2020 at 17:24, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > Resending because last attempt failed CI and meanwhile the results are
> > lost :-/
>
> Did anything happen with this?

Nope. There's an igt now that fails with this, and I'm not sure
whether changing the igt is the right idea or not.

I'm kinda now thinking about changing this to instead document under
which exact situations you can get a spurious EBUSY, and enforcing
that in the code with some checks. Essentially only possible if you do
a ALLOW_MODESET | NONBLOCKING on the other crtc. And then tell
userspace you get to eat that. We've been shipping with this for so
long by now that's defacto the uapi anyway :-/

Thoughts? Too horrible?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
