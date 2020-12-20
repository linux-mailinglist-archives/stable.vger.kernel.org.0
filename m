Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63362DF4FD
	for <lists+stable@lfdr.de>; Sun, 20 Dec 2020 11:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbgLTKPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Dec 2020 05:15:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52423 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727322AbgLTKPb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Dec 2020 05:15:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608459245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L7WBlnc4uBH3yp60EsaVmDi0Gnm0WESlPJ7pAkexlYE=;
        b=UTDlLgLW6FYsj6LN3L/1CkbZwDDd9lQZ2wncHtNhlUfCghg+fJFpSlmK4jX4j9PNp+yS06
        ymVZ4pURrHZRWthFDWxRdYfCx0hmMtLNOyUuigrMuDq6Z4dEM47Vxt3GQpZ7uX1j/R1h3G
        ljooRgGXryBQD8GkQNrn7ebehu7eTY4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-EkyDCo7HO9-EaJpq7SKZJg-1; Sun, 20 Dec 2020 05:14:01 -0500
X-MC-Unique: EkyDCo7HO9-EaJpq7SKZJg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2519615720;
        Sun, 20 Dec 2020 10:14:00 +0000 (UTC)
Received: from [10.36.112.16] (ovpn-112-16.ams2.redhat.com [10.36.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A9D996294D;
        Sun, 20 Dec 2020 10:13:58 +0000 (UTC)
Subject: Re: [PATCH v1 4/4] s390/kvm: VSIE: correctly handle MVPG when in VSIE
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, stable@vger.kernel.org
References: <20201218141811.310267-1-imbrenda@linux.ibm.com>
 <20201218141811.310267-5-imbrenda@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <6836573a-a49d-9d9f-49e0-96b5aa479c52@redhat.com>
Date:   Sun, 20 Dec 2020 11:13:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201218141811.310267-5-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18.12.20 15:18, Claudio Imbrenda wrote:
> Correctly handle the MVPG instruction when issued by a VSIE guest.
> 

I remember that MVPG SIE documentation was completely crazy and full of
corner cases. :)

Looking at arch/s390/kvm/intercept.c:handle_mvpg_pei(), I can spot that

1. "This interception can only happen for guests with DAT disabled ..."
2. KVM does not make use of any mvpg state inside the SCB.

Can this be observed with Linux guests?


Can I get some information on what information is stored at [0xc0, 0xd)
inside the SCB? I assume it's:

0xc0: guest physical address of source PTE
0xc8: guest physical address of target PTE


Also, which conditions have to be met such that we get a ICPT_PARTEXEC:

a) State of guest DAT (I assume off?)
b) State of PTEs: What happens if there is no PTE (I assume we need two
PTEs, otherwise no such intercept)? I assume we get an intercept if one
of both PTEs is not present or the destination PTE is protected. Correct?

So, when we (g1) get an intercept for g3, can we be sure 0xc0 and 0xc8
in the scb are both valid g1 addresses pointing at our PTE, and what do
we know about these PTEs (one not present or destination protected)?

[...]
>  /*
>   * Run the vsie on a shadow scb and a shadow gmap, without any further
>   * sanity checks, handling SIE faults.
> @@ -1063,6 +1132,10 @@ static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>  		if ((scb_s->ipa & 0xf000) != 0xf000)
>  			scb_s->ipa += 0x1000;
>  		break;
> +	case ICPT_PARTEXEC:
> +		if (scb_s->ipa == 0xb254)

Old code hat "/* MVPG only */" - why is this condition now necessary?

> +			rc = vsie_handle_mvpg(vcpu, vsie_page);
> +		break;
>  	}
>  	return rc;
>  }
> 


-- 
Thanks,

David / dhildenb

