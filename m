Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 321D350F7A4
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243598AbiDZJLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346280AbiDZJH3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:07:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F9ACA0D7;
        Tue, 26 Apr 2022 01:48:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B14F5B81D0A;
        Tue, 26 Apr 2022 08:48:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB37C385A0;
        Tue, 26 Apr 2022 08:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962912;
        bh=dTrkoAicnKNbR8OoKD9QRqhGbzc5PwsgGK9Ouyr9B7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wALMeqXus2Z04YUG1AhB9X/AGLzp18hM5tVNhD8GYAyJlqEGHStxb0xfR8uEPbdpc
         P53UcnmQPhyclO2+xYXhgtrTCfXd3bRQnTuqI8WNcAkjM4HtJDN1M8MPShwBoGiteB
         Sy0kED6HcevFT/bKP/Rod8oXiaT2wI9Qh7wkKVv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.17 129/146] KVM: x86: Dont re-acquire SRCU lock in complete_emulated_io()
Date:   Tue, 26 Apr 2022 10:22:04 +0200
Message-Id: <20220426081753.688082335@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 2d08935682ac5f6bfb70f7e6844ec27d4a245fa4 upstream.

Don't re-acquire SRCU in complete_emulated_io() now that KVM acquires the
lock in kvm_arch_vcpu_ioctl_run().  More importantly, don't overwrite
vcpu->srcu_idx.  If the index acquired by complete_emulated_io() differs
from the one acquired by kvm_arch_vcpu_ioctl_run(), KVM will effectively
leak a lock and hang if/when synchronize_srcu() is invoked for the
relevant grace period.

Fixes: 8d25b7beca7e ("KVM: x86: pull kvm->srcu read-side to kvm_arch_vcpu_ioctl_run")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20220415004343.2203171-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10296,12 +10296,7 @@ static int vcpu_run(struct kvm_vcpu *vcp
 
 static inline int complete_emulated_io(struct kvm_vcpu *vcpu)
 {
-	int r;
-
-	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
-	r = kvm_emulate_instruction(vcpu, EMULTYPE_NO_DECODE);
-	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
-	return r;
+	return kvm_emulate_instruction(vcpu, EMULTYPE_NO_DECODE);
 }
 
 static int complete_emulated_pio(struct kvm_vcpu *vcpu)


