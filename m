Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D64D593CF1
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244395AbiHOUHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346381AbiHOUGi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:06:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68522BD2;
        Mon, 15 Aug 2022 11:55:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99CD9611ED;
        Mon, 15 Aug 2022 18:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C6EC433D6;
        Mon, 15 Aug 2022 18:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589719;
        bh=/aQnZQ5JFG9L15x7QKi8JUfhjGN48NNx0wirGU2yGxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y0f7VTWC4syI/7z+h/90eEbCsA84pAq8P9KTeE1mB9rciar2sOwVVEOvAG8YRb1gm
         ZCxHSj+SOETtuiJV6KEMuYVS+cBfMbGWnYg/007U/fIV+gix+n/6Gcc0k3IvojeyRY
         C9S8HOj4gXpE6z724LRog1VKptrzjnxqWRVqweIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nico Boehr <nrb@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 5.18 0026/1095] KVM: s390: pv: dont present the ecall interrupt twice
Date:   Mon, 15 Aug 2022 19:50:25 +0200
Message-Id: <20220815180430.438032854@linuxfoundation.org>
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

From: Nico Boehr <nrb@linux.ibm.com>

commit c3f0e5fd2d33d80c5a5a8b5e5d2bab2841709cc8 upstream.

When the SIGP interpretation facility is present and a VCPU sends an
ecall to another VCPU in enabled wait, the sending VCPU receives a 56
intercept (partial execution), so KVM can wake up the receiving CPU.
Note that the SIGP interpretation facility will take care of the
interrupt delivery and KVM's only job is to wake the receiving VCPU.

For PV, the sending VCPU will receive a 108 intercept (pv notify) and
should continue like in the non-PV case, i.e. wake the receiving VCPU.

For PV and non-PV guests the interrupt delivery will occur through the
SIGP interpretation facility on SIE entry when SIE finds the X bit in
the status field set.

However, in handle_pv_notification(), there was no special handling for
SIGP, which leads to interrupt injection being requested by KVM for the
next SIE entry. This results in the interrupt being delivered twice:
once by the SIGP interpretation facility and once by KVM through the
IICTL.

Add the necessary special handling in handle_pv_notification(), similar
to handle_partial_execution(), which simply wakes the receiving VCPU and
leave interrupt delivery to the SIGP interpretation facility.

In contrast to external calls, emergency calls are not interpreted but
also cause a 108 intercept, which is why we still need to call
handle_instruction() for SIGP orders other than ecall.

Since kvm_s390_handle_sigp_pei() is now called for all SIGP orders which
cause a 108 intercept - even if they are actually handled by
handle_instruction() - move the tracepoint in kvm_s390_handle_sigp_pei()
to avoid possibly confusing trace messages.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Cc: <stable@vger.kernel.org> # 5.7
Fixes: da24a0cc58ed ("KVM: s390: protvirt: Instruction emulation")
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Link: https://lore.kernel.org/r/20220718130434.73302-1-nrb@linux.ibm.com
Message-Id: <20220718130434.73302-1-nrb@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/intercept.c |   15 +++++++++++++++
 arch/s390/kvm/sigp.c      |    4 ++--
 2 files changed, 17 insertions(+), 2 deletions(-)

--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -528,12 +528,27 @@ static int handle_pv_uvc(struct kvm_vcpu
 
 static int handle_pv_notification(struct kvm_vcpu *vcpu)
 {
+	int ret;
+
 	if (vcpu->arch.sie_block->ipa == 0xb210)
 		return handle_pv_spx(vcpu);
 	if (vcpu->arch.sie_block->ipa == 0xb220)
 		return handle_pv_sclp(vcpu);
 	if (vcpu->arch.sie_block->ipa == 0xb9a4)
 		return handle_pv_uvc(vcpu);
+	if (vcpu->arch.sie_block->ipa >> 8 == 0xae) {
+		/*
+		 * Besides external call, other SIGP orders also cause a
+		 * 108 (pv notify) intercept. In contrast to external call,
+		 * these orders need to be emulated and hence the appropriate
+		 * place to handle them is in handle_instruction().
+		 * So first try kvm_s390_handle_sigp_pei() and if that isn't
+		 * successful, go on with handle_instruction().
+		 */
+		ret = kvm_s390_handle_sigp_pei(vcpu);
+		if (!ret)
+			return ret;
+	}
 
 	return handle_instruction(vcpu);
 }
--- a/arch/s390/kvm/sigp.c
+++ b/arch/s390/kvm/sigp.c
@@ -480,9 +480,9 @@ int kvm_s390_handle_sigp_pei(struct kvm_
 	struct kvm_vcpu *dest_vcpu;
 	u8 order_code = kvm_s390_get_base_disp_rs(vcpu, NULL);
 
-	trace_kvm_s390_handle_sigp_pei(vcpu, order_code, cpu_addr);
-
 	if (order_code == SIGP_EXTERNAL_CALL) {
+		trace_kvm_s390_handle_sigp_pei(vcpu, order_code, cpu_addr);
+
 		dest_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, cpu_addr);
 		BUG_ON(dest_vcpu == NULL);
 


