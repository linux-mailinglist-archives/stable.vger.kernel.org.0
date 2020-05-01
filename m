Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE0D1C201F
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 23:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgEAVz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 17:55:27 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:36525 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgEAVz0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 17:55:26 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id d7bce547;
        Fri, 1 May 2020 21:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=GBwk1frAmvPVyRR7LTO6C8+MPwQ=; b=FyD4yn
        lg5FFrDdIgRqTVyQvuCQd/D6b31eNZG4cR1WZKbuwF32UJbTtB/x2AqwZ5I5n4MV
        5bvz9LTBEX3Yen66cNtuT55VKbYvwcTzXuQpvbd41fhdtUs4mMCGVRmYaN1YDWeE
        xBBnnknz7WUQAzEcuPoYFdGYJ6+8NSNf++PFkb04Eic9CaXmVY8pCvBLDTwv2M9V
        AWBl8U4EuO2db51kl2qL2XJxVd96n/XO+gjoOFpMpgfki/kia3FL2GIZqbG7rKVJ
        P90laXF4vjMfMg/SEaqN7xWkk3sKhYTUqCkUgFYGMXmyqICkllPSbJqGJZbrT0pM
        1kjwQf1Dok2GOteQ==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id bd97f9f9 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Fri, 1 May 2020 21:43:21 +0000 (UTC)
Received: by mail-io1-f53.google.com with SMTP id e9so6201571iok.9;
        Fri, 01 May 2020 14:55:25 -0700 (PDT)
X-Gm-Message-State: AGi0PuaefE46slkOVt0YwFGquJZIkU2WSmUslgQwTATfmnyJxioCTVME
        zY8G8ciaHP4kjNg8yBXrIqeH2BgFT3aLGYgM/eg=
X-Google-Smtp-Source: APiQypJtn0r3d2QBtiNDkHKo54/QKsvUWyvhMz7w+JkvaOeex9CkkeH4YNxWwVM/8W8LRE48ClMQgV+DndrosQN46FA=
X-Received: by 2002:a6b:7114:: with SMTP id q20mr5626475iog.79.1588370124889;
 Fri, 01 May 2020 14:55:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200430221016.3866-1-Jason@zx2c4.com> <20200501180731.GA2485@infradead.org>
In-Reply-To: <20200501180731.GA2485@infradead.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 1 May 2020 15:55:14 -0600
X-Gmail-Original-Message-ID: <CAHmME9pDtoPOwMGZuFAyYyWpOs8cnVO8t3FeOTR+YTeKL6PETg@mail.gmail.com>
Message-ID: <CAHmME9pDtoPOwMGZuFAyYyWpOs8cnVO8t3FeOTR+YTeKL6PETg@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: check to see if SIMD registers are available
 before using SIMD
To:     Christoph Hellwig <hch@infradead.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 1, 2020 at 12:07 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Thu, Apr 30, 2020 at 04:10:16PM -0600, Jason A. Donenfeld wrote:
> > Sometimes it's not okay to use SIMD registers, the conditions for which
> > have changed subtly from kernel release to kernel release. Usually the
> > pattern is to check for may_use_simd() and then fallback to using
> > something slower in the unlikely case SIMD registers aren't available.
> > So, this patch fixes up i915's accelerated memcpy routines to fallback
> > to boring memcpy if may_use_simd() is false.
>
> Err, why does i915 implements its own uncached memcpy instead of relying
> on core functionality to start with?

I was wondering the same. It sure does seem like this ought to be more
generalized functionality, with a name that represents the type of
transfer it's optimized for (wc or similar).
