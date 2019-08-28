Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABFDBA06EF
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 18:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfH1QIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 12:08:09 -0400
Received: from foss.arm.com ([217.140.110.172]:33724 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbfH1QIJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 12:08:09 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9F9CD28;
        Wed, 28 Aug 2019 09:08:08 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 496C53F59C;
        Wed, 28 Aug 2019 09:08:07 -0700 (PDT)
Date:   Wed, 28 Aug 2019 17:08:05 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Viresh Kumar <viresh.kumar@linaro.org>
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
Message-ID: <20190828160804.GB42408@lakrids.cambridge.arm.com>
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
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 08, 2019 at 05:36:00PM +0530, Viresh Kumar wrote:
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

I don't think that buys us anything; that's still going to cause some
context problems (e.g. for commit 179a56f6f9fb itself), and still means
that the v4.4 backport differs from all the others.

If it's really not feasible to do the meltdown patches first, then I
reluctantly agree that we should just do the spectre bits alone if there
aren't major changes that have to be made to entry.S and friends as a
result.

Could you send a v3 (of just the spectre bits) with the changes
requested so far?

Thanks,
Mark.
