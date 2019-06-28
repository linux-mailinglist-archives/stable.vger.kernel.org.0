Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF3559671
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 10:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfF1IwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 04:52:04 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:43019 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726431AbfF1IwE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 04:52:04 -0400
Received: by mail-oi1-f193.google.com with SMTP id w79so3720492oif.10
        for <stable@vger.kernel.org>; Fri, 28 Jun 2019 01:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lsOvbpUQ1p5oy4ZoXQ9SUcims4T1WqArJuy9bd21jpo=;
        b=tTfTOmZVQAfWOgN3xtqXSgiA0HXDKbFA0XLMV+xrxdCSLCXVEITE7waHUhen1f4sHO
         DUZ6e+NCj63lPqP5P4IG73O+PGcN1zvsAYRcW2YCMznHR7iXyrpI+BR1rrV8x4s9cdle
         Gnqh2IuThTl4+VP6MhX+p8uRsdaoI1Aydz6scdFqoqXftxVVp+3OGGPHiPEJOuL6UFWx
         Ku6e+2ViO+1ZejeyHWTaJUHOVC8clJwCIfLHbSRrcLvnug+wAh+hFSY933TvztvmjM6o
         XmdW9M284c2VSWXsduuatqhk0/Q00+FkVwgyGgJKs6fSwwGn4Fc/tO9feJbEOvXodKp1
         9Wew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lsOvbpUQ1p5oy4ZoXQ9SUcims4T1WqArJuy9bd21jpo=;
        b=bVS0CC5huA9S/0oU+868du9VjgBWypowlu3c3h/4Q3kHdoglN42NAGIM60xpeWAtvL
         UbYzKvPv0cMiS6dwG2Nec2SbS4SB2MtJN/nPVdWulcBf1rGCZLaqhH8tx0tz7bRjGrOG
         DC91sOKCWNoLGYKmpe7puQEy2vKMdMkCH4beY8MQwc1XDX1LVq2TBb+h7XMHzHozdrM5
         EKGwP+pFGBEkkbSj0iSGtsSroRwBnq5SVicMakCGWVqVBqJfMc40nOBrMc+q9byBc2RC
         u1x4YcOnxUv4BQirXz9prynfjNhNpQEnLL6526BOzvdCeFUrJs+za7Lu55QqwnV8Bmwh
         +gng==
X-Gm-Message-State: APjAAAVSW5z1Jb3nCxxC4a1CpfhNuCHNZ7DwA6yvQmhBNi766kQV1tOP
        76rkmNYa+yHyg1pD00mSO9UUEw==
X-Google-Smtp-Source: APXvYqzvxevU5SCTRIlfZKbb0Fhw6DVlbRa/Rm/cyiyHva+kYngXSvNkKwOEFJfA/yW4bAC/QawS9g==
X-Received: by 2002:aca:d7d7:: with SMTP id o206mr1083143oig.92.1561711923482;
        Fri, 28 Jun 2019 01:52:03 -0700 (PDT)
Received: from leoy-ThinkPad-X240s (li964-79.members.linode.com. [45.33.10.79])
        by smtp.gmail.com with ESMTPSA id r13sm576415otk.49.2019.06.28.01.51.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Jun 2019 01:52:02 -0700 (PDT)
Date:   Fri, 28 Jun 2019 16:51:54 +0800
From:   Leo Yan <leo.yan@linaro.org>
To:     Andrew Murray <andrew.murray@arm.com>
Cc:     Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        coresight@lists.linaro.org, Sudeep Holla <sudeep.holla@arm.com>,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Leach <mike.leach@linaro.org>
Subject: Re: [PATCH v2 2/5] coresight: etm4x: use explicit barriers on
 enable/disable
Message-ID: <20190628085154.GD32370@leoy-ThinkPad-X240s>
References: <20190627083525.37463-1-andrew.murray@arm.com>
 <20190627083525.37463-3-andrew.murray@arm.com>
 <20190628024529.GC20296@leoy-ThinkPad-X240s>
 <20190628083523.GG34530@e119886-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628083523.GG34530@e119886-lin.cambridge.arm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andrew,

On Fri, Jun 28, 2019 at 09:35:24AM +0100, Andrew Murray wrote:

[...]

> > > @@ -454,7 +458,8 @@ static void etm4_disable_hw(void *info)
> > >  	control &= ~0x1;
> > >  
> > >  	/* make sure everything completes before disabling */
> > > -	mb();
> > > +	/* As recommended by 7.3.77 of ARM IHI 0064D */
> > > +	dsb(sy);
> > 
> > Here the old code should be right, mb() is the same thing with
> > dsb(sy).
> > 
> > So we don't need to change at here?
> 
> Correct - on arm64 there is no difference between mb and dsb(sy) so no
> functional change on this hunk.
> 
> In repsonse to Suzuki's feedback on this patch, I've updated the commit
> message to describe why I've made this change, as follows:
>      
> "On armv8 the mb macro is defined as dsb(sy) - Given that the etm4x is
> only used on armv8 let's directly use dsb(sy) instead of mb(). This
> removes some ambiguity and makes it easier to correlate the code with
> the TRM."
> 
> Does that make sense?

On reason for preferring to use mb() rather than dsb(sy) is for
compatibility cross different architectures (armv7, armv8, and
so on ...).  Seems to me mb() is a general API and transparent for
architecture's difference.

dsb(sy) is quite dependent on specific Arm architecture, e.g. some old
Arm architecures might don't support dsb(sy); and we are not sure later
it will change for new architectures.

Thanks,
Leo Yan
