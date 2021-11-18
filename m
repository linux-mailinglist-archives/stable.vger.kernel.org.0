Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18191455A01
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 12:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343849AbhKRLVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 06:21:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35822 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343760AbhKRLU7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 06:20:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637234279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NQUsvGyK2l93NEDn//YdPMN068V8OCsLEvwQ2ItdtNE=;
        b=BWxJzBZEt9eycxerAm47BxpGR9NilcsOJFd6pvK90gSXKSvGALAciTRHNK8ntaJwg2Zboq
        dJMrI/e/PjInIxbG1KZexGYhnUCmK3Vj+BmSvDM9wDm9wWk5gfPNqa8jH/B7kDrPzZIX7P
        uYJYy+k8o4y5pjz4G7HrTNuNce+6wog=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-1llPDQ2CNHOTU6lhbIdAnw-1; Thu, 18 Nov 2021 06:17:54 -0500
X-MC-Unique: 1llPDQ2CNHOTU6lhbIdAnw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17522875047;
        Thu, 18 Nov 2021 11:17:53 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8406E5C1D0;
        Thu, 18 Nov 2021 11:17:51 +0000 (UTC)
Message-ID: <5d170d5242f1cd9b291f3171120b86d2f2941229.camel@redhat.com>
Subject: Re: [PATCH v2] KVM: x86: check PIR even for vCPUs with disabled
 APICv
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Date:   Thu, 18 Nov 2021 13:17:50 +0200
In-Reply-To: <4ee9fe58-73ca-98fd-3d79-198e1093f722@redhat.com>
References: <20211118072531.1534938-1-pbonzini@redhat.com>
         <8ad47d43a7c8ae19f09cc6ada73665d6e348e213.camel@redhat.com>
         <4ee9fe58-73ca-98fd-3d79-198e1093f722@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2021-11-18 at 12:11 +0100, Paolo Bonzini wrote:
> On 11/18/21 10:56, Maxim Levitsky wrote:
> > vmx_sync_pir_to_irr has 'if (KVM_BUG_ON(!vcpu->arch.apicv_active,
> > vcpu->kvm))' That has to be removed I think for this to work.
> 
> Good point.
> 
> > Plus the above calls now can happen when APICv is fully disabled (and
> > not just inhibited), which is also something that I think that
> > vmx_sync_pir_to_irr should be fixed to be aware of.
> 
> No, that works because sync_pir_to_irr is set to NULL as you point out 
> below.  static_call sites are updated right after ops->hardware_setup(), 
> in kvm_arch_hardware_setup.

I understand now. Thanks!

Best regards,
	Maxim Levitsky

> 
> Paolo
> 
> > Also note that VMX has code that sets vmx_x86_ops.sync_pir_to_irr to
> > NULL in its 'hardware_setup' if APICv is disabled. I wonder if that
> > done befor or after the static_call_cond sites are updated.
> > 
> > I think that this code should be removed as well, and
> > vmx_sync_pir_to_irr should just do nothing when APICv is fully
> > disabled.


