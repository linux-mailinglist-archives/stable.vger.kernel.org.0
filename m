Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D11674561E1
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 18:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhKRR7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 12:59:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50873 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230164AbhKRR7l (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 12:59:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637258201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MxhnEclBR8jNFCPokG8x6EB8ezTmbh4+h0AQiwN5yKM=;
        b=J46Nsh4S07B3p7r0t3RJG+I6b6X+sKwqcHd7Djud8Z/MNdWTuD78bVcKuCrvPPr0xj9LPs
        IpAEAgxlBKbPHH3nEd2EWYw3T5/gFeu2tJlU8JWbIjB/n1E+39an3vIzopBTxiuRQDpd4K
        yhAq7SbGkRgLJ5liAa/B3A46R26hzeY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-424-7ABgYMPDPfqCTaDlTPTsEw-1; Thu, 18 Nov 2021 12:56:37 -0500
X-MC-Unique: 7ABgYMPDPfqCTaDlTPTsEw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B953E100C609;
        Thu, 18 Nov 2021 17:56:36 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 82A9410190A7;
        Thu, 18 Nov 2021 17:56:35 +0000 (UTC)
Message-ID: <4316fbc5-b758-a7c6-530d-dc5a97f4e97b@redhat.com>
Date:   Thu, 18 Nov 2021 18:56:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2] KVM: x86: check PIR even for vCPUs with disabled APICv
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org
References: <20211118072531.1534938-1-pbonzini@redhat.com>
 <8ad47d43a7c8ae19f09cc6ada73665d6e348e213.camel@redhat.com>
 <4ee9fe58-73ca-98fd-3d79-198e1093f722@redhat.com>
 <YZZ8hAjbIJnkkraD@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YZZ8hAjbIJnkkraD@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/18/21 17:17, Sean Christopherson wrote:
> On Thu, Nov 18, 2021, Paolo Bonzini wrote:
>> On 11/18/21 10:56, Maxim Levitsky wrote:
>>> vmx_sync_pir_to_irr has 'if (KVM_BUG_ON(!vcpu->arch.apicv_active,
>>> vcpu->kvm))' That has to be removed I think for this to work.
>>
>> Good point.
> 
> Hmm, I think I'd prefer to keep it as
> 
> 	if (KVM_BUG_ON(!enable_apicv))
> 		return -EIO;
> 
> since calling it directly or failing to nullify vmx_x86_ops.sync_pir_to_irr when
> APICv is unsupported would lead to all sorts of errors.  It's not a strong
> preference though.
> 

Sure, why not.  There's a few more changes required to handle 
KVM_REQ_EVENT when APICv is !active on the CPU, so I'll post it early 
next week.

(The MOVE/COPY context stuff also exposed itself as a bit of a 
trainwreck and ate half of my day).

Paolo

