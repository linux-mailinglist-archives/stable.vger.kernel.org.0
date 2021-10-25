Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02AB643A2D3
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235286AbhJYTxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:53:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238660AbhJYTvA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:51:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3743760E75;
        Mon, 25 Oct 2021 19:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190966;
        bh=EnoDjRZNeWMBEV5pFdsiCUsyHCHqbezOCF3FWUhiANs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nn/EZ4gXe3FgWKepKX75H+M1kl4Zxyar7wbYHmebbjBEN7PIKj6gDecQ8C7KLtWYs
         A5smzvpxvKuwY+CzP0whxdd/hjVz8GkhVksICm4H6ttZ0voKkqVI6R4ez1O3gN0JqB
         YAoLZqoSQuedM14Yhox6EE6WD0Mh2F/kCBrqZ7FA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.14 113/169] KVM: x86: check for interrupts before deciding whether to exit the fast path
Date:   Mon, 25 Oct 2021 21:14:54 +0200
Message-Id: <20211025191032.315857412@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit de7cd3f6761f49bef044ec49493d88737a70f1a6 upstream.

The kvm_x86_sync_pir_to_irr callback can sometimes set KVM_REQ_EVENT.
If that happens exactly at the time that an exit is handled as
EXIT_FASTPATH_REENTER_GUEST, vcpu_enter_guest will go incorrectly
through the loop that calls kvm_x86_run, instead of processing
the request promptly.

Fixes: 379a3c8ee444 ("KVM: VMX: Optimize posted-interrupt delivery for timer fastpath")
Cc: stable@vger.kernel.org
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9642,14 +9642,14 @@ static int vcpu_enter_guest(struct kvm_v
 		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
 			break;
 
-                if (unlikely(kvm_vcpu_exit_request(vcpu))) {
+		if (vcpu->arch.apicv_active)
+			static_call(kvm_x86_sync_pir_to_irr)(vcpu);
+
+		if (unlikely(kvm_vcpu_exit_request(vcpu))) {
 			exit_fastpath = EXIT_FASTPATH_EXIT_HANDLED;
 			break;
 		}
-
-		if (vcpu->arch.apicv_active)
-			static_call(kvm_x86_sync_pir_to_irr)(vcpu);
-        }
+	}
 
 	/*
 	 * Do this here before restoring debug registers on the host.  And


