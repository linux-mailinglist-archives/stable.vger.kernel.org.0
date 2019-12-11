Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 463C511B815
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730649AbfLKPJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:09:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:57858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730177AbfLKPJp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:09:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7064D22B48;
        Wed, 11 Dec 2019 15:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576076984;
        bh=TQTDf8uMGZaMCrhwqddDGr70A0eN8FQyvw+Bojojpcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LrmO6YumTuEx2NXR3BkfdgSBej2yGRq2jOvphU39TrYUV8Blvd48Jpv9P8g5Pfgj5
         0R3wK4AS5YWS5Hg/e3gNx7VDtiUqeDxaHphfyh0efDsi36OzGgaYOehWC7qAbhB1YK
         E6RXOBBSXVBJ2VurDAbIEv9w1ZVLBeQq/VZ77HrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 65/92] KVM: x86: fix presentation of TSX feature in ARCH_CAPABILITIES
Date:   Wed, 11 Dec 2019 16:05:56 +0100
Message-Id: <20191211150252.913746294@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
References: <20191211150221.977775294@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit cbbaa2727aa3ae9e0a844803da7cef7fd3b94f2b upstream.

KVM does not implement MSR_IA32_TSX_CTRL, so it must not be presented
to the guests.  It is also confusing to have !ARCH_CAP_TSX_CTRL_MSR &&
!RTM && ARCH_CAP_TAA_NO: lack of MSR_IA32_TSX_CTRL suggests TSX was not
hidden (it actually was), yet the value says that TSX is not vulnerable
to microarchitectural data sampling.  Fix both.

Cc: stable@vger.kernel.org
Tested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1328,12 +1328,18 @@ static u64 kvm_get_arch_capabilities(voi
 	 * If TSX is disabled on the system, guests are also mitigated against
 	 * TAA and clear CPU buffer mitigation is not required for guests.
 	 */
-	if (boot_cpu_has_bug(X86_BUG_TAA) && boot_cpu_has(X86_FEATURE_RTM) &&
-	    (data & ARCH_CAP_TSX_CTRL_MSR))
+	if (!boot_cpu_has(X86_FEATURE_RTM))
+		data &= ~ARCH_CAP_TAA_NO;
+	else if (!boot_cpu_has_bug(X86_BUG_TAA))
+		data |= ARCH_CAP_TAA_NO;
+	else if (data & ARCH_CAP_TSX_CTRL_MSR)
 		data &= ~ARCH_CAP_MDS_NO;
 
+	/* KVM does not emulate MSR_IA32_TSX_CTRL.  */
+	data &= ~ARCH_CAP_TSX_CTRL_MSR;
 	return data;
 }
+EXPORT_SYMBOL_GPL(kvm_get_arch_capabilities);
 
 static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
 {


