Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56D9C593AA9
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239483AbiHOUHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346281AbiHOUGY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:06:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FC882746;
        Mon, 15 Aug 2022 11:55:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C6346125F;
        Mon, 15 Aug 2022 18:55:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D8A4C433D6;
        Mon, 15 Aug 2022 18:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589708;
        bh=xk5weKLElopg822jWZDDlH2ickDhjXnskd5/YunhLns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XojDrGvC8axA0qrO2mrR2iUOQ4yV/AIQPTrbgdeVsrGt2219Ws+13K9sT5btt8xWa
         e9dKT+ExeDYIxj6OrtAnbwasLlalLOmPxYLO3/9YQSYIZ7rAm4ogBLF579B92OChTZ
         Tbahwk4JmP9uZMl8XKmTGlApiHEYOJHe9g6sWsn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lei Wang <lei4.wang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.18 0023/1095] KVM: nVMX: Snapshot pre-VM-Enter BNDCFGS for !nested_run_pending case
Date:   Mon, 15 Aug 2022 19:50:22 +0200
Message-Id: <20220815180430.314059193@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit fa578398a0ba2c079fa1170da21fa5baae0cedb2 upstream.

If a nested run isn't pending, snapshot vmcs01.GUEST_BNDCFGS irrespective
of whether or not VM_ENTRY_LOAD_BNDCFGS is set in vmcs12.  When restoring
nested state, e.g. after migration, without a nested run pending,
prepare_vmcs02() will propagate nested.vmcs01_guest_bndcfgs to vmcs02,
i.e. will load garbage/zeros into vmcs02.GUEST_BNDCFGS.

If userspace restores nested state before MSRs, then loading garbage is a
non-issue as loading BNDCFGS will also update vmcs02.  But if usersepace
restores MSRs first, then KVM is responsible for propagating L2's value,
which is actually thrown into vmcs01, into vmcs02.

Restoring L2 MSRs into vmcs01, i.e. loading all MSRs before nested state
is all kinds of bizarre and ideally would not be supported.  Sadly, some
VMMs do exactly that and rely on KVM to make things work.

Note, there's still a lurking SMM bug, as propagating vmcs01.GUEST_BNDFGS
to vmcs02 across RSM may corrupt L2's BNDCFGS.  But KVM's entire VMX+SMM
emulation is flawed as SMI+RSM should not toouch _any_ VMCS when use the
"default treatment of SMIs", i.e. when not using an SMI Transfer Monitor.

Link: https://lore.kernel.org/all/Yobt1XwOfb5M6Dfa@google.com
Fixes: 62cf9bd8118c ("KVM: nVMX: Fix emulation of VM_ENTRY_LOAD_BNDCFGS")
Cc: stable@vger.kernel.org
Cc: Lei Wang <lei4.wang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220614215831.3762138-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3381,7 +3381,8 @@ enum nvmx_vmentry_status nested_vmx_ente
 	if (!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
 		vmx->nested.vmcs01_debugctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
 	if (kvm_mpx_supported() &&
-		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
+	    (!vmx->nested.nested_run_pending ||
+	     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
 		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
 
 	/*


