Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A73A2EFBB
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731614AbfE3DSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:18:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731604AbfE3DSh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:37 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F7D02479B;
        Thu, 30 May 2019 03:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186317;
        bh=oAxXuymPmuidvsgEn2m/qqwU03WCP9EmRkFFh9OyPYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bBA7EFzYemanAl4f3XuKnaCC5h4yRnbR//UQYu5L6A8eB2Iz57OCVJJGwffSOrQBm
         zHsabpGPUY2FNy6n2dWQ/l+yyuQVa/q+FppEIT+wCO8rTAcC9SIz+gEIhaPt7BJIPq
         zDC/BDlp5JhtQFVB4M5NcYbsS6xHwhSTChIY+uxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.14 004/193] KVM: x86: fix return value for reserved EFER
Date:   Wed, 29 May 2019 20:04:18 -0700
Message-Id: <20190530030447.601169202@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 66f61c92889ff3ca365161fb29dd36d6354682ba upstream.

Commit 11988499e62b ("KVM: x86: Skip EFER vs. guest CPUID checks for
host-initiated writes", 2019-04-02) introduced a "return false" in a
function returning int, and anyway set_efer has a "nonzero on error"
conventon so it should be returning 1.

Reported-by: Pavel Machek <pavel@denx.de>
Fixes: 11988499e62b ("KVM: x86: Skip EFER vs. guest CPUID checks for host-initiated writes")
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1133,7 +1133,7 @@ static int set_efer(struct kvm_vcpu *vcp
 	u64 efer = msr_info->data;
 
 	if (efer & efer_reserved_bits)
-		return false;
+		return 1;
 
 	if (!msr_info->host_initiated) {
 		if (!__kvm_valid_efer(vcpu, efer))


