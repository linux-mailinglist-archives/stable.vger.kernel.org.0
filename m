Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFA865A929
	for <lists+stable@lfdr.de>; Sun,  1 Jan 2023 07:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbjAAGUN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Jan 2023 01:20:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjAAGUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Jan 2023 01:20:12 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD8AF66
        for <stable@vger.kernel.org>; Sat, 31 Dec 2022 22:20:10 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id bf43so37464422lfb.6
        for <stable@vger.kernel.org>; Sat, 31 Dec 2022 22:20:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FtfnZ0V05BlgjlWPLYPsWqRel3QPXIplFXSje5Bb4hw=;
        b=RC4NYnMMBtpX2MC8xx996T5hNhz+g6ifNsUbCZgsKO+bXJJkUlGj0p5OPv+fDSw6tl
         jO0riEpZi+l6lsRMuyPUfV8SP7YuWLqDmo9bAeMJhsh4RQgCSVog/j2G7FuFdSEU3yR1
         n1ZU9yZ119GmgY7XwU6EMeE0X+DKHgdJ70bJc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FtfnZ0V05BlgjlWPLYPsWqRel3QPXIplFXSje5Bb4hw=;
        b=ibZDcm+y9mHbkYg0yCnO5esdje8ePPHV06lRomjg+7N2IgrsdhpXHYX51sJhyK/JXj
         Vi+0l8dspQ+fwAH0OTKp73DGaDHEBMs119fT3qe6Wyqitfe65LGmVGW6LVMP2gALA/CK
         6626ME9/e82n6nu+V+MrpbCf64aBTz25iSHo4wpz94oQdrTivF72KFcN2AduH9yfqzZv
         Oblq0f4xKKWe9KYJJRHktP5J1kc4bC8ipdb4RsglIu4OFIuaKk7Kqr9ZXOQsL+cLAp3y
         MxjvzRr+BQ72rhRf19qevKjkTptna1to03zHqOoaKxdSNehmm7MSruTvGqkexdLm45xb
         xv1A==
X-Gm-Message-State: AFqh2kpdK3fcuSy0GGUDiZyjL+tH4mt/nBhAov/RZPovTU8ScWS5h4G0
        /mO5qZVbZ30u4XjvBj/kI4CHc1+9adji4B94YVjLqg==
X-Google-Smtp-Source: AMrXdXuPEHw0RmsApKygPvEDVouuZKrky5j7R2PNlaNDnrD6GTz89FIN2kKU0fsbB1bCzMU/ww5IvDltVwGswi8ulKg=
X-Received: by 2002:a05:6512:e90:b0:4aa:148d:5168 with SMTP id
 bi16-20020a0565120e9000b004aa148d5168mr1779729lfb.561.1672554009126; Sat, 31
 Dec 2022 22:20:09 -0800 (PST)
MIME-Version: 1.0
References: <20230101061555.278129-1-joel@joelfernandes.org>
In-Reply-To: <20230101061555.278129-1-joel@joelfernandes.org>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Sun, 1 Jan 2023 01:20:01 -0500
Message-ID: <CAEXW_YQyieW+w-VJ48N5kMkQo-RzJhFXD2kBR91B0KqhVFJNbw@mail.gmail.com>
Subject: Re: [PATCH] torture: Fix hang during kthread shutdown phase
To:     linux-kernel@vger.kernel.org
Cc:     Paul McKenney <paulmck@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Zhouyi Zhou <zhouzhouyi@gmail.com>, stable@vger.kernel.org,
        Davidlohr Bueso <dave@stgolabs.net>,
        Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 1, 2023 at 1:16 AM Joel Fernandes (Google)
<joel@joelfernandes.org> wrote:
>
> During shutdown of rcutorture, the shutdown thread in
> rcu_torture_cleanup() calls torture_cleanup_begin() which sets fullstop
> to FULLSTOP_RMMOD. This is enough to cause the rcutorture threads for
> readers and fakewriters to breakout of their main while loop and start
> shutting down.
>
> Once out of their main loop, they then call torture_kthread_stopping()
> which in turn waits for kthread_stop() to be called, however
> rcu_torture_cleanup() has not even called kthread_stop() on those
> threads yet, it does that a bit later.  However, before it gets a chance
> to do so, torture_kthread_stopping() calls
> schedule_timeout_interruptible(1) in a tight loop. Tracing confirmed
> this makes the timer softirq constantly execute timer callbacks, while
> never returning back to the softirq exit path and is essentially "locked
> up" because of that. If the softirq preempts the shutdown thread,
> kthread_stop() may never be called.
>
> This commit improves the situation dramatically, by increasing timeout
> passed to schedule_timeout_interruptible() 1/20th of a second. This
> causes the timer softirq to not lock up a CPU and everything works fine.
> Testing has shown 100 runs of TREE07 passing reliably, which was not the
> case before because of RCU stalls.
>
> Cc: Paul McKenney <paulmck@kernel.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>
> Cc: <stable@vger.kernel.org> # 6.0.x

Question for stable maintainers:
This patch is for mainline and 6.0 stable. However, it should also go
to 6.1 stable. How do we tag it to do that? I did not know how to tag
2 stable versions. I guess the above implies > 6.0 ?

Thanks,

 - Joel
