Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048DD453904
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 18:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239256AbhKPSAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 13:00:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:52570 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239231AbhKPSAv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 13:00:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637085474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bxRsAOBW/nYmpQYZ1/qsSGInqYX/0c52l0jGtO/u6l4=;
        b=UwaBfFFbU3hbBkEpMa6ybmlM9cMKcI7+ELXg9P7LiNiCxUZWl1n/ZN6IoUeUfg8r+KNzDF
        ml4HrFxQXh8PjwN3tkOntU1AFuB9WiEbZabt1Sa8Me1bMn3GlZ73nR9j9CAi3KW66asdis
        nBUdRLCkPhyWRz2cGu5iiOsUvZuz168=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-jhEMIlk-OzSSU4MNOqdXkw-1; Tue, 16 Nov 2021 12:57:52 -0500
X-MC-Unique: jhEMIlk-OzSSU4MNOqdXkw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5EDC41808323;
        Tue, 16 Nov 2021 17:57:51 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3714460C81;
        Tue, 16 Nov 2021 17:57:50 +0000 (UTC)
Message-ID: <3226f821-1461-b7cf-3f75-ba2e3dcaa446@redhat.com>
Date:   Tue, 16 Nov 2021 18:57:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] KVM: x86: Use a stable condition around all VT-d PI paths
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, jgross@suse.com,
        stable@vger.kernel.org
References: <20211116142205.719375-1-pbonzini@redhat.com>
 <YZPtheR+pShP+CX6@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YZPtheR+pShP+CX6@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/16/21 18:42, Sean Christopherson wrote:
>> +	return kvm_arch_has_assigned_device(kvm) &&
>> +		irq_remapping_cap(IRQ_POSTING_CAP) &&
>> +		irqchip_in_kernel(kvm) && enable_apicv;
> Bad indentation/alignment.

What is even the right indentation?  I'd just wrap everything in 
parentheses but then check patch complains "return is not a function" 
(NSS), so I went for two tabs and called it a day.

> Not that it's likely to matter, but would it make sense to invert the checks so
> that they're short-circuited on the faster KVM checks?  E.g. fastest to slowest:
> 
> 	return irqchip_in_kernel(kvm) && enable_apic &&
> 	       kvm_arch_has_assigned_device(kvm) &&
> 	       irq_remapping_cap(IRQ_POSTING_CAP);

Sure, why not.

Paolo

