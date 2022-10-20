Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06FCD605B2F
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 11:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiJTJbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 05:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbiJTJbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 05:31:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995E0157883
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 02:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666258274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NO7cWLyVclWMKKTiYZzmBycykjfaB0P86+4KIdCX/tM=;
        b=Zf52MnJGudbW0oqIMsv+43r6uuVzjpMOaqSKD2fo1c+ROvVQs6kJ6kpGTYLNO74CBld9J4
        ZZzNpkeVh2p7EZtFtZ/12VRrKcLmJsZO1dKqzOsSocWmAycZExDSnj2BWclJSAwi8Cgvlc
        MRfW+7yquzn+JXC7s0drZt6XPsq2Szw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-si_bzrwCPsqHWe6dAUaoPQ-1; Thu, 20 Oct 2022 05:31:11 -0400
X-MC-Unique: si_bzrwCPsqHWe6dAUaoPQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B30138012DD;
        Thu, 20 Oct 2022 09:31:11 +0000 (UTC)
Received: from localhost.localdomain (ovpn-192-51.brq.redhat.com [10.40.192.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D32649BB60;
        Thu, 20 Oct 2022 09:31:08 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 2/4] KVM: x86: nSVM: harden svm_free_nested against freeing vmcb02 while still in use
Date:   Thu, 20 Oct 2022 12:30:53 +0300
Message-Id: <20221020093055.224317-3-mlevitsk@redhat.com>
In-Reply-To: <20221020093055.224317-1-mlevitsk@redhat.com>
References: <20221020093055.224317-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure that KVM uses vmcb01 before freeing nested state,
and warn if that is not the case.

This is a minimal fix for CVE-2022-3344 making the kernel
print a warning instead of a kernel panic.

Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 4c620999d230a5..b02a3a1792f194 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1125,6 +1125,9 @@ void svm_free_nested(struct vcpu_svm *svm)
 	if (!svm->nested.initialized)
 		return;
 
+	if (WARN_ON_ONCE(svm->vmcb != svm->vmcb01.ptr))
+		svm_switch_vmcb(svm, &svm->vmcb01);
+
 	svm_vcpu_free_msrpm(svm->nested.msrpm);
 	svm->nested.msrpm = NULL;
 
-- 
2.26.3

