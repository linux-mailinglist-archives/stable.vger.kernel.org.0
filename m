Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 187098614E
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 14:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbfHHMGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 08:06:05 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43467 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbfHHMGF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Aug 2019 08:06:05 -0400
Received: by mail-pg1-f194.google.com with SMTP id r26so8012161pgl.10
        for <stable@vger.kernel.org>; Thu, 08 Aug 2019 05:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QY0vLTd/DtI+BoLweHV1eyVNR0ivfIadKEaonMSKMLc=;
        b=jIWEMf5er9+tizK+48ReAsiaE2Mx+XlmpxAjYYpH8V4xa24nefI94dko4/5d8RKzsB
         hp2mpx2wUrJaM/EgGqO+IUY9/2/oDHY8eMGH98DTznmhLr4vUzERTdyTZdguwxVwflD0
         nIORxE1+1nG2rj1yb7P75bpC8YmecV9XVOw4OgCnOpVHc6d8xMu3XIwwex6PUtJfpRdK
         9nrFUy51veES1U2I8U9JMEoEtdoIC9KXXZy0UgFGtULnWrxtnc06Tl5RGm3cnXsUbLou
         MN7fa0dAxafGXqCJqoDuPk1ErOcsCQ98uqKesoQzpd4mKEf8mKs3KR+xxTk4YVtIda16
         nzpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QY0vLTd/DtI+BoLweHV1eyVNR0ivfIadKEaonMSKMLc=;
        b=bWYB96pCCLW9gjBi8WT64JhhHxhcRWfVmjzsYgJcP+JVeL7AFTQq/6nKA66/1QmKqz
         ljulr5zdCIfS2BwN9Q/bWSUrkCM6wIQxAgQW36mjjg+LCTPfr/HcWSpPTdaqOEqWNvza
         tuFTZaj6xFGAgh+l95J0GPeSlhh8CjEKfB3iB8QZ51NqFE8wqGBsFgz7rMU+wtemwmsj
         TDDJvs9BQpOWKc2EoV1duqF4NlLURU5uwfpYv31mOZZCtxGj9ZlinMq9DmGZJkpD/uZr
         pGw6j/5wVLddnlD146XlPaXysg5kK4XF+nGVX8MAxcxmkU6OSTK6HKfMRk5bv5Y3QRyR
         00qw==
X-Gm-Message-State: APjAAAXFvB34IbaQYEH0ICG9PxBVlodCWorU3eLVa2IskxTGMsff5IcR
        g/Ahm9Qs4mjYo3L9OCJnF5WWt5m0E7M=
X-Google-Smtp-Source: APXvYqwgaHdyFFRt/3UHo8TtFBzfu7jVV1XBtXs2OzBXhleDGl37AKrxd6WRcphUmYdBbpg0Hx3MWA==
X-Received: by 2002:a17:90a:ab0b:: with SMTP id m11mr3838423pjq.73.1565265963879;
        Thu, 08 Aug 2019 05:06:03 -0700 (PDT)
Received: from localhost ([122.172.76.219])
        by smtp.gmail.com with ESMTPSA id y23sm100491085pfo.106.2019.08.08.05.06.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 05:06:02 -0700 (PDT)
Date:   Thu, 8 Aug 2019 17:36:00 +0530
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
Message-ID: <20190808120600.qhbhopvp4e5w33at@vireshk-i7>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
 <4349161f0ed572bbc6bff64bad94aa96d07b27ff.1562908075.git.viresh.kumar@linaro.org>
 <20190731164556.GI39768@lakrids.cambridge.arm.com>
 <20190801052011.2hrei36v4zntyfn5@vireshk-i7>
 <20190806121816.GD475@lakrids.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806121816.GD475@lakrids.cambridge.arm.com>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06-08-19, 13:18, Mark Rutland wrote:
> Upstream and in v4.9, the meltdown patches came before the spectre
> patches, and doing this in the opposite order causes context problems
> like the above.
> 
> Given that, I think it would be less surprising to do the meltdown
> backport first, though I apprecaite that's more work to get these
> patches in. :/

I attempted meltdown backport in the last two days and the amount of
extra patches to be backported is enormous. And I am not sure if
everything is alright as well now, and things will greatly rely on
reviews from you for it.

For this series, what about just backporting for now to account for
CSV3 ? And attempting meltdown backport separately later ?

179a56f6f9fb arm64: Take into account ID_AA64PFR0_EL1.CSV3

-- 
viresh
