Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7159FC40D6
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 21:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbfJATQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 15:16:30 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37703 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfJATQa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 15:16:30 -0400
Received: by mail-wr1-f68.google.com with SMTP id i1so16872721wro.4;
        Tue, 01 Oct 2019 12:16:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FltPPrn0RyJnptmNx0sxFImXuote0rVzpvmBZNIkzIk=;
        b=N+wrM4aN61IeZLSaRbpcs2ekEhmW/HNKTl0eLR39O1818OCN/uvMoTJmuVZ3CCdcVo
         zIDmnkV6/zzabMzJmOGFKuJ1vcbcitEH9w/Fw50RLcYEpM/tbKkWUOCYFrsM3Rux1P30
         X/vpghWtYJV8ACYHnKA/yu223AMvSkiEf2QnMqZpfHPLyHom+Yfav9YrkVXLjv+PeA9F
         JmXZjM3aaNJqXD0S5VPAFRuP6QYAtB41lQ0En9ZwiwcM811IEJyAtHo6HrF/Q6oAQXqS
         feL/Tz/T7kyTB/2ZoSWhdbFlseoD/byboBq3y4zRx4AyO+pPgttHOPmIgcJTOsSfRfmq
         dyIw==
X-Gm-Message-State: APjAAAVlOgvb6RtIOfOosnt3OtyhBqGx0EDXCyWp+73uBdMkMEVwJ/vi
        goixwhDngpk0gS/RZlThQ6s=
X-Google-Smtp-Source: APXvYqwtq9OVu+i0azeVn4qOTObwJAZ150zoEL9CgLUhKYNQvdJH4iLNRbw4xX2CQvyebggTGD8G9g==
X-Received: by 2002:a5d:670f:: with SMTP id o15mr13203989wru.242.1569957386592;
        Tue, 01 Oct 2019 12:16:26 -0700 (PDT)
Received: from kozik-lap ([194.230.155.145])
        by smtp.googlemail.com with ESMTPSA id x2sm23725861wrn.81.2019.10.01.12.16.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 01 Oct 2019 12:16:25 -0700 (PDT)
Date:   Tue, 1 Oct 2019 21:16:23 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     linux-samsung-soc@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: dts: exynos: Revert "Remove unneeded address
 space mapping for soc node"
Message-ID: <20191001191623.GB30860@kozik-lap>
References: <CGME20190912073608eucas1p1c2da86b1f85244a507b0f2ce96390ad3@eucas1p1.samsung.com>
 <20190912073602.22829-1-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190912073602.22829-1-m.szyprowski@samsung.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 12, 2019 at 09:36:02AM +0200, Marek Szyprowski wrote:
> Commit ef72171b3621 ("arm64: dts: exynos: Remove unneeded address space
> mapping for soc node") changed the address and size cells in root node from
> 2 to 1, but /memory nodes for the affected boards were not updated. This
> went unnoticed on Exynos5433-based TM2(e) boards, because they use u-boot,
> which updates /memory node to the correct values. On the other hand, the
> mentioned commit broke boot on Exynos7-based Espresso board, which
> bootloader doesn't touch /memory node at all.
> 
> This patch reverts commit ef72171b3621, so Exynos5433 and Exynos7 SoCs
> again matches other ARM64 platforms with 64bit mappings in root node.
> 
> Reported-by: Alim Akhtar <alim.akhtar@samsung.com>
> Fixes: ef72171b3621 ("arm64: dts: exynos: Remove unneeded address space mapping for soc node")
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: <stable@vger.kernel.org>
> Tested-by: Alim Akhtar <alim.akhtar@samsung.com>
> ---
> A few more comments:
> 
> 1. I've added 'tested-by' tag from Alim, as his original report pointed
> that reverting the offending commit fixes the boot issue.
> 
> 2. This patch applies down to v4.18.
> 
> 3. For v5.3 release, two patches:
>    - "arm64: dts: exynos: Move GPU under /soc node for  Exynos5433"
>    - "arm64: dts: exynos: Move GPU under /soc node for Exynos7"
>    has to be applied first to ensure that GPU node will have correct 'reg'
>    property (nodes under /soc still use 32bit mappings). I'm not sure if

Thanks, applied.

I tried the cc-stable-with-prerequisites syntax. It looks like this:
https://git.kernel.org/pub/scm/linux/kernel/git/krzk/linux.git/commit/?h=next/dt64&id=bed903167ae5b5532eda5d7db26de451bd232da5

I hope it will work...

Best regards,
Krzysztof

