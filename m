Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB4E1B317E
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 22:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgDUUzf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 16:55:35 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:40697 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbgDUUzf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 16:55:35 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 48352c64;
        Tue, 21 Apr 2020 20:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=date:from:to
        :cc:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=mail; bh=12pLsRhdNM+N7Ux+ZFOGd+NBSro=; b=UGWFCM6
        a2l8xu7sEASmFXNF87llOr131UkD778ESOCLKK6RuYCNRzTKLwUJW3VHAISO769n
        1x/Grnja5uXODdnmRNo5XtbBlmFjlsTGa5gua8HaQNkklSgMe8AAF8LbqWgA7+f+
        Bn/HAm6TnPbS1qupR13Tflyu6oHP52xjrPGQ2C62JOObqyBJF4DZ+RwW7eHYneru
        ZzQ+uRveCJORG7dRjDdRpLGGj1uuBCzLAoDTAPOCZpEr0SStO0hS4tHksHyw3asV
        QCthiqvp896ZNdRpYSXE6pH04v09FHGD7IB0Pur1fIIqI6sveSBDUXD87KtqH7sW
        zK1mCjx7EkyQWlQ==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 33eacc33 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 21 Apr 2020 20:44:43 +0000 (UTC)
Date:   Tue, 21 Apr 2020 14:55:28 -0600
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Sultan Alsawaf <sultan@kerneltoast.com>
Cc:     Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v2] drm/i915: Fix ref->mutex deadlock in
 i915_active_wait()
Message-ID: <20200421205528.GA44784@zx2c4.com>
References: <20200407071809.3148-1-sultan@kerneltoast.com>
 <20200410090838.GD1691838@kroah.com>
 <20200410141738.GB2025@sultan-box.localdomain>
 <20200411113957.GB2606747@kroah.com>
 <158685210730.16269.15932754047962572236@build.alporthouse.com>
 <20200414082344.GA10645@kroah.com>
 <158737335977.8380.15005528012712372014@jlahtine-desk.ger.corp.intel.com>
 <20200420154216.GA1963@sultan-box.localdomain>
 <158745625375.5265.15743487643543685929@jlahtine-desk.ger.corp.intel.com>
 <20200421163809.GB2289@sultan-box.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200421163809.GB2289@sultan-box.localdomain>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 21, 2020 at 09:38:09AM -0700, Sultan Alsawaf wrote:
> Why hasn't this bug got any attention:
> https://gitlab.freedesktop.org/drm/intel/issues/1412
> 
> That seems like a showstopper.

Indeed, pretty shocking. It's worth mentioning that the reporter of said
bug, after significant time had elapsed, removed i915 from the kernel
entirely and now daily drives the NVIDIA binary blob. Having to fall
back to closed source blobs indicates a pretty awful state of affairs.
It might otherwise be hard to imagine how that could be preferable, but
this situation indicates how.

Joonas - More generally, it seems what's happening now is that i915
driver stability and quality is reaching a real low point. Back when
i915 was the only stable driver in town, the ivory tower attitude of the
maintainers seemed quasi-justifiable. The drivers kept being awesome, so
when they kicked the can back at users or gave them the cold shoulder on
reports, there was never much of an issue, since things always got fixed
in fairly short order. This is no longer the case. Bugs are piling up.
Users are unhappy. So it's only natural that some users will just wind
up fixing it themselves, especially with responses from Intel like "not
guilty!" in response to i915 bug reports. And these users who try to fix
these bugs will do so without access to your proprietary debuggers,
top-secret data sheets, and NDA'd hardware engineers down the hall, and
thus you'll always be able to accuse them of something or another about
"due-diligence", since nobody is better suited than you to find and fix
these issues in the best way possible. But it hasn't been happening in a
satisfactory way from your end, and users need their laptops to actually
work, and so things will gradually get fixed (hopefully, anyhow) through
other means. Even on the stable front, if fixes to bugs are intermingled
into massive refactoring patches, and your team isn't taking charge to
separate them out and send them to stable@, then backporting to stable
kernels is going to result in a lot of custom work from other people. In
other words, you can shun your users' bug reports and fellow developers
and get away with that while your driver quality remains tip-top, but if
you let things fall, as they have as of late, then expect your ivory
tower to be shaken a bit.
