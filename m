Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8AA2DF4E2
	for <lists+stable@lfdr.de>; Sun, 20 Dec 2020 10:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgLTJq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Dec 2020 04:46:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29241 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727112AbgLTJq3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Dec 2020 04:46:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608457502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hZuuWYgsYqtOq9pElDc1NbTuuW8utHaswvEIseLkrwU=;
        b=GStrCtjy0eGbfeO6grjBD5WXROi1jTal+meKsQjcQIOY4FsCUY8J+QsXcrInZunrgIvN56
        nJsiTXQHqTJIeMGFDPhaYTf+oZv2vOU6W0wk/t9DqqtjyyL7qocvCfwpudmB4Zg9zN2Nzc
        jGmKG2adjQ2zV+Z4Eharwfw2N36uN8I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-4szOjY9POcaa_QH5pkrEHg-1; Sun, 20 Dec 2020 04:45:00 -0500
X-MC-Unique: 4szOjY9POcaa_QH5pkrEHg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2AA7F15720;
        Sun, 20 Dec 2020 09:44:59 +0000 (UTC)
Received: from [10.36.112.16] (ovpn-112-16.ams2.redhat.com [10.36.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE42E5C1B4;
        Sun, 20 Dec 2020 09:44:57 +0000 (UTC)
Subject: Re: [PATCH v1 1/4] s390/kvm: VSIE: stop leaking host addresses
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, stable@vger.kernel.org
References: <20201218141811.310267-1-imbrenda@linux.ibm.com>
 <20201218141811.310267-2-imbrenda@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <b1a31982-a967-7439-1a7c-3c948deeb79d@redhat.com>
Date:   Sun, 20 Dec 2020 10:44:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201218141811.310267-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18.12.20 15:18, Claudio Imbrenda wrote:
> The addresses in the SIE control block of the host should not be
> forwarded to the guest. They are only meaningful to the host, and
> moreover it would be a clear security issue.

It's really almost impossible for someone without access to
documentation to understand what we leak. I assume we're leaking the g1
address of a page table (entry), used for translation of g2->g3 to g1.
Can you try making that clearer?

In that case, it's pretty much a random number (of a random page used as
a leave page table) and does not let g1 identify locations of symbols
etc. If so, I don't think this is a "clear security issue" and suggest
squashing this into the actual fix (#p4 I assume).

@Christian, @Janosch? Am I missing something?

> 
> Subsequent patches will actually put the right values in the guest SIE
> control block.
> 
> Fixes: a3508fbe9dc6d ("KVM: s390: vsie: initial support for nested virtualization")
> Cc: stable@vger.kernel.org
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/kvm/vsie.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index 4f3cbf6003a9..ada49583e530 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -416,11 +416,6 @@ static void unshadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>  		memcpy((void *)((u64)scb_o + 0xc0),
>  		       (void *)((u64)scb_s + 0xc0), 0xf0 - 0xc0);
>  		break;
> -	case ICPT_PARTEXEC:
> -		/* MVPG only */
> -		memcpy((void *)((u64)scb_o + 0xc0),
> -		       (void *)((u64)scb_s + 0xc0), 0xd0 - 0xc0);
> -		break;
>  	}
>  
>  	if (scb_s->ihcpu != 0xffffU)
> 


-- 
Thanks,

David / dhildenb

