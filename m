Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 383E71C201C
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 23:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgEAVyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 17:54:33 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:57327 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgEAVyd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 17:54:33 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 697688e6;
        Fri, 1 May 2020 21:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=58S7gafTvCyAaihiGAJkt1yLd6Y=; b=uEMjOf
        vaAoQm6Md4vl1zLH4e384tV3WtBAWLlgCo+K5pEl80lJ/GvpGM7c9fZDyOTsAkmv
        cuKynBhaCqSRHqZBzqTqWXv6Z4HbPF3NqtVfde1VMOZHGonxruz94B6y8j3TcIsU
        uMZdOgcG077zI+WnCV+P65QbA9sYgpXGtdgY65bj5PTj75+rbbisf87/GmQ91cZQ
        JKagWB9eEWX77XQ8c2TM5CYF9dNqiKFdiQQYRHI2ADz7Hzq/L2X0R66E2It3cZ/G
        U0lvdu8uQf4ysuexTDsNGdp569KlEKabIVY9ZUebiQQBot72XKZie2s2vflviruB
        QmdrxR8gpZsEXDxg==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9ab6eb77 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Fri, 1 May 2020 21:42:27 +0000 (UTC)
Received: by mail-il1-f182.google.com with SMTP id w6so5722552ilg.1;
        Fri, 01 May 2020 14:54:31 -0700 (PDT)
X-Gm-Message-State: AGi0PuZ2GNJJnpYDquv7xOZERTgYP9JgGeX/WqSkomrtz2kOdYBrBKZr
        qX1jxcTgSaN7zwft8k826ph+7CbwSej1MKn2GDU=
X-Google-Smtp-Source: APiQypKi8VgL32io/YMf/TnAiuoD4oQjdoDdZRV4jk7+CgfAceJlLxx1gZqoTLRU71ehr0skb3Rw0hz+zCqa+vWKwOI=
X-Received: by 2002:a92:d98c:: with SMTP id r12mr5878280iln.224.1588370070637;
 Fri, 01 May 2020 14:54:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200430221016.3866-1-Jason@zx2c4.com> <20200501104215.s2eftchxm66lmbvj@linutronix.de>
In-Reply-To: <20200501104215.s2eftchxm66lmbvj@linutronix.de>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 1 May 2020 15:54:19 -0600
X-Gmail-Original-Message-ID: <CAHmME9othY=_3szXKh-+4uAgcLpuvgXm4HX2-SU+Hg7KztXTFw@mail.gmail.com>
Message-ID: <CAHmME9othY=_3szXKh-+4uAgcLpuvgXm4HX2-SU+Hg7KztXTFw@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: check to see if SIMD registers are available
 before using SIMD
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 1, 2020 at 4:42 AM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>    Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Thanks.

>
> May I ask how large the memcpy can be? I'm asking in case it is large
> and an explicit rescheduling point might be needed.

Yea I was worried about that too. I'm not an i915 developer, but so
far as I can tell:

- The path from intel_engine_cmd_parser is  <= 256 KiB for "known
users", so that's rather large.
- The path from perf_memcpy is either 4k, 64k, or 4M, depending on the
type of object, so that seems gigantic, but I think that might be
selftest code.
- The path from compress_page appears to be PAGE_SIZE, so 4k, which
meshes with the limits we set agreed on few weeks ago for the crypto
stuff.
- The path from guc_read_update_log_buffer appears to be 8k, 32k, 2M,
or 8M, depending on the type of object, so that seems absurdly huge
and doesn't appear to be selftest code either like the other case.

I have no doubt the i915 developers will jump in here waving their
arms, but either way, it sure seems to me like you might have a point.
