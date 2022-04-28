Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD11512B16
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 07:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243198AbiD1Fup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 01:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236607AbiD1Fun (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 01:50:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 65D5960D8E
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 22:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651124847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DG+ZWTYM+2N3N8ie381woeSNrk5TKMnxDxFcPW5T2gU=;
        b=ANwMoVLoAPNn52nzcbabSYPK29Jup2CneEKztpm5MJ8wWbnMN/Qh0TNALykpONhXTVgOun
        DC+kHDQ0lbzWAivtd6O72H7/FAUn677Y0i9gW2UouYaQtbVg+Trm+tJnJ5ZPDaoTjG7Cfj
        SUJz6CqkU21+xhii2z2t1SMs/Whx8iE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-6NkoKukGOtaavdgTVDpqmw-1; Thu, 28 Apr 2022 01:47:23 -0400
X-MC-Unique: 6NkoKukGOtaavdgTVDpqmw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C903885A5BE;
        Thu, 28 Apr 2022 05:47:22 +0000 (UTC)
Received: from starship (unknown [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2536C2024CBB;
        Thu, 28 Apr 2022 05:47:14 +0000 (UTC)
Message-ID: <68707ba71f3e03d9d9a7bc5b0f592fb3cef2f776.camel@redhat.com>
Subject: Re: [PATCH 1/8] KVM: x86: avoid loading a vCPU after .vm_destroy
 was called
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Date:   Thu, 28 Apr 2022 08:47:13 +0300
In-Reply-To: <27670a35-c67e-726f-f03f-9cf2eae83523@redhat.com>
References: <20220322172449.235575-1-mlevitsk@redhat.com>
         <20220322172449.235575-2-mlevitsk@redhat.com> <YkOkCwUgMD1SVfaD@google.com>
         <27670a35-c67e-726f-f03f-9cf2eae83523@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2022-03-30 at 14:07 +0200, Paolo Bonzini wrote:
> On 3/30/22 02:27, Sean Christopherson wrote:
> > Rather than split kvm_free_vcpus(), can we instead move the call to svm_vm_destroy()
> > by adding a second hook, .vm_teardown(), which is needed for TDX?  I.e. keep VMX
> > where it is by using vm_teardown, but effectively move SVM?
> > 
> > https://lore.kernel.org/all/1fa2d0db387a99352d44247728c5b8ae5f5cab4d.1637799475.git.isaku.yamahata@intel.com
> 
> I'd rather do that only for the TDX patches.
> 
> Paolo
> 
Any update on this patch? Looks like it is not upstream nor in kvm/queue.

Best regards,
	Maxim Levitsky

