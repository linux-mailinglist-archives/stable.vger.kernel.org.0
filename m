Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED06386DF2
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 01:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238805AbhEQX4n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 19:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239375AbhEQX4k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 19:56:40 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ACBAC061756
        for <stable@vger.kernel.org>; Mon, 17 May 2021 16:55:23 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id l70so5743853pga.1
        for <stable@vger.kernel.org>; Mon, 17 May 2021 16:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Dt/9En1bGh9mqV5EDahzJAJYX6uZITBcCbOiK+du0JQ=;
        b=REtaxFuOq2C7rrWmKN8QPNMb56kHx90r/ZLUD5LtniukPNpoviGx1VVxzCMPE8FXpu
         cB/PqjB02JKjhWZTFMl/lF/b4tZK39vXd+kLpH+jprVFn9iLAhG0VhsifsZtcIjT8jbR
         xwJtd+AnwnzUHHj8pSaxUFgPdF4U1P7Ep45y8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Dt/9En1bGh9mqV5EDahzJAJYX6uZITBcCbOiK+du0JQ=;
        b=uI6pVwJ4QxA/2Ee9uOlYd44GIOEySiXNhtBmMn+RxUu1vxTKrMrER0Y1gPO2s5P3Ce
         O2MWhLhmYue8dn+pdN063C7VDhRrQgS/Ngs84jG2o15sVXoQlqIwFQFcEuOwujGl4q5u
         EPB82NSzBGAu/nnRCXaMB59fyI9nCHprSwh5tWeG88b3qhrgUdur19RbT1YDoe1PSn0j
         UXt3tCHT5+15jr+oCiI1yfX6qBYCex654QaPFFIlDKBinxwY1jdNFcCKr8Leh3zcnk43
         6PKmSZhE7lXQtFuBa2VdpjT6hxai6twjDiw/l8ndpWjmQT/0CveSKcAHCmhN8Q2JAKOK
         25Xw==
X-Gm-Message-State: AOAM533pPy1HX4WHY3Abx6Oar4OW7hl28pW2XV7KoXuNkm6aGwvK1yN/
        keuSv7g7kB9qtAqnbzK0HYihcQ==
X-Google-Smtp-Source: ABdhPJzjWUTAiFLfgQZeKKCkY0XQYoEwCLqRSutkBu75r4AjWSrcVDD7G8M3LXAo9+FSKhhLEaVj7g==
X-Received: by 2002:a63:79c5:: with SMTP id u188mr2084699pgc.198.1621295722925;
        Mon, 17 May 2021 16:55:22 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:1f25:dd29:abb6:257a])
        by smtp.gmail.com with ESMTPSA id 11sm6015257pfh.182.2021.05.17.16.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 16:55:22 -0700 (PDT)
Date:   Tue, 18 May 2021 08:55:17 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Laurence Oberman <loberman@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.12 123/363] watchdog: cleanup handling of false
 positives
Message-ID: <YKMCZWhhNS9kIOoR@google.com>
References: <20210517140302.508966430@linuxfoundation.org>
 <20210517140306.783130885@linuxfoundation.org>
 <YKJ+INpik2i9IhZN@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKJ+INpik2i9IhZN@alley>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On (21/05/17 16:30), Petr Mladek wrote:
> On Mon 2021-05-17 15:59:49, Greg Kroah-Hartman wrote:
> > From: Petr Mladek <pmladek@suse.com>
> > 
> > [ Upstream commit 9bf3bc949f8aeefeacea4b1198db833b722a8e27 ]
> > 
> > Commit d6ad3e286d2c ("softlockup: Add sched_clock_tick() to avoid kernel
> > warning on kgdb resume") introduced touch_softlockup_watchdog_sync().
> 
> [...]
> 
> > Make the code more straightforward:
> > 
> > 1. Always call kvm_check_and_clear_guest_paused() at the very
> >    beginning to handle PVCLOCK_GUEST_STOPPED. It touches the watchdog
> >    when the quest did sleep.
> > 
> > 2. Handle the situation when the watchdog has been touched
> >    (SOFTLOCKUP_DELAY_REPORT is set).
> > 
> >    Call sched_clock_tick() when touch_*sync() variant was used. It makes
> >    sure that the timestamp will be up to date even when it has been
> >    touched in atomic context or quest did sleep.
> > 
> > As a result, kvm_check_and_clear_guest_paused() is called on a single
> > location.  And the right timestamp is always set when returning from the
> > timer callback.
> > 
> > Link: https://lkml.kernel.org/r/20210311122130.6788-7-pmladek@suse.com
> 
> Please, remove this patch from the stable backport. It might
> cause false softlockup reports, see

Oh, I didn't know about the stable backport. Thank you for taking care of it.
