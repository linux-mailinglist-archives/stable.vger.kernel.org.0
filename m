Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B506C218DB6
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 18:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgGHQ7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 12:59:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:36000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbgGHQ7b (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jul 2020 12:59:31 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFD11206F6;
        Wed,  8 Jul 2020 16:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594227571;
        bh=uh4+uFjSS8z4pzDfvQDdc+cDo68c1srgnsXeCX9tkrM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LPOU23/WvkxwZI/Js3Zh7GK/6l9f479mhy5NmU59FlaNEvxCW0kiCAXv03Cq25GdU
         0Q7cNxfNnZ5pAnPqAswpQedsrGbgbH250JStUEa1C+5lH13PgW38dBl/PbI4olK495
         wprTQbPlJqgZVFFbs3QBnEqdjTdZ60UZMHgeHm4A=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jtDPt-00A9GR-GX; Wed, 08 Jul 2020 17:59:29 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 08 Jul 2020 17:59:29 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Will Deacon <will@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Fix definition of PAGE_HYP_DEVICE
In-Reply-To: <20200708162546.26176-1-will@kernel.org>
References: <20200708162546.26176-1-will@kernel.org>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <aa1d1bc3bbef499a909ca6367d1bc77b@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kernel-team@android.com, catalin.marinas@arm.com, james.morse@arm.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-07-08 17:25, Will Deacon wrote:
> PAGE_HYP_DEVICE is intended to encode attribute bits for an EL2 stage-1
> pte mapping a device. Unfortunately, it includes PROT_DEVICE_nGnRE 
> which
> encodes attributes for EL1 stage-1 mappings such as UXN and nG, which 
> are
> RES0 for EL2, and DBM which is meaningless as TCR_EL2.HD is not set.
> 
> Fix the definition of PAGE_HYP_DEVICE so that it doesn't set RES0 bits
> at EL2.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
> Marc -- I'm happy to take this as a fix via arm64 with your Ack.
> Please just let me know.
> 
>  arch/arm64/include/asm/pgtable-prot.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Marc Zyngier <maz@kernel.org>

Thanks for fixing this!

         M.
-- 
Jazz is not dead. It just smells funny...
