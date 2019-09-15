Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2CA3B31F8
	for <lists+stable@lfdr.de>; Sun, 15 Sep 2019 22:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbfIOUTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Sep 2019 16:19:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbfIOUTu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Sep 2019 16:19:50 -0400
Received: from localhost (159.35.136.95.rev.vodafone.pt [95.136.35.159])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37949214AF;
        Sun, 15 Sep 2019 20:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568578790;
        bh=jCkVYwV6zbKgIt0Fdzu/rRWlWNH8bz+rGXp5+C0d2XQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FoFGRvIZFA1XkjcABtIPLpBTkKqEp/JFLlrWIz6VMyvY3RWzCWwug1FLfJ+DFDVGH
         62JTuavOMoj8mRlmvw9fIeRHlOatVU+Gzj2M3I6EijrqQNCacrtvAuHMxyVSX+SBLd
         pFKTkPeBV0vr5NuCx+0tUHWroj5+uRT9zoN+bjYg=
Date:   Sun, 15 Sep 2019 16:19:43 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ladi Prosek <lprosek@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 4.19 043/190] KVM: hyperv: define VP assist page helpers
Message-ID: <20190915201943.GQ1546@sasha-vm>
References: <20190913130559.669563815@linuxfoundation.org>
 <20190913130603.202370862@linuxfoundation.org>
 <20190915190130.GA18580@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190915190130.GA18580@amd>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 15, 2019 at 09:01:30PM +0200, Pavel Machek wrote:
>On Fri 2019-09-13 14:04:58, Greg Kroah-Hartman wrote:
>> [ Upstream commit 72bbf9358c3676bd89dc4bd8fb0b1f2a11c288fc ]
>>
>> The state related to the VP assist page is still managed by the LAPIC
>> code in the pv_eoi field.
>
>I don't get it.
>
>>
>> +bool kvm_hv_assist_page_enabled(struct kvm_vcpu *vcpu)
>> +{
>> +	if (!(vcpu->arch.hyperv.hv_vapic & HV_X64_MSR_VP_ASSIST_PAGE_ENABLE))
>> +		return false;
>> +	return vcpu->arch.pv_eoi.msr_val & KVM_MSR_ENABLED;
>> +}
>> +EXPORT_SYMBOL_GPL(kvm_hv_assist_page_enabled);
>> +
>> +bool kvm_hv_get_assist_page(struct kvm_vcpu *vcpu,
>> +			    struct hv_vp_assist_page *assist_page)
>> +{
>> +	if (!kvm_hv_assist_page_enabled(vcpu))
>> +		return false;
>> +	return !kvm_read_guest_cached(vcpu->kvm, &vcpu->arch.pv_eoi.data,
>> +				      assist_page, sizeof(*assist_page));
>> +}
>> +EXPORT_SYMBOL_GPL(kvm_hv_get_assist_page);
>> +
>
>This adds two functions, but not their users. What bug is it fixing? I
>don't see any users in the next patch, either.

Look closer at the following patch.

--
Thanks,
Sasha
