Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B158B127FC0
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 16:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfLTPoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 10:44:39 -0500
Received: from foss.arm.com ([217.140.110.172]:52680 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727413AbfLTPoj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 10:44:39 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1306F30E;
        Fri, 20 Dec 2019 07:44:39 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9B9943F6CF;
        Fri, 20 Dec 2019 07:44:37 -0800 (PST)
Date:   Fri, 20 Dec 2019 15:44:35 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Drew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 3/3] KVM: arm/arm64: correct AArch32 SPSR on exception
 entry
Message-ID: <20191220154434.GB25258@lakrids.cambridge.arm.com>
References: <20191220150549.31948-1-mark.rutland@arm.com>
 <20191220150549.31948-4-mark.rutland@arm.com>
 <8e3719bf81f135508eac2378bfee60f2@www.loen.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e3719bf81f135508eac2378bfee60f2@www.loen.fr>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 20, 2019 at 03:36:47PM +0000, Marc Zyngier wrote:
> On 2019-12-20 15:05, Mark Rutland wrote:
> > +static inline unsigned long host_spsr_to_spsr32(unsigned long spsr)
> > +{
> > +	const unsigned long overlap = BIT(24) | BIT(21);
> > +	unsigned long dit = !!(spsr & PSR_AA32_DIT_BIT);
> > +
> > +	spsr &= overlap;
> 
> Are you sure this is what you want to do? This doesn't leave
> that many bits set in SPSR... :-/

Oh, whoops. :(

> Apart from what I believe is a missing ~ above, this looks good.

I've added the missing '~' and pushed out the updated branch.

Thanks,
Mark.
