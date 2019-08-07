Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7505848DE
	for <lists+stable@lfdr.de>; Wed,  7 Aug 2019 11:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbfHGJt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Aug 2019 05:49:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727842AbfHGJt1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Aug 2019 05:49:27 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3189222FC;
        Wed,  7 Aug 2019 09:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565171366;
        bh=YWjJTH9BX33ozN1JnaT38MtkFUk72jD2U5RQUqOZJfM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VwRXZIGTJJgv5q38Pxz0+XZnHv7QC1okh7Q8bYBwnGHzoNlTuMcRIdJA6vIRFD/X5
         bme/5xkGsxYOgEkCgdUp4HqMtfTOLXELc02K5kH20QLuPgt9yNOtg+2GlY6BMyxsqs
         sbeg0c9vVdtHGiY32EdJ6ZK5YlEKdI3gdNHyOFK0=
Date:   Wed, 7 Aug 2019 10:49:19 +0100
From:   Will Deacon <will@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        suzuki.poulose@arm.com
Subject: Re: [PATCH 0/2] [Backport for 4.4.y stable] arm64 CTR_EL0 cpufeature
 fixes
Message-ID: <20190807094919.qzkf2jj6m4qrecsl@willie-the-truck>
References: <20190805171308.19249-1-will@kernel.org>
 <20190806212904.GL17747@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806212904.GL17747@sasha-vm>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha, [+Suzuki]

On Tue, Aug 06, 2019 at 05:29:04PM -0400, Sasha Levin wrote:
> On Mon, Aug 05, 2019 at 06:13:06PM +0100, Will Deacon wrote:
> > These two patches are backports for 4.4.y stable kernels after one of
> > them failed to apply:
> > 
> >  https://lkml.kernel.org/r/156498316752100@kroah.com
> 
> I took these 2, but note that they have two fixes that are not in 4.4:
> 
> 314d53d297980 arm64: Handle mismatched cache type
> 4c4a39dd5fe2d arm64: Fix mismatched cache line size detection
> 
> Will you send a backport for them?

4.4 doesn't handle mismatches for the cache type or the line sizes, and
instead taints the kernel with a big splat at boot. If we wanted to
backport this, we'd need to pick up more than just the above patches, since
we don't have the means to emulate user cache maintenance operations either.

Given that the vast majority of systems don't suffer from this problem,
I'd be inclined not to try shoe-horning all of this into 4.4, where I think
it's more likely introduce other issues.

Suzuki, what do you think?

Will
