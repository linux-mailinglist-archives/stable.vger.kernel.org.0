Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA180332DFA
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 19:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhCISOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 13:14:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbhCISOl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Mar 2021 13:14:41 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0F5C06175F
        for <stable@vger.kernel.org>; Tue,  9 Mar 2021 10:14:41 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id b18so17552548wrn.6
        for <stable@vger.kernel.org>; Tue, 09 Mar 2021 10:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=9qv4MCbyas1K94lwFyXxe0kQNVU1v80OT8W+RonhDAw=;
        b=TjeKGhz+InFKDHxcuDqJmg7DdaHy6FbTCPuUWuBbK0FOEgdoGff3DxsKvwZwCpzUuI
         0yOU+JLT7/9U/s1pfwH9OVO9dwAjEOckMVliBTQ11l65tilCAo9Y/v6qTEswRVT5Kqob
         T+GSBl+lZusdglJtRlxrRFBcuEIeyuKUPh3yDwWjgby937BNP4h6C5jVDRIvL4xPDAvj
         BoBdCwuP0Gdeq6Hdyjx4IZj1eNJ/FQXLrAiuV1rCPAfs220kEWuCj7/C5wkYrZ1hrp7L
         NHFClmCLVL3GMucUJ2g7i1eHumIJRW5PMIY/YpGWlBgbugpqydzKz6Mi2gvVut+gH8ae
         TGlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=9qv4MCbyas1K94lwFyXxe0kQNVU1v80OT8W+RonhDAw=;
        b=Bra6rpZjVQ4+g78pr3nBSruTa49DaCGqih1DgTYqQ3183SidZgzO2uCDKjb8v0vu9X
         Pn2B/cus2KzmauBZOx3k40FylsGZoAQnbKl3gvdDNvI5V/poRnbFWIJ2r/WoI5PA8k4V
         DjBviwFRGHVxfXFU5tkC0dRpXItCcTHnJ2O7c28j2eZB+Z3fgljRTCT1ZHUQ7zK000xc
         9jcgorg9X6qSGge3MxvKeICvo0/cdM6qXLj8zzXBT13o357KYp3s30VqgUJPQVTYoHjj
         YxSQsB2f7+Hi0IDhEBN0ZbG8e4n4Ta3e1VCu53Grn0ffr2pdtdZ9VE6ZUgcdeLhGmT4h
         YOBg==
X-Gm-Message-State: AOAM533F8o4L+eoz5jyJq+lALlSQN0M3qcCuIXWxAS4hvKyotRh4uQ6f
        fll71jA5tOiMsVcWE4YPMtANsA==
X-Google-Smtp-Source: ABdhPJwYxA+bzo+/mhpMdiP2N3kVlEkKjcb1LKZu4H03FtYGEOd8UxoEP3X2WT5nMtZWYs1sgUyDLQ==
X-Received: by 2002:a5d:42d2:: with SMTP id t18mr29560123wrr.258.1615313680037;
        Tue, 09 Mar 2021 10:14:40 -0800 (PST)
Received: from dell ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id z1sm25343412wru.95.2021.03.09.10.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 10:14:39 -0800 (PST)
Date:   Tue, 9 Mar 2021 18:14:37 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Zheng Yejian <zhengyejian1@huawei.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        cj.chengjian@huawei.com, judy.chenhui@huawei.com,
        zhangjinhao2@huawei.com, nixiaoming@huawei.com
Subject: Re: [PATCH 4.4 3/3] futex: fix dead code in attach_to_pi_owner()
Message-ID: <20210309181437.GV4931@dell>
References: <20210309030605.3295183-1-zhengyejian1@huawei.com>
 <20210309030605.3295183-4-zhengyejian1@huawei.com>
 <YEdQoy6j7eOne+8h@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YEdQoy6j7eOne+8h@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 09 Mar 2021, Greg KH wrote:

> On Tue, Mar 09, 2021 at 11:06:05AM +0800, Zheng Yejian wrote:
> > From: Thomas Gleixner <tglx@linutronix.de>
> > 
> > The handle_exit_race() function is defined in commit 9c3f39860367
> >  ("futex: Cure exit race"), which never returns -EBUSY. This results
> > in a small piece of dead code in the attach_to_pi_owner() function:
> > 
> > 	int ret = handle_exit_race(uaddr, uval, p); /* Never return -EBUSY */
> > 	...
> > 	if (ret == -EBUSY)
> > 		*exiting = p; /* dead code */
> > 
> > The return value -EBUSY is added to handle_exit_race() in upsteam
> > commit ac31c7ff8624409 ("futex: Provide distinct return value when
> > owner is exiting"). This commit was incorporated into v4.9.255, before
> > the function handle_exit_race() was introduced, whitout Modify
> > handle_exit_race().
> > 
> > To fix dead code, extract the change of handle_exit_race() from
> > commit ac31c7ff8624409 ("futex: Provide distinct return value when owner
> >  is exiting"), re-incorporated.
> > 
> > Lee writes:
> > 
> > This commit takes the remaining functional snippet of:
> > 
> >  ac31c7ff8624409 ("futex: Provide distinct return value when owner is exiting")
> > 
> > ... and is the correct fix for this issue.
> > 
> > Fixes: 9c3f39860367 ("futex: Cure exit race")
> > Cc: stable@vger.kernel.org # v4.9.258
> > Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
> > Reviewed-by: Lee Jones <lee.jones@linaro.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
> > ---
> >  kernel/futex.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Same here, what is the upstream git id?

It doesn't have one as such - it's a part-patch:

> > This commit takes the remaining functional snippet of:
> > 
> >  ac31c7ff8624409 ("futex: Provide distinct return value when owner is exiting")

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
