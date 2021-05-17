Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A05838382E
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240175AbhEQPuh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:50:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242280AbhEQPrJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:47:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61BD961D39;
        Mon, 17 May 2021 14:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262676;
        bh=UWAuHH+k11x/vZynb/+xEpgKYE2kwaW20XG/OLYUMuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wFtKBpLqnYDNqBE9D9lv8fpwAd4tzwYpbCCm+n1X6w9jVpF7wNKiHcXPO3XGhRi7z
         YnkeMiaJa9gJKcpbwkPJMvkawNVLVRg6m3TXxDSAeEydmC8sCDw8yKYJlNAQVdacx2
         k40W4wfk6Ev9TTdG7Wk7TlSfTpLgvoZB2nEggwCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 257/289] KVM: x86: Move RDPID emulation intercept to its own enum
Date:   Mon, 17 May 2021 16:03:02 +0200
Message-Id: <20210517140313.799801282@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 2183de4161b90bd3851ccd3910c87b2c9adfc6ed upstream.

Add a dedicated intercept enum for RDPID instead of piggybacking RDTSCP.
Unlike VMX's ENABLE_RDTSCP, RDPID is not bound to SVM's RDTSCP intercept.

Fixes: fb6d4d340e05 ("KVM: x86: emulate RDPID")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210504171734.1434054-5-seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/emulate.c     |    2 +-
 arch/x86/kvm/kvm_emulate.h |    1 +
 arch/x86/kvm/vmx/vmx.c     |    3 ++-
 3 files changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4502,7 +4502,7 @@ static const struct opcode group8[] = {
  * from the register case of group9.
  */
 static const struct gprefix pfx_0f_c7_7 = {
-	N, N, N, II(DstMem | ModRM | Op3264 | EmulateOnUD, em_rdpid, rdtscp),
+	N, N, N, II(DstMem | ModRM | Op3264 | EmulateOnUD, em_rdpid, rdpid),
 };
 
 
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -468,6 +468,7 @@ enum x86_intercept {
 	x86_intercept_clgi,
 	x86_intercept_skinit,
 	x86_intercept_rdtscp,
+	x86_intercept_rdpid,
 	x86_intercept_icebp,
 	x86_intercept_wbinvd,
 	x86_intercept_monitor,
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7360,8 +7360,9 @@ static int vmx_check_intercept(struct kv
 	/*
 	 * RDPID causes #UD if disabled through secondary execution controls.
 	 * Because it is marked as EmulateOnUD, we need to intercept it here.
+	 * Note, RDPID is hidden behind ENABLE_RDTSCP.
 	 */
-	case x86_intercept_rdtscp:
+	case x86_intercept_rdpid:
 		if (!nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENABLE_RDTSCP)) {
 			exception->vector = UD_VECTOR;
 			exception->error_code_valid = false;


