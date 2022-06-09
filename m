Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA63554456D
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 10:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239312AbiFIINi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 04:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240595AbiFIINd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 04:13:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3F13C5EDF3
        for <stable@vger.kernel.org>; Thu,  9 Jun 2022 01:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654762411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0UBhD5YEWFNp4aDc/ahVKPUNtBuVUhhYKUmhLtmUs50=;
        b=gZzX9GF1NuOTJ/lWGBC+MFKjq/F8t4B2JUwc6fbGAwBAImjs44uBDu2QEXbU8IKCFW/ENw
        bs/nYZYGBh7QO55PLDFPydIhsRgiKJBEpljSW/Mji6RuG/f5cW4NEszcNhnCBg0iO6bzFr
        dZBpSLswvlgY21RcqzWIMFbV7noFgt8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-LSqcigi8OVWcf-rDwFRfYQ-1; Thu, 09 Jun 2022 04:13:27 -0400
X-MC-Unique: LSqcigi8OVWcf-rDwFRfYQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AEF381C004E9;
        Thu,  9 Jun 2022 08:13:26 +0000 (UTC)
Received: from starship (unknown [10.40.194.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C72111121315;
        Thu,  9 Jun 2022 08:13:22 +0000 (UTC)
Message-ID: <909920fcfb5a614861fbc2654b3e8c1f0240bb51.camel@redhat.com>
Subject: Re: [PATCH 4/7] KVM: x86: SVM: fix avic_kick_target_vcpus_fast
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        stable@vger.kernel.org
Date:   Thu, 09 Jun 2022 11:13:21 +0300
In-Reply-To: <c7fb78e2-2650-f9a2-3062-5d5ecc34332b@redhat.com>
References: <20220606180829.102503-1-mlevitsk@redhat.com>
         <20220606180829.102503-5-mlevitsk@redhat.com>
         <c7fb78e2-2650-f9a2-3062-5d5ecc34332b@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2022-06-08 at 15:21 +0200, Paolo Bonzini wrote:
> On 6/6/22 20:08, Maxim Levitsky wrote:
> > There are two issues in avic_kick_target_vcpus_fast
> > 
> > 1. It is legal to issue an IPI request with APIC_DEST_NOSHORT
> >     and a physical destination of 0xFF (or 0xFFFFFFFF in case of x2apic),
> >     which must be treated as a broadcast destination.
> > 
> >     Fix this by explicitly checking for it.
> >     Also don’t use ‘index’ in this case as it gives no new information.
> > 
> > 2. It is legal to issue a logical IPI request to more than one target.
> >     Index field only provides index in physical id table of first
> >     such target and therefore can't be used before we are sure
> >     that only a single target was addressed.
> > 
> >     Instead, parse the ICRL/ICRH, double check that a unicast interrupt
> >     was requested, and use that info to figure out the physical id
> >     of the target vCPU.
> >     At that point there is no need to use the index field as well.
> > 
> > 
> > In addition to fixing the above	issues,	also skip the call to
> > kvm_apic_match_dest.
> > 
> > It is possible to do this now, because now as long as AVIC is not
> > inhibited, it is guaranteed that none of the vCPUs changed their
> > apic id from its default value.
> > 
> > 
> > This fixes boot of windows guest with AVIC enabled because it uses
> > IPI with 0xFF destination and no destination shorthand.
> > 
> > Fixes: 7223fd2d5338 ("KVM: SVM: Use target APIC ID to complete AVIC IRQs when possible")
> > Cc: stable@vger.kernel.org
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> Is it possible to use kvm_intr_is_single_vcpu_fast, or am I missing 
> something?

Yes, except that it needs 'struct kvm_lapic_irq' which we won't have when
we emulate guest<->guest interrupts, and also it goes over apic map and such,
which can be be skipped.

It also does more unneeded things like dealing with low priority mode for example,
which thankfully AVIC doenst' support and if attempted will still VM exit
with 'incomplete IPI' but with AVIC_IPI_FAILURE_INVALID_INT_TYPE subreason,
which goes through full APIC register emulation.

I do think about the fact that ICRL/H parsing in the case of logical ID,
(which depends on cluser mode and x2apic mode) can be moved to some common
code, but I wasn't able yet to find a clean way to do it.

BTW: there is another case where AVIC must be inhibited: in xapic mode,
logical ids, don't have to have a single bit set in the mask area of the logical id, 
(low 4 bits in cluster mode and all 8 bits in flat mode)
and neither there is a guarnantee that multilple CPUs don't share these bits.

AVIC however has a logical ID table which maps each (bit x cluster value) to a physical id,
and therefore a single vCPU, so tha later is not possible to support with AVIC.

I haven't studied the code that is responsible for this, I will do this soon.


Thankfully IPIv only supports physical IPI mode (this is what I heard, don't know for sure).

I also will write a unit test for this very soon, to test various logical id
IPIs, messing with logical id registers, etc, etc.

Best regards,
	Maxim Levitsky


> 
> Series queued, thanks.
> 
> Paolo
> 


