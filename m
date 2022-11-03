Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49CC8617E97
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 14:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbiKCN7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 09:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbiKCN6z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 09:58:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D09F15FFE
        for <stable@vger.kernel.org>; Thu,  3 Nov 2022 06:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667483873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZLirfmVsMl7Z8L0J+XcE1Zsp+gCHNtOKzvKZLLJ8RdA=;
        b=PliTro3xAmx+SWUzrtL8cosxDFNc06zRCkRtjqpzztYrEyqB5HDboxOdb7dYtTigS8Vb0q
        OrmHmBvYadTnkp/+glHH3cZtzAn+KeZFXM38pb+8i/sRauMZLtkG+rVyzrzmFnBkXR5lN8
        cdGNRV7cKze9AVNmxKmRme814E+zpoo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-271-J74K2mJrOAGRjdR_58cgEA-1; Thu, 03 Nov 2022 09:57:50 -0400
X-MC-Unique: J74K2mJrOAGRjdR_58cgEA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F6B33C0DDD0;
        Thu,  3 Nov 2022 13:57:49 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C1F3040C2087;
        Thu,  3 Nov 2022 13:57:44 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Colton Lewis <coltonlewis@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Peter Xu <peterx@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kselftest@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 2/9] KVM: x86: nSVM: harden svm_free_nested against freeing vmcb02 while still in use
Date:   Thu,  3 Nov 2022 15:57:29 +0200
Message-Id: <20221103135736.42295-3-mlevitsk@redhat.com>
In-Reply-To: <20221103135736.42295-1-mlevitsk@redhat.com>
References: <20221103135736.42295-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure that KVM uses vmcb01 before freeing nested state, and warn if
that is not the case.

This is a minimal fix for CVE-2022-3344 making the kernel print a warning
instead of a kernel panic.

Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index b258d6988f5dde..b74da40c1fc40c 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1126,6 +1126,9 @@ void svm_free_nested(struct vcpu_svm *svm)
 	if (!svm->nested.initialized)
 		return;
 
+	if (WARN_ON_ONCE(svm->vmcb != svm->vmcb01.ptr))
+		svm_switch_vmcb(svm, &svm->vmcb01);
+
 	svm_vcpu_free_msrpm(svm->nested.msrpm);
 	svm->nested.msrpm = NULL;
 
-- 
2.34.3

