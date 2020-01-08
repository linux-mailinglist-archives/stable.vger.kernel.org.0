Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A255B1346B0
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 16:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgAHPvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 10:51:02 -0500
Received: from foss.arm.com ([217.140.110.172]:46418 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728800AbgAHPvC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jan 2020 10:51:02 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA382328;
        Wed,  8 Jan 2020 07:51:01 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 507113F534;
        Wed,  8 Jan 2020 07:51:00 -0800 (PST)
Date:   Wed, 8 Jan 2020 15:50:58 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        maz@kernel.org, drjones@redhat.com, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, peter.maydell@linaro.org,
        stable@vger.kernel.org, suzuki.poulose@arm.com, will@kernel.org
Subject: Re: [PATCHv2 2/3] KVM: arm/arm64: correct CPSR on exception entry
Message-ID: <20200108155057.GG49203@lakrids.cambridge.arm.com>
References: <20200108134324.46500-1-mark.rutland@arm.com>
 <20200108134324.46500-3-mark.rutland@arm.com>
 <3805fc5c-aa84-d203-11e4-b3a41ce5d809@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3805fc5c-aa84-d203-11e4-b3a41ce5d809@arm.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 08, 2020 at 02:41:04PM +0000, Alexandru Elisei wrote:
> On 1/8/20 1:43 PM, Mark Rutland wrote:
> > When KVM injects an exception into a guest, it generates the CPSR value
> > from scratch, configuring CPSR.{M,A,I,T,E}, and setting all other
> > bits to zero.
> >
> > This isn't correct, as the architecture specifies that some CPSR bits
> > are (conditionally) cleared or set upon an exception, and others are
> > unchanged from the original context.
> >
> > This patch adds logic to match the architectural behaviour. To make this
> > simple to follow/audit/extend, documentation references are provided,
> > and bits are configured in order of their layout in SPSR_EL2. This
> > layout can be seen in the diagram on ARM DDI 0487E.a page C5-426.
> >
> > Note that this code is used by both arm and arm64, and is intended to
> > fuction with the SPSR_EL2 and SPSR_HYP layouts.
> >
> > Signed-off-by: Mark Rutland <mark.rutland@arm.com>

> Looks good:
> 
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks!

I've folded that in (along with your Reviewed-by on patch 1), and pushed
out my kvm/exception-state branch again.

Mark.
