Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D40342A9C
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 06:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhCTE57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 00:57:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47305 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229872AbhCTE5o (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Mar 2021 00:57:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616216263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J3dVHYyPLLYK+/fjLt1QByORvvHqzjgGQxzlyWvSTq0=;
        b=ixG4f4IKPk9iegLZk4Bkjh+zntqncegA7J8OXMHVjhPnygV5ns/ymFSZIjAJe0XaFMx3tv
        JmwRuWk+5868Fkn94xwdzrpn1EBcsVD9TBXklTIsFqMKxB0KwwVWilf5kgOwxZIwfzuJgA
        vKgRikZ1YHnW9ZqJMEN8eyZmLAyP+J8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-t7vHDpVgNUa3n5WbSuuKqA-1; Sat, 20 Mar 2021 00:57:39 -0400
X-MC-Unique: t7vHDpVgNUa3n5WbSuuKqA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86B041007467;
        Sat, 20 Mar 2021 04:57:37 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-13.ams2.redhat.com [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4AB445C1D1;
        Sat, 20 Mar 2021 04:57:32 +0000 (UTC)
Subject: Re: [PATCH v1 1/2] s390/kvm: split kvm_s390_real_to_abs
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org
References: <20210319193354.399587-1-imbrenda@linux.ibm.com>
 <20210319193354.399587-2-imbrenda@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <fa583ab0-36ac-47a7-7fa3-4ce88c518488@redhat.com>
Date:   Sat, 20 Mar 2021 05:57:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210319193354.399587-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19/03/2021 20.33, Claudio Imbrenda wrote:
> A new function _kvm_s390_real_to_abs will apply prefixing to a real address
> with a given prefix value.
> 
> The old kvm_s390_real_to_abs becomes now a wrapper around the new function.
> 
> This is needed to avoid code duplication in vSIE.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   arch/s390/kvm/gaccess.h | 23 +++++++++++++++++------
>   1 file changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
> index daba10f76936..7c72a5e3449f 100644
> --- a/arch/s390/kvm/gaccess.h
> +++ b/arch/s390/kvm/gaccess.h
> @@ -18,17 +18,14 @@
>   
>   /**
>    * kvm_s390_real_to_abs - convert guest real address to guest absolute address
> - * @vcpu - guest virtual cpu
> + * @prefix - guest prefix
>    * @gra - guest real address
>    *
>    * Returns the guest absolute address that corresponds to the passed guest real
> - * address @gra of a virtual guest cpu by applying its prefix.
> + * address @gra of by applying the given prefix.
>    */
> -static inline unsigned long kvm_s390_real_to_abs(struct kvm_vcpu *vcpu,
> -						 unsigned long gra)
> +static inline unsigned long _kvm_s390_real_to_abs(u32 prefix, unsigned long gra)

<bikeshedding>
Just a matter of taste, but maybe this could be named differently? 
kvm_s390_real2abs_prefix() ? kvm_s390_prefix_real_to_abs()?
</bikeshedding>

Anyway:
Reviewed-by: Thomas Huth <thuth@redhat.com>

