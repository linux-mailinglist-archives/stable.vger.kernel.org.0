Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05D2911B604
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731227AbfLKPOf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:14:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:40080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731638AbfLKPOe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:14:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84F9B24658;
        Wed, 11 Dec 2019 15:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077274;
        bh=Gw4aZjR8Io/XIQ78BX+sc+7ll0U9rP0IAVhxmX2jV3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gDuzAVKzdBX4DpuBgkZl6jfRXvk5ygB/nwtUEpywj8vq1QgtoLN3zZ7zHmvmihKhg
         gfePPM5n9FthcpTLdBIJe2Xcp/1kHzJjF7eI5fPmYDSQFyB/kbtxRUNpjR3gKf0mWZ
         nXoki8h9W+3fTgV9gUrrGG72NfPP2vTVvgCHMnVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.3 081/105] KVM: x86: do not modify masked bits of shared MSRs
Date:   Wed, 11 Dec 2019 16:06:10 +0100
Message-Id: <20191211150258.164355315@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit de1fca5d6e0105c9d33924e1247e2f386efc3ece upstream.

"Shared MSRs" are guest MSRs that are written to the host MSRs but
keep their value until the next return to userspace.  They support
a mask, so that some bits keep the host value, but this mask is
only used to skip an unnecessary MSR write and the value written
to the MSR is always the guest MSR.

Fix this and, while at it, do not update smsr->values[slot].curr if
for whatever reason the wrmsr fails.  This should only happen due to
reserved bits, so the value written to smsr->values[slot].curr
will not match when the user-return notifier and the host value will
always be restored.  However, it is untidy and in rare cases this
can actually avoid spurious WRMSRs on return to userspace.

Cc: stable@vger.kernel.org
Reviewed-by: Jim Mattson <jmattson@google.com>
Tested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -300,13 +300,14 @@ int kvm_set_shared_msr(unsigned slot, u6
 	struct kvm_shared_msrs *smsr = per_cpu_ptr(shared_msrs, cpu);
 	int err;
 
-	if (((value ^ smsr->values[slot].curr) & mask) == 0)
+	value = (value & mask) | (smsr->values[slot].host & ~mask);
+	if (value == smsr->values[slot].curr)
 		return 0;
-	smsr->values[slot].curr = value;
 	err = wrmsrl_safe(shared_msrs_global.msrs[slot], value);
 	if (err)
 		return 1;
 
+	smsr->values[slot].curr = value;
 	if (!smsr->registered) {
 		smsr->urn.on_user_return = kvm_on_user_return;
 		user_return_notifier_register(&smsr->urn);


