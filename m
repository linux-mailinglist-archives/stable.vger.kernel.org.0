Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3C7258D67
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 13:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgIAL0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 07:26:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726895AbgIALZ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 07:25:27 -0400
Received: from gaia (unknown [46.69.195.127])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C0F1206FA;
        Tue,  1 Sep 2020 11:16:45 +0000 (UTC)
Date:   Tue, 1 Sep 2020 12:16:42 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Andre Przywara <andre.przywara@arm.com>, stable@vger.kernel.org,
        James Morse <james.morse@arm.com>
Subject: Re: [PATCH stable v5.4 1/3] KVM: arm64: Add kvm_extable for
 vaxoricism code
Message-ID: <20200901111642.GI5561@gaia>
References: <20200901094923.52486-1-andre.przywara@arm.com>
 <20200901094923.52486-2-andre.przywara@arm.com>
 <79d6944d383945608b685a2d0f9d9b2c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79d6944d383945608b685a2d0f9d9b2c@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 01, 2020 at 12:12:57PM +0100, Marc Zyngier wrote:
> On 2020-09-01 10:49, Andre Przywara wrote:
> > From: James Morse <james.morse@arm.com>
> > 
> > commit e9ee186bb735bfc17fa81dbc9aebf268aee5b41e upstream.
> > 
> > KVM has a one instruction window where it will allow an SError exception
> > to be consumed by the hypervisor without treating it as a hypervisor
> > bug.
> > This is used to consume asynchronous external abort that were caused by
> > the guest.
> > 
> > As we are about to add another location that survives unexpected
> > exceptions,
> > generalise this code to make it behave like the host's extable.
> > 
> > KVM's version has to be mapped to EL2 to be accessible on nVHE systems.
> > 
> > The SError vaxorcism code is a one instruction window, so has two
> > entries
> > in the extable. Because the KVM code is copied for VHE and nVHE, we end
> > up
> > with four entries, half of which correspond with code that isn't mapped.
> > 
> > Cc: <stable@vger.kernel.org> # 5.4.x
> > Cc: Marc Zyngier <maz@kernel.org>
> > Signed-off-by: James Morse <james.morse@arm.com>
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> 
> Can you make sure these patches do carry the sign-off chain as we have
> in mainline? In particular, this is missing:
> 
>     Reviewed-by: Marc Zyngier <maz@kernel.org>
>     Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> You can add your own SoB after this.

Good point. James prepared the backports before we merged the patches
into mainline.

BTW, I also corrected a subject typo: s/vaxoricism/vaxorcism/ (not that
this is a real word ;)).

-- 
Catalin
