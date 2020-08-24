Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3FD2501DB
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 18:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgHXQQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 12:16:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbgHXQQk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 12:16:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C68AD20838;
        Mon, 24 Aug 2020 16:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598285800;
        bh=sVMIt4NTydSHDJbd1pZCbQ3XabwLEdzIA0ymX2MLdLk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ag88bNqU15b7HjHbHyC63fLBjAE57kPfVIbO9ANW5jawUJxZNIytank8MvdI1zFYC
         d/iw8fmdkqi88Lq1Pjv5sd0QD3ePFxzMY02q3ufJwON9RK5+1rQMzvYtfJ2uI1vk0k
         YjwUwoLaPJERrsjcJ/zz6U1uPiA7YXhtr5m0yPks=
Date:   Mon, 24 Aug 2020 18:16:50 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Will Deacon <will@kernel.org>
Cc:     linux-kernel@vger.kernel.org, maz@kernel.org,
        suzuki.poulose@arm.com, james.morse@arm.com, pbonzini@redhat.com,
        kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH stable-4.4.y backport] KVM: arm/arm64: Don't reschedule
 in unmap_stage2_range()
Message-ID: <20200824161650.GF435319@kroah.com>
References: <20200824112854.24651-1-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824112854.24651-1-will@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 24, 2020 at 12:28:54PM +0100, Will Deacon wrote:
> Upstream commits fdfe7cbd5880 ("KVM: Pass MMU notifier range flags to
> kvm_unmap_hva_range()") and b5331379bc62 ("KVM: arm64: Only reschedule
> if MMU_NOTIFIER_RANGE_BLOCKABLE is not set") fix a "sleeping from invalid
> context" BUG caused by unmap_stage2_range() attempting to reschedule when
> called on the OOM path.
> 
> Unfortunately, these patches rely on the MMU notifier callback being
> passed knowledge about whether or not blocking is permitted, which was
> introduced in 4.19. Rather than backport this considerable amount of
> infrastructure just for KVM on arm, instead just remove the conditional
> reschedule.
> 
> Cc: <stable@vger.kernel.org> # v4.4 only
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: James Morse <james.morse@arm.com>
> Signed-off-by: Will Deacon <will@kernel.org>

Thanks for tall the backports, now queued up.

greg k-h
