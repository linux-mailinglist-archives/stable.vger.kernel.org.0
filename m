Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64D589FFAF
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 12:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbfH1KYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 06:24:02 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35558 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbfH1KYC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 06:24:02 -0400
Received: by mail-pf1-f194.google.com with SMTP id d85so1445530pfd.2
        for <stable@vger.kernel.org>; Wed, 28 Aug 2019 03:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zSFcplridhj7y02Ycdc0QCZBu/Jgfc6+2J1eLEdrC8U=;
        b=dJOPjff/iJGCBo/PjQjOwXMlyxp5nLDKFpJrw+KCeMIdQy013C7aUggWOC+/HJzc5i
         2/JshmhyjqvLRSwJyMBMwjOon/e+jI0gdmX5AYtw1wysjz1/2uXRcQVVWcpyZNswZCbY
         YxzKDd9+MBjQ/k2YFTc4mSbc3Ybb1OxHkbLYVTA8VGdkCqdvdt2VS+S3VaWfgmuOn8aw
         7XwYWlNY4FYKtQ4ibpKP7kyFGztCnqecRGVCqJcdMoFMgrMfEss+RkmLRwmMY77MoXwy
         azM+MaHKBHXJ8RGNmafhqRLc/zYHT8voOIMmZznjMzjZ1wThLPTCFP6VBYBFYjJAfiBa
         RW2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zSFcplridhj7y02Ycdc0QCZBu/Jgfc6+2J1eLEdrC8U=;
        b=P78gzsHqSbAFRu4YtTMUPi5aKc9S8EWpH+5C7rWS/rx1fyyc9bR81pDvWOoIP92GMI
         /BTpWrzFrpr6b1aegfHjOLbb+9pm2+m23RFfwth1n0PFZmp2HuGejqClbNJMRhwfbxDw
         mVV6s65LzSz/RD4i/g47z3+y4EyGXjwcX7CWyM7adTRlC34GRkvOjmU3gYL7AwEUtHdy
         5dU/KNUf6Y4fkRTaypyelNjXbyDq8dXSIHdV9nTnTWz+Fn1JPEmPS3H6a0M/wycrVEU6
         eAOpf5bKZytwrr32CI/dScg5ynAjQLcUcYu2lrqVFvX24wSGnEo6L7uykK3VWlIRAE0D
         GWGA==
X-Gm-Message-State: APjAAAW08rpGq55iIpapiqkQgiQLYjqEWEVht39cYXnLibooSEAnVsPr
        T7nxQtFwH+sfoaMkrUYzkcf+eA==
X-Google-Smtp-Source: APXvYqxxjScNWNqUf4XJIY8BRc5y0WHCZv7XV1cQaiSqTGH7clqNM6xU6KCYvNjD2avSjsBnU1e1HQ==
X-Received: by 2002:a65:41c2:: with SMTP id b2mr2804787pgq.320.1566987841270;
        Wed, 28 Aug 2019 03:24:01 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id e185sm3129030pfa.119.2019.08.28.03.23.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 03:23:58 -0700 (PDT)
Date:   Wed, 28 Aug 2019 15:53:56 +0530
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
Subject: Re: [PATCH v4.4 V2 24/43] arm64: Add skeleton to harden the branch
 predictor against aliasing attacks
Message-ID: <20190828102356.tlhgi3riue3bl5p4@vireshk-i7>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
 <4349161f0ed572bbc6bff64bad94aa96d07b27ff.1562908075.git.viresh.kumar@linaro.org>
 <20190731164556.GI39768@lakrids.cambridge.arm.com>
 <20190801052011.2hrei36v4zntyfn5@vireshk-i7>
 <20190806121816.GD475@lakrids.cambridge.arm.com>
 <20190808120600.qhbhopvp4e5w33at@vireshk-i7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808120600.qhbhopvp4e5w33at@vireshk-i7>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08-08-19, 17:36, Viresh Kumar wrote:
> On 06-08-19, 13:18, Mark Rutland wrote:
> > Upstream and in v4.9, the meltdown patches came before the spectre
> > patches, and doing this in the opposite order causes context problems
> > like the above.
> > 
> > Given that, I think it would be less surprising to do the meltdown
> > backport first, though I apprecaite that's more work to get these
> > patches in. :/
> 
> I attempted meltdown backport in the last two days and the amount of
> extra patches to be backported is enormous. And I am not sure if
> everything is alright as well now, and things will greatly rely on
> reviews from you for it.
> 
> For this series, what about just backporting for now to account for
> CSV3 ? And attempting meltdown backport separately later ?
> 
> 179a56f6f9fb arm64: Take into account ID_AA64PFR0_EL1.CSV3

@Mark ?

-- 
viresh
