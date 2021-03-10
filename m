Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24865333EEB
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234202AbhCJN2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:28:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234077AbhCJN2F (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 08:28:05 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DD5C061761
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 05:28:05 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id l12so23295957wry.2
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 05:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Ud5GV8jteIAfR0+OIo+yJBwr2As0MS7U/ZgI9Fa6uR8=;
        b=pqFzZKpHYtR0sVsG29K4pZpYbRkWS6JnGHGtP6DR3e6n0hPf6n1YJ3kVFvP7roE9BF
         mawJ9qTwiJpWb+agYCEr5M7c6cpRpDJxVampnJQPT9vFDk54T8Dq0mTxTWnI0Vycg/fe
         oRzyMt6o+HooT6ogwd2LlWbgtd7vIPCzYYvm0ueYohFbo2F5IswQ3ZZyHz3J6yqHZwXk
         eTUpyXx2iu01GvATn+zmVsPamXTLYpF5bIM3TZN1+DfrgypcfatkDBzj2ebuc9VkcpmG
         Qxv+t7Siooo5r+n5B3ZbdEztNh0kZCVj4jNRhoPcG6qsqnPTTBPQHlvaJAen7GnBQ0Hz
         ssLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Ud5GV8jteIAfR0+OIo+yJBwr2As0MS7U/ZgI9Fa6uR8=;
        b=NJLS2vHacYbhQ+WGcgQP6msfO/+LpV+qCM57PDVM2SMSsGXv9+hQvsdOWe8d9s3b5F
         m2amq7j5vHpT905DhtDI0OV9BeS/MCxLN6pAp0JJatn5FHuufHZ5ZBXFc1zKVzLDvwP2
         sMwP6yF7S3U4/nrmEmguVqwrK5V7pHKbqFrFAc2y8iEbka43I7fh1ZLDIRtpwvNglFwX
         SMmBcnKR1hIF9/xLl0dkEaT6dncPeUBjBKx59ow8ElBjQXGlXuh5QP/quqZ7CFnVn+Vs
         Jf9YvTkKAddQYEptkpwASHRmyuCN9Im7pnuByngh7oFGzIvd+0hbpyaTxLSoEmrvPpVu
         vcmw==
X-Gm-Message-State: AOAM530GwddlyqkWI0ihlHQcPEbVL7GYFH8XCm3ygHxcidH8/5pT7b9u
        VAsexTXrOJzbrRAFCNyTJaKHqw==
X-Google-Smtp-Source: ABdhPJyai3lwYkvYs3UUHDPoPfmSh3Fud+xWK7Gs+5D1UXMbnrPD5cJe556wXX4ouZAHUyRnwLF3xg==
X-Received: by 2002:a5d:6989:: with SMTP id g9mr3748288wru.198.1615382884189;
        Wed, 10 Mar 2021 05:28:04 -0800 (PST)
Received: from dell ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id p27sm9815467wmi.12.2021.03.10.05.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 05:28:03 -0800 (PST)
Date:   Wed, 10 Mar 2021 13:28:02 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Zheng Yejian <zhengyejian1@huawei.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        cj.chengjian@huawei.com, judy.chenhui@huawei.com,
        zhangjinhao2@huawei.com, nixiaoming@huawei.com
Subject: Re: [PATCH 4.4 3/3] futex: fix dead code in attach_to_pi_owner()
Message-ID: <20210310132802.GP701493@dell>
References: <20210309030605.3295183-1-zhengyejian1@huawei.com>
 <20210309030605.3295183-4-zhengyejian1@huawei.com>
 <YEdQoy6j7eOne+8h@kroah.com>
 <20210309181437.GV4931@dell>
 <YEi08Dr3cgNp0KlP@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YEi08Dr3cgNp0KlP@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Mar 2021, Greg KH wrote:

> On Tue, Mar 09, 2021 at 06:14:37PM +0000, Lee Jones wrote:
> > On Tue, 09 Mar 2021, Greg KH wrote:
> > 
> > > On Tue, Mar 09, 2021 at 11:06:05AM +0800, Zheng Yejian wrote:
> > > > From: Thomas Gleixner <tglx@linutronix.de>
> > > > 
> > > > The handle_exit_race() function is defined in commit 9c3f39860367
> > > >  ("futex: Cure exit race"), which never returns -EBUSY. This results
> > > > in a small piece of dead code in the attach_to_pi_owner() function:
> > > > 
> > > > 	int ret = handle_exit_race(uaddr, uval, p); /* Never return -EBUSY */
> > > > 	...
> > > > 	if (ret == -EBUSY)
> > > > 		*exiting = p; /* dead code */
> > > > 
> > > > The return value -EBUSY is added to handle_exit_race() in upsteam
> > > > commit ac31c7ff8624409 ("futex: Provide distinct return value when
> > > > owner is exiting"). This commit was incorporated into v4.9.255, before
> > > > the function handle_exit_race() was introduced, whitout Modify
> > > > handle_exit_race().
> > > > 
> > > > To fix dead code, extract the change of handle_exit_race() from
> > > > commit ac31c7ff8624409 ("futex: Provide distinct return value when owner
> > > >  is exiting"), re-incorporated.
> > > > 
> > > > Lee writes:
> > > > 
> > > > This commit takes the remaining functional snippet of:
> > > > 
> > > >  ac31c7ff8624409 ("futex: Provide distinct return value when owner is exiting")
> > > > 
> > > > ... and is the correct fix for this issue.
> > > > 
> > > > Fixes: 9c3f39860367 ("futex: Cure exit race")
> > > > Cc: stable@vger.kernel.org # v4.9.258
> > > > Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
> > > > Reviewed-by: Lee Jones <lee.jones@linaro.org>
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
> > > > ---
> > > >  kernel/futex.c | 6 +++---
> > > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > Same here, what is the upstream git id?
> > 
> > It doesn't have one as such - it's a part-patch:
> > 
> > > > This commit takes the remaining functional snippet of:
> > > > 
> > > >  ac31c7ff8624409 ("futex: Provide distinct return value when owner is exiting")
> 
> That wasn't obvious :(

This was also my thinking, which is why I replied to the original
patch in an attempt to clarify what I thought was happening.

> Is this a backport of another patch in the stable tree somewhere?

Yes, it looks like it.

The full patch was back-ported to v4.14 as:

  e6e00df182908f34360c3c9f2d13cc719362e9c0

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
