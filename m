Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5CC436E00
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 01:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbhJUXMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Oct 2021 19:12:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26213 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232164AbhJUXMf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Oct 2021 19:12:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634857818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XYdsUZzx5QU5AAt5z09EOuFHW+CZ0X7lELgHpIVoMrc=;
        b=H2J71iCcfna9Ghe7a+FtlCSKoUF0TcyjzTCbGSv8PhuCgK3/6jYWIiuWFhtK0oMEOdGUSD
        pius5P3evb74zcR6oE4ZLnbnoF4IYVWz+1OQsoi1X/j+NycDNuc1sILlYnk4jQzCoa2rQd
        48DRw5uc448RwSkXahL0nC0aa5EEfBM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-db70K_CON-i4hMUocFdsLQ-1; Thu, 21 Oct 2021 19:10:13 -0400
X-MC-Unique: db70K_CON-i4hMUocFdsLQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D5F29126B;
        Thu, 21 Oct 2021 23:10:12 +0000 (UTC)
Received: from starship (unknown [10.40.192.246])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4BC276788F;
        Thu, 21 Oct 2021 23:10:09 +0000 (UTC)
Message-ID: <d2d183e69cea95df5b46df229173460d53edbd44.camel@redhat.com>
Subject: Re: [PATCH 1/8] KVM: SEV-ES: fix length of string I/O
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     fwilhelm@google.com, seanjc@google.com, oupton@google.com,
        stable@vger.kernel.org
Date:   Fri, 22 Oct 2021 02:10:08 +0300
In-Reply-To: <20211013165616.19846-2-pbonzini@redhat.com>
References: <20211013165616.19846-1-pbonzini@redhat.com>
         <20211013165616.19846-2-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2021-10-13 at 12:56 -0400, Paolo Bonzini wrote:
> The size of the data in the scratch buffer is not divided by the size of
> each port I/O operation, so vcpu->arch.pio.count ends up being larger
> than it should be by a factor of size.
> 
> Cc: stable@vger.kernel.org
> Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm/sev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c36b5fe4c27c..e672493b5d8d 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2583,7 +2583,7 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
>  		return -EINVAL;
>  
>  	return kvm_sev_es_string_io(&svm->vcpu, size, port,
> -				    svm->ghcb_sa, svm->ghcb_sa_len, in);
> +				    svm->ghcb_sa, svm->ghcb_sa_len / size, in);
>  }
>  
>  void sev_es_init_vmcb(struct vcpu_svm *svm)

This ends in kvm_sev_es_ins/outs and both indeed expect count of operations which they pass to emulator_pio_{out|in}_emulated

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

