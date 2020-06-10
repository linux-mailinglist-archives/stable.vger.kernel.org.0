Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD6F51F520D
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 12:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgFJKQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 06:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbgFJKQ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 06:16:28 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8DBC03E96B
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 03:16:28 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id u23so1252406otq.10
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 03:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DK7KT4QRy+jvN6KqJwVezT/GyD3BIvlJY6OTkwmEN2Y=;
        b=w30cr1b/ct3qgcdfvWISAttn/2pK+MoGzWXNmOqJjyC8ILrdIq7eyCcC+xue4nj82m
         XxkBd0a/RbSnDaI7VXaejrxKC2wef9lm1QRy1Vwn6s0ktWS7NDV0oR6+CG2f9usWp2Ui
         OtNKK+8g2ySbId7sN7dIDSyP3Yx68DKco3lZ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DK7KT4QRy+jvN6KqJwVezT/GyD3BIvlJY6OTkwmEN2Y=;
        b=OzjqW8aTEfOzSCkScnVAT8QGij4Gr0lennMCjTAj7qEW43NVAhoUQ/BKyefwCh/iQa
         25HYOMZedBChaKDa+Ce3JZGD2lNeULHgiP3Ps60HLWHKu7IDMfK93bn/lb/PB+ujkokm
         RwbQ7VVSnMIa9QhZPxj5HksPGTK0ALYtESJHLxqOUh9uou6NIHcOmk0pGqOokud0yg7T
         ZPgvoArggJiv6c7ZL0vGT/iKateJrlqFlZ61+CCfAfNNMmic2swZqxa/aQcM0ijSgsKJ
         ZiLW5GqsMFxtod2Dk7RfjAr/GCFnZwEvpWWRi+j5gh6V6nuvOtETXJ3NrS4oU1m3u3Ex
         hzFw==
X-Gm-Message-State: AOAM5301EHCBG0yzzg1aPZsu3RO80TuBHF5Sbrq42ySVD+lAK8uckU1/
        kJJ8FTjnPW51znvZeKIcSgh1fuHal0UPgU/rKZ/JQQ==
X-Google-Smtp-Source: ABdhPJzrOa3lWy0c/7yv/8whRHwCb+UqkWNRrmb53qcZvpVj2wwjgBa2L1Nf8+AAD6fKbsAFuBrLTFfuHSw6176hg/w=
X-Received: by 2002:a9d:7f06:: with SMTP id j6mr1966728otq.132.1591784187645;
 Wed, 10 Jun 2020 03:16:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200521144841.7074-1-lmb@cloudflare.com> <20200522000934.GM33628@sasha-vm>
In-Reply-To: <20200522000934.GM33628@sasha-vm>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Wed, 10 Jun 2020 11:16:16 +0100
Message-ID: <CACAyw9-FH7e5fXAU923xSN9ENtyBo+FkqHnd7WAbpyhnz=X9MA@mail.gmail.com>
Subject: Re: [PATCH 4.19.y] selftests: bpf: fix use of undeclared RET_IF macro
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, kernel-team <kernel-team@cloudflare.com>,
        kernel test robot <rong.a.chen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 22 May 2020 at 01:09, Sasha Levin <sashal@kernel.org> wrote:
>
> On Thu, May 21, 2020 at 03:48:41PM +0100, Lorenz Bauer wrote:
> >commit 634efb750435 ("selftests: bpf: Reset global state between
> >reuseport test runs") uses a macro RET_IF which doesn't exist in
> >the v4.19 tree. It is defined as follows:
> >
> >        #define RET_IF(condition, tag, format...) ({
> >                if (CHECK_FAIL(condition)) {
> >                        printf(tag " " format);
> >                        return;
> >                }
> >        })
> >
> >CHECK_FAIL in turn is defined as:
> >
> >        #define CHECK_FAIL(condition) ({
> >                int __ret = !!(condition);
> >                int __save_errno = errno;
> >                if (__ret) {
> >                        test__fail();
> >                        fprintf(stdout, "%s:FAIL:%d\n", __func__, __LINE__);
> >                }
> >                errno = __save_errno;
> >                __ret;
> >        })
> >
> >Replace occurences of RET_IF with CHECK. This will abort the test binary
> >if clearing the intermediate state fails.
> >
> >Fixes: 634efb750435 ("selftests: bpf: Reset global state between reuseport test runs")
> >Reported-by: kernel test robot <rong.a.chen@intel.com>
> >Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
>
> Thanks for the backport Lorenz. We'll need to wait for it to make it
> into Linus's tree before queueing up for the stable trees.

Apologies for sending the patch too early (?), I'm still new to this process.
I've just hit this on 4.19.127. Do you want me to re-submit the patch somewhere?

Lorenz

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
