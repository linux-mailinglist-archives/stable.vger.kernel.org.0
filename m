Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1AB1469F7E
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391227AbhLFPpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389685AbhLFPku (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:40:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E57AC08ECAB;
        Mon,  6 Dec 2021 07:25:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2428BB8111C;
        Mon,  6 Dec 2021 15:25:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F05CC34901;
        Mon,  6 Dec 2021 15:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804313;
        bh=pl+NVoGM0qCHAbs542du1cnS1YcpHO39jg+ZG6kGjpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tGqB9dV8o28YcC0C/ACHWDIxcnvo+koNSwyyhnZHA9zKh0drQS5psw7Wy4eHfliFy
         4GK5ubDrY+cPnf8a0gVdim16mwqa64w6dDSvgskNtkMEZLzALXNRTnXuU+swBSTy6W
         +2Ewv/5d6aLjHw1F3LFh5XpCIzTPmGv5Qt/O0FsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 070/207] KVM: fix avic_set_running for preemptable kernels
Date:   Mon,  6 Dec 2021 15:55:24 +0100
Message-Id: <20211206145612.655810380@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 7cfc5c653b07782e7059527df8dc1e3143a7591e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/avic.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -988,16 +988,18 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu
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


