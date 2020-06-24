Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC292073DE
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 14:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389254AbgFXM6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 08:58:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389124AbgFXM6w (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jun 2020 08:58:52 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC7F920706;
        Wed, 24 Jun 2020 12:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593003531;
        bh=wc5mxzVtIYH7yXtP0I4Y5L+JdMP9jb1MqWLgvygyC2Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g7LBBWk0hcjd9EWZt5yCOj+T1kx3Nm+H/7l/getRmdhgGbnYXcCS7OByq70ddLFLp
         c26IiFZtjdu0zSZHl/BF7aEBhL5FZ21TcitI3oJgebolD4iDQdMXOL2H/63jOWFhbl
         1LguVB1N74FOG5WCRfQjYaROpMCGXIAihnhNJpsM=
Date:   Wed, 24 Jun 2020 13:58:46 +0100
From:   Will Deacon <will@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        stable@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>
Subject: Re: [PATCH stable 4.9] arm64: entry: Place an SB sequence following
 an ERET instruction
Message-ID: <20200624125846.GD6270@willie-the-truck>
References: <20200612044219.31606-1-f.fainelli@gmail.com>
 <2bcebe48-1218-403a-798c-da30d678fdd6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2bcebe48-1218-403a-798c-da30d678fdd6@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 23, 2020 at 11:46:37AM -0700, Florian Fainelli wrote:
> On 6/11/20 9:42 PM, Florian Fainelli wrote:
> > From: Will Deacon <will.deacon@arm.com>
> > 
> > commit 679db70801da9fda91d26caf13bf5b5ccc74e8e8 upstream
> > 
> > Some CPUs can speculate past an ERET instruction and potentially perform
> > speculative accesses to memory before processing the exception return.
> > Since the register state is often controlled by a lower privilege level
> > at the point of an ERET, this could potentially be used as part of a
> > side-channel attack.
> > 
> > This patch emits an SB sequence after each ERET so that speculation is
> > held up on exception return.
> > 
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > [florian: Adjust hyp-entry.S to account for the label]
> > Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> > ---
> > Will,
> > 
> > Can you confirm that for 4.9 these are the only places that require
> > patching? Thank you!
> 
> Hi Will, Catalin,
> 
> Does this look good to you for a 4.9 backport? I would like to see this
> included at some point since this pertains to CVE-2020-13844.

I think you're missing one of the ERET instructions in hyp/entry.S

Will
