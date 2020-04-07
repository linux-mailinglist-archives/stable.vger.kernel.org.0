Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18B061A107B
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 17:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgDGPo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 11:44:57 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46614 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbgDGPo5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 11:44:57 -0400
Received: by mail-lj1-f193.google.com with SMTP id r7so4213908ljg.13
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 08:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5Y6Hx1sXgJ3W5d0gTkp6nD1FW85ltE5sJAkh5hIto3A=;
        b=QoSShl9oiN/+zyCgi+M5b9ay4gbY0igdPZcELx3hFDjksWUQnrgJlAFGIBzEKmr4jp
         GWnJl5dnFxKhoCI5IGvvQqbEEp0eZlH03J2tFItJeKqX97kAW0keTpO+wb1Z3pjATCCy
         UNQpOCiIYNAqhbyGH35z5yaeRiMvOI/XPKTdE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5Y6Hx1sXgJ3W5d0gTkp6nD1FW85ltE5sJAkh5hIto3A=;
        b=a8QbflQA43L4ocU9TX9ifUeW3m+Hg+6ULIfi/3Gwo2YOZcVFyM/hK07lqvUBGAR/LJ
         7u3pNrFiwVLMSAFWTEWaQAelejQqLA3UgrliH6j0y7OlG5WOIQs734W19WMo48RmbMrr
         FzWswwtBK7oNYMZK0NPd/F9pcOpynMYCFeq3gT+hvzHPBeAk7hIwMPVINaid6cn6Jm6y
         Wt/htk/S+QmFt9nyPFS99p6JiUthGLhbYfCLLxqD5V2ZP+BkYK1uMNat8qyj1wDCrU6E
         BdJ0rsZYWzIjwrgwMM5KV596T3AQZKbr91/3MVPqau5vNqHszRTQFf0aCNDKQDPyajuh
         2UTw==
X-Gm-Message-State: AGi0PuYcqVZ1Z7dT8aTlwWG9fAwSbANGwQpe/was4iffmCZPYTk3Jk1B
        rC1HJHW+M5Mz+Qgi9ssjICbSl1xCXPs=
X-Google-Smtp-Source: APiQypK1b0jikcwfJ7LtnhYYTJUanzUkkc/EZYgs4ZHVjp8ECPTA/+FIYL02pTmkXpnKKn1zyoTwvA==
X-Received: by 2002:a2e:9851:: with SMTP id e17mr2174415ljj.208.1586274294280;
        Tue, 07 Apr 2020 08:44:54 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id 6sm13603785lft.83.2020.04.07.08.44.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 08:44:53 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id m19so732221lfq.13
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 08:44:52 -0700 (PDT)
X-Received: by 2002:a19:9109:: with SMTP id t9mr1918172lfd.10.1586274292580;
 Tue, 07 Apr 2020 08:44:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org> <20200407031042.8o-fYMox-%akpm@linux-foundation.org>
In-Reply-To: <20200407031042.8o-fYMox-%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 7 Apr 2020 08:44:35 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi1h-wBC3Kg2qBhs_R1UGyocGq0cT1eO+12pwBsO+d1ww@mail.gmail.com>
Message-ID: <CAHk-=wi1h-wBC3Kg2qBhs_R1UGyocGq0cT1eO+12pwBsO+d1ww@mail.gmail.com>
Subject: Re: [patch 125/166] lib/list: prevent compiler reloads inside 'safe'
 list iteration
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        David Laight <David.Laight@aculab.com>,
        Marco Elver <elver@google.com>, Linux-MM <linux-mm@kvack.org>,
        Mark Rutland <mark.rutland@arm.com>,
        mm-commits@vger.kernel.org,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 6, 2020 at 8:10 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> From: Chris Wilson <chris@chris-wilson.co.uk>
> Subject: lib/list: prevent compiler reloads inside 'safe' list iteration
>
> Instruct the compiler to read the next element in the list iteration
> once, and that it is not allowed to reload the value from the stale
> element later. This is important as during the course of the safe
> iteration, the stale element may be poisoned (unbeknownst to the
> compiler).

Andrew, Chris, this one looks rather questionable to me.

How the heck would the ->next pointer be changed without the compiler
being aware of it? That implies a bug to begin with - possibly an
inline asm that changes kernel memory without having a memory clobber.

Quite fundamentally, the READ_ONCE() doesn't seem to fix anything. If
something else can change the list _concurrently_, it's still
completely broken, and hiding the KASAN report is just hiding a bug.

What and where was the actual KASAN issue? The commit log doesn't say...

            Linus
