Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D29414AC4AA
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 17:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348643AbiBGP7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 10:59:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385487AbiBGPz0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 10:55:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 52AEAC0401D3
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 07:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644249325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I4R9ip16BNHzOCMyjNW2i8e6oOdWXHYHkd2se90F0XI=;
        b=K1qvILtcstiUQRby6iK6P//2ZxXiOK5sb5MYIRYAYyI/GEXgU7Xct4IFWBjWIwyBNgJQ4i
        3VS3gr4AXZm+/FzdWGtXOyO47N1ZNHJzY+eP0QuuzCYE+DiyPA+cGeGRLmmiF5s2IxCYnx
        Jz/Y8ZTrSRoxxKPdHkCwEPdxYNvUWMo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-wKwVbDHBNS-GatSourBQzg-1; Mon, 07 Feb 2022 10:55:24 -0500
X-MC-Unique: wKwVbDHBNS-GatSourBQzg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E010293922;
        Mon,  7 Feb 2022 15:55:20 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 739AF7DE56;
        Mon,  7 Feb 2022 15:55:13 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Tony Luck <tony.luck@intel.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        David Airlie <airlied@linux.ie>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, stable@vger.kernel.org
Subject: [PATCH RESEND 03/30] KVM: x86: nSVM: mark vmcb01 as dirty when restoring SMM saved state
Date:   Mon,  7 Feb 2022 17:54:20 +0200
Message-Id: <20220207155447.840194-4-mlevitsk@redhat.com>
In-Reply-To: <20220207155447.840194-1-mlevitsk@redhat.com>
References: <20220207155447.840194-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While usually, restoring the smm state makes the KVM enter
the nested guest thus a different vmcb (vmcb02 vs vmcb01),
KVM should still mark it as dirty, since hardware
can in theory cache multiple vmcbs.

Failure to do so, combined with lack of setting the
nested_run_pending (which is fixed in the next patch),
might make KVM re-enter vmcb01, which was just exited from,
with completely different set of guest state registers
(SMM vs non SMM) and without proper dirty bits set,
which results in the CPU reusing stale IDTR pointer
which leads to a guest shutdown on any interrupt.

On the real hardware this usually doesn't happen,
but when running nested, L0's KVM does check and
honour few dirty bits, causing this issue to happen.

This patch fixes boot of hyperv and SMM enabled
windows VM running nested on KVM.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
---
 arch/x86/kvm/svm/svm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 995c203a62fd9..3f1d11e652123 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4267,6 +4267,8 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 	 * Enter the nested guest now
 	 */
 
+	vmcb_mark_all_dirty(svm->vmcb01.ptr);
+
 	vmcb12 = map.hva;
 	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
 	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
-- 
2.26.3

