Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC553D7378
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 12:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236274AbhG0Klt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 06:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236104AbhG0Klt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 06:41:49 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C179C061757
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 03:41:49 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id w6so14566720oiv.11
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 03:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pXQoDhan5KKaj7bwAWgdzui7fh0fxafAhg6EvIGCxG0=;
        b=R56hL1qfoj7g0ummxwJKLOo2PxwCISobZaxpIwnzaMDRRcEuWwKkCMS528v3zbHimJ
         KCvWFBNJMTqpvj5T4QWaqyRmWbb/2nn3aRcmJM1iVLlWTNV53k23pPooN03VI/axBvWP
         T4XKpdCo7QqSX7aiRswWOM4CJuv/M10Ab5C7s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pXQoDhan5KKaj7bwAWgdzui7fh0fxafAhg6EvIGCxG0=;
        b=ISVnv+sezFAwAFwnYdm8t7rDc/2eLdEwy5GMuo73gKMPyskRSyXxQD482cVNz94oo+
         D8n4uUCGj0uxoRk9OpRLFT85fah9ezqcKscsSX4TsqGsSg2q9tvLcHJWjF4QBmW3UkVS
         cjHbrDJZNDAYjIAB0IcX49iw0LT4+2qP4xByEVX247Qw1Q9q0ETlqSYum+4efUiioksm
         ELwSnxhLVyUbrGwp0vDyENnrkREbBaUhr4362JDnnK4ZIBCrSoafCTZvsheV8aOiXYq8
         HW1+tUBY7A65Cv2GlNhGL+XVryFK64/PC/kVXhL0oJWa9wkUbpHZfi+L9niR1Xd2K4wt
         /KuA==
X-Gm-Message-State: AOAM5322FGjWTqyudWc8sRHfDf1xs7OcUaY8k4GtNJY1GwCCeixbhTDK
        s8TQZgNkcRx1k0Ri0IL2FGBKffsxJASd+C13YlLGdx7Rr2V/WQ==
X-Google-Smtp-Source: ABdhPJzKGkOCSJRUuNTx9929n4vHij7VtdSZAXEJT++z8Gs+qe6bOgghZD8ZU+RQIJ3ss4tFM+u1X5aZU7khDL2kj5U=
X-Received: by 2002:aca:3085:: with SMTP id w127mr2352240oiw.101.1627382508742;
 Tue, 27 Jul 2021 03:41:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210726231548.3511743-1-jason@jlekstrand.net> <YP+WQ4Ej2jyHjIeO@kroah.com>
In-Reply-To: <YP+WQ4Ej2jyHjIeO@kroah.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue, 27 Jul 2021 12:41:37 +0200
Message-ID: <CAKMK7uFpmd=Or2uRfh8vrdnmeJLUFkz0HbC44ueNyv59P-T-mA@mail.gmail.com>
Subject: Re: [PATCH] Revert "drm/i915/gem: Asynchronous cmdparser"
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jason Ekstrand <jason@jlekstrand.net>,
        stable <stable@vger.kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Jon Bloomfield <jon.bloomfield@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 27, 2021 at 7:15 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Jul 26, 2021 at 06:15:48PM -0500, Jason Ekstrand wrote:
> > commit 93b713304188844b8514074dc13ffd56d12235d3 upstream.  This version
> > applies to the 5.10 tree.
>
> I do not see that commit id in Linus's tree, are you sure it is correct?

3761baae908a ("Revert "drm/i915: Propagate errors on awaiting already
signaled fences"")

Jason, you need to pick the sha1 from drm-intel-fixes, which
cherry-picks. Confuses -stable otherwise.

Aside from that confusion, they're all there in -rc3.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
