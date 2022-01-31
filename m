Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B0B4A469F
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 13:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351790AbiAaMJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 07:09:42 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:46734 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351719AbiAaMJl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 07:09:41 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2652F212C5;
        Mon, 31 Jan 2022 12:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1643630979; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c/9wntyVcPRuIJYO+qxgXPjOo3WXs3vJsPhbe1nzf1M=;
        b=N/LcTHEcanhAuMVVhCc+dJhaN0MCqmxF2ORVJz0ouD5kaWazeEoZLIbmIhA/p3z9255x6h
        UMELlMp9tQOBiVZuS+gUYQt2FTYYMalEETkgjCZ7Z2MN1yTlzpQDNj9yvfwbI9/k9EKAse
        hHsgnV9c/57ZeBd49FibkdE0X8WU0fE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1643630979;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c/9wntyVcPRuIJYO+qxgXPjOo3WXs3vJsPhbe1nzf1M=;
        b=5S+mTZ55tgBMrbqv0z9cZIoypSdbp8GZ6mgtyam5gs8hk7+qbAi4JmAHyWEQ/ywokHnGce
        AW/0uQtvtsFemWAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CC62513C40;
        Mon, 31 Jan 2022 12:09:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 8EFXMILR92F0ZQAAMHmgww
        (envelope-from <ptesarik@suse.cz>); Mon, 31 Jan 2022 12:09:38 +0000
Message-ID: <76a1c7b0-a073-02bb-1612-a74ca97105ec@suse.cz>
Date:   Mon, 31 Jan 2022 13:09:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
From:   =?UTF-8?B?UGV0ciBUZXNhxZnDrWs=?= <ptesarik@suse.cz>
Subject: Re: [PATCH 1/1] KVM: s390: index kvm->arch.idle_mask by vcpu_idx
Content-Language: en-GB
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Michael Mueller <mimu@linux.ibm.com>
References: <20210827125429.1912577-1-pasic@linux.ibm.com>
 <3ca4de98-8f4d-9937-923e-f8865c96f82c@suse.cz>
 <20220131125337.05f73251.pasic@linux.ibm.com>
In-Reply-To: <20220131125337.05f73251.pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Halil,

Dne 31. 01. 22 v 12:53 Halil Pasic napsal(a):
> On Mon, 31 Jan 2022 11:13:18 +0100
> Petr Tesařík <ptesarik@suse.cz> wrote:
> 
>> Hi Halil,
>>
>> Dne 27. 08. 21 v 14:54 Halil Pasic napsal(a):
>>> While in practice vcpu->vcpu_idx ==  vcpu->vcp_id is often true,
>>> it may not always be, and we must not rely on this.
>>>
>>> Currently kvm->arch.idle_mask is indexed by vcpu_id, which implies
>>> that code like
>>> for_each_set_bit(vcpu_id, kvm->arch.idle_mask, online_vcpus) {
>>>                   vcpu = kvm_get_vcpu(kvm, vcpu_id);
>>> 		do_stuff(vcpu);
>>> }
>>> is not legit. The trouble is, we do actually use kvm->arch.idle_mask
>>> like this. To fix this problem we have two options. Either use
>>> kvm_get_vcpu_by_id(vcpu_id), which would loop to find the right vcpu_id,
>>> or switch to indexing via vcpu_idx. The latter is preferable for obvious
>>> reasons.
>>
>> I'm just backporting this fix to SLES 12 SP5, and I've noticed that
>> there is still this code in __floating_irq_kick():
>>
>> 	/* find idle VCPUs first, then round robin */
>> 	sigcpu = find_first_bit(fi->idle_mask, online_vcpus);
>> /* ... round robin loop removed ...
>> 	dst_vcpu = kvm_get_vcpu(kvm, sigcpu);
>>
>> It seems to me that this does exactly the thing that is not legit, but
>> I'm no expert. Did I miss something?
>>
> 
> We made that legit by making the N-th bit in idle_mask correspond to the
> vcpu whose vcpu_idx == N. The second argument of kvm_get_vcpu() is the
> vcpu_idx. IMHO that ain't super-intuitive because it ain't spelled out.
> 
> So before this was a mismatch (with a vcpu_id based bitmap we would have
> to use kvm_get_vcpu_by_id()), and with this patch applied this code
> becomes legit because both idle_mask and kvm_get_vcpu() operate with
> vcpu_idx.
> 
> Does that make sense?

Yes!

> I'm sorry the commit message did not convey this clearly enough...

No, it's not your fault. I didn't pay enough attention to the change, 
and with vcpu_id and vcpu_idx being so similar I got confused.

In short, there's no bug now, indeed. Thanks for your patience.

Petr T
