Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7F57D65F
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 09:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbfHAHev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 03:34:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbfHAHev (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Aug 2019 03:34:51 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81130205F4;
        Thu,  1 Aug 2019 07:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564644890;
        bh=oCubh7Cb+deCvDcmZg9vFwBuc4+abNFtLvJvRi/oQQk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LJKpg5ujtimcG0q3vt17cCHRCeqkYqVdFX3WBgkPJB6ycDpNolRW8M587y2eQMS/u
         7WeauE9TNOYUXm9X07zTqg66i5n93heatoZda8br62ExmWPlMEy5GmDgQtYgf4t+L2
         oU6N9bnSmoy879K7pZhOWhwVnipiVE6nfN+Y8dLM=
Date:   Thu, 1 Aug 2019 08:34:45 +0100
From:   Will Deacon <will@kernel.org>
To:     Viresh Kumar <viresh.kumar@linaro.org>
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
Message-ID: <20190801073444.4n45h6kcbmejvzte@willie-the-truck>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
 <f655aaa158af070d45a2bd4965852b0c97a08838.1562908075.git.viresh.kumar@linaro.org>
 <59b252cf-9cb7-128b-4887-c21a8b9b92a9@arm.com>
 <20190801050940.h65crfawrdifsrgg@vireshk-i7>
 <86354576-fc54-a8b7-4dc9-bc613d59fb17@arm.com>
 <20190801063544.ruw444isj5uojjdx@vireshk-i7>
 <20190801065700.GA17391@kroah.com>
 <20190801070541.hpmadulgp45txfem@vireshk-i7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801070541.hpmadulgp45txfem@vireshk-i7>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 01, 2019 at 12:35:41PM +0530, Viresh Kumar wrote:
> On 01-08-19, 08:57, Greg KH wrote:
> > On Thu, Aug 01, 2019 at 12:05:44PM +0530, Viresh Kumar wrote:
> > > On 01-08-19, 07:30, Julien Thierry wrote:
> > > > I must admit I am not familiar with backport/stable process enough. But
> > > > personally I think the your suggestion seems more sensible than
> > > > backporting 4 patches.
> > > > 
> > > > Or you can maybe ignore patch 25 and say in patch 24 that among the
> > > > changes made for the 4.4 codebase, the call arm64_apply_bp_hardening()
> > > > was moved from post_ttbr_update_workaround as it doesn't exist and
> > > > placed in check_and_switch_context() as it is its final destination.
> > > 
> > > Done that and dropped the other two patches.
> > > 
> > > > However, I really don't know what's the best way to proceed according to
> > > > existing practices. So input from someone else would be welcome.
> > > 
> > > Lets see if someone comes up and ask me to do something else :)
> > 
> > Keeping the same patches that upstream has is almost always the better
> > thing to do in the long-run.
> 
> That would require two additional patches to be backported, 22 and 23
> from this series. From your suggestion it seems that keeping them is
> better here ?

Yes. Backporting individual patches as they appear upstream is definitely
the preferred method for -stable. It makes the relationship to mainline
crystal clear, as well as any dependencies between patches that have been
backported. Everytime we tweak something unecessarily in a stable backport,
it just creates the potential for confusion and additional conflicts in
future backports, so it's best to follow the shape of upstream as closely as
possible, even if it results in additional patches.

So I wouldn't worry about total number of patches. I'd worry more about
things like conflicts, deviation from mainline and overall testing coverage.

Will
