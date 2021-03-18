Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781D334066E
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 14:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbhCRNIQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 09:08:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231304AbhCRNHz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Mar 2021 09:07:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EB6964F01;
        Thu, 18 Mar 2021 13:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616072875;
        bh=MG89MYSdpuKmskYRMKAcawmwc2DP/92dyzf8UU5Qem0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JMt09k8Cq0FEScH0OrQOE7qbQnKmSwP08X7vPCmznolggqk9F9v+L0pajV+Ko6ZUA
         g4HLdc6JkePldHMe/g5LlOQKINzNAeKkNzFl7BaIyam5ZKhFwN+CXHU2c5NN0809eM
         PaA/BF4n9Y9cEIRZGaoz+GQ+nwQAj3tjiQuDIF1yXucvIa7x3gbxR0IShD+mATWlSr
         OffF34b2JB6pIjet87fascqldPZMjF8p5ECOz2zi9T1+jZ1jLPsI7P7JErSlO7LEMz
         Q5GyP5eMwC3EKPMsLBWnlHlZBg5ha0dyjtDRbTBv72s/K9qVShv2e9P49L3tBDf2cJ
         tPfBNFIf6TSHA==
Date:   Thu, 18 Mar 2021 09:07:54 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>, stable@vger.kernel.org,
        catalin.marinas@arm.com, will@kernel.org, alexandru.elisei@arm.com,
        christoffer.dall@arm.com
Subject: Re: [PATCH] KVM: arm64: nvhe: Save the SPE context early
Message-ID: <YFNQqsr34+dtLyGb@sashalap>
References: <16157981451454@kroah.com>
 <20210316183353.4081445-1-suzuki.poulose@arm.com>
 <87eegdj2yf.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <87eegdj2yf.wl-maz@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 17, 2021 at 01:59:36PM +0000, Marc Zyngier wrote:
>On Tue, 16 Mar 2021 18:33:53 +0000,
>Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>>
>> commit b96b0c5de685df82019e16826a282d53d86d112c upstream
>>
>> The nVHE KVM hyp drains and disables the SPE buffer, before
>> entering the guest, as the EL1&0 translation regime
>> is going to be loaded with that of the guest.
>>
>> But this operation is performed way too late, because :
>>  - The owning translation regime of the SPE buffer
>>    is transferred to EL2. (MDCR_EL2_E2PB == 0)
>>  - The guest Stage1 is loaded.
>>
>> Thus the flush could use the host EL1 virtual address,
>> but use the EL2 translations instead of host EL1, for writing
>> out any cached data.
>>
>> Fix this by moving the SPE buffer handling early enough.
>> The restore path is doing the right thing.
>>
>> Cc: stable@vger.kernel.org # v5.4-
>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>
>Acked-by: Marc Zyngier <maz@kernel.org>

Queued up this and the 4.19 backport, thanks!

-- 
Thanks,
Sasha
