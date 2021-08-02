Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F74A3DDDFF
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 18:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbhHBQw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 12:52:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:51838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229945AbhHBQw2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 12:52:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89CCB610FF;
        Mon,  2 Aug 2021 16:52:17 +0000 (UTC)
Date:   Mon, 2 Aug 2021 17:52:14 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, kernel-team@android.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] KVM: arm64: Unregister HYP sections from kmemleak
 in protected mode
Message-ID: <20210802165214.GK18685@arm.com>
References: <20210802123830.2195174-1-maz@kernel.org>
 <20210802123830.2195174-3-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802123830.2195174-3-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 02, 2021 at 01:38:30PM +0100, Marc Zyngier wrote:
> Booting a KVM host in protected mode with kmemleak quickly results
> in a pretty bad crash, as kmemleak doesn't know that the HYP sections
> have been taken away. This is specially true for the BSS section,
> which is part of the kernel BSS section and registered at boot time
> by kmemleak itself.
> 
> Unregister the HYP part of the BSS before making that section
> HYP-private. The rest of the HYP-specific data is obtained via
> the page allocator or lives in other sections, none of which is
> subjected to kmemleak.
> 
> Fixes: 90134ac9cabb ("KVM: arm64: Protect the .hyp sections from the host")
> Reviewed-by: Quentin Perret <qperret@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: stable@vger.kernel.org # 5.13

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
