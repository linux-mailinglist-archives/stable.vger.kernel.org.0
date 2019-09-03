Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37980A606B
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 07:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbfICFPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 01:15:09 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34663 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfICFPJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 01:15:09 -0400
Received: by mail-pf1-f196.google.com with SMTP id b24so10060726pfp.1
        for <stable@vger.kernel.org>; Mon, 02 Sep 2019 22:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZeFgyFIHCDtxRARd0KAjIBoFG6zEBmwoBwDcSrmUBO4=;
        b=qK+fUm3oO9zpLsBqRCJYOE3M5fwIde5pU3QD3Vy+RaQP3i6XutK1x1jCr48WwiEstL
         lSJ2/xGIH3I31pkalrf/j5bcB1HEHxk7WlL8zT7kFkpdozhKoR1Q5Rybzg2Js4mGPEF4
         /DfF9MXYfamdhrcUxaTztedS75OfQHzJjSBq5QtfdfsBRbenHcvrdK7NPGc6fSVZ5Ufe
         7ku/DiLD62PLmH5wOh+E/aFfJ1FHR8VDryYWQkxv5eYXGrfkeRPW+8S71rQtRHmT/W89
         793w4QnOurZU0CLIxiTm7vnDdKTgOPv75Ho/ocZQNDmn1e82BvLwXPrestXCOs+kFpGi
         eFTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZeFgyFIHCDtxRARd0KAjIBoFG6zEBmwoBwDcSrmUBO4=;
        b=LqZYmHsydBlHN2cb+OVyrxVhUtrHoyxOscQB6cMxiGjZncMiioTcNRYioGH4ZyVxhg
         GjubL8j9+GOQbdnIxzR323Hk4uPmkO+c9QGhcOD0PGv0dlr47gHbKKl1cCQWis9sKJXp
         2ZK71r/oLee0ytQR1Qs8jAdMr0Hxe5J3feevA6cwDsA+jDp9lHx9tuJNRDEPixu223R4
         eAfpDct+e+TgcQlZkGeDYEifKqb4Unas89ExHG3ultkxqSRGzTCKZFZ3xaUGdanqyTFT
         lwJrsJR5Wr3d0K9lcNVQLHaXH3dQHji8Nj0T173hueFT0GMeAn5mRapRlCvyvpnL8I4C
         2siw==
X-Gm-Message-State: APjAAAXNCvvTr+SDDF3ZuKq8bDndsPtIObC+tJprkjWJQsDLRk9Uj2+M
        mMgOwiBmboATpE28QOhW+SX7vA==
X-Google-Smtp-Source: APXvYqyHtSrm5YyZjYXdqdq+0yUaF32Axr3lTT0vASucA20PnjDHcHbH8EMoHDj2RHxLBsIEORzYSQ==
X-Received: by 2002:a63:d90f:: with SMTP id r15mr28309557pgg.259.1567487708752;
        Mon, 02 Sep 2019 22:15:08 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id e9sm20604854pja.17.2019.09.02.22.15.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Sep 2019 22:15:07 -0700 (PDT)
Date:   Tue, 3 Sep 2019 10:45:05 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: Re: [PATCH ARM64 v4.4 V3 44/44] arm64: futex: Mask __user pointers
 prior to dereference
Message-ID: <20190903051505.yere5kimi42e24v7@vireshk-i7>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
 <965d727955b4a45ac1f12e67c6a433110ef94871.1567077734.git.viresh.kumar@linaro.org>
 <20190830094249.GL46475@lakrids.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830094249.GL46475@lakrids.cambridge.arm.com>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30-08-19, 10:42, Mark Rutland wrote:
> On Thu, Aug 29, 2019 at 05:04:29PM +0530, Viresh Kumar wrote:
> > From: Will Deacon <will.deacon@arm.com>
> > 
> > commit 91b2d3442f6a44dce875670d702af22737ad5eff upstream.
> > 
> > The arm64 futex code has some explicit dereferencing of user pointers
> > where performing atomic operations in response to a futex command. This
> > patch uses masking to limit any speculative futex operations to within
> > the user address space.
> > 
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> This would have made more sense immediately following patch 11, as in
> mainline and the v4.9 backport. Having things applied in the same order
> makes it much easier to compare and verify.

Ahh, indeed the order was that way in the arm64/kpti branch, but not
in the stable branch where it got applied at the end and I followed
that order :(

Fixed the ordering now. Thanks.

-- 
viresh
