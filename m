Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2D843434D
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 11:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbfFDJhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 05:37:03 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:38944 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726918AbfFDJhD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 05:37:03 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A33D680D;
        Tue,  4 Jun 2019 02:37:02 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 904793F246;
        Tue,  4 Jun 2019 02:37:01 -0700 (PDT)
Date:   Tue, 4 Jun 2019 10:36:59 +0100
From:   Dave Martin <Dave.Martin@arm.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] KVM: arm64: Filter out invalid core register IDs in
 KVM_GET_REG_LIST
Message-ID: <20190604093658.GT28398@e103592.cambridge.arm.com>
References: <1559580727-13444-1-git-send-email-Dave.Martin@arm.com>
 <20190604092301.26vbijfoapl4whp6@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604092301.26vbijfoapl4whp6@kamzik.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 04, 2019 at 11:23:01AM +0200, Andrew Jones wrote:
> On Mon, Jun 03, 2019 at 05:52:07PM +0100, Dave Martin wrote:
> > Since commit d26c25a9d19b ("arm64: KVM: Tighten guest core register
> > access from userspace"), KVM_{GET,SET}_ONE_REG rejects register IDs
> > that do not correspond to a single underlying architectural register.
> > 
> > KVM_GET_REG_LIST was not changed to match however: instead, it
> > simply yields a list of 32-bit register IDs that together cover the
> > whole kvm_regs struct.  This means that if userspace tries to use
> > the resulting list of IDs directly to drive calls to KVM_*_ONE_REG,
> > some of those calls will now fail.
> > 
> > This was not the intention.  Instead, iterating KVM_*_ONE_REG over
> > the list of IDs returned by KVM_GET_REG_LIST should be guaranteed
> > to work.
> > 
> > This patch fixes the problem by splitting validate_core_offset()
> > into a backend core_reg_size_from_offset() which does all of the
> > work except for checking that the size field in the register ID
> > matches, and kvm_arm_copy_reg_indices() and num_core_regs() are
> > converted to use this to enumerate the valid offsets.
> > 
> > kvm_arm_copy_reg_indices() now also sets the register ID size field
> > appropriately based on the value returned, so the register ID
> > supplied to userspace is fully qualified for use with the register
> > access ioctls.
> 
> Ah yes, I've seen this issue, but hadn't gotten around to fixing it.
> 
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: d26c25a9d19b ("arm64: KVM: Tighten guest core register access from userspace")
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > 
> > ---
> > 
> > Changes since v3:
> 
> Hmm, I didn't see a v1-v3.

Looks like I didn't mark v3 as such when posting [1], but this has been
knocking around for a while.  It was rather low-priority and I hadn't
got around to testing it previously...


[1] [PATCH] KVM: arm64: Filter out invalid core register IDs in KVM_GET_REG_LIST
https://lists.cs.columbia.edu/pipermail/kvmarm/2019-April/035417.html

> > 
> >  * Rebased onto v5.2-rc1.
> > 
> >  * Tested with qemu by migrating from one qemu instance to another on
> >    ThunderX2.
> 
> One of the reasons I was slow to fix this is because QEMU doesn't care
> about the core registers when it uses KVM_GET_REG_LIST. It just completely
> skips all core reg indices, so it never finds out that they're invalid.
> And kvmtool doesn't use KVM_GET_REG_LIST at all. But it's certainly good
> to fix this.

[...]

> Reviewed-by: Andrew Jones <drjones@redhat.com>
> 
> I've also tested this using a kvm selftests test I wrote. I haven't posted
> that test yet because it needs some cleanup and I planned on getting back
> to that when getting back to fixing this issue. Anyway, before this patch
> every other 64-bit core reg index is invalid (because its indexing 32-bits
> but claiming a size of 64), all fp regs are invalid, and we were even
> providing a couple indices that mapped to struct padding. After this patch
> everything is right with the world.
> 
> Tested-by: Andrew Jones <drjones@redhat.com>

Thanks
---Dave
