Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8771863DDCA
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiK3Saa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiK3Sa1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:30:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B495E9F7
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:30:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1A2061D05
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3FB6C433C1;
        Wed, 30 Nov 2022 18:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833023;
        bh=7y2wYZZNZummR/FzcBwoezwVd7fEQ4jdL6XzcnMdDJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lwRYfucHFkBPFN5RcVSGhMO6bQq+OyPF8Bn2AH4WwL8H9WLvY3xXRS8GjtLpW7SfV
         rTxrTZd3b4nZODlfodYnC6H4UnbUGjvtD9Va3nw/TtDbEM8vIogi8wz9gDjyWr8UmP
         rE1POdLQozBK60p+yuzxli5OjMdzEpyGd2ujq+Ko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 123/162] KVM: x86: remove exit_int_info warning in svm_handle_exit
Date:   Wed, 30 Nov 2022 19:23:24 +0100
Message-Id: <20221130180531.825518769@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

commit 05311ce954aebe75935d9ae7d38ac82b5b796e33 upstream.

It is valid to receive external interrupt and have broken IDT entry,
which will lead to #GP with exit_int_into that will contain the index of
the IDT entry (e.g any value).

Other exceptions can happen as well, like #NP or #SS
(if stack switch fails).

Thus this warning can be user triggred and has very little value.

Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20221103141351.50662-10-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |   15 ---------------
 1 file changed, 15 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -305,12 +305,6 @@ int svm_set_efer(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static int is_external_interrupt(u32 info)
-{
-	info &= SVM_EVTINJ_TYPE_MASK | SVM_EVTINJ_VALID;
-	return info == (SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR);
-}
-
 static u32 svm_get_interrupt_shadow(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -3116,15 +3110,6 @@ static int handle_exit(struct kvm_vcpu *
 		return 0;
 	}
 
-	if (is_external_interrupt(svm->vmcb->control.exit_int_info) &&
-	    exit_code != SVM_EXIT_EXCP_BASE + PF_VECTOR &&
-	    exit_code != SVM_EXIT_NPF && exit_code != SVM_EXIT_TASK_SWITCH &&
-	    exit_code != SVM_EXIT_INTR && exit_code != SVM_EXIT_NMI)
-		printk(KERN_ERR "%s: unexpected exit_int_info 0x%x "
-		       "exit_code 0x%x\n",
-		       __func__, svm->vmcb->control.exit_int_info,
-		       exit_code);
-
 	if (exit_fastpath != EXIT_FASTPATH_NONE)
 		return 1;
 


