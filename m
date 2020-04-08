Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFB701A2C22
	for <lists+stable@lfdr.de>; Thu,  9 Apr 2020 01:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgDHXOb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 19:14:31 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:37690 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbgDHXOb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 19:14:31 -0400
Received: by mail-pj1-f66.google.com with SMTP id k3so476437pjj.2;
        Wed, 08 Apr 2020 16:14:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2dDJWh79T+QwbSORYSdxSbFbZJ+4Kb781kLYzxisEwA=;
        b=jiSJCZxKwZiCDhKLOlXasL6uAe8ZBpxzDA4kDrfKKHEs/G5y2o9S+LAUYIf07HlU0P
         b++5YEbC1q5bLSOZnlxKapc8rmuguBey3AD1u5n2/PSWoBytSrhogSekSsj1oafG+dX3
         Np+Cc4/E2ZqZR4llD0Xn7YOarZU241sBtwR6iuqtJ+wp924JnqM9WGSJyApWX0uD8zpa
         It0w3KP5MZnxF8rfuVNgzv12f27l1KQAku8rxUOi+CMG9MBoGYGMDrIMapLjCspfWQ3C
         CbHfNYxzAbfhnIj6f8VkGU513W5nB1yLbYD1iaMw3qj5bomNq8xCLhyG4MG/VD8ZQj+R
         K3Cg==
X-Gm-Message-State: AGi0PuZRu/miKoV83t3qp8QE/3OQXvAWtZAYjGe0+7fuCEomjU8CBnJF
        xVTD6ExO/Gg1Wm9akXyWRu4=
X-Google-Smtp-Source: APiQypLmMSFDOCiE+OBRFqHbxk1A6IV4TgC7GWmKe4/0VrM1zb4TXxe/3ulSYAVo/codF9ue37a8eg==
X-Received: by 2002:a17:90a:8a08:: with SMTP id w8mr8213311pjn.119.1586387670316;
        Wed, 08 Apr 2020 16:14:30 -0700 (PDT)
Received: from sultan-box.localdomain (static-198-54-129-52.cust.tzulo.com. [198.54.129.52])
        by smtp.gmail.com with ESMTPSA id j5sm530256pjb.36.2020.04.08.16.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2020 16:14:29 -0700 (PDT)
Date:   Wed, 8 Apr 2020 16:14:25 -0700
From:   Sultan Alsawaf <sultan@kerneltoast.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Laight <David.Laight@aculab.com>,
        Marco Elver <elver@google.com>, Linux-MM <linux-mm@kvack.org>,
        Mark Rutland <mark.rutland@arm.com>,
        mm-commits@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [patch 125/166] lib/list: prevent compiler reloads inside 'safe'
 list iteration
Message-ID: <20200408231425.GA2641@sultan-box.localdomain>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
 <20200407031042.8o-fYMox-%akpm@linux-foundation.org>
 <CAHk-=wi1h-wBC3Kg2qBhs_R1UGyocGq0cT1eO+12pwBsO+d1ww@mail.gmail.com>
 <20200408202630.GA1666@paulmck-ThinkPad-P72>
 <CAHk-=wicuF-BZj9b_Dbv+Ev8FT4XqULj2qMpkaUgEokNir345A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wicuF-BZj9b_Dbv+Ev8FT4XqULj2qMpkaUgEokNir345A@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 08, 2020 at 02:14:38PM -0700, Linus Torvalds wrote:
>  (a) what the i915 driver does is at a minimum questionable, and quite
> likely actively buggy

By the way, this doesn't even seem like the only place in i915 where locking and
object lifetime semantics are... special. I found a combined deadlock and
use-after-free last week, inside of interwoven recursive call chains, and posted
a patch here [1]. Unfortunately, it's been ignored thus far. But the interesting
thing is how the bizarre object lifetime semantics there required even more
weird things to enact a proper fix. That patch really should be merged (Chris?),
but moreover, it'd be nice to see a whole release cycle devoted to just cleaning
some of this stuff up. Showstopper bugs and hangs in i915 have really multiplied
in recent times.

Sultan

[1] https://lore.kernel.org/lkml/20200407064007.7599-1-sultan@kerneltoast.com
