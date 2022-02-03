Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF87D4A84E2
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 14:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350696AbiBCNIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 08:08:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347590AbiBCNIg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 08:08:36 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA8DC061714
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 05:08:35 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id i17so2164975pfq.13
        for <stable@vger.kernel.org>; Thu, 03 Feb 2022 05:08:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z+cMMLA2uqIqG4JJGjT5UJwJKih1Hzcajbh1/9otjJ4=;
        b=EtkmuTeRXd6+VxCth18/d3W3LBLmSTMqrAsp8qbYATFLcz2qhrTa+jq3YpvwdOhcQe
         WGMc64XHokrPGuGjbrPvgxA646Bm62H6luiYNxl3DBSYTqA70GzR6y/1NR1gMDLGGoHE
         ryppNdaRkaD/cz80GnVHyTrwnsiTykYgMUEyi+zkxDynRKQf46WXTMlnJDzhuN7knUTW
         EkhfBcYM1QPlBTS2npBO2/bfYK/kTFPDuiYkQ01+ESd5myr3Vny2md9kkmSZsgyLHgYi
         lnFFLROVtRUt8FYRddajcs1+zMDEOjBoRIxy4DXytccq3kDvjMxpveGK0rtvrSc8Acof
         IvBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z+cMMLA2uqIqG4JJGjT5UJwJKih1Hzcajbh1/9otjJ4=;
        b=fuWsPbhZQ4OQo+1M0yOUEmxYud5sQjhYm5tmLkslOPTDQZCrGxsCgTHndzl0+cvnb0
         4Dwe0HAo8ZC2bGr1Xuctx1VQEtiHGujTNl7jNxsIp2+dh18nBIJeUFDQOG72drFT5/5a
         MMn9VFMIBcQ6egz+chSsVk/i1+gE3vP8vkU6+bXAF8w6uzU5oY+d1enKGmV5OW7p2/8i
         BpwG5mEUfeFbdyZwHZoaeH/pFPJscAofrEkQc7bGXQDN7Uuhx/ukxHeldG8gmfepnsff
         iSV4Rx5LCJye7CLGvT4vjdcA7NINkBS+JjJ/u6fXAguZG8MCRdCnqPrHHsCR/AbjKqXc
         c6Ug==
X-Gm-Message-State: AOAM532waSI8jHDifHQO8aw3KouiIYeUQhHw+KQ9Sozryd+ESu4zhHzj
        b3RuK9n6VWql4uz7o2Q0QFbN3QSqkpQEo9uCGNJETQGTnJA=
X-Google-Smtp-Source: ABdhPJxYbtVRYXRlMOXZ+MlJmKpdFPiO0SSHyURxoVCWFi6244WEpnUclVVX0b3lLiJMhW7qEpKUv6huFDK8ATcmWlc=
X-Received: by 2002:a63:f709:: with SMTP id x9mr28206057pgh.428.1643893715325;
 Thu, 03 Feb 2022 05:08:35 -0800 (PST)
MIME-Version: 1.0
References: <20220127142939.1734912-1-jens.wiklander@linaro.org> <CAFA6WYNqSKwtRYN+dudreG=ZuRLhzsbNgy8wwjrYuSR6oq_79w@mail.gmail.com>
In-Reply-To: <CAFA6WYNqSKwtRYN+dudreG=ZuRLhzsbNgy8wwjrYuSR6oq_79w@mail.gmail.com>
From:   Jens Wiklander <jens.wiklander@linaro.org>
Date:   Thu, 3 Feb 2022 14:08:24 +0100
Message-ID: <CAHUa44EDnkwYLJGKqDmmkq1kgHEWo4u_1d3yZzrSM=vj8PMo2Q@mail.gmail.com>
Subject: Re: [PATCH] optee: use driver internal tee_contex for some rpc
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     linux-kernel@vger.kernel.org, op-tee@lists.trustedfirmware.org,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Lars Persson <lars.persson@axis.com>,
        Lars Persson <larper@axis.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 28, 2022 at 6:46 AM Sumit Garg <sumit.garg@linaro.org> wrote:
>
> On Thu, 27 Jan 2022 at 19:59, Jens Wiklander <jens.wiklander@linaro.org> wrote:
> >
> > Adds a driver private tee_context by moving the tee_context in struct
> > optee_notif to struct optee. This tee_context was previously used when
> > doing internal calls to secure world to deliver notification.
> >
> > The new driver internal tee_context is now also when allocating driver
> > private shared memory. This decouples the shared memory object from its
> > original tee_context. This is needed when the life time of such a memory
> > allocation outlives the client tee_context.
> >
> > This patch fixes the problem described below:
> >
> > The addition of a shutdown hook by commit f25889f93184 ("optee: fix tee out
> > of memory failure seen during kexec reboot") introduced a kernel shutdown
> > regression that can be triggered after running the OP-TEE xtest suites.
> >
> > Once the shutdown hook is called it is not possible to communicate any more
> > with the supplicant process because the system is not scheduling task any
> > longer. Thus if the optee driver shutdown path receives a supplicant RPC
> > request from the OP-TEE we will deadlock the kernel's shutdown.
> >
> > Fixes: f25889f93184 ("optee: fix tee out of memory failure seen during kexec reboot")
> > Fixes: 217e0250cccb ("tee: use reference counting for tee_context")
> > Reported-by: Lars Persson <larper@axis.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
> > ---
> >
> > This patch is from "optee: add driver private tee_context" and "optee: use
> > driver internal tee_contex for some rpc" in [1] combined into one patch for
> > easier tracking. It turned out that those two patches fixes reported
> > problem so I'm breaking out this from the patchset in order to target it
> > for the v5.17.
> >
> > [1] https://lore.kernel.org/lkml/20220125162938.838382-1-jens.wiklander@linaro.org/
> >
> >  drivers/tee/optee/core.c          |  1 +
> >  drivers/tee/optee/ffa_abi.c       | 77 +++++++++++++++++--------------
> >  drivers/tee/optee/optee_private.h |  5 +-
> >  drivers/tee/optee/smc_abi.c       | 48 +++++++------------
> >  4 files changed, 64 insertions(+), 67 deletions(-)
> >
>
> Reviewed-by: Sumit Garg <sumit.garg@linaro.org>

Thanks, I'm picking this up now.

/Jens
