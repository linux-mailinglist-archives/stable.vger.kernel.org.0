Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBA94BE818
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351572AbiBUJue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:50:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352570AbiBUJrf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:47:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657C142ED4;
        Mon, 21 Feb 2022 01:20:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C7720CE0E80;
        Mon, 21 Feb 2022 09:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7153C340E9;
        Mon, 21 Feb 2022 09:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435207;
        bh=fuV+g5ItwfrMizpj8gb/qGp+Ga0dQF92sjKhMTC425I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YTOnPh2DE5i3i4snh+A/NWgTbHbM/VKutKXYf/vPfMfNEbazTlNkl8hWGwnUKPjgO
         GlQnUgNh2dOhNVKfhuMReUB9Klwng1tBmhk1fMsgZg7tQRT1lU1W2YPkQInAmZSPVc
         z+ll20F4U9oq9UfA/MHdeDSKgQgMeSH7SrbTudYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.16 075/227] KVM: x86: nSVM: mark vmcb01 as dirty when restoring SMM saved state
Date:   Mon, 21 Feb 2022 09:48:14 +0100
Message-Id: <20220221084937.368558831@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
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
@@ -4449,6 +4449,8 @@ static int svm_leave_smm(struct kvm_vcpu
 	 * Enter the nested guest now
 	 */
 
+	vmcb_mark_all_dirty(svm->vmcb01.ptr);
+
 	vmcb12 = map.hva;
 	nested_load_control_from_vmcb12(svm, &vmcb12->control);
 	ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, false);


