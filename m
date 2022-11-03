Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBE1617F18
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 15:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbiKCOPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 10:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbiKCOPH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 10:15:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C6512633
        for <stable@vger.kernel.org>; Thu,  3 Nov 2022 07:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667484846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZLirfmVsMl7Z8L0J+XcE1Zsp+gCHNtOKzvKZLLJ8RdA=;
        b=AiUIqipJ5nidd3miNtVnLZwmxPKGYk0whxyIYOFRYRrjEpY1cxNFnLeDJyhkqNDK9SVgye
        Ui68gPZvhIlAdlkm5aJkUWI3kdFIe2Z3zTVUSb2TUbgI2zlOmSwM5CZ8eQB8d3Fbl/Zscl
        1WO5paRCldzYwSX2wykF3HtnyNrYxLY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-S-ZNYUDBODiUjCzhqFo44A-1; Thu, 03 Nov 2022 10:14:05 -0400
X-MC-Unique: S-ZNYUDBODiUjCzhqFo44A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EAE2029AA3BB;
        Thu,  3 Nov 2022 14:14:03 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2EA8040C6EC3;
        Thu,  3 Nov 2022 14:14:00 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        Shuah Khan <shuah@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Colton Lewis <coltonlewis@google.com>,
        Borislav Petkov <bp@alien8.de>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kselftest@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Wei Wang <wei.w.wang@intel.com>,
        David Matlack <dmatlack@google.com>, stable@vger.kernel.org
Subject: [PATCH v2 2/9] KVM: x86: nSVM: harden svm_free_nested against freeing vmcb02 while still in use
Date:   Thu,  3 Nov 2022 16:13:44 +0200
Message-Id: <20221103141351.50662-3-mlevitsk@redhat.com>
In-Reply-To: <20221103141351.50662-1-mlevitsk@redhat.com>
References: <20221103141351.50662-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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

