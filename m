Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80970109F87
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 14:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbfKZNuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 08:50:13 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40865 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbfKZNuN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 08:50:13 -0500
Received: by mail-wm1-f68.google.com with SMTP id y5so3382860wmi.5
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 05:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=tsj4AXaBf2OKH3JD14NeJEXvf/A3qIm9YxHg9zWu5J8=;
        b=Fhb28BbRAFf7tgmvMgmztYdvmGnqRCNYJKoxNFd/ipMkYuCojA27OwcvKMt8+Fj+ey
         zvX6GRfBv3ddgdXg8SFwICbvAUwuYor3ZRTdP8f1zJGuaYERgsP9pajF0JhfSr+NCI2X
         H0CF8O3uzY/Xbz0FFZ6blsu8Me6W0XDGO9MOu9Z89jMFQxC5UyN3xaygNWA5z6Xwxpdb
         oZF8/lsWLoYG7Q+pUzYKn3wsl3RmZ8inRhga+dm+PIqRsaHHulS7r4YBe2ImFq2jCfuZ
         pOg+xvnNJ7KnBIIvKuz8ZGIhi/U3V3RJ3UHOdgx+XpxD+f90RosVF0L1HylrdwXP8Iky
         UxJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=tsj4AXaBf2OKH3JD14NeJEXvf/A3qIm9YxHg9zWu5J8=;
        b=G95Jr2Zk/sHSIZpSQu8qdrJMQt+3uakqo/QqFjoDN/k7bwBkMcUMCroChXKHNUBhHS
         shTjIT/GiQfM8t19BdtcSQNvV269wZg15i49skqsmFpeDDo4MLKFTGCWhXwPcw7eF3zP
         PrHNmhDyXiMqiCM+MphulVLrNdgupCp4n14BVzVWKWArQwNcxM4vdC6G1hpOUn0EATK7
         e6fWUcch0BS/Ugaq4GjDRy7bEevu5FLrpBiU4TXqcs+79XQylq3yGWNZ18m4lJ6f100y
         uSHUn1wQowbwMxNoOghSqhcZb3jbJ3xJzbIYdt9hT6BWngcgfgsh315KEDGzAPQaoFVa
         WLrw==
X-Gm-Message-State: APjAAAX6IZS/GpIsW5TLslYc28WJt1Pjn5CNRkiaDylOAX6hXwZlwyd7
        tmvp++An54G9Eh1r6dylYpvjyQ==
X-Google-Smtp-Source: APXvYqwom14V0WbU96pWp+N29yC0tS77lBFl3cYph2bFmUoicKN5Tc2Wy41CBK8MJkz5L3a9R6XEug==
X-Received: by 2002:a05:600c:2052:: with SMTP id p18mr4347815wmg.92.1574776211849;
        Tue, 26 Nov 2019 05:50:11 -0800 (PST)
Received: from dell ([95.149.164.72])
        by smtp.gmail.com with ESMTPSA id a206sm3240152wmf.15.2019.11.26.05.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 05:50:11 -0800 (PST)
Date:   Tue, 26 Nov 2019 13:49:57 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 3/8] arm64: fix for bad_mode() handler to always
 result in panic
Message-ID: <20191126134957.GI3296@dell>
References: <20191122105253.11375-1-lee.jones@linaro.org>
 <20191122105253.11375-3-lee.jones@linaro.org>
 <20191125134700.GA5861@sasha-vm>
 <20191125144429.GF3296@dell>
 <20191125174103.GA2872072@kroah.com>
 <20191125182529.GH3296@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191125182529.GH3296@dell>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 25 Nov 2019, Lee Jones wrote:

> On Mon, 25 Nov 2019, Greg KH wrote:
> 
> > On Mon, Nov 25, 2019 at 02:44:29PM +0000, Lee Jones wrote:
> > > On Mon, 25 Nov 2019, Sasha Levin wrote:
> > > 
> > > > On Fri, Nov 22, 2019 at 10:52:48AM +0000, Lee Jones wrote:
> > > > > From: Hari Vyas <hari.vyas@broadcom.com>
> > > > > 
> > > > > [ Upstream commit e4ba15debcfd27f60d43da940a58108783bff2a6 ]
> > > > > 
> > > > > The bad_mode() handler is called if we encounter an uunknown exception,
> > > > > with the expectation that the subsequent call to panic() will halt the
> > > > > system. Unfortunately, if the exception calling bad_mode() is taken from
> > > > > EL0, then the call to die() can end up killing the current user task and
> > > > > calling schedule() instead of falling through to panic().
> > > > > 
> > > > > Remove the die() call altogether, since we really want to bring down the
> > > > > machine in this "impossible" case.
> > > > 
> > > > Should this be in newer LTS kernels too? I don't see it in 4.14. We
> > > > can't take anything into older kernels if it's not in newer ones - we
> > > > don't want to break users who update their kernels.
> > > 
> > > Only; 3.18, 4.4, 4.9 and 5.3 were studied.
> > > 
> > > I can look at others if it helps.
> > 
> > You have to look at others, we can't have regressions if people move
> > from one LTS to a newer one.

Okay, now sent appropriate patches to linux-4.14.y and linux-4.19.y.

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
