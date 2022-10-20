Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27232605B2C
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 11:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiJTJbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 05:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbiJTJbR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 05:31:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B31B13FDE1
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 02:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666258271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IBgj4Fw1P4eekn5EviwqvOJ2K/YwxD/QOnBlpto11Zg=;
        b=O5ryYTQqQFBNfUMm10Pk3t3HoJjEeHge5NrUTwo0znTPDz8j/EAYzNRkTohd1LCxhWowq9
        qvMG6V6PJUgq1J3ugEi2luCC1P6f9isK2V6BZRYXv59NMeGtNXGcH23RerVdL3tOOI3dhN
        GDQSJna7TA9/bw0vI22y8TWlDNFCmxw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-_oUs1GGWOj61jsTPq0Yptw-1; Thu, 20 Oct 2022 05:31:08 -0400
X-MC-Unique: _oUs1GGWOj61jsTPq0Yptw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0EA5885A583;
        Thu, 20 Oct 2022 09:31:08 +0000 (UTC)
Received: from localhost.localdomain (ovpn-192-51.brq.redhat.com [10.40.192.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 09EC149BB60;
        Thu, 20 Oct 2022 09:31:04 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 1/4] KVM: x86: nSVM: leave nested mode on vCPU free
Date:   Thu, 20 Oct 2022 12:30:52 +0300
Message-Id: <20221020093055.224317-2-mlevitsk@redhat.com>
In-Reply-To: <20221020093055.224317-1-mlevitsk@redhat.com>
References: <20221020093055.224317-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the VM was terminated while nested, we free the nested state
while the vCPU still is in nested mode.

Soon a warning will be added for this condition.

Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 58f0077d935799..958faa8807f52b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1439,6 +1439,7 @@ static void svm_vcpu_free(struct kvm_vcpu *vcpu)
 	 */
 	svm_clear_current_vmcb(svm->vmcb);
 
+	svm_leave_nested(vcpu);
 	svm_free_nested(svm);
 
 	sev_free_vcpu(vcpu);
-- 
2.26.3

