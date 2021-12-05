Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3340468AB4
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 13:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbhLEMN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 07:13:59 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51568 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232391AbhLEMN6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 07:13:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7699860FBF
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 12:10:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BF4C341C1;
        Sun,  5 Dec 2021 12:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638706230;
        bh=6drbtzaj+e4FbwyF49RNViUjbOKCBJWpEQMfMKmfe88=;
        h=Subject:To:Cc:From:Date:From;
        b=D87JkjFlI/t7ltAQN9MSg136PFw8rajKoWBug0cXeUmMThojBcuJNSXLc8sMpI0HF
         yyCTNgEhB8w/SIJqtRJIO+QfhSS8O+6YwgJ28VUHTmW5yoOFhkJvsVmC3bc4RdVyzc
         3awcixwoVn4YYiLguESW4+3Mw3EaPxmKXY1WBpqc=
Subject: FAILED: patch "[PATCH] KVM: fix avic_set_running for preemptable kernels" failed to apply to 4.9-stable tree
To:     pbonzini@redhat.com, mlevitsk@redhat.com, seanjc@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 05 Dec 2021 13:10:27 +0100
Message-ID: <163870622724443@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7cfc5c653b07782e7059527df8dc1e3143a7591e Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 30 Nov 2021 03:46:07 -0500
Subject: [PATCH] KVM: fix avic_set_running for preemptable kernels

avic_set_running() passes the current CPU to avic_vcpu_load(), albeit
via vcpu->cpu rather than smp_processor_id().  If the thread is migrated
while avic_set_running runs, the call to avic_vcpu_load() can use a stale
value for the processor id.  Avoid this by blocking preemption over the
entire execution of avic_set_running().

Reported-by: Sean Christopherson <seanjc@google.com>
Fixes: 8221c1370056 ("svm: Manage vcpu load/unload when enable AVIC")
Cc: stable@vger.kernel.org
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index affc0ea98d30..9d6066eb7c10 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -989,16 +989,18 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 static void avic_set_running(struct kvm_vcpu *vcpu, bool is_run)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	int cpu = get_cpu();
 
+	WARN_ON(cpu != vcpu->cpu);
 	svm->avic_is_running = is_run;
 
-	if (!kvm_vcpu_apicv_active(vcpu))
-		return;
-
-	if (is_run)
-		avic_vcpu_load(vcpu, vcpu->cpu);
-	else
-		avic_vcpu_put(vcpu);
+	if (kvm_vcpu_apicv_active(vcpu)) {
+		if (is_run)
+			avic_vcpu_load(vcpu, cpu);
+		else
+			avic_vcpu_put(vcpu);
+	}
+	put_cpu();
 }
 
 void svm_vcpu_blocking(struct kvm_vcpu *vcpu)

