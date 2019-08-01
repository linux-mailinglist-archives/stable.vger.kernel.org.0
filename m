Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A19E27D681
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 09:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729266AbfHAHle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 03:41:34 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46831 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729140AbfHAHle (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 03:41:34 -0400
Received: by mail-pg1-f194.google.com with SMTP id k189so14620940pgk.13
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 00:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=stRY7i1GZrfY6D+PTgs0D4UrvfUCsK1idtnpqO9v05A=;
        b=FIzQTHdYyzbSF4UXVeIZHy3ZAwIm6WNjJ/7SFU/GqKhukmbYUPc5uoLrynWLyUBJVb
         fRHC5adeqiJFVkCnJcahOseTMZ7e2ZkBrgl6yzcXksAwGWJhQu+I8pPcCuRU+gQJMZrt
         6zWlCDe679nJhA/Frtiufn5nm9bM8CDM32JZOhtmzzcvNFyU0tW2INMvtpZKKuJlNGB1
         Z05sWFHKHngzHjtuXq+dCNMtQE/y0N5oT7ENpWnZjy2HUF3NgPHY0YsXwrYwcAhAhbfK
         BwVZloDwEUKpWfOLiuawIFKfuHlNJKEVWD08Fy5DVw55YcQkMA1MTyaNgn+YACVYM24+
         I9QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=stRY7i1GZrfY6D+PTgs0D4UrvfUCsK1idtnpqO9v05A=;
        b=dCf0pcyIQfrPlPm6vCy9hG2d/fP00ks2/ShVnJzRLUtmNZL0hA359Auw+OVQgZj6W5
         gOZI1I25qrCLE/OsbNhbNxkdCX64hAuaBWvSp1bo2PGx/clLBYguFlEu046mEa1Ai6Kk
         zT9kabZgb2VevWAo/1+K7afc9f2Nw5oi6jDBJbDrOyZQWGHmjnjj8SAHD0w+9O104V/c
         iH+DEU0qQOi1+3plsNBx3hu+9MA4WtZLiWq+ui4GdM/2ISzxFp414oozVMelopC4iyqQ
         kGHCl+t7hJo5JxtMSukYAa5joO/AQVvxBhDEBXzmRGLRah9HB1BaRnDyiL+A7Hma/S67
         9/OQ==
X-Gm-Message-State: APjAAAX8NLPmp8gGctfzex9aQia52SJvxpt7Z1oG61W8LBy9DTUPyjNC
        vAIdX6jUzPgq7hzNROrz0VRbaQ==
X-Google-Smtp-Source: APXvYqyjrB9ZTQXX8An99agwlE3etMrgkqcBgU4z6N9t7CiNe210eVe0fuU/nEZOBJMkJFfzCzTgfw==
X-Received: by 2002:a17:90a:228b:: with SMTP id s11mr6888100pjc.23.1564645293756;
        Thu, 01 Aug 2019 00:41:33 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id u97sm4101405pjb.26.2019.08.01.00.41.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 00:41:32 -0700 (PDT)
Date:   Thu, 1 Aug 2019 13:11:31 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Will Deacon <will@kernel.org>
Cc:     Greg KH <greg@kroah.com>, Mark Rutland <mark.rutland@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, stable@vger.kernel.org,
        mark.brown@arm.com, julien.thierry.kdev@gmail.com,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4.4 V2 25/43] arm64: Move BP hardening to
 check_and_switch_context
Message-ID: <20190801074131.526h5d4hwpxutlq2@vireshk-i7>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
 <f655aaa158af070d45a2bd4965852b0c97a08838.1562908075.git.viresh.kumar@linaro.org>
 <59b252cf-9cb7-128b-4887-c21a8b9b92a9@arm.com>
 <20190801050940.h65crfawrdifsrgg@vireshk-i7>
 <86354576-fc54-a8b7-4dc9-bc613d59fb17@arm.com>
 <20190801063544.ruw444isj5uojjdx@vireshk-i7>
 <20190801065700.GA17391@kroah.com>
 <20190801070541.hpmadulgp45txfem@vireshk-i7>
 <20190801073444.4n45h6kcbmejvzte@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801073444.4n45h6kcbmejvzte@willie-the-truck>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01-08-19, 08:34, Will Deacon wrote:
> On Thu, Aug 01, 2019 at 12:35:41PM +0530, Viresh Kumar wrote:
> > On 01-08-19, 08:57, Greg KH wrote:
> > > On Thu, Aug 01, 2019 at 12:05:44PM +0530, Viresh Kumar wrote:
> > > > On 01-08-19, 07:30, Julien Thierry wrote:
> > > > > I must admit I am not familiar with backport/stable process enough. But
> > > > > personally I think the your suggestion seems more sensible than
> > > > > backporting 4 patches.
> > > > > 
> > > > > Or you can maybe ignore patch 25 and say in patch 24 that among the
> > > > > changes made for the 4.4 codebase, the call arm64_apply_bp_hardening()
> > > > > was moved from post_ttbr_update_workaround as it doesn't exist and
> > > > > placed in check_and_switch_context() as it is its final destination.
> > > > 
> > > > Done that and dropped the other two patches.
> > > > 
> > > > > However, I really don't know what's the best way to proceed according to
> > > > > existing practices. So input from someone else would be welcome.
> > > > 
> > > > Lets see if someone comes up and ask me to do something else :)
> > > 
> > > Keeping the same patches that upstream has is almost always the better
> > > thing to do in the long-run.
> > 
> > That would require two additional patches to be backported, 22 and 23
> > from this series. From your suggestion it seems that keeping them is
> > better here ?
> 
> Yes. Backporting individual patches as they appear upstream is definitely
> the preferred method for -stable. It makes the relationship to mainline
> crystal clear, as well as any dependencies between patches that have been
> backported. Everytime we tweak something unecessarily in a stable backport,
> it just creates the potential for confusion and additional conflicts in
> future backports, so it's best to follow the shape of upstream as closely as
> possible, even if it results in additional patches.
> 
> So I wouldn't worry about total number of patches. I'd worry more about
> things like conflicts, deviation from mainline and overall testing coverage.

Okay, I won't make these changes then. Thanks.

-- 
viresh
