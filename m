Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8E747D603
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 09:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfHAHFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 03:05:44 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33959 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfHAHFo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 03:05:44 -0400
Received: by mail-pl1-f196.google.com with SMTP id i2so31771169plt.1
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 00:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5xEE7OE40acja6HTHPbTsIAF5qXRLsg5qviZS++h4sk=;
        b=Ps1y/Xaz3lwzyYCr5700QuCSNYG1xF1T41Ww1t7m/9jGdfHvnukxkLw5a87d13PFJS
         uk//PQSnx3f8tAzRGhGmlHUZC/+o45lvPGRePqRqPMIuXojnMrmdtDuchFuAqqguGi32
         Rrf4E7/4YBQMgTs7Jw3ROruJl+UkZzjOlpsRIxbL7d+1T3XVu+Jsw5KUtB1IaTSD6MaS
         ywmWRC+zgTspVsGy5Io631w/1rqfihcdqwzV6IRIZ3e0yjobo+NaV36WKradIWi9l6qR
         Uxftp/XvEl8Si9qD5JXtmBEqya2ijb43oQMM3BumaU407REp+xoQI0v7aMdWY9t7gcsa
         PMww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5xEE7OE40acja6HTHPbTsIAF5qXRLsg5qviZS++h4sk=;
        b=GYJohIogFiw9rZeJL3CRBBWwWnMP4/lnzj8YD9qCpw8B2JvlHgbnoRC0OsOdLvZn7X
         8p7SxxzIii7AExyGmKfUZSXJr0Rkf1eu3Xn18tdBGQa/v0MdyryCRCpmUDMSIS7o8YSE
         7vw4gFoauY9HX3L8xqmlwqb39WyXAdsYTj+M9EepmfKfVbaP8jmalq6mg0HOwKQs0saq
         8NHkm0u+DQFQ//04JFqEU/I4l+hjhnGbvbmh6Ve0svfVlx4DFG+IXNTBPRjzC9fFmpK6
         vM/a5an5FVr9iV36VgsXIT78MxjG48whw13dZRz1Ofbntgz48N924xHXDRIQ6j7LxoQ9
         Ubcw==
X-Gm-Message-State: APjAAAVPA0MaiGzyH88OqnyiBdusFHQCGct4hQvTCeNlYIaN7lLrdAo3
        fNQ/9M9ipCT41TpIkl2HMjNqBQ==
X-Google-Smtp-Source: APXvYqzvPJetAaPvVWV5Rh/dqIgG6HC1vo3c28lA11uW4stNKIWem710/6/D393JbPr632qzGwWEIg==
X-Received: by 2002:a17:902:788f:: with SMTP id q15mr126398605pll.236.1564643143876;
        Thu, 01 Aug 2019 00:05:43 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id u1sm66483005pgi.28.2019.08.01.00.05.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 00:05:43 -0700 (PDT)
Date:   Thu, 1 Aug 2019 12:35:41 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Greg KH <greg@kroah.com>
Cc:     Julien Thierry <julien.thierry@arm.com>, stable@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com, julien.thierry.kdev@gmail.com
Subject: Re: [PATCH v4.4 V2 25/43] arm64: Move BP hardening to
 check_and_switch_context
Message-ID: <20190801070541.hpmadulgp45txfem@vireshk-i7>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
 <f655aaa158af070d45a2bd4965852b0c97a08838.1562908075.git.viresh.kumar@linaro.org>
 <59b252cf-9cb7-128b-4887-c21a8b9b92a9@arm.com>
 <20190801050940.h65crfawrdifsrgg@vireshk-i7>
 <86354576-fc54-a8b7-4dc9-bc613d59fb17@arm.com>
 <20190801063544.ruw444isj5uojjdx@vireshk-i7>
 <20190801065700.GA17391@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801065700.GA17391@kroah.com>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01-08-19, 08:57, Greg KH wrote:
> On Thu, Aug 01, 2019 at 12:05:44PM +0530, Viresh Kumar wrote:
> > On 01-08-19, 07:30, Julien Thierry wrote:
> > > I must admit I am not familiar with backport/stable process enough. But
> > > personally I think the your suggestion seems more sensible than
> > > backporting 4 patches.
> > > 
> > > Or you can maybe ignore patch 25 and say in patch 24 that among the
> > > changes made for the 4.4 codebase, the call arm64_apply_bp_hardening()
> > > was moved from post_ttbr_update_workaround as it doesn't exist and
> > > placed in check_and_switch_context() as it is its final destination.
> > 
> > Done that and dropped the other two patches.
> > 
> > > However, I really don't know what's the best way to proceed according to
> > > existing practices. So input from someone else would be welcome.
> > 
> > Lets see if someone comes up and ask me to do something else :)
> 
> Keeping the same patches that upstream has is almost always the better
> thing to do in the long-run.

That would require two additional patches to be backported, 22 and 23
from this series. From your suggestion it seems that keeping them is
better here ?

-- 
viresh
