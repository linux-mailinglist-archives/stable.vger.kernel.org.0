Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE7014BE755
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344171AbiBUJWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:22:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350270AbiBUJWT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:22:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B3F2679;
        Mon, 21 Feb 2022 01:09:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B2E1608C1;
        Mon, 21 Feb 2022 09:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F211DC340E9;
        Mon, 21 Feb 2022 09:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434583;
        bh=oeOo2roACYOM5L7OWcgyEXtvakiGX2fmg09LX4dp2JM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YjVszOglHr1WHVf98rlJ/LmKRmGhROfymbYEVeHAOzgkSb+jNAh79kEvEeNR4XIp5
         JjArWMH7FozZvf3/HdKsuomZXjJS3BpBqtluuFROVX3U/8A4yWfS/onvmpb4A9gYwL
         kO3Pdoh2b79NgYTbPI6Ef6n2qkyUBj4X6PnYGuAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 059/196] KVM: x86: nSVM: mark vmcb01 as dirty when restoring SMM saved state
Date:   Mon, 21 Feb 2022 09:48:11 +0100
Message-Id: <20220221084932.915232739@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Maxim Levitsky <mlevitsk@redhat.com>

commit e8efa4ff00374d2e6f47f6e4628ca3b541c001af upstream.

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
Message-Id: <20220207155447.840194-4-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4392,6 +4392,8 @@ static int svm_leave_smm(struct kvm_vcpu
 	 * Enter the nested guest now
 	 */
 
+	vmcb_mark_all_dirty(svm->vmcb01.ptr);
+
 	vmcb12 = map.hva;
 	nested_load_control_from_vmcb12(svm, &vmcb12->control);
 	ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, false);


